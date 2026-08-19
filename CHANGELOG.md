# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Versioning note: this project ships prose, not code. A **major** bump means a
normative rule changed meaning (something that used to pass now fails, or the
reverse). A **minor** bump means a rule, dimension, or rehearsal check was
added. A **patch** bump means wording, examples, or typos.

## [Unreleased]

_Nothing yet._

## [0.2.2] - 2026-08-19

### Changed

- **The description now leads with the situation, not with what the tool is.**
  It opened `Adversarial verification protocol for deciding whether work is
  actually finished` — a definition — and put the trigger last, as a list of
  literal phrases the user had to say. That inherits the blind spot the protocol
  exists to remove: someone confidently about to say "done" is, by definition,
  not thinking "I should be examined," so a description that waits to be asked
  for by name is asking the subject to diagnose themselves.

  It now opens `Use when about to call work finished and someone downstream will
  act on it without re-checking it`, and names §1's four rows — handing over a
  brief or test plan, marking something verified in a ledger, telling a
  stakeholder it is done, withdrawing someone else's defect report.

  It also states the exclusion, because over-firing is the failure mode that
  gets a skill turned off: *skip it for a single reversible bugfix that already
  has test coverage.*

  Three literal phrases were dropped to stay inside the 400-line budget
  (`verify this is complete`, `review my test plan`, `before I ship`) — the
  situational clause now covers them, and per CONTRIBUTING an addition names
  what it replaced.

  **Not claimed:** whether a model actually invokes it more often after this is
  unmeasured. What is checkable is that the structure now matches
  `superpowers:verification-before-completion`, the one skill in the official
  marketplace occupying the same moment.

### Added

- README **"When it fires"** — states that the skill is model-invocable, why it
  deliberately does not ship `disable-model-invocation`, and how to turn that
  off if you would rather it never started on its own.

## [0.2.1] - 2026-08-19

Corrections found by an outside reviewer who had never seen this repository and
was asked to look for reasons **not** to publish it. Every item below is the
defect class this project sells itself on catching, found in this project.

### Fixed

- **Both CHANGELOG version links were dead, because no git tag had ever been
  cut.** `v0.1.0` and `v0.2.0` both 404'd, `[0.2.0]` had no link definition at
  all, and `[Unreleased]` still compared against `v0.1.0`. Tags now exist for
  every released version. Gate 16 could not catch this: it validates the
  `owner/repo` slug, not the path.
- **`README.md` told you to read back `version: "0.1.0"` after installing
  0.2.0.** Stale since the bump.
- **A count that disagreed with itself.** `scripts/check.sh` said "six of the
  nine went red"; `CONTRIBUTING.md` said "Seven of nine" and its table lists
  seven. The table is right. By this project's own §3.3 that is a mechanical
  red — a string that does not resolve against another string.
- **Gate 10's pass label overclaimed.** It printed "skills/ left to
  auto-discovery" while only rejecting four literal spellings, so
  `skills: ["./skills/exam-protocol"]` passed and was reported as absent. The
  check now normalises the path and rejects anything under `skills/`, and the
  label states what was actually checked. Proved by mutation: the exact string
  the reviewer found now fails, and the unmutated tree stays green.
- **The repository layout omitted `references/extending.md`**, added in 0.2.0.
- `[0.2.0]` was ordered above `[Unreleased]`, inverting the convention this file
  cites. The packaging work previously sitting under `[Unreleased]` is now named
  `[0.1.1]`, which is what actually shipped.

### Added

- **A comparison against `superpowers:verification-before-completion`.** The
  existing comparison was with a tool that runs *earlier*; the one that runs at
  the same moment sits in the official marketplace and was missing. Its Iron Law
  is self-verification, which is precisely what this protocol argues is
  structurally insufficient — the argument is the differentiation, and it was
  never made. Omitting the closest neighbour reads as avoidance.
- **"What kind of project this came from."** The five rules and the
  discrimination reference are domain-neutral; **R1-R8 are not** — they were
  shaped by a web application with authentication, an admin panel and payment
  vendors, and nothing said so. Now stated plainly, with a translation for each
  web-shaped check. This was the largest adoption barrier and it was an unstated
  assumption in a document that states everything else.

## [0.2.0] — 2026-08-19

### Added

- **§3.2 — what the seal cannot freeze.** Hashing the artifact pins the claims
  and pins nothing about the running system the claims are about. Found on the
  first real run of this protocol against a live project: while an exam was being
  answered, a separate agent was editing three of the services the exam asked
  about, with every hash still matching. The rule now asks for a third recorded
  value — the system revision the answers describe — and says that a system
  moving faster than its exam is a finding, not a detail.

### Changed

- **§10 moved to `references/extending.md`.** The §3.2 addition pushed
  `SKILL.md` over its 400-line budget and the gate went red. Per `CONTRIBUTING`,
  an addition must name what it replaces: extending the protocol is secondary to
  using it, so it left. `SKILL.md` is 399 lines; the stub keeps the two rules an
  extender must not miss (12+/R9+ reserved, `SKILL.local.md` not in-place edits).

