# Seal record (example)

> **Fictional.** The artifact these rows describe — a checkout release brief —
> does not exist. The exam and answer sheet beside this file are worked
> examples: the question shapes are real, the findings are staged, and every
> evidence label inside them is marked `— ILLUSTRATIVE` for that reason.
> The digests below, however, are real digests of real files in this repository,
> so the verification below genuinely works.

Append-only. One row per exam revision. Never edit a row; supersede it.

| Exam file | Exam SHA-256 | Artifact SHA-256 | Questions | Discriminating | Author | Independence | Sealed | Status |
|---|---|---|---|---|---|---|---|---|
| `checkout-brief-r1-exam.md` | `66c23dddbb3e6f7d1a3bc43cf4e62e37c33f07c149926d45a5c2ccdef46f24e4` | not recorded | 12 | 11 | Fresh reviewer B | independent | 2026-08-18 | `SUPERSEDED` |
| `checkout-brief-r1-exam.md` | `8fd974c55e75756c83b126c75f7479b9b7d05029da6ad976c2e555eaa1035596` | not recorded — fictional artifact | 14 | 13 | Fresh reviewer B | independent | 2026-08-18 | `ANSWERED` |

**Why there are two rows, and it is not decoration.** The first row sealed an
exam whose header said it contained 12 questions. It contained 14 — its own
dimension-coverage table summed to 14, and so did its `### Q-` headings. Nobody
noticed until a gate counted them (`scripts/check.sh`, check 9), which is the
whole argument of this project happening to this project. Correcting the header
changed the bytes, so the digest changed, so the row was superseded rather than
edited. The stale row stays: that is what append-only means.

Verify before answering:

```bash
sha256sum examples/checkout-brief-r1-exam.md          # Linux / Git Bash
shasum -a 256 examples/checkout-brief-r1-exam.md      # macOS
```

```powershell
Get-FileHash -Algorithm SHA256 examples\checkout-brief-r1-exam.md
certutil -hashfile examples\checkout-brief-r1-exam.md SHA256
```

**Compare case-insensitively** — PowerShell and `certutil` return uppercase, and
this record stores lowercase.

If the hash does not match the `ANSWERED` row, see
[`../skills/exam-protocol/templates/seal.md`](../skills/exam-protocol/templates/seal.md#when-a-hash-does-not-match)
before stopping. Line endings and letter case are benign and recoverable; only
a mismatch that survives both normalizations means a sealed exam was edited.
