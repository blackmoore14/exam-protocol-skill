# Seal record

Append-only. One row per exam revision. Never edit a row; supersede it with a
new revision.

The seal exists so that "the exam that was answered" and "the exam that was
written" are provably the same document — and so that the **artifact** that was
graded is provably the artifact that was reviewed. Both digests are required by
[`../SKILL.md`](../SKILL.md) §3.2. Sealing only the exam leaves the thing being
graded free to move, and rehearsal (whose whole purpose is to change it) happens
between sealing and answering.

| Exam file | Exam SHA-256 | Artifact SHA-256 | Questions | Discriminating | Author | Independence | Sealed | Status |
|---|---|---|---|---|---|---|---|---|
| `<subject>-r1-exam.md` | `<hash>` | `<hash or "not recorded">` | `<n>` | `<n>` | `<name>` | `independent` / `self-authored` | `<YYYY-MM-DD>` | `AUTHORED_NOT_RUN` |

`Artifact SHA-256` is never blank — a blank column reads as "unchanged". Write
`not recorded` if you did not hash it, and hash a manifest if the artifact is a
directory. `Independence` records whether a genuinely fresh session authored the
exam; see `SKILL.md` §2.

Status values:

| Status | Meaning |
|---|---|
| `AUTHORED_NOT_RUN` | Sealed, nobody has answered it |
| `ANSWERED` | An answer file exists and cites this hash |
| `SUPERSEDED` | A later revision replaced it. Row stays. |

`ANSWERED` requires the answer file to **cite the digest**, not to point at this
record. A pointer re-resolves to whatever the row says today, which is the thing
the seal exists to prevent.

## Computing the hash

```bash
sha256sum exams/<subject>-r1-exam.md          # Linux / Git Bash
shasum -a 256 exams/<subject>-r1-exam.md      # macOS
```

```powershell
Get-FileHash -Algorithm SHA256 exams\<subject>-r1-exam.md
certutil -hashfile exams\<subject>-r1-exam.md SHA256   # no PowerShell needed
```

**Compare case-insensitively.** `Get-FileHash` and `certutil` print uppercase
hex; this record stores lowercase; `sha256sum` prefixes the filename with `*` in
binary mode. A "mismatch" in which every single character differs is a case
difference, not a mismatch.

## When a hash does not match

**Do not stop yet.** Stopping is correct for tampering and wrong for the two
benign causes, and both benign causes are platform defaults:

| Cause | How to tell | What to do |
|---|---|---|
| **Letter case** | The digests match ignoring case | Nothing. Not a mismatch. |
| **Line endings** | Re-hash the file with LF endings and it matches; or the repository has no `.gitattributes` pinning `eol=lf` | The seal is **stale, not tampered**. Recompute and add a new row. |
| **Anything else** | Survives both normalizations | **Stop.** Someone edited a sealed exam, and answers would be about a different document. |

> **Stop only if the mismatch survives line-ending and case normalization.**

The arbiter is the override authority: only they may rule that a surviving
mismatch is benign, and they must record the reason in a new row.

A false stop is not a safe default. A guard that fires on a platform default
gets switched off within a week, and a switched-off guard is worse than none —
which is why `.gitattributes` must ship before the first clone, not after.

## Editing a sealed document

If you edit the exam or the artifact — even to fix a typo — this row becomes
stale, which is exactly the situation the seal is designed to make visible.
**Recompute and add a new row rather than editing this one.** Mark the old row
`SUPERSEDED`; it stays.
