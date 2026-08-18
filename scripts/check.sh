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

# =============================================================================
# 10-12. Packaging manifests (Claude Code plugin + marketplace).
#
#    These three need a JSON parser, and the script deliberately depends on
#    exactly one: node. GitHub's runners ship it, and on Windows the usual
#    alternative resolves to a Store stub that hangs rather than answering. A
#    second implementation would also be a second source of truth for what
#    "valid" means, which is the thing CONTRIBUTING.md rule one forbids. If node
#    is absent these report SKIP — never pass.
#
#    They are structural. `claude plugin validate` is the authority on the
#    schema; see CONTRIBUTING.md, "The packaging gates", for why that command is
#    not run here.
# =============================================================================
if command -v node >/dev/null 2>&1; then
	pkg_out="${TMPDIR:-/tmp}/exam-protocol-pkg-$$.txt"
	node - > "$pkg_out" <<'NODE'
'use strict';
const fs = require('fs');
const path = require('path');

const PASS = (t) => console.log('PASS\t' + t);
const FAIL = (t) => console.log('FAIL\t' + t);
const NOTE = (t) => console.log('NOTE\t' + t);

// Marketplace names Anthropic reserves, plus the shapes that impersonate an
// official source. Encoded here rather than in prose because a naming rule
// nobody can run is a naming rule nobody follows.
const RESERVED = new Set([
	'claude-code-marketplace', 'claude-code-plugins', 'claude-plugins-official',
	'claude-plugins-community', 'claude-community', 'anthropic-marketplace',
	'anthropic-plugins', 'agent-skills', 'anthropic-agent-skills',
	'knowledge-work-plugins', 'life-sciences', 'claude-for-legal',
	'claude-for-financial-services', 'financial-services-plugins',
	'first-party-plugins', 'healthcare',
]);
const KEBAB = /^[a-z0-9]+(-[a-z0-9]+)*$/;
const DEFAULT_SKILL_DIRS = ['skills', './skills', 'skills/', './skills/'];

function readJson(p) {
	if (!fs.existsSync(p)) return { err: 'file not found' };
	try { return { val: JSON.parse(fs.readFileSync(p, 'utf8')) }; }
	catch (e) { return { err: 'does not parse as JSON — ' + e.message }; }
}

// --- 10: the plugin manifest ------------------------------------------------
const PM = '.claude-plugin/plugin.json';
const pm = readJson(PM);
if (pm.err) {
	FAIL('10  ' + PM + ' ' + pm.err);
} else {
	const p = pm.val;
	const bad = [];
	if (typeof p.name !== 'string' || !KEBAB.test(p.name)) {
		bad.push('name missing or not kebab-case: ' + JSON.stringify(p.name));
	}
	// Skills are auto-discovered from a top-level skills/ directory. Listing it
	// again buys nothing and invites the copy this repository exists to avoid.
	const declared = p.skills == null ? [] : (Array.isArray(p.skills) ? p.skills : [p.skills]);
	const redundant = declared.filter((s) => typeof s === 'string' && DEFAULT_SKILL_DIRS.includes(s));
	if (redundant.length) {
		bad.push('"skills" re-declares the auto-discovered directory (' + redundant.join(', ') + ')');
	}
	if (bad.length) FAIL('10  ' + PM + ': ' + bad.join('; '));
	else PASS('10  ' + PM + ' parses; name "' + p.name + '"; skills/ left to auto-discovery');
}

// --- 11: the marketplace manifest -------------------------------------------
const MM = '.claude-plugin/marketplace.json';
const mm = readJson(MM);
if (mm.err) {
	FAIL('11  ' + MM + ' ' + mm.err);
} else {
	const m = mm.val;
	const bad = [];
	if (typeof m.name !== 'string' || !KEBAB.test(m.name)) {
		bad.push('name missing or not kebab-case: ' + JSON.stringify(m.name));
	} else if (RESERVED.has(m.name)) {
		bad.push('name "' + m.name + '" is reserved for an official marketplace');
	}
	const o = m.owner;
	if (!o || typeof o !== 'object' || Array.isArray(o) || typeof o.name !== 'string' || !o.name) {
		bad.push('owner must be an object carrying a non-empty name');
	}
	if (!Array.isArray(m.plugins) || m.plugins.length === 0) {
		bad.push('plugins must be a non-empty array');
	}
	if (bad.length) FAIL('11  ' + MM + ': ' + bad.join('; '));
	else PASS('11  ' + MM + ' parses; name "' + m.name + '" is kebab-case and not reserved; owner.name and plugins[] present');
}

