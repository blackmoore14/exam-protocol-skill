---
name: exam-protocol
description: >
  Use when about to call work finished and someone downstream will act on it
  without re-checking it — handing another party a brief, test plan or
  instruction pack; marking something verified, working or shipped in a status
  ledger; telling a stakeholder a thing is done; or withdrawing someone else's
  defect report. Self-review cannot catch what these hide, because the person
  writing the checklist is the person answering it; instead a fresh reviewer
  authors a sealed exam, a second fresh reviewer answers it, and the implementer
  only arbitrates. Skip it for a single reversible bugfix that already has test
  coverage — the cost is out of proportion. Also use when asked for a "sealed
  exam", "am I really done", "adversarial review", "negative control",
  "covariate", "mutation test", "rehearsal", or "does_not_grade".
user-invocable: true
argument-hint: "[path to the artifact to examine]"
license: MIT
metadata:
  version: "0.2.2"
  category: verification
---

# Exam Protocol

**Self-review does not work, because the person writing the checklist is the
person answering it.** This protocol replaces it with an adversarial one: a
reviewer who did not do the work writes a sealed exam of questions the
implementer would not ask themselves, a second reviewer answers it, and the
implementer only arbitrates.

The first measured run, over two release documents their author believed correct:
**36 questions, 30 red** `[PRIOR]`. Self-review had found none of them. Nothing
about the authors was careless — the questions simply do not occur to the person
who already knows what they meant.
([references/failure-modes.md](references/failure-modes.md) §1.)

---

## 1. When to run an exam

| Situation | Run one? |
|---|---|
| A brief, plan, or instruction pack that another party will execute | **Yes.** If they get stuck, the whole cycle is wasted and you find out afterwards. |
| Marking something "working" / "verified" / "shipped" in a ledger, or telling a stakeholder "this is done" | **Yes.** |
| Withdrawing or downgrading someone else's defect report | **Yes.** Withdrawing wrongly permanently closes a real defect. |
| A single-point bugfix that is reversible and has test coverage | No. The cost is out of proportion. |

---

## 2. Roles — four, and the separations are load-bearing

| Role | Constraint |
|---|---|
| **Implementer** | Did the work. **Does not author. Does not answer.** |
| **Author** | Fresh context, read-only. Writes the exam. **Must not verify their own questions** (see 3.1). |
| **Answerer** | Fresh context. Receives **only the sealed exam** — not the author's reasoning, not the implementer's reasoning. |
| **Arbiter** | Usually the implementer or the person accountable for shipping. Rules on findings and fixes. **Does not answer the exam.** |

"Fresh context" means a session, agent or person with no exposure to how the
artifact came to be. An author who reads the implementer's rationale inherits its
blind spots and re-asks its assumptions back at it.

**If you cannot get a genuinely fresh session, declare it rather than pretending.**
Every exam header carries an **author independence** field — `independent` or
`self-authored (<reason>)` — and `templates/seal.md` has the column, because a
rule with nowhere to be recorded is a rule nobody follows. A self-authored exam
is not worthless; it is measurably weaker, and the reader is entitled to know.

---

## 3. The five rules

### 3.1 The author must not know the answers

The exam is authored read-only and sealed as `AUTHORED_NOT_RUN`. Strong evidence
met while orienting is recorded as `author_side_note: <where they saw it>` —
**never as a conclusion**. Compliance is declared as a list of sessions and their
inputs (§4.1): "I did not check" leaves no trace, and an absence cannot be
audited.

Two different reasons, depending on the target. For a *system*: an author who
knows the answers writes only the questions they could check, and the expensive
defects live in "hard to check, so nobody checked". For a **document** — the
default — the author has read all of it, so nothing was out of reach; the rule
still binds because **writing the answer down pre-empts the answerer**, and the
second fresh reader is the entire mechanism. Read all you like; record locations,
never conclusions.

### 3.2 Seal first, answer second — and seal **both** documents