### Notes

- The first real run also produced the protocol's first measured catch on a live
  artifact: an exam question comparing a brief against a second status document
  the executor would also open found a figure that mixed two environments — a
  local-database tenant count paired with a production scope count, in one
  sentence, labelled as a database observation. The brief's author knew the whole
  document was unverified against screens and still could not see it.

## [0.1.1] - 2026-08-19

### Added

- `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` — the
  repository is now installable as a Claude Code plugin and is its own
  single-plugin marketplace. The plugin manifest deliberately declares **no**
  `skills` field: skills are auto-discovered from the top-level `skills/`
  directory, so the plugin and the standalone skill are the same bytes rather
  than two copies that can drift. Verified by installing from a local clone and
  reading the component inventory back (`Skills (1) exam-protocol`).
- Eight packaging gates in `scripts/check.sh` (checks 10–17): both manifests
  parse; the marketplace entry resolves to a real plugin directory; the
  marketplace name is not one Anthropic reserves; the skill directory name, its
  frontmatter `name` and the documented invocation are one string; exactly one
  `SKILL.md` exists; the README carries every section its compatibility matrix
  promises; the documented repository URL is this repository; no relative link
  is broken. Five were red on their first run; the other three were proved by
  mutation. CONTRIBUTING.md records both.
- README sections for the three install paths, a compatibility matrix showing
  what `AGENTS.md` agents do **not** get, an "I installed it — now what?"
  walkthrough, updating, uninstalling, and distribution.
- A `Where this sits` section comparing this protocol with the `grilling` /
  `grill-me` skill in `mattpocock-skills` — requirements first, verification
  after. Read from that skill's source at v1.2.3 on 2026-08-19 and dated
  accordingly, because a description of a file is an observation of the moment
  it was read.

### Fixed

- **Every clone and install command pointed at a repository that does not
  exist.** The repository is `blackmoore14/exam-protocol-skill`; the README and
  both `CHANGELOG.md` links said `blackmoore14/exam-protocol`. This was the
  resolved-but-wrong tail of the `OWNER` placeholder defect found by this
  project's own sealed exam (Q-1-01): check 2 guards the literal placeholder and
  is structurally unable to see a plausible wrong value, so it stayed green.
  Check 16 now pins the documented URL to `git remote get-url origin`.

### Added

- `.gitattributes` pinning `*.md` to LF. The seal is a hash over bytes, and a
  clone with Git's Windows default rewrote every file, so the first check the
  protocol asks a reader to perform failed on day one.
- `scripts/check.sh` and `.github/workflows/check.yml` — nine gates over this
  repository's own invariants. Seven went red on their first run against the
  tree; the two that did not are ratchets and were proved red by mutation.
- `exams/` — this protocol applied to itself, sealed, with the open findings
  left open. `.gitignore` previously dropped exactly this file.
- Author-independence and artifact-hash fields in the exam, answer and seal
  templates.

### Changed

- The install instructions now remove the destination before copying. `cp -r`
  into an existing directory left the superseded copy where the loader reads it.
- The worked example is regraded: two answers whose own findings said the
  artifact did not hold were marked `PASS`, and the file invented a fourth
  status. Its question count was also wrong — 12 declared, 14 present — so its
  seal hash has changed.
- Quantitative claims are labelled `[PRIOR]`, and figures precise enough to
  fingerprint the source repository have been blurred.

## [0.1.0] - 2026-08-18

### Added

- `skills/exam-protocol/SKILL.md` — the normative protocol: roles, the five
  rules, the sealed workflow, the 11 authoring dimensions, the 8 rehearsal
  checks, evidence-strength labels, and the `does_not_grade` requirement.
- `skills/exam-protocol/references/discrimination.md` — how to tell whether a
  check can fail at all: covariate detection, negative controls, mutation
  testing, the two shapes of an invalid mutation, and the N-doors rule.
- `skills/exam-protocol/references/failure-modes.md` — anonymized post-mortems
  of exams that passed while the work was broken, each paired with the
  dimension or rehearsal check that now exists because of it.
- `skills/exam-protocol/templates/` — copy-paste templates for the exam, the
  answer sheet, and the seal record.
- `AGENTS.md` — entry point for Codex and other `AGENTS.md`-reading agents;
  delegates to `SKILL.md` rather than restating it.
- `examples/` — one complete worked exam and answer sheet.

[Unreleased]: https://github.com/blackmoore14/exam-protocol-skill/compare/v0.2.2...HEAD
[0.2.2]: https://github.com/blackmoore14/exam-protocol-skill/releases/tag/v0.2.2
[0.2.1]: https://github.com/blackmoore14/exam-protocol-skill/releases/tag/v0.2.1
[0.2.0]: https://github.com/blackmoore14/exam-protocol-skill/releases/tag/v0.2.0
[0.1.1]: https://github.com/blackmoore14/exam-protocol-skill/releases/tag/v0.1.1
[0.1.0]: https://github.com/blackmoore14/exam-protocol-skill/releases/tag/v0.1.0
