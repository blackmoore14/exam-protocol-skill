# Answers: exam-protocol (the repository itself) — revision 1

> Answered by a fresh reviewer who received only the exam. I did not author it,
> did not write the artifact, and had no exposure to either author's reasoning.
> Written in the shape of `skills/exam-protocol/templates/answers.md`, because
> answering this exam in any other form would have been the first finding.

| Field | Value |
|---|---|
| Exam file | `scratchpad/exam-protocol-self-exam.md` |
| Exam SHA-256 | `43f4a36b09e6cc49dc900f8ca5a37c85748413015083319149ec6755bac7ed73` |
| Answerer | Fresh reviewer (read-only on the artifact) |
| Answered | 2026-08-18 |

**Note on the seal.** The exam declared itself `AUTHORED_NOT_RUN` **and not
sealed** (exam:843-847). No seal record existed. I computed the hash above over
the file as delivered and record it here so that these answers are pinnable to a
specific document. Under `SKILL.md` §3.2 this is out of order — sealing precedes
answering — and I am noting it rather than silently proceeding.

## Result

| Status | Count |
|---|---|
| `FAIL` | 30 |
| `PASS` | 3 |
| `UNRESOLVED` | 1 |
| Withdrawn | 0 |
| **Total** | 34 |

Thirty reds out of thirty-two discriminating questions. The exam has
demonstrated it can fail many times over, so the three greens carry information.

**But 30/32 is itself a finding, and it is the one the exam asked about in
Q-2-02.** A red rate this high is exactly the signal a well-formed protocol
should treat as ambiguous between "the artifact is broken" and "the exam was
mis-aimed." I hold the first hypothesis, and the evidence separating them is
that **the reds are overwhelmingly mechanical rather than interpretive**: a
placeholder string that does not resolve, a hash that does not match on a
default platform configuration, a status vocabulary the shipped example does not
use, byte-identical text in two files, a directory count of zero gates. Those do
not depend on my reading. Only Q-2-05, Q-8-04 and Q-10-01 required judgement.

That said, this exam **did** attack a soft target in one respect: it graded a
0.1.0 pre-publication prose repository against the standard of a finished
product. Several reds (Q-4-02, Q-11-01, Q-11-02) are "not yet built" rather than
"built wrong." I have marked those.

---

## Answers

### Q-1-01 — `FAIL`

**Finding:** The documented install sequence cannot succeed. `git clone
https://github.com/OWNER/exam-protocol.git` resolves to a literal user named
`OWNER`, which is not the publisher. The placeholder appears in **three**
places, not two: `README.md:129`, `CHANGELOG.md:34`, `CHANGELOG.md:35`. The
correct command is not derivable from anything in the tree — the repository does
not state its own publication URL anywhere.

**Evidence:** `grep -rn "OWNER" .` returns exactly those three lines and nothing
else. There is no `package.json`, no `.github`, and no remote to infer the
account from — the working tree contains only `.gitignore`, `LICENSE`, and 14
Markdown files (`find . -type f ! -name '*.md' ! -name 'LICENSE'` → `./.gitignore`).

**Verified by:** `[API]` — ran the search; did not attempt the clone.

**Suggested fix:** Substitute the real account in all three lines, and add a
release check that greps for `OWNER` before tagging.

**Limit:** I did not attempt the clone, because a `github.com/OWNER` account may
exist and belong to a stranger. That would make the command worse, not better.

---

### Q-1-02 — `FAIL`

**Finding:** The upgrade path is worse than the exam's hypothesis. I ran the
sequence. On a second run the result is **not** merely "one directory deeper" —
the *old* copy survives at the loaded path and the *new* copy is buried where
nothing reads it:

```
first run   → dst/exam-protocol/SKILL.md                (v1)
second run  → dst/exam-protocol/SKILL.md                (still v1)
              dst/exam-protocol/exam-protocol/SKILL.md  (v2)
```

So an adopter who "upgrades" keeps loading the **superseded** protocol
indefinitely, with the new one present on disk as proof they upgraded. This is
POSIX-specified behaviour for `cp` when the destination is an existing
directory, so BSD/macOS `cp -R` does the same. No documented upgrade path exists
— `grep -rni "upgrade\|update"` finds no install-related instruction. Nothing
makes the nesting visible to the adopter, and a skill that does not load
produces no error.

**Evidence:** Executed in a scratch directory with GNU coreutils 8.32 (output
above). `README.md:128-138` and `AGENTS.md:29-32` are the only install
instructions and both are bare `cp -r`.

**Verified by:** `[WALKED]` — ran the exact command shape against dummy files.

**Suggested fix:** `rm -rf ~/.claude/skills/exam-protocol && cp -r <src>/skills/exam-protocol ~/.claude/skills/`,
or `cp -rT`. Add a version line the adopter can read back after installing —
`metadata.version` already exists in the frontmatter and is the natural probe.

---

### Q-1-03 — `UNRESOLVED`

**Finding:** I cannot grade the primary clause, for two independent reasons, and
the first of them is a defect in the question.

1. **The question is out of scope by this exam's own declaration.** The exam's
   `does_not_grade` (exam:34-36) excludes "any state that lives outside this
   working tree — GitHub issues, CI runs, releases, a published skill listing,
   the commit history, or **whether the package has ever been installed
   anywhere**." Q-1-03 asks precisely that. Under `SKILL.md` §3.5 the header
   binds the exam; grading it anyway would make the `does_not_grade` decorative.
2. **The harness-parsing clause requires an action I am prohibited from
   performing** — installing the skill into `~/.claude/skills/` and loading it
   in Claude Code, Codex, Jules, Cursor and Aider.

**Who is blocked, on what:** Whoever can install the skill, in each named
harness. This is not "too hard"; it is a capability I do not have under my
instructions. One five-minute load per harness settles it.

**Spillover finding (red, and answerable from the tree):** the README's
triggering claim cannot hold for half the audience it claims. `README.md:5-6`
says the skill "works in both Claude Code and Codex and other `AGENTS.md`
agents", and `README.md:140-142` says the `description` field triggers on
phrases. But `AGENTS.md:8-9` instructs those agents to **read a file**
(`> Read skills/exam-protocol/SKILL.md`) — there is no skill loader, no
frontmatter parser, and therefore no description-based triggering in that
ecosystem. For an `AGENTS.md` agent the entire YAML block at `SKILL.md:1-20` is
inert text that consumes context. The claim is Claude-Code-only and the README
does not scope it.

**Verified by:** `[CODE]` for the spillover; nothing for the primary clause.

---

### Q-2-01 — `FAIL`

**Finding:** Applying the repository's own negative control (`discrimination.md`
§1.1) to its own trigger claim: **if `SKILL.md` were emptied of everything below
line 20, the evidence offered for triggering would be byte-identical**, because
what triggers is the `description:` field and the description is above line 20.
Worse, the repository offers **no evidence at all** for triggering — not a run,
not a transcript, not a log. So there is nothing to differ.

No observation currently distinguishes "the skill triggered" from "the skill
triggered and helped." Distinguishing them requires an outcome measure the
repository does not have and does not claim to have: e.g. a paired run of the
same artifact with and without the skill loaded, comparing whether the produced
exam names the eleven dimensions and produces a red.

**Evidence:** `SKILL.md:1-20` is the frontmatter; `SKILL.md:3-13` is the
`description`. `README.md:140-142` states the triggering claim. There is no
`examples/` artifact produced by a real run — `examples/checkout-brief-r1-exam.md:3`
declares itself fictional.

**Verified by:** `[CODE]`

**Suggested fix:** Either drop the effectiveness implication and claim only
triggering, or add one real transcript. The honest cheap version: run the
protocol against one public artifact and commit the exam, the answers and the
seal.

---

### Q-2-02 — `FAIL`

**Finding:** There is **no** stated threshold on the high-red side, anywhere in
the repository. `SKILL.md` §3.3 is one-sided by construction: it names only the
zero-red hypothesis. `templates/answers.md:26-28` again asks only "if `FAIL` is
zero." `AGENTS.md:74-75` again only "If zero."