// --- 12: every marketplace entry resolves to a real plugin ------------------
if (mm.err) {
	FAIL('12  cannot resolve marketplace entries: ' + MM + ' ' + mm.err);
} else {
	const entries = Array.isArray(mm.val.plugins) ? mm.val.plugins : [];
	const bad = [];
	let resolved = 0;
	for (const e of entries) {
		const nm = e && e.name;
		if (typeof nm !== 'string' || !KEBAB.test(nm)) {
			bad.push('an entry has a missing or non-kebab-case name: ' + JSON.stringify(nm));
			continue;
		}
		const src = e.source;
		if (src === undefined || src === null) { bad.push(nm + ': no source'); continue; }
		if (typeof src === 'string') {
			// A relative source must start with "./" and is resolved against the
			// marketplace root — the directory holding .claude-plugin/, which is
			// this one, not .claude-plugin/ itself.
			if (src.indexOf('./') !== 0) {
				bad.push(nm + ': relative source "' + src + '" does not start with "./"');
				continue;
			}
			const manifest = path.join(path.resolve(process.cwd(), src), '.claude-plugin', 'plugin.json');
			if (!fs.existsSync(manifest)) {
				bad.push(nm + ': source "' + src + '" has no .claude-plugin/plugin.json under it');
				continue;
			}
			const inner = readJson(manifest);
			if (inner.err) { bad.push(nm + ': the plugin manifest at "' + src + '" ' + inner.err); continue; }
			if (inner.val.name !== nm) {
				bad.push(nm + ': marketplace entry name disagrees with plugin.json name "' + inner.val.name + '"');
				continue;
			}
			resolved++;
		} else if (typeof src === 'object') {
			NOTE('12  entry "' + nm + '" uses a non-path source (' + (src.source || 'object') + '); this gate cannot resolve it offline');
		} else {
			bad.push(nm + ': source is neither a "./path" string nor an object');
		}
	}
	if (bad.length) FAIL('12  marketplace entries: ' + bad.join('; '));
	else PASS('12  all ' + resolved + ' path-sourced marketplace entr' + (resolved === 1 ? 'y resolves' : 'ies resolve') + ' to a real plugin manifest');
}
NODE
	while IFS='	' read -r verdict text; do
		case "$verdict" in
			PASS) ok   "$text" ;;
			FAIL) red  "$text" ;;
			NOTE) note "$text" ;;
		esac
	done < "$pkg_out"
	rm -f "$pkg_out"
else
	skip "10 no node found; .claude-plugin/plugin.json not parsed"
	skip "11 no node found; .claude-plugin/marketplace.json not parsed"
	skip "12 no node found; marketplace entries not resolved"
fi

# =============================================================================
# 13. The skill directory name, the frontmatter name, and the invocation the
#     documentation promises are three copies of one value.
#
#     Claude Code resolves the invocation from the frontmatter and finds the
#     skill by its directory. If those disagree you discover it by trial, which
#     is the worst way. README.md's rename table already says to change both;
#     this makes forgetting one an error rather than a surprise.
# =============================================================================
SKILL_DIR=$(dirname "$SKILL_FILE")
SKILL_DIR_NAME=$(basename "$SKILL_DIR")
fm_name=$(
	awk '
		NR == 1 && $0 == "---" { inside = 1; next }
		inside && $0 == "---"  { exit }
		inside && /^name:[ \t]*/ {
			sub(/^name:[ \t]*/, "")
			gsub(/^["'"'"']|["'"'"']$/, "")
			sub(/[ \t]+$/, "")
			print; exit
		}
	' "$SKILL_FILE" 2>/dev/null
)
if [ -z "$fm_name" ]; then
	red "13 $SKILL_FILE has no name: field in its YAML frontmatter"
elif [ "$fm_name" != "$SKILL_DIR_NAME" ]; then
	red "13 frontmatter name \"$fm_name\" != directory name \"$SKILL_DIR_NAME\""
	note "   Change both together, or the invocation and the install path disagree."
elif ! grep -q "/$fm_name" README.md 2>/dev/null; then
	red "13 README.md never shows the invocation /$fm_name"
else
	ok "13 skill name \"$fm_name\" agrees: directory, frontmatter, and the /$fm_name in README.md"
fi

# =============================================================================
# 14. Exactly one SKILL.md, at the canonical path.
#
#     This is the gate for the failure the install instructions warn about:
#     `cp -r` into an existing directory leaves the superseded copy where the
#     loader reads it and buries the new one. If that ever happens inside this
#     repository, two files claim to be the protocol and nothing compares them.
# =============================================================================
skill_files=$(find . -type f -name 'SKILL.md' ! -path './.git/*' 2>/dev/null | sed 's|^\./||' | sort)
skill_count=$(printf '%s\n' "$skill_files" | grep -c . || true)
if [ "$skill_count" -eq 1 ] && [ "$skill_files" = "$SKILL_FILE" ]; then
	ok "14 exactly one SKILL.md, at $SKILL_FILE"
else
	red "14 expected exactly one SKILL.md at $SKILL_FILE; found $skill_count"
	printf '%s\n' "$skill_files" | sed 's/^/           /'
fi

# =============================================================================
# 15. README.md carries an install path for every distribution channel it
#     claims to support, plus the two sections people need afterwards.
#
#     A channel documented in the compatibility matrix but with no instructions
#     is worse than an unsupported one: the reader believes it works.
# =============================================================================
missing_section=""
for heading in \
	'### Claude Code — as a plugin' \
	'### Claude Code — as a standalone skill' \
	'### Codex and other `AGENTS.md` agents' \
	'## Compatibility' \
	'## Updating' \
	'## Uninstalling'
