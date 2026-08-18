# Exam: <subject> — revision <n>

<!--
  Copy this file to exams/<subject>-r<n>-exam.md and fill it in.
  Authored read-only by someone who did not do the work.
  Do NOT verify your own questions. Do NOT edit after sealing.
-->

| Field | Value |
|---|---|
| Artifact under exam | `<path or name of the thing being examined>` |
| Artifact SHA-256 | `<hash of the artifact at authoring time, or "not recorded">` |
| Decision this unblocks | `<what becomes allowed if this comes back clean>` |
| Author | `<fresh reviewer>` |
| Author independence | `independent` / `self-authored (<why no fresh session>)` |
| Authored | `<YYYY-MM-DD>` |
| Status | `AUTHORED_NOT_RUN` |
| Question count | `<n>` |
| Of which discriminating | `<n>` — see the note below |

<!--
  Author independence is required by SKILL.md §2. A self-authored exam is not
  worthless; it is measurably weaker, and the reader is entitled to know which
  one they are holding. Say so here rather than pretending.

  The artifact hash is required by SKILL.md §3.2. Sealing only the exam proves
  the exam did not move and proves nothing about the thing being graded — and
  rehearsal, whose whole purpose is to change the artifact, happens between
  sealing and answering. Never leave it blank; blank reads as "unchanged".
-->

Question count must equal the number of `### Q-` headings below. If they
disagree, the count is wrong — an exam that miscounts itself is teaching the
reader the wrong number while §3.3 tells them to quote one.

## does_not_grade

This exam does **not** evaluate:

- `<e.g. the product source code; only the document is in scope>`
- `<e.g. anything requiring an authenticated write action>`
- `<e.g. files not listed in "documents in scope" below>`

Green here is necessary, not sufficient.

## Documents in scope

Dimension 9 requires naming everything the executor is likely to open, not just
this artifact.

| Document | Why the executor would open it | Checked for contradictions? |
|---|---|---|
| `<the artifact>` | it is the instruction | yes |
| `<credential table / prior report / plan doc>` | `<reason>` | `<yes / no>` |

## Dimension coverage

Every row must say how many questions were asked, or why the dimension does not
apply. Blank is not permitted.

| # | Dimension | Questions | If none, why |
|---|---|---|---|
| 1 | Executability | | |
| 2 | Covariates / false findings | | |
| 3 | Operability of named fixtures | | |
| 4 | Stability of expected values | | |
| 5 | Concurrency | | |
| 6 | Assumed tooling | | |
| 7 | Blast radius of stop rules | | |
| 8 | Withdrawn items | | |
| 9 | Documents outside this one | | |
| 10 | Can the system satisfy the control? | | |
| 11 | Architecture invariants | | |

---

## Questions

<!--
  ID format: Q-<dimension number>-<sequence>.
  "Discriminates" = would this question give a different answer if the artifact
  were wrong? If the honest answer is no, the question is decoration; either
  sharpen it or delete it before sealing.
-->

### Q-1-01

**Question:** `<one specific, checkable question>`

**Why it might fail:** `<the failure mode being probed, in one sentence>`

**Discriminates:** `<yes / no + why>`

**Author side note:** `<only if strong evidence was seen incidentally — a
location, never a conclusion. Omit this line otherwise.>`

---

### Q-2-01

**Question:**

**Why it might fail:**

**Discriminates:**

---

<!-- repeat -->

## Note on the discriminating count

Report the number of questions that discriminate, not the total. If some
questions cannot distinguish a working artifact from a broken one, list their
IDs here and state that the total should not be quoted.

Non-discriminating question IDs: `<none / list>`
