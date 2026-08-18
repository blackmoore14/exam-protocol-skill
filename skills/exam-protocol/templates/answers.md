# Answers: <subject> — revision <n>

<!--
  Copy to exams/<subject>-r<n>-answers.md.
  Answered by a fresh reviewer who received ONLY the sealed exam — not the
  author's reasoning and not the implementer's.
-->

| Field | Value |
|---|---|
| Exam file | `exams/<subject>-r<n>-exam.md` |
| Exam SHA-256 | `<paste the sealed hash itself, not a pointer to the seal record>` |
| Artifact SHA-256 | `<paste the sealed artifact hash, or "not recorded">` |
| Answerer | `<fresh reviewer>` |
| Answered | `<YYYY-MM-DD>` |

<!--
  Paste the digests, not "see SEAL.md". The point of these two fields is that
  this file records *which documents it answered*; a pointer re-resolves to
  whatever the seal record says today. templates/seal.md defines the ANSWERED
  status as "an answer file exists AND cites this hash", so a pointer here makes
  that status untrue.

  Compare case-insensitively — Get-FileHash and certutil return uppercase. If a
  hash does not match, see templates/seal.md before stopping: line endings and
  letter case are benign and recoverable.
-->


## Result

| Status | Count |
|---|---|
| `FAIL` | |
| `PASS` | |
| `UNRESOLVED` | |
| Withdrawn | |
| **Total** | |

If `FAIL` is zero, state here which hypothesis you hold: the questions were too
loose, or the artifact is genuinely sound — and what evidence separates those
two. A zero-red exam has not been shown to discriminate.

---

## Answers

### Q-1-01 — `FAIL` / `PASS` / `UNRESOLVED`

**Finding:** `<what is actually true>`

**Evidence:** `<where you checked — file and line, command and output, screen
and what was on it. An answer with no location does not count.>`

**Verified by:** `[WALKED]` / `[API]` / `[DB]` / `[CODE]` / `[PRIOR]`

**Suggested fix:** `<only for FAIL. One sentence. You are not the arbiter.>`

**If UNRESOLVED — who is blocked, on what:** `<name the capability or access
that is missing. "Too hard" is not an answer; "requires an authenticated write
action, which I am not permitted to perform" is.>`

---

### Q-2-01 — `...`

<!-- repeat -->

---

## Questions I believe are themselves wrong

Judging a question defective is a legal outcome, and a valuable one. Historically
a majority of defects found in exams have been in the harness or setup rather
than in the behavioral assertions.

| ID | Why the question is wrong | What it should have asked |
|---|---|---|
| | | |

## Withdrawals

> **The arbiter fills this table in, after the answer sheet is complete.**
> Withdrawal is a step-6 ruling (`SKILL.md` §4) and the answerer finishes at
> step 5, so leave it empty. It sits in this file only so that the record stays
> in one place; every other line above it is the answerer's.

Withdrawn only with a reason, and the original text is preserved in the exam
file. "Too hard to investigate" is not a withdrawal — that is `UNRESOLVED`.

**A withdrawal must not park a finding outside the arithmetic.** If part of a
question is answerable and red, split it: answer `Q-n-mma` and withdraw
`Q-n-mmb`. A defect recorded in this table but not in the result count is
dimension 8's own failure — a real gap removed along with the item — and the
count is the number people quote.

| ID | Reason | Who decided |
|---|---|---|
| | | Arbiter |