Write the exam to a file. Record **two** SHA-256 digests in the seal row: the
exam's, and the artifact's. After sealing, exactly two actions are legal —
**answer** it in a separate file, or **withdraw** a question, stating the reason
and preserving the original text.

"This question is too hard to investigate" is **not** grounds for withdrawal.
That is an answer, and its value is `UNRESOLVED`.

**Why two hashes.** Sealing only the exam proves the exam did not move and proves
nothing about the thing being graded — and that gap is not theoretical. Step 4
below is rehearsal, rehearsal exists in order to *change the artifact*, and it
sits between sealing and answering: every rule can be obeyed while the answers
describe a document that no longer exists. For a directory, hash a manifest and
say so; if you record no artifact hash write `not recorded`, because a blank
column reads as "unchanged".

**What the seal cannot freeze.** Most artifacts worth examining are documents
making claims about a *running system*. Hashing the document pins the claims and
pins nothing about the system — and the answers are about the system. Observed:
while one exam was being answered, another agent was editing three of the
services it asked about, every hash still matching.

So record a third thing beside the two digests: **the system revision the answers
describe** — a commit id, a deployed build tag. One line: *"answered against
`<rev>`"*. If the system moves faster than the exam is answered, that is a
finding about your process, not a detail to smooth over.

### 3.3 A red rate near either end is a claim about the exam, not the artifact

A green exam carries no information until you have seen it produce a red. At zero
reds the first hypothesis is **the questions are too loose**, not "we are in good
shape" — and there is a procedure, not just a suspicion, borrowed from the
mutation testing in the discrimination reference §2:

> **A green exam is credible if the same exam goes red against a deliberately
> damaged copy of the artifact.**

Copy the artifact, break one thing the exam claims to cover — delete the step,
blank the named record, remove the control arm — and re-answer. Red means the
greens were real; still green means the questions are loose, mechanically.

**A red rate near 100% is equally a claim about the exam**, because a well-aimed
exam and a mis-aimed one both produce a wall of red. State which hypothesis you
hold, and separate them with this:

> **Mechanical reds are about the artifact. Interpretive reds are about the
> exam.** A string that does not resolve, a hash that does not match, a missing
> file, a count that disagrees with itself — none depend on the reader. Findings
> turning on a reading of intent do.

Report the split: "twenty-seven of thirty are mechanical" is evidence, "thirty
reds" alone is not; mostly interpretive means re-authoring is cheaper. Either
way, quote the number of questions that **discriminate**, not the total — if 22
of 23 could distinguish a broken system from a working one, say 22 and say why
the 23rd does not count.

### 3.4 Attack both directions — including "what would this wrongly let through?"

The natural direction is "where is this wrong?" That side is loud — someone will
argue with you about it. The other side is silent: a check whose threshold is too
generous, an expectation any answer satisfies, an experiment that succeeds
whether or not the feature works. Those get sealed into the contract alongside
the legitimate greens, and nobody ever hears from them.

Deciding whether an experiment can distinguish anything is **mechanical**, and
[references/discrimination.md](references/discrimination.md) is the procedure:
three covariate detectors (negative control, counting independent changes, the
refuse-everything stub), mutation testing of guards, and the cache-purge case in
which an experiment reported a feature working because saving the setting
invalidated the cache by itself.

### 3.5 Every exam declares `does_not_grade`

The exam header must state what the exam does **not** evaluate. Green is
necessary, never sufficient, and an exam that does not name its blind spots is
making a claim it cannot support.

---

## 4. Workflow

```
1. Arbiter names the artifact under exam and the decision it will unblock.
2. Author (fresh, read-only) walks the dimension checklist in §5 and writes
   the exam. Status: AUTHORED_NOT_RUN.
3. Author, or arbiter, computes both SHA-256 digests and records the seal.
4. Implementer performs the rehearsal in §6 — before, not after, handing the
   artifact to anyone downstream. Rehearsal usually changes the artifact:
   re-hash it and add a new seal row before step 5.
5. Answerer (fresh) receives only the sealed exam, verifies **both** hashes,
   and answers.
6. Arbiter rules: fix, withdraw with reason, or accept as UNRESOLVED. If any
   answer was red, re-seal a new revision — never edit a sealed exam.
```