The only acknowledgement that an exam can itself be wrong is qualitative:
`SKILL.md:344-347` ("The author writes flawed questions too… all four were in
the harness or the setup") and the per-question table at
`templates/answers.md:57-65`. Neither is a threshold, a rate, or a rule. Nothing
tells a reader at what point a high red count should be read as evidence about
the exam rather than about the artifact.

**Evidence:** `grep -rn "zero red\|all-green\|too loose"` finds §3.3,
`templates/answers.md:26-28`, `AGENTS.md:74-75` and nothing on the other side.

**Verified by:** `[CODE]`

**Suggested fix:** Add the mirror rule to §3.3. A workable form, which this
answer sheet is forced to improvise: *when the red rate exceeds a large fraction,
state which hypothesis you hold and what separates them — the discriminator is
whether the reds are mechanical (a string, a hash, a count, a missing file) or
interpretive (a reading of intent). Mechanical reds are about the artifact.*

**This exam is the live demonstration.** 30 of 32 discriminating questions are
red and the protocol gives its own answerer no vocabulary for saying whether
that is a triumph or a warning.

---

### Q-2-03 — `FAIL`, and worse than the question supposes

**Finding:** Nothing prevents a reader from copying the reporting form without
performing the experiment, and the situation is one step worse than the question
assumes: **the file containing the fabricated measurement never says it is
fictional.**

The word "fictional" occurs exactly **once in the entire repository**, at
`examples/checkout-brief-r1-exam.md:3`. The answers file — the one carrying
"Negative control — replaced the button's handler with a no-op and re-ran the
sequence" at `:75-78`, carrying `[API]` evidence labels, and carrying the
arbiter note — says only "Worked example, paired with…" at `:3-5`. A reader who
opens the answer sheet directly (the likelier of the two, since it is the one
with the findings in it) receives **no fiction signal whatsoever**.

Every structural signal points the other way: a specific evidence-strength
label, a specific `[API]` claim, a specific reported observation. Those are the
exact markers `SKILL.md` §7 introduces so a reader can tell how deeply something
was checked — deployed here on something that was not checked at all.

`CONTRIBUTING.md:25` does say `examples/*` are "Illustrations. Never normative,"
but that is in a file the imitator has no reason to open.

**Evidence:** `grep -rn "fiction" --include=*.md .` → one hit, in the exam file
only. `examples/checkout-brief-r1-answers.md:1-12` header contains no such
marker; `:43`, `:62`, `:80`, `:96` etc. carry evidence labels.

**Verified by:** `[CODE]`

**Suggested fix:** Put a fiction banner in **every** example file, and strip or
visibly mark the evidence labels inside illustrated results — e.g.
`[API — ILLUSTRATIVE]`. A fabricated measurement wearing a real measurement's
badge is the repository's own §3.4 failure, committed in its teaching material.

---

### Q-2-04 — `FAIL`

**Finding:** A reader has **no location for any of them**. Checked each:

| Claim | Where stated | Location offered |
|---|---|---|
| 36 questions / 30 red | `README.md:26`, `SKILL.md:31`, `failure-modes.md:18-23` | none |
| ~70 review cycles | `README.md:222` | none |
| 42 of 506 admin entry points | `SKILL.md:241` | none |
| 51 of 52 → populated on 2 | `SKILL.md:249-250` | none |
| 12 passing cases turned red | `discrimination.md:149-150` | none |

Under `templates/answers.md:38-40` ("An answer with no location does not count")
the correct status for the entire provenance section is `UNRESOLVED`. That is
not an accident of sloppiness — it is **structurally guaranteed** by
`CONTRIBUTING.md:53-54`, which forbids repository-specific file paths. The
anonymization policy and the evidence policy are in direct conflict, and nothing
in the repository acknowledges that.

The aggravating detail: `README.md:169` presents the `does_not_grade` section as
"the reason to trust the rest of the page," and that section does **not** list
unauditable provenance among its blind spots.

**Evidence:** the five locations above; `README.md:167-194` (the seven
`does_not_grade` bullets; none covers this); `CONTRIBUTING.md:53-54`.

**Verified by:** `[CODE]`

**Suggested fix:** Add an eighth bullet to both `does_not_grade` sections: *the
quantitative claims in this repository cannot be audited by a reader, by design;
treat them as `[PRIOR]`.* Applying the protocol's own label to its own numbers
costs nothing and is the most credible thing the project could do.

---

### Q-2-05 — `FAIL`

**Finding:** Traced all four. **At most one** of the four is attributable to an
exam, and one of the four has no post-mortem in the repository at all.

| # | Incident (`README.md`) | Mechanism that found it, per the repository's own text |
|---|---|---|
| 1 | `deduct_prevents_negative_stock` skipping itself (`:39-42`) | **Untraceable.** `grep -rn "negative stock\|deduct_prevents"` → **README only.** No entry in `failure-modes.md`. |
| 2 | cache-purge covariate (`:43-46`) | Design-time negative control, `discrimination.md:26-31`: "This was settled before any executor touched it." Appears as an exam question in the fictional example. **Plausibly the exam.** |
| 3 | Three-door access link (`:47-51`) | **Mutation testing**, `discrimination.md:160-169` — a table of "door removed → suite result." Not an exam. |
| 4 | Paywall / syndication feed (`:52-55`) | **Bypass inventory**, `discrimination.md:198-214`: "all from independent investigations." Not an exam. |

The repository contradicts the README twice, in its own tables. `failure-modes.md:161-165`
lists "The exam" as one of three gates that **could not see** the credential
defect. `failure-modes.md:200-204` lists "The exam | briefs and ledgers —
**documents** | Product source was never in scope." Incidents 1, 3 and 4 all live
in product or test source. By `SKILL.md:338-341` an exam is blind to all three.

Incident 1 is the sharpest: it is the **lead** item under "What happens without
it," and it is the one the repository has no record of.

**Evidence:** the greps and line references above.

**Verified by:** `[CODE]`

**Suggested fix:** Retitle the section — it is currently "What happens without
it" under a heading about *this protocol*. Either label each incident with the
gate that caught it (which is far more persuasive: it shows a portfolio of
gates), or move 1/3/4 into a "what the exam does **not** catch" section, where
`SKILL.md` §9 already says they belong.

---

### Q-3-01 — `FAIL` — measured, with both hashes

**Finding:** On a Windows clone with Git's default `core.autocrlf`, the
working-tree file **does not** hash to the recorded value. There is no
`.gitattributes`.

```
recorded in examples/SEAL.md:7          66c23dddbb3e6f7d1a3bc43cf4e62e37c33f07c149926d45a5c2ccdef46f24e4
LF bytes (as shipped)                   66c23dddbb3e6f7d1a3bc43cf4e62e37c33f07c149926d45a5c2ccdef46f24e4  ✓
CRLF bytes (autocrlf=true checkout)     89897f54e42481aa296d27bfa1c34937aebab6585cbcf80e26de90f6fdab3185  ✗
```

`core.autocrlf` is `true` in the global configuration of the machine I am
answering on, which is Git for Windows' installer default. So the **first
verification a new Windows adopter performs — on the repository's own shipped
example — fails, and the instruction they are given at `examples/SEAL.md:20-21`
is "stop."**

`discrimination.md:96-101` states the consequence in the repository's own words:
false positives get guards switched off, and that is worse than having none. This
is a false positive on the flagship guard, on day one, for the platform the
install instructions do not cover at all (Q-6-01).

**Evidence:** `sha256sum examples/checkout-brief-r1-exam.md` →
`66c23ddd…`; `sed 's/$/\r/' … | sha256sum` → `89897f54…`;
`ls .gitattributes` → No such file; `git config --global core.autocrlf` → `true`.
All 14 Markdown files are currently LF (`grep -qU $'\r'` on each).

**Verified by:** `[WALKED]` — computed both hashes on disk.

**Suggested fix:** Add `.gitattributes` with `*.md text eol=lf` **before**
publishing. Retroactively adding it after adopters have cloned re-creates the
same mismatch in the other direction, so this must land in the initial release.

**Additional finding, outside the question:** `C:\Users\Admin\Repositories\exam-protocol`
**is not a git repository** — `git rev-parse --show-toplevel` → "fatal: not a git
repository", and there is no `.git` directory. So no clone, no checkout and no
line-ending conversion has ever happened here, no commit exists, the `.gitignore`
has never taken effect, and `CHANGELOG.md`'s `v0.1.0` tag links point at a
release that does not exist. Every question in this exam framed around "the
committed state" is currently answering about an uncommitted directory.

---

### Q-3-02 — `FAIL`

**Finding:** No. The repository contains **no exams/ directory and no sealed exam
over itself**. The only sealed artifact is the admittedly fictional checkout
example. And `.gitignore:19` would silently drop a real one placed in the
location `SKILL.md:149-154` recommends.

The `.gitignore` comment's reasoning does not survive the case where the artifact
under exam is this repository: `:17` says "Exams produced by *users* of this
protocol live in their own repo, not here" — but an exam **of** this protocol is
not produced by a user of it against their own code; it is this project's own
work product, and by the project's own thesis it is the one artifact that proves
the thesis.

**Evidence:** `find . -type f` lists 16 files, none under `exams/`;
`.gitignore:17-20`; `SKILL.md:149-154` recommends `exams/`.

**Verified by:** `[API]`

**Suggested fix:** Narrow the ignore to `exams/local/` or `*-answers.local.md`
(already there), commit a real self-exam under `exams/`, and put the seal row in
a top-level `SEAL.md`. Note that even this exam was, by instruction, written
**outside** the repository — the ignore rule is already shaping behaviour.

---

### Q-3-03 — `FAIL`, both halves

**Finding:** The example fails `AGENTS.md`'s completion condition, and the two
seal statuses contradict each other.

1. `AGENTS.md:73` (the exam cites `:72`, which is item 1 — an off-by-one in the
   question, the requirement itself is item 2 at `:73`) requires "does the answer
   sheet cite the matching hash?" The answer sheet's `Exam SHA-256` field at
   `examples/checkout-brief-r1-answers.md:10` contains the string
   `see examples/SEAL.md — verify before answering`. **That is a pointer, not a
   hash.** It is exactly the shape `SKILL.md` §3.2 and `templates/seal.md:6-9`
   exist to prevent: the answer file does not record which document it answered,
   so re-sealing `SEAL.md` at a new revision leaves the answer sheet pointing at
   whatever the row says today.
2. `templates/seal.md:20` defines `ANSWERED` as "An answer file exists **and
   cites this hash**." `examples/SEAL.md:7` records `ANSWERED`. Since the answer
   file cites no hash, the status is wrong by the repository's own definition.

So the repository's only worked example fails two of the five sanity-check items,
on a check the repository wrote, and nobody ran it. Per `discrimination.md`
§2.1, that check has now been shown capable of failing — by failing.

**Evidence:** `examples/checkout-brief-r1-answers.md:10`; `examples/SEAL.md:7`;
`templates/seal.md:20`; `AGENTS.md:73`; `templates/answers.md:12` (the template
field says "paste the sealed hash", so the example diverges from its own template).

**Verified by:** `[API]`

**Suggested fix:** Paste `66c23ddd…` into `:10`. One line, and it makes the
example pass its own gate.

---

### Q-4-01 — `FAIL`

**Finding:** The term "downstream artifact" is **never defined**. `grep -n
"downstream"` in `SKILL.md` finds `:220` ("before anything is handed
downstream"), `:262` (the §7 rule), `:309` ("any downstream artifact is a
rehearsal handoff") — a brief handed to an executor. `SKILL.md` is plainly
upstream of that, so it is probably exempt by implication.

But: the exemption is nowhere written, and the consequence is live. **None** of
`SKILL.md`'s numeric claims carries a label — `:31` (36/30), `:241` (42 of 506),
`:249-250` (51 of 52 → 2), `:345` (four defects in one exam). A reader cannot
tell whether "42 of 506" was `[WALKED]`, `[API]` or `[PRIOR]`, and §7's own
argument is that this distinction is the whole point. `discrimination.md:149-150`
and `failure-modes.md` §1 have the same gap.

The strongest version of this finding: `SKILL.md:274-278` says a `[PRIOR]` claim
is "an observation made then, not a fact now," and every number in this
repository is by construction an observation made then.

**Evidence:** the four line references; `grep -n "\[WALKED\]\|\[API\]\|\[DB\]\|\[CODE\]\|\[PRIOR\]" skills/exam-protocol/SKILL.md`
returns only the §7 definition table itself.

**Verified by:** `[API]`

**Suggested fix:** Define "downstream artifact" in §7 in one sentence, and label
the numbers anyway. Self-application is the cheapest credibility this project can
buy, and it currently spends it on nothing.

---

### Q-4-02 — `FAIL` (of the "not yet built" kind)

**Finding:** Nothing enforces it. `SKILL.md` is **365 lines** — inside the
budget, so the question is entirely about the future. There is no CI, no linter,
no PR template, no checklist that runs: `find . -type f ! -name '*.md' ! -name 'LICENSE'`
returns `./.gitignore` and nothing else, and there is no `.github/`.

No eviction policy exists. `CONTRIBUTING.md:29-41` explicitly anticipates new
dimensions and checks and asks four good questions about each — none of which is
"what comes out." `CONTRIBUTING.md:38` gets closest ("the fix is to sharpen that
one, not to add a twelfth") but that is a bar on *adding*, not a rule for
*removing*, and it does not bind once a twelfth is genuinely justified.

"Roughly 400" binds nothing: it is unenforced, approximate, and has no owner.
The first PR that breaches it will be judged by whoever reviews it.

**Evidence:** `wc -l skills/exam-protocol/SKILL.md` → 365; `CONTRIBUTING.md:73`;
`CONTRIBUTING.md:29-41`; the file listing.

**Verified by:** `[API]`

**Suggested fix:** A four-line CI step (`wc -l` with a hard number, not
"roughly") plus one sentence naming what gets evicted first — the historical
expansions at `SKILL.md:202-214` and `:244-257` are the obvious candidates, and
`references/` already exists to receive them.

---

### Q-4-03 — `FAIL`

**Finding:** Three separate violations of `SKILL.md:168` ("Answer statuses are
exactly three"), all in the one file people will imitate.

1. `examples/checkout-brief-r1-answers.md:159` uses **`PASS, with a required
   edit`** — a fourth status, invented in the example, not in the vocabulary.
2. `Q-5-01` is graded PASS while its own Finding says "**§4 is genuinely
   concurrency-unsafe**" (`:161`) and its Suggested fix requires two edits to the
   brief (`:170-172`). Under `SKILL.md:172-173` `FAIL` means "the question
   exposed a real problem" and `PASS` means "Checked, and it holds." It does not
   hold; the brief as written sends two testers at the same record.
3. `Q-10-01` is graded PASS while its Finding says the control is achievable
   "**only with a step the brief omits**" (`:250`) and its own last sentence says
   "Without it, the tester would have filed correct behavior as a major defect"
   (`:261-262`). That is `failure-modes.md:87-88`'s most expensive failure shape,
   graded green.

Correct statuses: both `FAIL`. **True FAIL count = 8**, not 6 — and 9 once
Q-8-01's withdrawn red is counted. The reported "6 of 11" at `:24` and the
arbiter note at `:288` both understate by a third to a half.

The rationalisation used in both cases is the same and is exactly §3.4's silent
side: "Counted as pass because the mechanism exists; it is one sentence from
being correct" (`:171-172`) and "Counted as pass because the system *can* produce
the expected answer" (`:260-261`). An expectation generous enough that a
defective artifact satisfies it — written down, in the teaching example, as
reasoning to imitate.

**Evidence:** `SKILL.md:168-174`; `examples/checkout-brief-r1-answers.md:159`,
`:161`, `:170-172`, `:248-262`, `:18-22`, `:24`, `:288`.

**Verified by:** `[CODE]`

**Suggested fix:** Regrade both to `FAIL` and fix the counts. If "the mechanism
exists but the document does not use it" needs its own expression, it belongs in
the **Suggested fix** line ("one-sentence fix"), not in the status.

---

### Q-5-01 — `FAIL`

**Finding:** A mixed-agent project ends up with two copies of `SKILL.md` and the
README explicitly tells them it does not matter. `README.md:128-138` installs to
`~/.claude/skills/exam-protocol` or `.claude/skills/exam-protocol`;
`README.md:148-151` and `AGENTS.md:29-32` install to `.agents/exam-protocol`.
`README.md:164-165` then says "Both ecosystems read the same normative file, so
there is nothing to keep in sync."

That sentence is true of the *upstream* file and false of the *adopter's* tree.
Which copy each agent loads: Claude Code loads `.claude/skills/…`, an
`AGENTS.md` agent reads whatever path the project's `AGENTS.md` names. Detection
of divergence: **none documented** — `grep -rn "diff"` finds only `AGENTS.md:45`
("lets you diff against upstream"), which is a different diff and does not
compare the two local copies to each other. Single-copy setup: **not documented
anywhere.**

The failure this produces is precisely the one `CONTRIBUTING.md:8-16` calls rule
number one, exported to every adopter with a sentence telling them not to worry
about it.

**Evidence:** the four line ranges above; `grep -rn "symlink\|single copy\|one copy"`
→ no hits.

**Verified by:** `[CODE]`

**Suggested fix:** Document one canonical location and point the other at it
(`ln -s ../../.agents/exam-protocol .claude/skills/exam-protocol`, or the
reverse), and change `:164-165` to say what is actually true: *upstream is one
file; if you vendor it twice, you own the sync.*

---

### Q-5-02 — `FAIL`

**Finding:** The seal binds the **exam only**, and the repository says so
explicitly at `templates/seal.md:6-9`: "so that 'the exam that was answered' and
'the exam that was written' are provably the same document." Nothing binds the
artifact — there is no artifact-hash field in `templates/exam.md` (its header at
`:9-17` records the artifact only as a path or name), none in
`templates/answers.md:9-14`, and no column in `templates/seal.md:11-13`.

The ordering makes this live rather than theoretical. `SKILL.md:135-145` seals at
step 3 and rehearses at step 4, and rehearsal exists to change the artifact —
`failure-modes.md` §4 lists six blockers found by rehearsal, every one of which
required an edit. So the standard path is: seal exam → edit artifact → answer
sealed exam. The answerer at step 5 grades a document that has already moved, and
**every stated rule was followed.**

Nothing detects it. The answerer has no way to know which version they are
looking at, and the seal's green light says "provably the same document" about
the wrong document.

**Evidence:** `SKILL.md:135-145`; `templates/seal.md:6-9`, `:11-13`;
`templates/exam.md:9-17`; `templates/answers.md:9-14`; `failure-modes.md:104-115`.

**Verified by:** `[CODE]`

**Suggested fix:** Either move the seal to step 4½ (after rehearsal), or record
**two** hashes in the seal row — the exam's and the artifact's — and have the
answerer verify both. The second is better: it also catches the artifact moving
during answering, and it makes `SKILL.md:144` ("re-seal a new revision") mean
something when the change was to the artifact rather than the exam.

---

### Q-6-01 — `FAIL`

**Finding:** No normalization is stated anywhere. `grep -rni "lowercase\|uppercase\|normali"`
across all 14 files → **zero hits**. `examples/SEAL.md:7` stores lowercase.
`Get-FileHash` returns uppercase hex inside a formatted object with `Algorithm`
and `Path` columns, so a PowerShell user comparing "exactly" against that row
sees a mismatch on every character. `sha256sum` on Git Bash additionally prefixes
the filename with `*` (binary-mode marker) — visible in my own output above.

There is **no path for a reader who has none of the three.** No `certutil -hashfile`
(present on every Windows install), no `python -c "import hashlib…"`, no
`openssl dgst -sha256`.

Compounded with Q-3-01 and Q-7-01: on Windows, the default clone changes the
bytes, the default hashing tool changes the case, and the instruction on
mismatch is "stop." Three independent false-stop mechanisms aimed at the one
platform whose install instructions do not exist (`README.md` has no PowerShell
install; Q-1-02's territory).

**Evidence:** the grep; `SKILL.md:162-166`; `templates/seal.md:25-32`;
`examples/SEAL.md:11-18`.

**Verified by:** `[API]`

**Suggested fix:** One line under each command block: *compare case-insensitively;
`Get-FileHash` returns uppercase.* And add
`certutil -hashfile <file> SHA256` as the no-dependency fallback.

---

### Q-6-02 — `FAIL`

**Finding:** Neither field exists.

- `templates/exam.md:9-17` — the header table's rows are Artifact under exam,
  Decision this unblocks, Author, Authored, Status, Question count, Of which
  discriminating. **No independence / self-authored field.** The `Author` row's
  placeholder is `<fresh reviewer>`, which presumes the answer.
- `templates/seal.md:11-13` — columns are Exam file, SHA-256, Questions,
  Discriminating, Author, Sealed, Status. **No independence column.**

So the requirement at `AGENTS.md:59-62` ("say so in the exam header rather than
pretending") asks a writer to fill in a field that does not exist, in a form
they copied verbatim, and the append-only record a future reader consults has
nowhere to keep it. The distinction is lost at exactly the point `AGENTS.md:61-62`
says it matters ("the reader is entitled to know which one they are holding").

**Evidence:** the two template line ranges; `AGENTS.md:59-62`; `grep -rn
"self-author"` → `AGENTS.md:61` only.

**Verified by:** `[API]`

**Suggested fix:** Add `| Author independence | independent / self-authored (reason) |`
to `templates/exam.md` and an `Independence` column to `templates/seal.md`. Also
see Q-9-01 — this rule currently lives only in `AGENTS.md`, which claims to
contain no rules.

---

### Q-7-01 — `FAIL`

**Finding:** The stop cancels **everything downstream** — the entire answering
step, i.e. `SKILL.md:135-145` steps 5, 6 and 7. There is no narrower condition
and no named override; `grep -rni "override\|authorized\|unless"` finds no
exception clause attached to either stop instruction.

A recovery procedure exists but only in the wrong place. `examples/SEAL.md:23-26`
does tell the reader what to do about a typo fix ("Recompute and add a **new**
row rather than editing this one") — but that file is an *example*, which
`CONTRIBUTING.md:25` declares "Never normative." The normative copies,
`templates/seal.md:6-9` and `SKILL.md` §3.2, say only "stop." A reader who
copied `templates/seal.md` into their own project — the documented use — carries
the stop rule and leaves the recovery behind.

Benign causes are not hypothetical: a line-ending difference is **the default on
Windows** (Q-3-01, measured), a case difference is **the default in PowerShell**
(Q-6-01), and a whitespace-touching rebase is routine.

Dimension 7 exists in this repository because a previous exam's own
recommendation became a broad stop rule that cancelled two sections
(`SKILL.md:204-208`, `failure-modes.md:50`). This is that shape, in the file that
wrote the dimension.

**Evidence:** `examples/SEAL.md:20-26`; `templates/seal.md:6-9`;
`SKILL.md:82-91`, `:196`; `CONTRIBUTING.md:25`.

**Verified by:** `[CODE]`

**Suggested fix:** Move the recovery note from the example into
`templates/seal.md`, and narrow the rule: *stop only if the mismatch survives
line-ending and case normalization; if it does not, the seal is stale, not
tampered — recompute and add a new row.* Name the arbiter as the override
authority.

---

### Q-7-02 — `PASS`

**Finding:** The tension is real but is resolved in the text, in three places,
and I could not construct a reading in which §8.1 forbids R1/R2.

§8.1's scope is the steps an author **writes for someone else**: "Before writing
any step, ask: does this require an action *I am myself prohibited from taking*?"
(`SKILL.md:301-303`). R1 and R2 are things the author **does**, not steps they
write, so §8.1 does not reach them.

What happens when the author cannot perform them is stated three times:
`SKILL.md:228-231` ("the artifact must say **R*n* was not rehearsed**"),
`:254-257` ("R1 and R2 are the ones that get skipped… See §8"), and §8.2's `§0-R`
handoff block (`:308-324`), whose four checklist items map one-to-one onto R1,
R3 and R6. So the answer to "what remains that an automated author can claim" is
also written: everything except the marked checks, with the marking mandatory and
per-check.

**Evidence:** `SKILL.md:301-303`, `:228-231`, `:254-257`, `:308-324`;
`failure-modes.md:290-296`.

**Verified by:** `[CODE]`

**Limit, and it is a serious one:** the resolution is **known-weak and the
repository says so twice**. `SKILL.md:229-231`: "this marking has, in practice,
*not* prevented the resulting failures." `failure-modes.md:300-304`: "This does
not stop 'the capability was built and nobody used it.' Somebody must actually
mint a link each cycle. **Nothing guards that**." So this passes as *documented*,
not as *effective* — and the repository is more honest about that than most of
the rest of it. The "how much does it cancel" clause is unmeasurable against
this repository, as the exam itself noted.

---

### Q-8-01 — `FAIL`

**Finding:** Yes. A defect that would otherwise be `FAIL` is recorded outside the
count. The withdrawal row at `examples/checkout-brief-r1-answers.md:282` states:
"its clause (a) is expected to be red: the configured provider for this account
is **not** the one §6 assumes, so **the intended payment path would never have
been exercised**." That is a finding about the artifact, of the same severity as
Q-1-01 and Q-3-01 (both graded FAIL and both called execution-blocking at `:289`).

The result table at `:18-22` reads `FAIL 6`. A reader scanning the summary — and
`README.md:215-216` advertises exactly that summary, "6 red, 2 unresolved, 1
withdrawn question hiding a seventh" — sees six.

With Q-11-01 counted, FAIL = 7. With Q-4-03's two mis-graded passes, **FAIL = 9
of 12**. The reported "Six reds out of eleven discriminating questions" (`:24`)
does not survive; the true figure is 9 of 11.

To be fair to the example: the withdrawal reason itself is legal under
`SKILL.md:82-91` (compound question, not "too hard"), and the README does flag
the hidden seventh. The defect is that the *number* is the thing people quote and
the number is wrong.

**Evidence:** `examples/checkout-brief-r1-answers.md:282`, `:18-22`, `:24`,
`:288-290`; `README.md:215-216`; `SKILL.md:82-91`.

**Verified by:** `[CODE]`

**Suggested fix:** Split at withdrawal time rather than deferring to revision 2 —
`Q-11-01a` answerable and red now, `Q-11-01b` withdrawn as out of scope. Then the
count is honest without a footnote. Failing that, add a `FAIL (withdrawn)` line
to the result table; a finding parked outside the arithmetic is dimension 8's own
definition of a gap removed along with the item.

---

### Q-8-02 — `FAIL`

**Finding:** Information flows in the direction the role separation is meant to
block, and **the template forces it**.

`SKILL.md:61` says the answerer "Receives **only the sealed exam** — not the
author's reasoning, not the implementer's." `:62` says the arbiter "**Does not
answer the exam.**" `SKILL.md:143` puts the arbiter's ruling at step 6, *after*
the answerer finishes at step 5. Yet `examples/checkout-brief-r1-answers.md:282`
carries "Who decided: **Arbiter**" inside the answerer's file, and the reason
text carries a system fact the answerer is not recorded as having established.

What else travelled with it: the phrase "re-issued as Q-11-01a and Q-11-01b in
revision 2" — a **future revision plan**, which is arbiter output by
`SKILL.md:143-144`.

Ownership is never assigned. `templates/answers.md:67-74` puts the Withdrawals
table in the answer sheet with a "Who decided" column that can only be filled by
someone who is not the answerer. `SKILL.md:85-88` says withdrawal preserves the
original text "in the exam file" — a third document. So the withdrawal record is
split across three files with no owner named for any part of it.

**Evidence:** `SKILL.md:59-62`, `:82-91`, `:135-145`;
`examples/checkout-brief-r1-answers.md:266-268`, `:278-282`;
`templates/answers.md:67-74`.

**Verified by:** `[CODE]`

**Suggested fix:** Move the Withdrawals table out of `answers.md` into the seal
record or a separate arbiter ruling file, which is where a decision made at step
6 belongs. If it must stay, the template needs a line saying **the arbiter fills
this in after the answer sheet is complete**, so a reader can tell which parts of
the file the answerer wrote.

---

### Q-8-03 — `PASS`, with a sharp split

**Finding:** The anonymization kept the mechanism and lost the arithmetic, and
the repository leads with the arithmetic.

**Mechanisms that survived — reproducible by a stranger without trusting anyone:**

- `SKILL.md:244-250` — `grep -c` counts string occurrences, not items with a
  property, because comments and docblocks are counted. Anyone can verify this in
  thirty seconds on any codebase. The *conclusion* it supports (a security claim
  changed when the number was corrected) is fully reconstructible from the shape.
- `discrimination.md:154-190` (N doors) — the mechanism is stated completely:
  the tampering case failed at the token hash before reaching signature
  verification; the allowlist account also lacked the underlying permission, so
  both doors returned the same status. **Anyone can reproduce that in a toy
  three-check endpoint.** This is the best-preserved item in the repository.
- `failure-modes.md:126-133` — the polymorphic-type alias mismatch: fixture wrote
  a fully-qualified class name, the framework stores a short alias, the
  relationship query missed 18 rows. Reproducible on any ORM with a morph map.
- `discrimination.md:131-136` — the idempotency mutation table. The two
  mutations and their outcomes (`0 assertions` vs 9 assertions) are complete.

**Rules where the mechanism did NOT survive:**

- §3.3 (all-green) — its only evidence is "36 questions, 30 red." No mechanism.
- Dimension 8 (withdrawn items) — "a withdrawal whose reasoning did not survive
  contact with the code" (`failure-modes.md:30-31`). What the reasoning was, and
  why it failed, are gone. A reader cannot reconstruct anything.
- Every quantitative claim (Q-2-04).

**Verified by:** `[CODE]`

**Limit:** I graded this PASS because the question's second clause — "name one
claim a stranger could verify without trusting the author" — has several good
answers, and because for the checks that carry the project's weight (R1–R8, the
dimensions, discrimination) the mechanism is intact. The honest summary is
narrower than a green suggests: **the techniques are checkable; the evidence that
they were needed is not.** The two are not the same purchase, and `README.md:220-226`
sells the second.

---

### Q-8-04 — `FAIL`

**Finding:** **No clause covers combinations.** Every bullet at
`CONTRIBUTING.md:49-54` is a single-value prohibition — names, hostnames/domains/
IPs/URLs, account identifiers/usernames/emails/merchant IDs, repository-specific
file paths. `:56-57` ("Keep the incident, drop the identifiers") and `:59-62`
(do not write a wrong value in copy-pasteable form) are also single-value rules.
A contributor following the checklist literally passes it while publishing a
mosaic.

And the mosaic is unusually specific. Combining across files: a **production
multi-tenant SaaS** with an **admin panel of 506 entry points**, roughly
**seventy** review cycles, a **content paywall with a syndication feed**, a
**discount engine with preview-versus-charge divergence**, **menu deployment
with automated and manual paths**, **per-day per-item limits**, **campaign
attribution with a 30-day window**, **points and coupons restored on
cancellation**, an ORM with a **polymorphic morph map**, a **primary UI language
that does not use spaces between words**, and a **third-party pickup-location
picker at checkout**. That last one plus the language constraint plus multi-tenant
SaaS is close to a geography and a vertical.

**Evidence:** `CONTRIBUTING.md:43-62`; `README.md:222`; `SKILL.md:241`, `:249-250`;
`discrimination.md:99-101`, `:149-150`, `:205-210`; `failure-modes.md:76`, `:111`,
`:126-133`.

**Verified by:** `[CODE]`

**Suggested fix:** Add a fifth bullet: *aggregate check — read the whole PR as if
you were trying to identify the source, and blur any figure precise enough to be
a fingerprint.* Concretely, "506 admin entry points" and "51 of 52 → 2" carry no
argumentative weight that "several hundred" and "nearly all → two" would not.
The mechanism is what teaches; the precision is what identifies.

---

### Q-9-01 — `FAIL`, but the exam picked the wrong instance

**Finding — where I disagree with the author first.** The exam's cited example is
a misreading. `AGENTS.md:74-75` does **not** require at least one red; read in
full it says: "Did the exam produce at least one red? **If zero, which hypothesis
do you hold — questions too loose, or artifact genuinely sound — and what
separates them?**" That is `SKILL.md` §3.3 restated faithfully. And `AGENTS.md:66`
says "If any **answer** is missing, the exam is not finished" — the completion
condition is answering the five questions, not producing a red. The two bars the
exam claims to have found are not different.

**But the invariant is still violated, in a place the exam did not name.**
`AGENTS.md:59-62` states a rule that appears **nowhere** in `SKILL.md`:

> "If you cannot get a genuinely fresh session, say so in the exam header rather
> than pretending. A self-authored exam is not worthless, but it is measurably
> weaker, and the reader is entitled to know which one they are holding."

`grep -rn "self-author"` across the whole tree returns exactly one hit, this one.
`SKILL.md` §2 has no fallback for an unobtainable fresh session and no
self-authored disclosure requirement. So this is a normative statement defined in
`AGENTS.md` — which `CONTRIBUTING.md:22` says may contain "**No rules**," and
which `AGENTS.md:11` says "deliberately contains **no rules**."

Secondary instance: the five-item completion checklist itself. `AGENTS.md:66`
("If any answer is missing, the exam is not finished") is a completion condition
with no counterpart in `SKILL.md`. The disclaimer at `:68-70` ("If this list and
`SKILL.md` ever disagree, `SKILL.md` is correct") does not help here — there is
nothing in `SKILL.md` to disagree with.

And this is not academic: Q-6-02 shows the self-authored rule is **unfollowable**
because neither template has the field. A rule that exists in only one of the two
entry points, and cannot be complied with in either, is the drift the repository
asserts is structurally impossible.

**Evidence:** `AGENTS.md:11`, `:59-62`, `:64-77`; `CONTRIBUTING.md:22`;
`grep -rn "self-author\|pretending" --include=*.md .` → `AGENTS.md:60-61` only;
`SKILL.md:55-67` (§2, no fallback).

**Verified by:** `[API]`

**Suggested fix:** Move the self-authored-exam rule into `SKILL.md` §2 and leave
a one-line pointer in `AGENTS.md`. Then add the field to `templates/exam.md` per
Q-6-02.

---

### Q-9-02 — `FAIL`

**Finding:** No, it does not pass its own rule number one — and there is a
second, more interesting problem: **`CONTRIBUTING.md` contradicts itself about
what the rule permits.**

Measured, pair by pair:

| Pair | Result |
|---|---|
| `README.md:153-159` vs `AGENTS.md:36-42` (the `## Verification` block) | **Byte-identical.** `diff` → empty. |
| `README.md:148-151` vs `AGENTS.md:29-32` (the vendoring command) | **Byte-identical.** `diff` → empty. |
| `README.md:171-194` vs `SKILL.md:333-353` (`does_not_grade`) | Same six claims, reworded, plus a seventh in the README ("The ceiling is your own capability") that `SKILL.md` §9 does not carry — it lives in §8. |
| `SKILL.md:113-118` vs `README.md:42-46` vs `discrimination.md:25-32` (cache-purge) | Three prose retellings of one incident. `discrimination.md` links back at `:3` but does not present it as a marked quote. |

The first two are literal violations of `CONTRIBUTING.md:27` ("If a PR adds the
same sentence to two files, it will be asked to delete one") — the same sentences,
byte for byte, in two files. A defence exists (they are copy-paste snippets for
the *user*, and `CONTRIBUTING.md:25` allows templates to be forms) but it is not
written down, and a contributor will cite them as precedent.

**The self-contradiction is the finding worth fixing.** `CONTRIBUTING.md:23`
says `README.md` may contain "Marketing, quickstart, and **the honest-limits
section**." An honest-limits section is by definition a restatement of `SKILL.md`
§9. So line 23 permits precisely what line 27 forbids, four lines apart, in the
file that calls this "the one rule that matters most."

**Evidence:** two `diff` runs, both empty (verified today); the four line ranges;
`CONTRIBUTING.md:23`, `:25`, `:27`.

**Verified by:** `[API]` — ran the diffs.

**Suggested fix:** Rewrite `:27` to say what is actually meant: *no normative
statement may be **defined** in two files; verbatim quotation and user-facing
snippets are permitted and must link to the definition.* Then the README and the
snippets are legal and the rule survives its first contributor.

---

### Q-9-03 — `FAIL`, and the honest count is zero

**Finding:** There are **no gates of any kind**. No CI, no linter, no link
checker, no PR template, no checklist that runs, no script. `find . -type f !
-name '*.md' ! -name 'LICENSE'` returns exactly `./.gitignore`. There is no
`.github/`, no `scripts/`, no `.ci/`. There is not even a git repository — `git
rev-parse` fails and no `.git` exists — so not even a commit hook is possible
today.

Per invariant:

| Invariant | Gate | Would it have caught the violation? |
|---|---|---|
| One source of truth | none | Q-9-02 found two byte-identical blocks |
| `AGENTS.md` contains no rules | none | Q-9-01 found one |
| `SKILL.md` under ~400 lines | none | currently 365; unenforced |
| Every rule names an incident | none | `deduct_prevents_negative_stock` has none (Q-2-05) |
| Every rule names what it does not catch | none | not audited |
| Case material anonymized | none | no combination clause (Q-8-04) |

By `failure-modes.md:212-214` — "If the answer is none, the invariant does not
exist" — **none of this repository's six invariants exists**, and four of the six
are already violated in the shipped text. That is not an argument; it is the
repository's own criterion applied to its own contents, and each violation above
was found by an ordinary `grep` or `diff` that a ten-line gate would run.

`CONTRIBUTING.md:40-41` does provide for "discipline rather than mechanism," but
that escape is offered to *contributors adding rules*, and the repository never
invokes it for its own invariants. `discrimination.md:64-73` requires a new guard
to run against the real corpus and go red — with zero guards, that requirement has
never been exercised here.

**Evidence:** the `find` output; the file listing; `failure-modes.md:210-214`;
`discrimination.md:64-73`; `CONTRIBUTING.md:40-41`.

**Verified by:** `[API]`

**Suggested fix:** Three greps in one CI job would catch four of the six: a
duplicate-block detector across `README`/`AGENTS`/`SKILL`, a `wc -l` budget, and
an `OWNER` placeholder check (Q-1-01). Per `discrimination.md:88-95`, run them
against the current tree first — they will go red immediately, which is the
proof, and they can be made green the same day.

---

### Q-10-01 — `FAIL`, with the falsifiability clause going the author's way

**Finding — partial disagreement with the author.** §3.3 **is** falsifiable, and
the text is careful about it: `SKILL.md:96-97` says "the **first hypothesis** is
the questions are too loose," not the conclusion, and `templates/answers.md:26-28`
explicitly names "the artifact is genuinely sound" as a live alternative the
answerer may hold. So zero reds can be correct, and the protocol says so.

**What is missing is the discriminator.** `templates/answers.md:27-28` asks
"what evidence separates those two" — and nothing anywhere answers it. Compare
`discrimination.md:64-73`, which faces the identical problem for guards ("a guard
that finds nothing on its first run has not been shown capable of failing") and
*does* give a procedure: run it against real history, and treat a clean first run
as a signal to investigate. §3.3 has no equivalent for exams. The technique that
would transfer is sitting one file away: **mutate the artifact and re-answer the
exam** — if a deliberately damaged artifact still comes back green, the questions
are loose; if it goes red, the greens were real. That is `discrimination.md`
§2.1–2.6 applied to exams, and nobody wrote it down.

On the pressure clause, which the exam correctly flags as judgement: the pressure
is real and structural. `AGENTS.md:66` makes an unanswered checklist item mean
"the exam is not finished," and Q-2-02 established there is no penalty at the
high end. Cheapest compliance is one manufactured red — and the cheapest
manufactured red is a question the artifact was never obliged to satisfy, which
is `failure-modes.md:87-88`'s "a wrong control converts correct behavior into a
defect report."

**Evidence:** `SKILL.md:93-101`; `templates/answers.md:26-28`; `AGENTS.md:66`,
`:74-75`; `discrimination.md:64-73`, `:154-190`; `failure-modes.md:87-88`.

**Verified by:** `[CODE]`

**Suggested fix:** Add two sentences to §3.3 giving the mutation procedure, and
state the discriminator explicitly: *a green exam is credible if the same exam
goes red against a deliberately damaged copy of the artifact.* That is cheap,
mechanical, and it is the repository's own signature technique.

---

### Q-10-02 — `FAIL`

**Finding:** There is **no observable trace**, and the check is a covariate by the
repository's own definition (`discrimination.md:8-14`: a measurement that gives
the same answer whether the system works or not).

Who answers it: the author, about themselves — `AGENTS.md:66` says "Answer these
in your report," and the report is the exam. Can the answer ever be anything
other than self-assertion? From the artifacts alone, no. Nothing in
`templates/exam.md` records a tool trace, a session boundary, a timestamp, or an
access log, and `SKILL.md` §2's "fresh context" is defined as an informational
property (`:64-66`) that leaves no residue.

**This exam is the demonstration.** Its compliance statement (exam:827-832) —
"No hash was computed, no install command was run, no git configuration was
inspected" — is unverifiable in exactly this way. I believe it, and I believe it
on trust, which is the thing being measured.

There is one **weak** trace, worth naming because it is the seed of a fix:
`SKILL.md:74-76` requires incidental evidence to be recorded as
`author_side_note: <where they saw it>`, never as a conclusion. An author who
checked tends to leak conclusions into question text ("Does X work, **given that
Y**…"), and a reviewer can scan for that. This exam is clean under that scan —
every side note is a bare location. That is evidence of *compliant writing*, not
of *not having checked*.

**Evidence:** `AGENTS.md:72` (the exam cites `:71`, an off-by-one; the item is at
`:72`); `SKILL.md:59-66`, `:72-80`; `templates/exam.md:9-17`;
`discrimination.md:8-14`.

**Verified by:** `[CODE]`

**Suggested fix:** Stop asking for it as a fact and ask for it as a declaration
with a mechanism: *state which sessions were used and what each was given.* An
author who lists "session B, given: the artifact and `SKILL.md`" has made a
falsifiable statement someone with harness access can check. Or accept it as
discipline and say so out loud, per `CONTRIBUTING.md:40-41`.

---

### Q-10-03 — `FAIL`

**Finding:** The conflict is real, no precedence is stated, and the shipped
example violated dimension 10.

`SKILL.md:199` (dimension 10, final sentence): "**If you cannot answer, do not
ask the question.**" `SKILL.md:72-80` (§3.1): the author "**Must not verify their
own questions**," and records incidental evidence as a location, never a
conclusion. For a control question, "can you answer it" means "do you know
whether the system produces X here by design" — which for the example's Q-10-01
means knowing the attribution window is 30 days, which is a verification.

`grep -rn "precedence\|takes priority\|governs"` finds no rule ordering the two.
The nearest thing, `AGENTS.md:68-70`, orders `SKILL.md` above `AGENTS.md` — no
help when both statements are inside `SKILL.md`.

In the shipped example the author asked `Q-10-01` (`examples/checkout-brief-r1-exam.md:234-246`)
in open form — "**Is** there an attribution window…?" — and recorded **no**
author side note, while the template at `templates/exam.md:77-78` requires one if
strong evidence was seen. So the author did not answer it first. **Dimension 10
was violated**, not §3.1. And the outcome was good: the answerer found the 30-day
window and it became one of the example's most valuable findings.

That is the diagnosis. Dimension 10's sentence, read literally, would have
suppressed the example's best question. It is scoped wrong: it is aimed at *the
author asserting a control the system cannot satisfy*, not at *the author asking
whether it can*.

**Evidence:** `SKILL.md:199`, `:72-80`; `examples/checkout-brief-r1-exam.md:234-246`
(no side note); `templates/exam.md:77-78`; `failure-modes.md:90-98`.

**Verified by:** `[CODE]`

**Suggested fix:** Rewrite the sentence to say what it means: *do not assert a
control the artifact must satisfy unless you can state the mechanism by which the
system would satisfy it — asking whether such a mechanism exists is always
permitted, and is the point.* `failure-modes.md:90-98` already phrases it
correctly as three questions; dimension 10's one-liner is the lossy compression.

---

### Q-10-04 — `PASS`

**Finding — I am overturning the question's premise.** §3.1 does have a procedure
for exactly this case, one paragraph below the rule: `SKILL.md:74-76` — "If the
author stumbles across strong evidence **while orienting**, they record it as
`author_side_note: <where they saw it>` — **never as a conclusion**." The word
"orienting" is precisely the act of reading the artifact. So what §3.1 forbids
for a document-scoped author is **writing down the answer**, not **knowing** it;
and what they should do instead is written: record the location, ask the question
open. `templates/exam.md:77-78` carries the field. An author following §3.1
literally does not have to avoid reading the artifact.

On the third clause, the protocol does distinguish document-scoped from
system-scoped work, though only in scope terms: `SKILL.md:338-341` ("The default
target is the *document*"; source code is invisible unless a dimension is aimed
at it) and `templates/exam.md:23` ("only the document is in scope").

**Evidence:** `SKILL.md:72-80`, `:338-341`; `templates/exam.md:23`, `:77-78`;
`examples/checkout-brief-r1-exam.md` — the shipped exam is document-scoped, and
its questions are consistently open-form.

**Verified by:** `[CODE]`

**Limit — a real residual gap, which I record rather than convert to a red:**
§3.1's stated *justification* does not survive the document case. "An author who
knows the answers writes only the questions they were able to check" (`:78-80`)
is an argument about *coverage*, and for a document the author has already
checked everything by reading it — so the rule's protective effect is different
in kind (it prevents the author from pre-empting the answerer) and nobody says
so. The mechanism is documented; the reason given for it is the wrong reason for
the default target. That is worth one sentence in §3.1 and does not amount to a
missing procedure.

---

### Q-11-01 — `FAIL` (of the "not yet built" kind)

**Finding:** There is no documented extension point of any kind. Searched for
every plausible shape — supplement file, overlay, local rules file, numbering
convention reserving a range, a `local/` directory — `grep -rn
"supplement\|overlay\|local addition\|dimension 12\|R9"` returns two unrelated
hits (`CONTRIBUTING.md:38`, `failure-modes.md:164`). An adopter needing a twelfth
dimension or a ninth rehearsal check must edit the vendored `SKILL.md`.

The tension the question names is exact, and the repository has already solved
this problem once for a different case: `CONTRIBUTING.md:78-90` gives
translations a separate directory (`skills/exam-protocol/i18n/<lang>/`), a
mirror declaration, a recorded source SHA, and a named re-sync owner. Every one
of those four mechanisms would work for a local extension. None is offered.

`AGENTS.md:44-45` sells vendoring on "lets you diff against upstream" — a benefit
that degrades on the adopter's first local addition, and there is no way to
separate their change from an upstream one when it does.

**Evidence:** the grep; `AGENTS.md:44-45`; `CONTRIBUTING.md:78-90`;
`SKILL.md:181-200` (the dimension table is a flat numbered list with no reserved
range).

**Verified by:** `[API]`

**Suggested fix:** Reserve dimension numbers 12+ and R9+ for local use, and
document one convention: `SKILL.local.md` alongside the vendored file, loaded
after it. One paragraph, and the diff-against-upstream benefit survives.

---

### Q-11-02 — `FAIL` (of the "not yet built" kind)

**Finding:** The literal string `exam-protocol` is a configuration value with no
single definition, repeated across the tree. As an install path or directory name
it appears at `README.md:129`, `:130` (×2), `:137`, `:150`, `:158`, `:206`;
`AGENTS.md:8`, `:19-23`, `:31`, `:41`. As the skill identity it appears at
`SKILL.md:2` (`name: exam-protocol`).

The relationship between the two is **documented nowhere**. `grep -rn "frontmatter\|name:"`
finds no explanation of whether the loader keys on the directory name, on the
`name:` field, or on both, or what happens when they disagree.

An adopter with a name collision, or an organization requiring a namespace
prefix, gets no guidance: which files to edit is not listed, whether `name:` must
track the directory is not stated, and whether `/exam-protocol` (`README.md:140`)
follows the directory or the field is not stated. In practice they will rename
the directory, leave `name:` alone, and find out by trial.

This is `CONTRIBUTING.md:8` ("Every normative statement lives in exactly one
file") applied to a configuration value instead of a rule — the same failure
mode, and the repository's own `discrimination.md:222-227` calls out "two
independent implementations of the same value" as a gap regardless of whether
they currently agree.

**Evidence:** the line references above; `SKILL.md:2`; `README.md:140-142`.

**Verified by:** `[API]`

**Suggested fix:** One short "Renaming the skill" subsection in the README: the
directory name and `name:` must match; here are the N places to change; if your
organization namespaces skills, use `<org>-exam-protocol` in both.

---

### Q-11-03 — `FAIL`, and the count is zero

**Finding:** **Zero of the 24 doors have a mutation behind them, because there is
nothing that could go red** (Q-9-03: no CI, no linter, no test, no script, no git
repository). If any of the five rules, eleven dimensions, or eight rehearsal
checks were deleted from `SKILL.md` today, the answer to "what would go red" is:
nothing, anywhere, ever. `discrimination.md:185-187` states the consequence in
this repository's own words: "the next person to see it as dead code will get a
green light for deleting it."

The true door count is higher than 24. Add the three status values
(`SKILL.md:170-174`), the five evidence labels (`:267-273`), and the two
mandatory consequences of §8 — **34 doors, 0 mutations**.

I want to be precise about what is and is not a defect here. **Prose rules cannot
be mutation-tested in the strict sense**, because there is no execution to
observe. But `discrimination.md`'s own generalization at `:189-190` ("payment
preconditions, validation chains, layered authorization") is about *any* system
with multiple independent reasons for an outcome, and the transferable form
exists: delete a rule, re-answer a fixed exam against a fixed artifact, and see
whether any answer changes. The repository ships a sealed exam, an answer sheet,
and an artifact — it has the fixture and did not use it. **At least a subset of
the 34 is testable, so "they cannot be" is not the whole truth.**

The exam's final clause is correct and is itself a finding: if the honest answer
is "prose rules cannot be mutation-tested," that belongs in `SKILL.md` §9's
`does_not_grade`. It is **not there** — §9's six bullets (`:335-353`) cover
sampling, source code, unpointed files, flawed questions, not-a-gate, and
discrimination-versus-meaning. Nothing says the protocol's own rules are
untested. So the repository's most-cited technique has never been applied to the
repository, and its blind-spot declaration does not mention that.

**Evidence:** `SKILL.md:70-129` (5 rules), `:188-200` (11 dimensions), `:234-242`
(R1–R8), `:170-174`, `:267-273`, `:301-324`; `discrimination.md:154-190`;
`SKILL.md:331-353` (§9, no such bullet); the `find` output from Q-9-03.

**Verified by:** `[API]`

**Suggested fix:** Add the bullet to §9. Then take one real door and prove the
technique on the repository's own fixture: delete dimension 5 from a copy of
`SKILL.md`, re-author the checkout exam, and show that `Q-5-01` disappears. That
is one afternoon and it is the single most persuasive artifact this project could
ship.

---

## Questions I believe are themselves wrong

| ID | Why the question is wrong | What it should have asked |
|---|---|---|
| **Q-1-03** | Its primary clause — "Has this skill ever been loaded by any harness? Name the run" — is **excluded by this exam's own `does_not_grade`** (exam:34-36: "…or whether the package has ever been installed anywhere"). A question that grades what its own header exempts makes the header decorative, which is the §3.5 failure the exam is enforcing on others. Its second clause requires installing the skill in five harnesses, which the answerer is prohibited from doing. | Split it. **(a)** *Does the repository contain any evidence — a transcript, a log, a committed example produced by a real run — that the protocol has been executed end-to-end by anything?* Answerable from the tree, and red. **(b)** *`README.md:5-6` claims the skill works in both ecosystems and `:140-142` claims description-based triggering; does the `AGENTS.md` path have a frontmatter parser at all?* Answerable from the tree, and red. **(c)** the harness-parse question, correctly marked out of scope. |
| Q-9-01 (partial) | Its cited instance is a misreading: `AGENTS.md:74-75` does not require at least one red, it requires stating a hypothesis when there are zero — identical to §3.3. The invariant **is** violated, but at `AGENTS.md:59-62`. | *Does `AGENTS.md` define any normative statement that has no counterpart in `SKILL.md`?* — which finds the self-authored-exam rule directly. |
| Q-10-01 (partial) | The falsifiability clause presumes §3.3 may be unfalsifiable. It is not: `SKILL.md:96` says "first hypothesis," and `templates/answers.md:26-28` names the alternative. | *What evidence would distinguish a sound artifact from a loose exam, and where is that procedure written?* — the real gap, and red. |
| Q-10-04 (premise) | "An author following it literally would have to avoid reading the artifact" is refuted one paragraph below the rule, at `SKILL.md:74-76`. | *Does §3.1's stated justification (an author who knows the answers only asks checkable questions) hold when the author necessarily knows most answers?* — the residual gap, and worth a red. |
| Q-3-03, Q-10-02 (citations) | Both cite `AGENTS.md` one line high (`:72` and `:71` for items at `:73` and `:72`). Does not affect either finding. | — |

## Withdrawals

None. No question was withdrawn; `Q-1-03` is `UNRESOLVED`, which is the correct
status under `SKILL.md:90-91` for a question the answerer lacks the capability to
settle, and I have recorded the answerable spillover finding inside it rather
than letting it disappear (`SKILL.md` dimension 8 / this exam's Q-8-01 is exactly
about that risk).

| ID | Reason | Who decided |
|---|---|---|
| — | — | — |

---

## Arbiter note

Thirty reds, three greens, one unresolved. Two things the arbiter should weigh
before acting on the count.

**First: the reds are not evenly serious.** Three are ordinary pre-1.0 gaps —
Q-4-02 (no line-budget enforcement), Q-11-01 (no extension point), Q-11-02 (no
rename guidance). They are red because nothing exists yet, not because something
is wrong. Ranked by damage on the day this is published:

1. **Q-3-01** — the first act the protocol asks of a new reader is verifying the
   seal on the shipped example, and on a default Windows clone it produces
   `89897f54…` against a recorded `66c23ddd…`, with the instruction "stop."
   The repository's flagship guard false-positives on its own artifact, on day
   one, in the manner `discrimination.md:96-101` says gets guards switched off.
   One `.gitattributes` file, and it must land before the first clone exists.
2. **Q-1-01** — the first command in the README is
   `git clone https://github.com/OWNER/…`. It cannot run. This fails before the
   reader has been given any reason to trust the rest of the page.
3. **Q-3-02 with Q-3-03** — "where is your own sealed exam?" is the first comment
   this project will receive, and the answers are: there is none, `.gitignore:19`
   would drop one, and the only example on offer fails two of the repository's own
   five completion checks (its answer sheet cites no hash while its seal says
   `ANSWERED`). Q-3-03 is one line to fix and should be fixed before anything else
   on this list.

Then, in the same tier of embarrassment though not of blocking: **Q-4-03** (the
teaching example invents a fourth status and under-reports its own failures by a
third), **Q-2-03** (a fabricated measurement wearing an `[API]` badge, in a file
that never says it is fiction), **Q-9-03** (zero gates, so by
`failure-modes.md:212-214` none of the repository's six invariants exists — and
four of the six are already violated in the shipped text).

**Second: the ones that bite later, not on day one.** These will not cost a
reader's trust at first contact and will cost real work afterwards. **Q-5-02** is
the most serious idea in this exam: the seal binds the exam and nothing binds the
artifact, while the workflow puts rehearsal — whose whole purpose is changing the
artifact — *between* sealing and answering. Every rule can be followed and the
answers can be about a document that no longer exists. **Q-1-02** is measured and
silent: the documented upgrade leaves the old copy in the loaded position and
buries the new one, so an adopter runs a superseded protocol with on-disk proof
that they upgraded. **Q-8-02** has the template forcing arbiter output into the
answerer's file. **Q-5-01** hands every mixed-agent team two copies with a
sentence telling them not to worry.

**Third, and this is the one I would act on first if the goal is credibility
rather than correctness.** Every finding in this sheet was reached with `grep`,
`diff`, `wc`, `sha256sum` and one `cp` — roughly ten minutes of mechanical work,
no judgement required for twenty-seven of the thirty. A project whose thesis is
that somebody else must ask you the questions you will not ask yourself has
shipped without anyone having run ten minutes of `grep` over it. That is not a
contradiction that undermines the thesis; **it is the thesis.** The most
persuasive thing this repository could publish is this sheet, or its own version
of it, sealed, in `exams/`, with the reds still open and dated.

Do not read the three passes as "the rest is fine." I graded a set of documents
for internal consistency and executability. I did not grade whether the protocol
works, and no artifact in this repository would let anyone do that.
