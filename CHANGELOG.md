# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Versioning note: this project ships prose, not code. A **major** bump means a
normative rule changed meaning (something that used to pass now fails, or the
reverse). A **minor** bump means a rule, dimension, or rehearsal check was
added. A **patch** bump means wording, examples, or typos.

## [Unreleased]

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

[Unreleased]: https://github.com/blackmoore14/exam-protocol/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/blackmoore14/exam-protocol/releases/tag/v0.1.0