Suggested layout inside the project being examined:

```
exams/
  SEAL.md                              seal record: both hashes, count, author, status
  <subject>-<revision>-exam.md         the exam        (AUTHORED_NOT_RUN)
  <subject>-<revision>-answers.md      the answer sheet (PASS / FAIL / UNRESOLVED)
```

Templates: [exam](templates/exam.md), [answers](templates/answers.md),
[seal](templates/seal.md), [`§0-R` handoff](templates/rehearsal-handoff.md) —
the seal template carries the hashing commands for each platform.

Two rules about the digest, because both benign causes of a mismatch are
platform defaults and both produce a false stop on the reader's first attempt:

- **Compare case-insensitively.** `Get-FileHash` and `certutil` return uppercase
  hex, seal records store lowercase, and `sha256sum` prefixes the filename with
  `*`. Every character differing by case is not a mismatch.
- **Pin your line endings** in `.gitattributes` before anyone clones. The digest
  is over bytes, so a checkout that rewrites LF to CRLF changes every hash you
  recorded. `templates/seal.md` has the recovery procedure for both.

### 4.1 Completion check — answer all five in the report

An exam is not finished while any of these is unanswered.

1. **Which sessions were used, and what was each given?** "The author verified
   nothing" is an unfalsifiable self-report and leaves no trace; a list of
   inputs — *"session B, given: the artifact and `SKILL.md`"* — is checkable by
   anyone with harness access, and its absence is itself a finding.
2. Are both hashes sealed, and does the answer sheet **cite** them?
3. What was the red rate, which hypothesis does the answerer hold at it (§3.3),
   and at zero reds, was the mutation check run?
4. Does the exam header declare `does_not_grade` and author independence?
5. Were all eleven dimensions given a count or a stated reason for not applying?

Answer statuses are exactly three:

| Status | Meaning |
|---|---|
| `FAIL` | The question exposed a real problem. |
| `PASS` | Checked, and it holds. Must cite where. |
| `UNRESOLVED` | Could not be determined. **A legitimate outcome.** Says who is blocked and on what. |

`UNRESOLVED` must never be silently converted to `PASS`. "We could not check
it" and "it is fine" are different facts.

---

## 5. Authoring dimensions — the author answers all eleven

This list stops coverage being a function of the author's imagination on the
day. Per dimension the author writes **how many questions they asked** or **why
it does not apply**. Skipping is not permitted; "not applicable" is, with a
reason.

| # | Dimension | The question to ask |
|---|---|---|
| 1 | **Executability** | Can the executor actually perform this step? Address, account, permission, entry point. |
| 2 | **Covariates / false findings** | Would this experiment give the same answer whether the system works or not? (See discrimination reference.) |
| 3 | **Operability of named fixtures** | Every record this artifact names: can it be *opened and saved* right now? Not "does it exist". |
| 4 | **Stability of expected values** | Is an expected value bound to something that changes — record contents, counts, timestamps, values other people also edit? |
| 5 | **Concurrency** | If two executors run this simultaneously, what happens? Which steps overwrite each other? Should they be assigned different subjects? |
| 6 | **Assumed tooling** | What tools or privileges does this step presuppose? If the executor lacks them, is an equivalent path written down? |
| 7 | **Blast radius of stop rules** | Each "if this fails, stop" instruction: how many downstream items does it cancel? Is a narrower stop condition available? |
| 8 | **Withdrawn items** | For anything removed from scope: is the stated reason checkable? Did a real gap get removed along with it? |
| 9 | **Documents outside this one** | What *else* will the executor open — credential tables, prior reports, a plan doc? Do those contradict this artifact? |
| 10 | **Can the system satisfy the control?** | For every "X must **not** appear here": in the executor's actual situation, would the system already not produce X? Do not *assert* a control unless you can state the mechanism by which the system would satisfy it. **Asking whether such a mechanism exists is always permitted, and is the point** — an open "is there an attribution window that would make this appear by design?" is the highest-yield question in this dimension. |
| 11 | **Architecture invariants** | Does the code involved violate an invariant the project has written down — especially *"can this value be changed without editing code?"* (hardcoded model names, vendors, rates, endpoints). |

