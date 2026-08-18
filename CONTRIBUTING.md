# Contributing

Thanks for wanting to improve this. This project is prose, not code, so the
contribution bar is about **evidence and non-duplication**, not about tests
passing.

## The one rule that matters most

> **Every normative statement lives in exactly one file.**

Everything else may quote it, link to it, or summarize it in a sentence that is
explicitly marked as a pointer — but only one file may *define* it.

Why this is rule number one here: a protocol whose whole purpose is to catch
"two documents that disagree, and nobody noticed" would be embarrassing to ship
in two copies that drift apart. Concretely:

| File | May contain |
|---|---|
| `skills/exam-protocol/SKILL.md` | **All normative rules.** This is the source of truth. |
| `skills/exam-protocol/references/*.md` | Case material, worked mechanics, post-mortems. May restate a rule *only* as a quote with a link back. |
| `AGENTS.md` | A pointer to `SKILL.md` plus harness-specific loading instructions. **No rules.** |
| `README.md` | Marketing, quickstart, and the honest-limits section. May restate `SKILL.md` §9; **may not define a rule.** |
| `templates/*` | Forms to fill in. Field labels, not rules. |
| `examples/*` | Illustrations. Never normative. |

**No normative statement may be *defined* in two files.** Verbatim quotation is
permitted and so are user-facing snippets — text the *reader* is meant to paste
into their own project — and both must link back to the definition. A snippet
repeated across `README.md` and `AGENTS.md` is legal precisely because an agent
reading one will never open the other; wrap it in
`<!-- shared-snippet -->` … `<!-- /shared-snippet -->` so the duplicate-block
gate can tell it from an accident.

The earlier wording here — "if a PR adds the same sentence to two files, it will
be asked to delete one" — forbade what the row above permits, four lines apart,
in the section that calls this the rule that matters most. Two byte-identical
blocks were shipped under it.

## Adding a rule, a dimension, or a rehearsal check

Every addition must answer these four questions in the PR description. A PR that
cannot answer them is a good idea that is not yet ready.

1. **What incident produced it?** A rule with no incident behind it is a guess.
   Describe the shape of the failure — what passed, what was actually broken,
   and why the existing checks did not see it.
2. **Which existing dimension or check would already have caught it?** If one
   would have, the fix is to sharpen that one, not to add a twelfth.
3. **What does it *not* catch?** Every check has a blind side. Name it.
4. **How would someone know it is working?** If the honest answer is "you
   wouldn't", say so, and mark the rule as discipline rather than mechanism.

## Anonymization requirements

Incident material is the most valuable content here, and it is also the easiest
way to leak your employer's internals. Contributions containing case material
must be scrubbed before they are opened as a PR:

- No project, product, company, tenant, or customer names
- No hostnames, domains, IP addresses, or URLs pointing at private systems
- No account identifiers, usernames, emails, merchant IDs, or anything shaped
  like a credential — **including ones you believe are public sandbox values**
- No repository-specific file paths; describe the role of the file instead
  ("the checkout service", "the admin form definition")
- **The aggregate check.** Every rule above is about a single value, and a
  contributor can pass all four while publishing a mosaic. Read the whole PR
  *together with what is already in the repository*, as if you were trying to
  identify the source, then **blur any figure precise enough to be a
  fingerprint**. "Several hundred admin entry points" argues exactly as well as
  the exact count did, and "reported on nearly all, actually populated on two"
  argues exactly as well as the exact ratio did — those two figures were in an
  earlier draft and are deliberately not reproduced here. The mechanism is what
  teaches. The precision is what identifies.

**Keep the incident, drop the identifiers.** "A test skipped itself at the exact
moment stock went negative" is the valuable part. Which company it happened at
is not.

If you must show a value in order to make a point about it being wrong, do not
write it in a copy-pasteable form. Redact it and keep the conclusion. The
evidentiary value is in the conclusion, not in the string.

### The cost of this policy, stated plainly

Forbidding repository-specific paths means **no quantitative claim in this
project can be audited by a reader**, and `SKILL.md`'s own evidence rule (§7)
says an unlocatable claim is weak. The two policies are in direct conflict and
we have chosen anonymization. The price is paid openly: every number here is
labelled `[PRIOR]`, and both `does_not_grade` sections say so. Do not resolve
the conflict quietly in either direction.

## Style

