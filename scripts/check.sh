#!/bin/sh
# Repository gates for exam-protocol.
#
# This project's own reference material (references/discrimination.md §2.1) says a
# guard that finds nothing on its first run against a real corpus has not been
# shown capable of failing. Every check below was run against this tree *before*
# the thing it checks was fixed; six of the nine went red. The two that were
# green on their first run (the line budget and the seal recomputation) are
# ratchets rather than finders, and each was demonstrated red by mutation
# instead. That evidence lives in CONTRIBUTING.md, "How these gates were proved".
#
# Dependencies: POSIX sh, grep, find, wc, awk, and one SHA-256 utility
# (sha256sum, shasum, openssl, or certutil). Checks that need a hasher and find
# none are reported as SKIP, never as pass.
#
# Usage:  sh scripts/check.sh

set -u

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd) || exit 2
cd "$ROOT" || exit 2

# --- the hard numbers, in one place ------------------------------------------
SKILL_FILE="skills/exam-protocol/SKILL.md"
SKILL_LINE_BUDGET=400
DUP_BLOCK_LINES=3          # a "block" is this many consecutive significant lines
EXAMPLE_EXAM="examples/checkout-brief-r1-exam.md"
EXAMPLE_ANSWERS="examples/checkout-brief-r1-answers.md"
EXAMPLE_SEAL="examples/SEAL.md"

fails=0
passes=0
skips=0

ok()   { printf 'ok       %s\n' "$1"; passes=$((passes + 1)); }
red()  { printf 'NOT OK   %s\n' "$1"; fails=$((fails + 1)); }
skip() { printf 'skip     %s\n' "$1"; skips=$((skips + 1)); }
note() { printf '         %s\n' "$1"; }

sha256_of() {
	# Prints the lowercase hex digest of "$1", or nothing if no hasher exists.
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$1" | awk '{print tolower($1)}'
	elif command -v shasum >/dev/null 2>&1; then
		shasum -a 256 "$1" | awk '{print tolower($1)}'
	elif command -v openssl >/dev/null 2>&1; then
		openssl dgst -sha256 "$1" | awk '{print tolower($NF)}'
	elif command -v certutil >/dev/null 2>&1; then
		certutil -hashfile "$1" SHA256 | awk 'NR==2 {gsub(/ /,""); print tolower($0)}'
	fi
}

# =============================================================================
# 1. Line endings are pinned before the first clone exists.
# =============================================================================
if [ -f .gitattributes ] && grep -q 'eol=lf' .gitattributes; then
	ok "1  .gitattributes pins line endings (eol=lf)"
else
	red "1  .gitattributes missing or does not pin eol=lf"
	note "   Without it a default Windows clone rewrites every .md to CRLF and"
	note "   the seal on the shipped example fails on day one."
fi

# =============================================================================
# 2. No unresolved account placeholder in anything a reader is told to run.
#
#    The pattern is the *defect shape* — the placeholder followed by a path
#    separator, which is how it appears in every clone URL and release link —
#    not the bare word. Matching the bare word made this check red on
#    CONTRIBUTING.md's own description of it, and a guard that fires on prose
#    about itself gets switched off (references/discrimination.md §2.2).
#    Documentation may therefore name the placeholder, but must not write it in
#    a copy-pasteable form, which is this project's own rule for wrong values.
#
#    exams/ is excluded on purpose: sealed records quote defects verbatim and
#    must never be edited to please a guard. scripts/ is excluded because this
#    file necessarily contains the string it searches for.
# =============================================================================
owner_hits=$(
	find . -type f -name '*.md' \
		! -path './exams/*' ! -path './scripts/*' ! -path './.git/*' \
		-exec grep -Hn -e 'OWNER/' -e '<OWNER>' {} + 2>/dev/null
)
if [ -z "$owner_hits" ]; then
	ok "2  no OWNER placeholder in published instructions"
else
	red "2  OWNER placeholder still present"
	printf '%s\n' "$owner_hits" | sed 's/^/           /'
fi

# =============================================================================
# 3. SKILL.md line budget — a hard number, not "roughly".
# =============================================================================
if [ -f "$SKILL_FILE" ]; then
	skill_lines=$(wc -l < "$SKILL_FILE" | tr -d ' \t')
	if [ "$skill_lines" -le "$SKILL_LINE_BUDGET" ]; then
		ok "3  $SKILL_FILE is $skill_lines lines (budget $SKILL_LINE_BUDGET)"
	else
		red "3  $SKILL_FILE is $skill_lines lines, over the budget of $SKILL_LINE_BUDGET"
		note "   Evict a historical expansion to references/ rather than raising this number."
	fi
else
	red "3  $SKILL_FILE not found"
fi

# =============================================================================
# 4. One source of truth: no byte-identical multi-line block shared between
#    README.md, AGENTS.md and SKILL.md.
#
#    Blocks wrapped in <!-- shared-snippet --> ... <!-- /shared-snippet --> are
#    exempt: those are text the *user* is meant to copy into their own project,
#    which CONTRIBUTING.md permits and requires to link to the definition.
# =============================================================================
dup_report=$(
	awk -v n="$DUP_BLOCK_LINES" '
		FNR == 1 { insnip = 0 }
		/<!--[ \t]*\/shared-snippet/ { insnip = 0; next }
		/<!--[ \t]*shared-snippet/   { insnip = 1; next }
		insnip { next }
		{
			line = $0
			gsub(/^[ \t]+|[ \t]+$/, "", line)
			if (line == "") next
			# ignore pure table rules and horizontal rules: too common to be evidence
			if (line ~ /^[|:| -]+$/) next
			buf[++c] = line
			bufline[c] = FNR
			if (c < n) next
			key = ""
			for (i = c - n + 1; i <= c; i++) key = key buf[i] "\n"
			if (!(key in seen)) {
				seen[key] = FILENAME ":" bufline[c - n + 1]
			} else if (seen[key] !~ ("^" FILENAME ":")) {
				if (!(key in reported)) {
					reported[key] = 1
					print seen[key] "  ==  " FILENAME ":" bufline[c - n + 1]
				}
			}
		}
	' README.md AGENTS.md "$SKILL_FILE" 2>/dev/null
)
if [ -z "$dup_report" ]; then
	ok "4  no unmarked ${DUP_BLOCK_LINES}-line block shared between README / AGENTS / SKILL"
