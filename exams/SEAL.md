# Seal record — this protocol, examined by this protocol

Append-only. One row per exam revision. Never edit a row; supersede it.

**This is not an illustration.** Everything in `examples/` is fiction. Everything
here is real: a fresh reviewer who did not write this repository authored 34
questions about it, a second reviewer answered them without seeing the author's
reasoning, and **30 came back red**. The answer sheet is committed unedited,
with its findings open.

It is here because the first question this project will be asked is "where is
your own exam?", and because `.gitignore` used to contain a rule that dropped
exactly this file.

| Exam file | Exam SHA-256 | Artifact SHA-256 | Questions | Discriminating | Author | Independence | Sealed | Status |
|---|---|---|---|---|---|---|---|---|
| `exam-protocol-self-r1-exam.md` | `43f4a36b09e6cc49dc900f8ca5a37c85748413015083319149ec6755bac7ed73` | not recorded — see below | 34 | 32 | Fresh reviewer, read-only | independent | **not sealed before answering** | `ANSWERED` |

Answer sheet: [`exam-protocol-self-r1-answers.md`](exam-protocol-self-r1-answers.md)
— SHA-256 `67bf6655477ad6a82158ae9fbc77e79bd31383b00c0ebc18e48e1db1363cb63f`.

## Three ways this row is out of order, stated rather than tidied away

**1. It was not sealed before it was answered.** `SKILL.md` §3.2 says seal
first. No seal record existed when the answerer received the exam; they computed
the digest over the file as delivered, recorded it in their own header, and
wrote a note saying they were proceeding out of order rather than silently. The
digest above is that same value, and it still matches the committed file — so
the exam demonstrably has not moved since. What is *not* proved is that it did
not move between authoring and answering. That is exactly the property a seal
exists to establish, and for this row it is not established.

**2. No artifact hash.** The artifact is this repository's working tree at the
moment of answering, which was before any of these findings were fixed. The
two-hash rule in §3.2 is one of the things this exam produced (Q-5-02), so the
mechanism did not exist when it was needed. The closest available reference
point is the first commit of this repository.

**3. Both documents were authored outside the tree**, under `scratchpad/`, and
copied in unmodified afterwards. The answer sheet's "Exam file" field still
names that original path. `.gitignore` ignored both `exams/` and `scratchpad/`
at the time, which is the ignore rule shaping behaviour — one of the findings.

## The answer sheet is preserved verbatim, including its own flaws

It grades one question `PASS, with a sharp split` — a fourth status, which
`SKILL.md` §4.1 does not have, and which is the same defect this exam found in
`examples/` (Q-4-03). It is left as written, because a sealed record that gets
edited to look better is not a record. `scripts/check.sh` check 8 therefore
scans `examples/` and `templates/` and deliberately **not** `exams/`: sealed
records must not be edited to please a guard, and a guard that pressures you to
edit them is worse than no guard.

## What has been fixed, and what has not

Most of the 30 reds are closed — the placeholder, the line endings, the seal
that cited a pointer instead of a digest, the invented fourth status, the zero
gates. The reds that remain open are named in the `does_not_grade` sections of
`README.md` and `SKILL.md`: the protocol's own rules have never been
mutation-tested, and none of its quantitative claims can be audited by a reader.

Neither is closed by writing it down. They are open, and dated.

## Verify

```bash
sha256sum exams/exam-protocol-self-r1-exam.md
sha256sum exams/exam-protocol-self-r1-answers.md
```

Compare case-insensitively. If a digest does not match, see
[`../skills/exam-protocol/templates/seal.md`](../skills/exam-protocol/templates/seal.md#when-a-hash-does-not-match)
before stopping — line endings and letter case are benign.