- Write for an agent reading this at 3am with no context. Short declaratives.
- Prefer a criterion that can be *asked as a question* over an adjective.
  "Would this measurement give the same answer if the system were broken?" beats
  "be careful about weak tests."
- Tables for anything with more than three parallel cases.
- No emoji-as-severity in normative files. If something is mandatory, say
  "must". Decorative emphasis does not survive translation or terminal rendering.
- **`SKILL.md` must be at most 400 lines.** Not "roughly" — the number is
  enforced by `scripts/check.sh` check 3, and the file is currently **at** it.
  It is loaded into a context window, so the budget is the point.

### The eviction policy — what comes out

Because the file sits at its budget, **any addition must name what it replaces.**
A PR that adds ten normative lines and does not say which ten leave is not
finished, and the gate will say so.

Evict in this order:

1. **Historical expansion** — the paragraphs explaining which incident produced
   a rule. `references/failure-modes.md` is the home for those; the rule itself
   stays and gains a link.
2. **A worked example told more than once.** The cache-purge case was in three
   files; the two retellings went, the definition stayed.
3. **A form.** Anything a reader pastes belongs in `templates/`, not in the
   normative file — this is how the `§0-R` block moved out.

Never evict a rule, a dimension, a rehearsal check, or a `does_not_grade`
bullet. If those genuinely no longer fit, the protocol has outgrown one file and
that is a design conversation, not a trim.

## The gates

```sh
sh scripts/check.sh
```

Run it before opening a PR. `.github/workflows/check.yml` runs the same script
on every push and pull request. It needs POSIX `sh`, `grep`, `find`, `wc`, `awk`
and one SHA-256 utility; checks 10–12 additionally need `node`. A check that
cannot find the tool it needs reports `skip`, never `pass` — and in CI a skip is
promoted to a failure, because a gate that quietly stopped guarding is the thing
this repository is about.

The seventeen gates enforce, in order: line endings are pinned; no unresolved
account placeholder survives in a clone URL or release link; `SKILL.md` is
within budget; no unmarked multi-line block
is shared between `README.md`, `AGENTS.md` and `SKILL.md`; every example file
says it is fiction; the example answer sheet cites its sealed hash; that hash
still matches the file on disk; only the three answer statuses appear in
examples and templates; the example exam's declared question count is its
real one; the plugin manifest parses and does not re-declare the auto-discovered
`skills/` directory; the marketplace manifest parses and its name is neither
malformed nor reserved; every marketplace entry resolves to a real plugin
manifest whose name agrees; the skill's directory name, frontmatter `name` and
documented invocation are the same string; exactly one `SKILL.md` exists; the
README carries every install, compatibility and lifecycle section it promises;
the documented repository URL is this repository; and no relative Markdown link
is broken.

Two of them have escape hatches, because both guard against drift rather than
against contributors:

| Gate | Escape hatch | When to use it |
|---|---|---|
| 16, documented URL | `EXAM_PROTOCOL_REPO_SLUG=owner/repo` | You are working in a fork, whose remote is legitimately not the canonical URL. CI reads this from a repository variable of the same name. |
| 16, other repositories | the `EXTERNAL_SLUGS` list in `scripts/check.sh` | The documentation deliberately links to somebody else's repository. Add it **with a comment saying why** — the point is that a third-party link is a named decision, so that a same-owner typo has nowhere to hide. |

Check 15 pins a list of literal README headings. If you restructure the README,
update that list in the same commit; it exists so that a distribution channel
named in the compatibility matrix cannot end up with no instructions, which is
worse than not supporting it.

### How these gates were proved

`references/discrimination.md` §2.1 says a guard that finds nothing on its first
run against a real corpus has not been shown capable of failing. So each check
was written and run **before** the thing it checks was fixed:

| Check | First run, against the unfixed tree |
|---|---|
| 1 line endings | **red** — no `.gitattributes` existed |
| 2 account placeholder | **red** — three occurrences |
| 3 line budget | green (365 ≤ 400) — see below |
| 4 duplicate block | **red** — six lines identical across two files |
| 5 fiction banner | **red** — two of three example files |
| 6 answer cites hash | **red** — the field held a pointer, not a digest |
| 7 seal matches disk | green — see below |
| 8 status vocabulary | **red** — a fourth status in the worked example |
| 9 question count | **red** — declared 12, contained 14 |