else
	red "4  identical multi-line block in two files (CONTRIBUTING.md rule one)"
	printf '%s\n' "$dup_report" | sed 's/^/           /'
	note "   Delete one, or wrap it in <!-- shared-snippet --> if it is text the"
	note "   reader is meant to copy into their own project."
fi

# =============================================================================
# 5. Every example file says it is fiction.
#
#    An illustration that carries evidence labels but no fiction banner is a
#    fabricated measurement wearing a real measurement's badge.
# =============================================================================
missing_banner=""
for f in examples/*.md; do
	[ -e "$f" ] || continue
	if ! grep -qi 'fictional\|ILLUSTRATIVE' "$f"; then
		missing_banner="$missing_banner $f"
	fi
done
if [ -z "$missing_banner" ]; then
	ok "5  every examples/*.md carries a fiction banner"
else
	red "5  example file(s) with no fiction banner:$missing_banner"
fi

# =============================================================================
# 6. The example answer sheet cites the hash recorded in the seal row.
#    templates/seal.md defines ANSWERED as "an answer file exists and cites this
#    hash", so a pointer in that field makes the seal status untrue.
# =============================================================================
# The live row is the one that is not SUPERSEDED. A seal record is append-only,
# so "the first hash in the file" is the oldest, not the current one.
seal_hash=$(
	grep '^|' "$EXAMPLE_SEAL" 2>/dev/null |
		grep -v 'SUPERSEDED' |
		grep -o '[0-9a-f]\{64\}' | head -n 1
)
if [ -z "$seal_hash" ]; then
	red "6  no SHA-256 found in $EXAMPLE_SEAL"
elif grep -q "$seal_hash" "$EXAMPLE_ANSWERS" 2>/dev/null; then
	ok "6  $EXAMPLE_ANSWERS cites the sealed hash"
else
	red "6  $EXAMPLE_ANSWERS does not cite the hash in $EXAMPLE_SEAL"
	note "   seal row: $seal_hash"
fi

# =============================================================================
# 7. The sealed hash still matches the file on disk.
#    This is the check a new reader performs first. It is also the one that goes
#    red on a CRLF checkout, which is why check 1 exists.
# =============================================================================
if [ -z "$seal_hash" ]; then
	skip "7  cannot recompute: no hash in $EXAMPLE_SEAL"
else
	actual=$(sha256_of "$EXAMPLE_EXAM")
	if [ -z "$actual" ]; then
		skip "7  no SHA-256 utility found; seal not recomputed"
	elif [ "$actual" = "$seal_hash" ]; then
		ok "7  seal row matches $EXAMPLE_EXAM on disk"
	else
		red "7  seal row does not match $EXAMPLE_EXAM on disk"
		note "   recorded: $seal_hash"
		note "   on disk:  $actual"
		note "   If these differ only by line endings, the seal is stale, not tampered."
	fi
fi

# =============================================================================
# 8. Answer statuses are exactly three (plus the Withdrawn disposition).
#    The shipped example once invented a fourth, in the file people imitate.
# =============================================================================
bad_status=$(
	find examples skills/exam-protocol/templates -type f -name '*.md' \
		-exec grep -Hn '^### Q-' {} + 2>/dev/null |
	awk -F' — ' 'NF > 1 {
		s = $2
		for (i = 3; i <= NF; i++) s = s " — " $i
		if (s == "`FAIL`") next
		if (s == "`PASS`") next
		if (s == "`UNRESOLVED`") next
		if (s == "Withdrawn") next
		if (s == "`FAIL` / `PASS` / `UNRESOLVED`") next
		if (s == "`...`") next
		print $1 " -> " s
	}'
)
if [ -z "$bad_status" ]; then
	ok "8  only FAIL / PASS / UNRESOLVED (or Withdrawn) in examples and templates"
else
	red "8  answer heading outside the three-status vocabulary"
	printf '%s\n' "$bad_status" | sed 's/^/           /'
	note "   Nuance belongs in the Suggested fix line, never in the status."
fi

# =============================================================================
# 9. The example exam's declared question count is its real question count.
#    §3.3 tells readers to quote a count; a wrong one in the teaching example
#    teaches the wrong number.
# =============================================================================
if [ -f "$EXAMPLE_EXAM" ]; then
	declared=$(awk -F'|' '/^\| *Question count *\|/ {gsub(/[^0-9]/,"",$3); print $3}' "$EXAMPLE_EXAM")
	actual_q=$(grep -c '^### Q-' "$EXAMPLE_EXAM")
	if [ -z "$declared" ]; then
		red "9  $EXAMPLE_EXAM declares no question count"
	elif [ "$declared" = "$actual_q" ]; then
		ok "9  $EXAMPLE_EXAM declares $declared questions and has $actual_q"
	else
		red "9  $EXAMPLE_EXAM declares $declared questions but has $actual_q"
	fi
else
	red "9  $EXAMPLE_EXAM not found"
fi

# -----------------------------------------------------------------------------
printf '\n%s\n' "----------------------------------------------------------"
printf '%d passed, %d failed, %d skipped\n' "$passes" "$fails" "$skips"
[ "$fails" -eq 0 ] || exit 1
exit 0