Two of them are counter-intuitive enough to be worth reading the incident
first — dimension 7 was created by a previous exam's own recommendation, and
dimension 9 exists because declaring precedence does not work. Both are written
up in [references/failure-modes.md](references/failure-modes.md) §2 and §5.

---

## 6. Rehearsal — R1 through R8

Before anything is handed downstream, the person who wrote it performs every
step themselves — not by reading code, not by checking that a URL returns 200.
The failure this catches has one shape:

> **I verified that it opens. The executor has to make it work.**

A check you cannot perform must be marked **"R*n* was not rehearsed"** in the
artifact. Honestly: that marking has *not*, in practice, prevented the resulting
failures. It warns that the risk is live; it does not substitute for rehearsal.

| # | Check | What it means |
|---|---|---|
| **R1** | **Walk it authenticated** | Open every screen the executor will open, while logged in. A redirect from an unauthenticated probe proves only that a route exists. |
| **R2** | **Close the loop** | For every "change X, then observe Y", run the whole loop yourself. This is the highest-value check: cache-invalidation defects are invisible to any read-only probe. |
| **R3** | **Count fixtures through the app's own read path, in the executor's scope** | Not "does this record exist" but "does it exist *for the account and role the executor will use*". Counting with global scopes disabled filters out the only condition that matters. And a raw datastore query does not count — read it the way the application reads it. |
| **R4** | **Declare measurement preconditions** | Window must be foregrounded; which developer-tools capabilities are needed; which steps need a real browser. Undeclared preconditions get reported back to you as product defects. |
| **R5** | **Flag external dependencies** | Third-party pickers, payment pages, OAuth consent, native apps. Mark them and write "if you get stuck here, stop and report the position" — otherwise the executor burns a session on something you cannot fix. |
| **R6** | **Count what you promised** | Any "you will see N of X": count it yourself first. If you cannot, rewrite it as "report how many you see." **If the list is produced by a function, run the function** — do not read the source. And **if an interface can enumerate it, do not count it with `grep`**: `grep -c` counts string occurrences, not items with a property, and it counts comments too. |
| **R7** | **Compute entry points, do not recall or copy them** | Derive real addresses from the routing table and derive who can reach them from the actual access checks. In one measured inventory, several dozen admin entry points out of a few hundred were not in the main navigation — that many places where "find it in the menu" fails. |
| **R8** | **Verify the provider, not the label** | Before writing "pay with vendor X", confirm that vendor X is the configured provider for that account — read the provider code, not the display name. "Credit Card" does not tell you who is behind it. And **different services from the same vendor are configured separately**: having invoicing enabled does not mean checkout works. |

**R1 and R2 are the ones that get skipped**, because they require authenticated
write actions that many reviewers and most automated agents are forbidden from
performing — see §8. And R6's counting rule has cost a security conclusion, not
just a number: [references/failure-modes.md](references/failure-modes.md) §4.

---

## 7. Evidence-strength labels

A **downstream artifact** is anything handed to someone who will act on it
without re-checking it: an execution brief, a status ledger, a release note, a
completion report, an answer sheet. Any document making a factual claim about a
system is inside the rule; a protocol you are meant to argue with is not.

Every factual claim in one carries a label saying **how it was verified**. This
converts "how deep did I actually check" from private knowledge into something
the reader can see.

| Label | Meaning | How the reader should treat it |
|---|---|---|
| `[WALKED]` | I logged in and did it | Strongest |
| `[API]` | I called the interface / ran the command | Credible — but the screen may still be empty |
| `[DB]` | I queried the datastore | Present in storage is not visible on screen |
| `[CODE]` | I read the source | Weakest. Treat as a hypothesis |
| `[PRIOR]` | Carried over from a previous cycle | **Treat as unverified** |