do
	grep -qF "$heading" README.md 2>/dev/null || missing_section="$missing_section
           $heading"
done
if [ -z "$missing_section" ]; then
	ok "15 README.md has every required install, compatibility and lifecycle section"
else
	red "15 README.md is missing required section(s):$missing_section"
fi

# =============================================================================
# 16. The repository URL the documentation tells people to clone is the
#     repository this actually is.
#
#     Check 2 catches an *unresolved* placeholder. It cannot catch a resolved
#     but wrong one, and that is not hypothetical: this project's own sealed
#     exam (exams/, Q-1-01) found the placeholder, the fix substituted an
#     account and a repository name, and the repository name was wrong — so
#     every clone command shipped broken with a green gate over it.
#
#     Citing somebody else's repository is legitimate, so this is not "no other
#     URL may appear" — it is "every other URL must be declared". An external
#     slug goes in EXTERNAL_SLUGS below, which makes a third-party link a named
#     decision instead of a silent one, and leaves a same-owner typo with
#     nowhere to hide.
#
#     Forks legitimately differ from the documented canonical URL. Set
#     EXAM_PROTOCOL_REPO_SLUG=owner/repo to override the comparison.
# =============================================================================
# Repositories this documentation may point at that are not this one.
# One per line, lowercase owner/repo, each with the reason it is here.
EXTERNAL_SLUGS='anthropics/claude-plugins-official'   # the grilling/grill-me comparison
slug_of() {
	# owner/repo from an https or ssh GitHub URL; nothing for anything else.
	printf '%s' "$1" |
		sed -e 's|^git+||' -e 's|^https://github\.com/||' -e 's|^git@github\.com:||' \
		    -e 's|^ssh://git@github\.com/||' -e 's|\.git$||' -e 's|/*$||' |
		awk -F/ 'NF >= 2 { print tolower($1 "/" $2) }'
}
expected_slug="${EXAM_PROTOCOL_REPO_SLUG:-}"
if [ -z "$expected_slug" ]; then
	expected_slug=$(slug_of "$(git remote get-url origin 2>/dev/null || true)")
fi
documented_slugs=$(
	grep -ho 'github\.com/[A-Za-z0-9._-]\{1,\}/[A-Za-z0-9._-]\{1,\}' README.md CHANGELOG.md 2>/dev/null |
		while IFS= read -r u; do slug_of "https://$u"; done |
		sort -u
)
undeclared=$(
	printf '%s\n' "$documented_slugs" | grep -v '^$' |
		grep -v -x -F "$expected_slug" |
		grep -v -x -F "$EXTERNAL_SLUGS" || true
)
if [ -z "$expected_slug" ]; then
	skip "16 no git remote and no EXAM_PROTOCOL_REPO_SLUG; documented URL not compared"
elif ! printf '%s\n' "$documented_slugs" | grep -q -x -F "$expected_slug"; then
	red "16 README.md / CHANGELOG.md never name this repository ($expected_slug)"
	note "   Readers cannot clone what is not written down."
	printf '%s\n' "$documented_slugs" | grep -v '^$' | sed 's/^/           documented instead: /'
elif [ -n "$undeclared" ]; then
	red "16 undeclared repository URL in the documentation"
	note "   this repository: $expected_slug"
	printf '%s\n' "$undeclared" | sed 's/^/           undeclared:      /'
	note "   A same-owner variant is the defect shape here: this project's own"
	note "   sealed exam fixed an OWNER placeholder into the wrong repository name"
	note "   and shipped every clone command broken. If the link is deliberate,"
	note "   add it to EXTERNAL_SLUGS in this script with a reason."
else
	ok "16 documented repository URL is $expected_slug, matching the git remote; external links declared"
fi

# =============================================================================
# 17. No broken relative link in any Markdown file.
#
#     Cross-file pointers are how this repository avoids duplicating rules, so
#     a dead one does not merely inconvenience a reader — it removes the only
#     copy of a rule from their reach.
# =============================================================================
broken_links=""
for f in $(find . -type f -name '*.md' ! -path './.git/*' 2>/dev/null | sort); do
	dir=$(dirname "$f")
	for target in $(grep -o '\]([^)]*)' "$f" 2>/dev/null | sed 's/^\](//; s/)$//'); do
		case "$target" in
			http://*|https://*|mailto:*|'#'*|'') continue ;;
		esac
		bare=${target%%#*}
		[ -n "$bare" ] || continue
		[ -e "$dir/$bare" ] || broken_links="$broken_links
           $f -> $target"
	done
done
if [ -z "$broken_links" ]; then
	ok "17 no broken relative link in any .md file"
else
	red "17 broken relative link(s):$broken_links"
fi

# -----------------------------------------------------------------------------
printf '\n%s\n' "----------------------------------------------------------"
printf '%d passed, %d failed, %d skipped\n' "$passes" "$fails" "$skips"
[ "$fails" -eq 0 ] || exit 1
exit 0