Seven of nine. Checks 3 and 7 are **ratchets**, not finders: nothing was wrong
for them to find on the day they were written, so a green first run proves
nothing about them. Both were therefore proved by mutation instead — appending
40 lines to `SKILL.md` turned check 3 red at 405, and re-writing the sealed
example with CRLF endings turned check 7 red with the digest a Windows clone
would produce. Both mutations were reverted and the files verified byte-identical.

Check 9's red was not in the answer sheet that prompted this work. The gate
found it on its own, which is the only reason anyone knows the flagship example
had been miscounting itself.

### The packaging gates

Checks 10–17 were added when this repository was made installable as a Claude
Code plugin. They were written and run **before** the manifests existed, so five
of the eight were red on their first run against the tree:

| Check | First run, against the unpackaged tree |
|---|---|
| 10 plugin manifest | **red** — `.claude-plugin/plugin.json` did not exist |
| 11 marketplace manifest | **red** — `.claude-plugin/marketplace.json` did not exist |
| 12 entries resolve | **red** — nothing to resolve |
| 13 skill name agrees | green — ratchet, see below |
| 14 one `SKILL.md` | green — ratchet, see below |
| 15 README sections | **red** — five of six required sections were absent |
| 16 documented URL | **red** — and this one found a live defect, below |
| 17 relative links | green — ratchet, see below |

**Check 16 found a shipped defect, and it is the reason the check exists.** This
project's own sealed exam (`exams/`, Q-1-01) found an unresolved `OWNER`
placeholder in every clone command. The fix substituted a real account *and a
repository name that was wrong* — the repository is `exam-protocol-skill`, and
the documentation said `exam-protocol`. Check 2 stayed green throughout, because
it looks for the literal placeholder and this was a resolved-but-wrong value.
Every install command in the README and both links in `CHANGELOG.md` pointed at
a repository that is not this one, under a gate that reported no problem.

The lesson is narrower than "add more checks": a guard written against the
*symptom you just fixed* does not cover the *class*. Check 2 guards "unresolved
placeholder". Check 16 guards "the URL is this repository", which is the property
anybody actually wanted.

Checks 13, 14 and 17 were green on their first run, so they prove nothing on
their own and were demonstrated red by mutation instead:

| Check | Mutation | Result |
|---|---|---|
| 13 | frontmatter `name:` changed to `exam-protokol` | red — reported the disagreement with the directory name |
| 14 | a second `SKILL.md` created at `skills/exam-protocol/exam-protocol/SKILL.md`, exactly the `cp -r` footgun the README warns about | red — found 2 |
| 17 | a link to `skills/exam-protocol/NOPE.md` appended to the README | red — named the file and the target |

Three branches of the packaging gates had also never fired, so they were mutated
too: re-declaring `"skills": ["./skills"]` in the plugin manifest (10, red),
renaming the marketplace to `anthropic-plugins` (11, red), and pointing the
plugin `source` at `./does-not-exist` (12, red). Every mutation was reverted and
the files verified identical to their pre-mutation copies.

**Why those last three matter.** `claude plugin validate` passes all three of
them. Measured on this repository against version 2.1.227 of the CLI: it
rejects a missing `owner` and a name containing spaces, so it is demonstrably
capable of failing — but it accepted `anthropic-plugins` as a marketplace name,
accepted a `source` of `./does-not-exist`, and accepted a `source` of `.`
without the required leading `./`. It validates schema, not resolution. Checks
11 and 12 exist to cover exactly that gap, and neither replaces the other:

```sh
claude plugin validate .claude-plugin/plugin.json
claude plugin validate .claude-plugin/marketplace.json
```

Run both before opening a PR that touches either manifest. They are not in CI —
`.github/workflows/check.yml` says why at the bottom of the file.

## Proposing a translation

Translations are welcome but are held to the non-duplication rule, which makes
them harder than they look. A translation PR must:

1. Live under `skills/exam-protocol/i18n/<lang>/`
2. State at the top, in both languages, that the English `SKILL.md` is
   authoritative and that this file is a mirror
3. Record the commit SHA of the `SKILL.md` it was translated from
4. Add a drift note to the PR explaining who will re-sync it, and what happens
   if nobody does

Point 4 is not bureaucracy. An unmaintained translation is worse than no
translation: it is a second source of truth that quietly disagrees with the
first, which is the exact failure this protocol exists to catch.

## Licensing

By contributing you agree that your contributions are licensed under the MIT
License, as found in [LICENSE](LICENSE).