`[PRIOR]` is a label, not a shortcut: a previous cycle's conclusion is *an
observation made then*, not *a fact now*. Carrying one forward unchecked has
made an entire section unexecutable.

---

## 8. The capability boundary — and the handoff it forces

> **The correctness ceiling of an artifact equals the depth its author can
> verify.**

Reviewers, and especially automated agents, are commonly forbidden from entering
passwords, creating accounts, solving CAPTCHAs, or making real payments — so the
deepest layer they reach is "the interface responds", and the two below are out
of reach. That is where the errors accumulate:

```
present in storage ≠ interface returns it ≠ rendered on screen ≠ user can find it ≠ user can finish it
```

Two consequences, both mandatory:

**8.1 If you cannot do it, neither can an agent executor.** Before writing any
step ask: *does this require an action I am myself prohibited from taking?* If so
the executor is under the same prohibition — remove the step, or build a
capability that avoids it (a one-time signed link, a pre-established session, a
human doing that part). Never schedule work nobody may perform.

**8.2 Hand the unreachable checks to whoever can reach them.** The first section
of any downstream artifact is a rehearsal handoff, not a task: four checkboxes
asking the executor whether they are signed in, whether each named page opens,
whether each named record **saves**, and whether each promised "you will see X"
is there. Paste it from
[templates/rehearsal-handoff.md](templates/rehearsal-handoff.md) — five minutes
of their time, against a section plus a round trip, measured repeatedly.

---

## 9. `does_not_grade` — including this protocol's own

Every exam states its blind spots. So does this protocol:

- **An exam is a sample, not coverage.** Thirty reds means thirty fingerprints
  were found; it says nothing about the rest.
- **An exam does not grade the product code** unless a dimension was
  deliberately aimed at it. The default target is the *document*, so a hardcoded
  vendor or model identifier in the source is invisible to an exam scoped at a
  brief — an observed miss, not a theoretical one.
- **An exam does not grade files it was not pointed at.** Credential tables,
  prior reports and plan documents sit outside it unless dimension 9 drags
  them in.
- **The author writes flawed questions too.** In one review round four defects
  were found in a single exam and **all four were in the harness or the setup,
  none in the behavioral assertions**. "This question is broken" is a legal
  answer.
- **This is not a gate.** It blocks no commit and fails no build. Its entire
  value is that somebody asked you a question you would not have asked yourself.
- **Discrimination is mechanical; meaning is not.** The discrimination reference
  tells you whether your measurement can tell two worlds apart. It never tells
  you which world is correct.
- **This protocol's own numbers are unauditable, by design.** Every count here
  came from a private repository, and our anonymization rules forbid the paths
  that would let you check one. Applying §7 to ourselves: all `[PRIOR]`.
- **This protocol's own rules have never been mutation-tested.** Delete a rule,
  a dimension or a rehearsal check and nothing goes red — so by the N-doors
  argument each is individually untested, however good the whole looks. The
  transferable experiment (remove one, re-author a fixed exam over a fixed
  artifact, see whether an answer changes) has not been run.

---

## 10. Adding your own dimensions and checks

Your project will need a twelfth dimension or a ninth rehearsal check. **Numbers
12+ and R9+ are reserved for you**, and local additions belong in
`SKILL.local.md` beside this file — never edited into it, or you can no longer
tell your change from an upstream one. Full procedure and the bar a local
addition must clear: [references/extending.md](references/extending.md).

## 11. References

- [references/discrimination.md](references/discrimination.md) — can this check
  fail at all? Covariates, negative controls, mutation testing, the two shapes of
  an invalid mutation, the N-doors rule, bypass inventory.
- [references/failure-modes.md](references/failure-modes.md) — anonymized
  post-mortems: exams that passed while the work was broken, each mapped to the
  dimension or check that exists because of it.
- [templates/](templates/) — exam, answers, seal, `§0-R` handoff.
