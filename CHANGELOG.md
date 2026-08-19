# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Versioning note: this project ships prose, not code. A **major** bump means a
normative rule changed meaning (something that used to pass now fails, or the
reverse). A **minor** bump means a rule, dimension, or rehearsal check was
added. A **patch** bump means wording, examples, or typos.

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

## [Unreleased]

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

[Unreleased]: https://github.com/blackmoore14/exam-protocol-skill/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/blackmoore14/exam-protocol-skill/releases/tag/v0.1.0
