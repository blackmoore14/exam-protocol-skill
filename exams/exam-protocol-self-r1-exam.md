# Exam: exam-protocol (the repository itself) — revision 1

> The artifact under exam is the `exam-protocol` repository at the working-tree
> state read on 2026-08-18: `README.md`, `AGENTS.md`, `CONTRIBUTING.md`,
> `CHANGELOG.md`, `.gitignore`, `skills/exam-protocol/**`, `examples/**`.
>
> This exam applies the protocol to itself. It was authored by a reviewer who
> did not write any of it, read-only, and who **did not check any answer**.
> Every question below is unanswered by construction. Where the author saw a
> location while orienting, it is recorded as `Author side note: <location>` and
> never as a conclusion.

| Field | Value |
|---|---|
| Artifact under exam | `exam-protocol` repository (all committed files, working tree of 2026-08-18) |
| Decision this unblocks | Publishing v0.1.0 as an open-source skill that strangers are asked to adopt and trust |
| Author | Fresh reviewer (read-only; not the implementer; no exposure to the implementation rationale) |
| Authored | 2026-08-18 |
| Status | `AUTHORED_NOT_RUN` |
| Question count | 34 |
| Of which discriminating | 32 — see the note at the bottom |

## does_not_grade

This exam does **not** evaluate:

- **Whether the protocol works.** There is no outcome data here. Everything
  below grades the repository's texts, their internal consistency, and their
  executability by a stranger. A repository that is perfectly self-consistent
  can still be advice that does not help anyone.
- **Whether each individual rule is good advice.** "Is dimension 4 a useful
  dimension" is a design question and is out of scope.
- **Prose quality, tone, or English style.**
- **Any state that lives outside this working tree** — GitHub issues, CI runs,
  releases, a published skill listing, the commit history, or whether the
  package has ever been installed anywhere. Only files on disk were read.
- **The origin of the anonymized incidents.** The author did not attempt to
  identify, locate, or compare against any private repository the case material
  may have come from, and deliberately did not look. Questions about
  anonymization below ask only whether the *repository's own stated
  requirements* are met by the text in the repository.
- **Legal fitness** of the MIT license or of publishing distilled internal
  incident material.

Green here is necessary, never sufficient.

## Documents in scope

Dimension 9 requires naming everything the executor is likely to open, not just
the primary artifact. Here the "executor" is **a stranger adopting the skill**,
and secondarily **an agent that loads it**.

| Document | Why the adopter would open it | Checked for contradictions? |
|---|---|---|
| `skills/exam-protocol/SKILL.md` | It is the normative protocol | It is the primary target |
| `AGENTS.md` | Convention: many agents read this file **first**, and some read nothing else | Probed — Q-9-01, Q-9-02 |
| `README.md` | The first thing a human sees on the repository page | Probed — Q-9-02, Q-2-05 |
| `CONTRIBUTING.md` | Anyone proposing a change; it declares the one-source-of-truth rule | Probed — Q-9-02, Q-9-03, Q-8-03 |
| `skills/exam-protocol/references/*.md` | Loaded on demand per `AGENTS.md` | Probed — Q-9-03, Q-11-03 |
| `skills/exam-protocol/templates/*.md` | Copied verbatim when producing an exam | Probed — Q-3-03, Q-6-02 |
| `examples/*` | The only worked demonstration; the shape people will imitate | Probed — Q-2-03, Q-3-03, Q-4-03, Q-8-01, Q-8-02 |
| `.gitignore` | Not opened deliberately, but it governs what an adopter can commit | Probed — Q-3-02 |
| `CHANGELOG.md` | Version and provenance | Probed — Q-1-01 |

## Dimension coverage

| # | Dimension | Questions | If none, why |
|---|---|---|---|
| 1 | Executability | 3 | |
| 2 | Covariates / false findings | 5 | |
| 3 | Operability of named fixtures | 3 | |
| 4 | Stability of expected values | 3 | |
| 5 | Concurrency | 2 | |
| 6 | Assumed tooling | 2 | |
| 7 | Blast radius of stop rules | 2 | |
| 8 | Withdrawn items | 4 | Read here as: what was deliberately removed — from scope, from the count, and from the evidence by anonymization |
| 9 | Documents outside this one | 3 | |
| 10 | Can the system satisfy the control? | 4 | |
| 11 | Architecture invariants | 3 | |

## A note on scope that the author is obliged to declare

`SKILL.md` §9 states that an exam "does not grade the product code" by default.
Here the product **is** the document, so that exemption does not apply and no
question below is excused by it.

Separately: this exam attaches a per-question `Does not grade` line. The
protocol requires `does_not_grade` only at the exam level. The extra line is
this author's addition, not a protocol requirement, and the arbiter may treat it
as a proposal rather than as compliance.

---

## Questions

### Q-1-01

**Question:** `README.md:129` and `CHANGELOG.md:34-35` contain the literal
placeholder `OWNER` in the clone URL and the release links. Does the documented
install sequence — copy-paste, no edits — succeed for a first-time adopter as
written today? If not, what is the correct command, and which other files carry
the same placeholder?

**Why it might fail:** The first command in the README is the first thing that
can fail, and it fails before the reader has any reason to trust the rest.

**Discriminates:** Yes. Either the strings are substituted or they are not.

**Author side note:** `README.md:129`, `CHANGELOG.md:34-35`.

**Does not grade:** whether the repository *should* be published at that URL.

---

### Q-1-02

**Question:** The install is `cp -r <src>/skills/exam-protocol ~/.claude/skills/exam-protocol`.
On a **second** run — the upgrade path, after the destination already exists —
what layout results, on GNU `cp` and on BSD/macOS `cp`? Is the documented
upgrade path the same command, and is the resulting nesting (if any) detectable
by the adopter before their agent silently loads the wrong copy?

**Why it might fail:** `cp -r src dst` where `dst` exists copies *into* it. An
adopter upgrading after a release would then have the skill one directory
deeper, and a skill that fails to load produces no error the adopter will see —
it simply never triggers.

**Discriminates:** Yes.

**Does not grade:** Windows/PowerShell install, which the README does not
document at all — that gap is Q-6-01's territory.

---

### Q-1-03

**Question:** Has this skill ever been loaded by any harness — Claude Code,
Codex, or otherwise? Name the run. `README.md:140-142` claims invocation as
`/exam-protocol` and claims description-based triggering. Does the frontmatter
(`user-invocable`, `argument-hint`, `license`, `metadata.version`,
`metadata.category`) parse in every harness the README names, and does any
harness reject or ignore an unrecognized key?

**Why it might fail:** The repository documents two ecosystems. A claim that
something "works in both" that has been observed in neither is a `[CODE]`-strength
claim presented as fact, and §7 of the protocol says exactly how to treat that.

**Discriminates:** Yes — either a load has been observed or it has not.

**Does not grade:** whether the description text is *well written* for
triggering; only whether the file loads at all.

---

### Q-2-01

**Question:** Apply the repository's own negative control (`discrimination.md`
§1.1) to its own trigger claim. If `SKILL.md` contained no protocol at all —
only the frontmatter — would the evidence currently offered for "the skill
triggers on these phrases" look any different? What observation would
distinguish "the skill triggered and helped" from "the skill triggered"?

**Why it might fail:** Triggering is a covariate for usefulness. It fires
identically whether the body is a protocol or a blank page.

**Discriminates:** Yes.

**Does not grade:** the trigger phrase list itself.

---

### Q-2-02

**Question:** `SKILL.md` §3.3 defines the failure signal on one side only: zero
reds means the questions are probably too loose. Is there **any** stated
threshold on the other side? At what red rate does an exam become evidence that
the author attacked the wrong artifact, wrote unanswerable questions, or graded
against an expectation the artifact never claimed? The repository's own headline
is 30 red out of 36.

**Why it might fail:** A one-sided criterion cannot distinguish "the artifact
was bad" from "the exam was bad." Both produce a high red count, and the
protocol currently reads the high count as success.

**Discriminates:** Yes — the threshold is either written down somewhere or it is
not.

**Does not grade:** whether 30/36 was in fact a correct result.

---

### Q-2-03

**Question:** `examples/checkout-brief-r1-answers.md:75-78` reports a negative
control as having been performed ("replaced the button's handler with a no-op
and re-ran the sequence"), inside an example the repository states is fictional.
What in the repository prevents a reader from copying that reporting *form*
without performing the experiment? Is there any signal, other than the header
prose, that separates an illustrated result from a measured one for a reader who
skims?

**Why it might fail:** The example is the only complete artifact in the
repository and is therefore the template people imitate. A fabricated
measurement rendered in the exact format of a real one teaches the format, not
the discipline — which is the failure `SKILL.md` §3.4 describes, applied to the
repository's own teaching material.

**Discriminates:** Yes.

**Does not grade:** whether the fictional example is otherwise well constructed.

**Author side note:** `examples/checkout-brief-r1-exam.md:3-6` and
`examples/checkout-brief-r1-answers.md:3-5` are where the fictional framing is
stated.

---

### Q-2-04

**Question:** `templates/answers.md:38-40` states: "An answer with no location
does not count." Apply that standard to the repository's own central claims —
"36 questions, 30 red", "roughly seventy review cycles", "42 of 506 admin entry
points", "51 of 52 items … actually populated on 2", "12 passing cases turned
red". What location does a reader have for any of them? Under the protocol's own
rule, what status should a reader assign to a claim whose evidence is
structurally unavailable?

**Why it might fail:** If the answer is "none", then the repository's most
persuasive content is exactly the kind of claim its own template refuses to
count, and an adopter applying the protocol faithfully to the protocol would
have to mark the provenance section `UNRESOLVED`.

**Discriminates:** Yes.

**Does not grade:** whether the claims are *true*. The question is about
auditability, not accuracy.

---

### Q-2-05

**Question:** `README.md:37-57` lists four incidents under "What happens without
it". For each of the four, was it found **by an exam authored under this
protocol**, or by a different mechanism — an automated scanner, a mutation run,
a bypass inventory, or a stakeholder noticing? Compare against
`references/failure-modes.md`, which attributes several incidents to gates that
are not the exam.

**Why it might fail:** If some of the four were found by a scanner or a mutation
sweep, the README is crediting the exam protocol with results a different tool
produced — while §9 of the same protocol explicitly states that an exam scoped
at a document cannot see product source, which is where at least some of those
four live.

**Discriminates:** Yes. Each incident either has an exam behind it or it does
not.

**Does not grade:** whether the incidents happened.

---

### Q-3-01

**Question:** `examples/SEAL.md:7` records a SHA-256 for
`examples/checkout-brief-r1-exam.md`, and the file instructs the reader to
**stop** if it does not match. On a Windows clone with Git's default
`core.autocrlf`, does the working-tree file hash to that value? Is there a
`.gitattributes` in this repository that pins line endings for `*.md`?

**Why it might fail:** If line-ending normalization changes the bytes, the very
first seal a new adopter checks fails for a reason that has nothing to do with
tampering. `discrimination.md` §2.2 states the consequence in the repository's
own words: false positives get guards switched off, which is worse than having
none.

**Discriminates:** Yes.

**Does not grade:** whether SHA-256 is the right algorithm.

**Author side note:** the repository's file listing as read contains no
`.gitattributes` entry; the author did not run any hash command.

---

### Q-3-02

**Question:** `.gitignore:19` ignores `exams/`. `SKILL.md` §4 recommends
`exams/` as the layout for the artifacts this protocol produces. Does this
repository contain a sealed exam over itself? Can it — that is, would an exam
placed in the recommended location be committable without editing `.gitignore`?

**Why it might fail:** The protocol's headline claim is that a work product is
not finished until a sealed exam exists. If the repository has none, and its own
ignore rules would silently drop one, the first reader to ask "where is yours?"
gets an answer that undermines the pitch. The `.gitignore` comment says exams
"live in their own repo, not here" — does that reasoning survive when the
artifact under exam *is* here?

**Discriminates:** Yes.

**Does not grade:** whether `.gitignore` is otherwise correct.

**Author side note:** `.gitignore:17-20`.

---

### Q-3-03

**Question:** `AGENTS.md:72` requires, as a condition of an exam being finished:
"Is the exam sealed, and does the answer sheet cite the matching hash?" The
shipped example answer sheet's `Exam SHA-256` field
(`examples/checkout-brief-r1-answers.md:10`) contains the text
`see examples/SEAL.md — verify before answering`. Does the example satisfy that
condition? Relatedly, `templates/seal.md:20` defines status `ANSWERED` as "An
answer file exists **and cites this hash**", while `examples/SEAL.md:7` records
status `ANSWERED`. Do both hold?

**Why it might fail:** If the repository's only worked example fails the
repository's own five-item sanity check, then that check has been demonstrated
capable of failing — on the repository itself — and nobody ran it.

**Discriminates:** Yes.

**Does not grade:** whether the recorded hash value is correct; that is Q-3-01.

**Author side note:** `examples/checkout-brief-r1-answers.md:10`,
`examples/SEAL.md:7`, `templates/answers.md:12`.

---

### Q-4-01

**Question:** `SKILL.md` §7 requires that "**every** factual claim in a
downstream artifact" carry an evidence-strength label. Is `SKILL.md` itself a
downstream artifact under that rule? If it is, which of its numeric claims carry
labels? If it is not, what rule governs the strength of claims made inside the
normative file, and where is that exemption written down?

**Why it might fail:** A rule that the file stating it does not apply to itself
is either scoped somewhere the reader cannot see, or is an exemption nobody
declared. Either way an adopter cannot tell which of the numbers in §6 were
walked, called, queried, or read.

**Discriminates:** Yes.

**Does not grade:** whether adding labels would improve readability.

---

### Q-4-02

**Question:** `CONTRIBUTING.md:73` sets a budget: keep `SKILL.md` under roughly
400 lines. The file is currently in the mid-300s. What enforces that budget, and
when dimension 12 and R9 arrive — the contribution process explicitly
anticipates new dimensions and checks — which content is evicted, and who
decides? Does an expected value stated as "roughly 400" bind anything?

**Why it might fail:** An unenforced numeric budget on a file that is designed
to grow is an expected value with no owner. The first PR that breaches it will
be judged by whoever happens to review it.

**Discriminates:** Yes — either a mechanism exists or the answer is "nothing".

**Does not grade:** whether 400 is the right number.

---

### Q-4-03

**Question:** `SKILL.md:168` states "Answer statuses are exactly three." The
example answer sheet uses `PASS, with a required edit`
(`examples/checkout-brief-r1-answers.md:159`). Two further items are graded
`PASS` while their own Finding text describes a defect **in the artifact under
exam**: Q-5-01 ("§4 is genuinely concurrency-unsafe") and Q-10-01 ("only with a
step the brief omits"). Under the stated three-status vocabulary, what are the
correct statuses, and what is the FAIL count?

**Why it might fail:** This is the shape §3.4 names as the silent side: an
expectation generous enough that a defective artifact satisfies it. If a "PASS"
can carry "the brief must be edited before anyone can run it", then PASS no
longer means what §4 says it means, and the example teaches the looser meaning.

**Discriminates:** Yes.

**Does not grade:** whether a fourth status *should* exist. If the arbiter wants
one, that is a change to §4, not a grading question.

**Author side note:** `examples/checkout-brief-r1-answers.md:159`, `:165-172`,
`:248-262`.

---

### Q-5-01

**Question:** A project that uses both Claude Code and an `AGENTS.md` agent is
instructed by `README.md:128-137` to vendor into `.claude/skills/exam-protocol`
and by `README.md:148-151` / `AGENTS.md:29-32` to vendor into
`.agents/exam-protocol`. That project now holds two copies of the normative
file. `README.md:161-165` claims "there is nothing to keep in sync." Which copy
does each agent load, how does the project detect that they have diverged, and
what is the documented single-copy setup?

**Why it might fail:** The repository's rule number one is that a normative
statement lives in exactly one file. Its own install instructions produce two
files, in the common case of a mixed-agent team — the precise drift the
protocol exists to catch, exported to every adopter.

**Discriminates:** Yes.

**Does not grade:** whether symlinks or submodules would be a better mechanism;
that is a proposal, not a finding.

---

### Q-5-02

**Question:** In the workflow (`SKILL.md:135-145`), the exam is **sealed at step
3** and the implementer performs the rehearsal at **step 4**. Rehearsal
routinely changes the artifact — R1 through R8 exist to find things that must be
fixed. At step 5 the answerer answers the sealed exam. Is the answerer grading
the artifact as it was sealed, or as it now stands? Which document does the seal
actually bind — the exam, the artifact, or both — and what detects that the
artifact moved underneath a sealed exam?

**Why it might fail:** The seal proves the *exam* was not edited. Nothing here
proves the *artifact* was not. An answerer can return a clean sheet about a
document that no longer exists in that form, and every stated rule was followed.

**Discriminates:** Yes — either the ordering is deliberate and explained, or it
is not.

**Does not grade:** whether the seal is worth having.

---

### Q-6-01

**Question:** `SKILL.md:162-166`, `templates/seal.md:25-32` and
`examples/SEAL.md:11-18` offer three hash commands. Their outputs differ in
format and, for `Get-FileHash`, in letter case. Is a reader expected to
normalize before comparing against the lowercase row in `SEAL.md`? Is that
stated anywhere? Is there any path for a reader who has none of the three?

**Why it might fail:** The comparison is instructed as an exact match with a
hard stop on mismatch (Q-7-01). A case difference produces a mismatch that is
not tampering, on the one platform whose install instructions are already absent
(Q-1-02).

**Discriminates:** Yes.

**Does not grade:** the correctness of the hash value itself.

---

### Q-6-02

**Question:** The protocol requires four roles with fresh context.
`AGENTS.md:59-62` permits a self-authored exam if a fresh session is
unobtainable, and requires saying so "in the exam header". Where in
`templates/exam.md` is that field? Where in `templates/seal.md` is the column
that lets a later reader tell a self-authored exam from an independent one?

**Why it might fail:** A weakness that is declared only in prose, in a field
that does not exist on the form, is a weakness that will not be declared. And
the seal record — the one append-only artifact a future reader consults — has no
place to record it, so the distinction is lost at exactly the point it matters.

**Discriminates:** Yes.

**Does not grade:** whether solo use of the protocol is worthwhile.

---

### Q-7-01

**Question:** `examples/SEAL.md:20-21` and `templates/seal.md:6-9` both
instruct: if the hash does not match, **stop**. How many downstream actions does
that cancel? What is the documented recovery procedure for the benign causes — a
typo fix, a line-ending difference, a rebase that touched whitespace? Is a
narrower stop condition available, and who is authorized to override?

**Why it might fail:** Dimension 7 exists in this repository because a previous
exam's own recommendation was implemented as a broad stop rule and cancelled two
sections. This is a broad stop rule, in the repository that wrote that dimension,
and the note at `examples/SEAL.md:23-26` acknowledges that a typo fix triggers it.

**Discriminates:** Yes.

**Does not grade:** whether stopping on mismatch is the right default.

---

### Q-7-02

**Question:** `SKILL.md` §8.1: "Do not schedule work that nobody is permitted to
perform." Applied to an automated author who cannot enter a password: how much
of a typical exam does that instruction cancel? Specifically, are R1 and R2 —
which §6 itself names as the highest-value checks and the ones that get skipped
— schedulable at all under §8.1, and if not, what remains that an automated
author can legitimately claim to have rehearsed?

**Why it might fail:** §8.1 and §6 may be in tension: §6 mandates checks that
§8.1 forbids scheduling. If the resolution is "hand them to a human via §0-R",
then the artifact's rehearsal section is a promise about someone else's future
behavior, and `failure-modes.md` §8 already records that nothing guards it.

**Discriminates:** Partially. The tension is checkable against the text; "how
much does it cancel" cannot be measured against this repository, only argued.

**Does not grade:** whether the capability boundary is real. The repository
argues it is, and this exam does not dispute it.

---

### Q-8-01

**Question:** In the example, `Q-11-01` is **withdrawn**, and the withdrawal row
(`examples/checkout-brief-r1-answers.md:282`) carries a substantive finding: the
configured provider "is **not** the one §6 assumes, so the intended payment path
would never have been exercised." `SKILL.md` §3.2 makes withdrawal an
alternative to answering. Is a defect that would otherwise be `FAIL` being
recorded outside the count? What is the FAIL count if it is counted, and does
the reported "6 of 11" survive?

**Why it might fail:** Dimension 8 asks exactly this: did a real gap get removed
along with the withdrawn item. Here the withdrawal text states the gap out loud
and the result table still reads 6 FAIL. A reader scanning the summary sees six.

**Discriminates:** Yes.

**Does not grade:** whether splitting a compound question is the right remedy.
It plainly is; the question is where the finding goes in the meantime.

---

### Q-8-02

**Question:** The withdrawal in the example is recorded in the **answerer's**
file with "Who decided: Arbiter". `SKILL.md` §2 says the answerer receives only
the sealed exam and that the arbiter does not answer the exam. By what channel
did an arbiter decision reach a file the answerer is writing, and what else
travelled with it? Which role owns the withdrawal table, and does the template's
placement of it inside `answers.md` (`templates/answers.md:67-74`) match §3.2?

**Why it might fail:** The role separations are described as load-bearing. The
worked example shows information flowing from the arbiter into the answerer's
document, which is the direction the separation is meant to block.

**Discriminates:** Yes.

**Does not grade:** whether the withdrawal decision was correct.

---

### Q-8-03

**Question:** `CONTRIBUTING.md:43-62` mandates anonymization; `README.md:220-226`
states every incident really happened but all identifying detail has been
removed. For each rule in `SKILL.md`, can a reader reconstruct **enough of the
mechanism** to reproduce the failure independently — or did the anonymization
remove the mechanism along with the identifiers? Name one claim in this
repository that a stranger could verify without trusting the author.

**Why it might fail:** Dimension 8's second clause. This is an open-source
project whose entire persuasive weight rests on incidents no reader can check,
published by an author no reader knows. If the honest answer is "none", the
project asks for trust on exactly the terms it tells its readers never to
extend.

**Discriminates:** Yes — the reader either names a checkable claim or they do
not.

**Does not grade:** whether anonymizing was the right decision. It may be
mandatory for other reasons; the question is what it cost.

---

### Q-8-04

**Question:** The reverse direction. Does the anonymization actually hold once
details are **combined across files**? Consider, in aggregate: "production
multi-tenant application", "roughly seventy review cycles", "42 of 506 admin
entry points", "51 of 52 items … populated on 2", "12 passing cases turned red",
"a language that does not use spaces between words", and the domain vocabulary
in `discrimination.md` §3 (paywall, syndication feed, discount preview versus
charge, menu deployment). Which clause of `CONTRIBUTING.md`'s anonymization list
covers **combinations** rather than individual identifiers?

**Why it might fail:** Every item in the CONTRIBUTING list is a single-value
prohibition — names, hostnames, account identifiers, file paths. A mosaic is
none of those, and a contributor following the checklist literally would pass it
while publishing a fingerprint.

**Discriminates:** Yes — either the requirement addresses combination or it does
not.

**Does not grade:** whether the aggregate in fact identifies anyone. The author
did not attempt to find out and states this in `does_not_grade`.

---

### Q-9-01

**Question:** Many agents read `AGENTS.md` and only `AGENTS.md`. It declares
"This document deliberately contains **no rules**" (`AGENTS.md:11`), then states
that an exam "is not finished" unless five conditions hold (`AGENTS.md:66`),
including #3: the exam produced at least one red. Is "at least one red" a
condition of completion in `SKILL.md`? §3.3 says a green exam "has not been
shown to work" — is that the same statement as "it is not finished"?

**Why it might fail:** If the two files impose different bars, then the file
that claims to contain no rules contains one, and the difference is invisible to
any agent that reads only one of them. That is the drift the repository asserts
is structurally impossible, occurring between its own two entry points.

**Discriminates:** Yes.

**Does not grade:** which of the two bars is preferable.

---

### Q-9-02

**Question:** `CONTRIBUTING.md:27` — "If a PR adds the same sentence to two
files, it will be asked to delete one." Compare, at v0.1.0: the `## Verification`
block at `README.md:153-159` against `AGENTS.md:36-42`; the vendoring commands at
`README.md:148-151` against `AGENTS.md:29-32`; the `does_not_grade` bullets at
`README.md:171-194` against `SKILL.md:333-353`; the cache-purge worked example at
`SKILL.md:113-118`, `README.md:42-46` and `discrimination.md:25-32`. Does the
repository pass its own rule number one?

**Why it might fail:** The rule is stated as the project's most important, and
the justification given is that shipping a drift-prone protocol in two copies
"would be embarrassing." Whether the current text is duplication or permitted
quotation is the arbiter's call — but it has to be made explicitly, because a
contributor will cite these files as precedent.

**Discriminates:** Yes.

**Does not grade:** which copy should be deleted.

**Author side note:** the four pairs above are the locations; the author records
them without stating whether they match.

---

### Q-9-03

**Question:** `failure-modes.md:212-214` states the general rule: "Whenever you
write down a new invariant, immediately ask which existing gate would catch a
violation of it. If the answer is none, the invariant does not exist." Apply it
to this repository's own invariants — one source of truth, `AGENTS.md` contains
no rules, `SKILL.md` under 400 lines, every rule names an incident, every rule
names what it does not catch, case material anonymized. For each, name the gate.
Is there CI, a linter, a link checker, a PR template, or a checklist that runs?

**Why it might fail:** `discrimination.md` §2.1 requires a new guard to be run
against the real corpus and to go red. If the honest count of gates is zero,
then by the repository's own criterion none of its invariants exist, and this
question is the one the first serious contributor will ask.

**Discriminates:** Yes — gates are enumerable.

**Does not grade:** whether these invariants ought to be automated. "This is
discipline, not mechanism" is a legal answer — `CONTRIBUTING.md:40-41` provides
for it — but it has to be said out loud.

---

### Q-10-01

**Question:** §3.3 says an all-green exam has not been shown to work. Is there
any state of any artifact in which zero reds is the **correct** outcome? If yes,
what distinguishes it from a loose exam, and where is that written? If no, is
§3.3 falsifiable — and does it create pressure on an author to manufacture a red
in order for the exam to be accepted?

**Why it might fail:** This is the silent side of §3.4 applied to §3.3. A rule
that treats every clean result as suspicious rewards authors who produce reds,
and the cheapest red to produce is a question the artifact was never obliged to
satisfy.

**Discriminates:** Partially. The "is it falsifiable" clause is checkable
against the text; "does it create pressure" is a judgment the arbiter must
make, not a fact this exam can settle.

**Does not grade:** whether §3.3's underlying instinct is correct.

---

### Q-10-02

**Question:** `AGENTS.md:71` requires the report to answer: "Did the author
verify any of their own questions? (Must be no.)" What observable trace
distinguishes an author who checked from one who did not? Who answers this
question, and can the answer ever be anything other than the author's own
assertion?

**Why it might fail:** This is a control the system may be unable to satisfy —
dimension 10 turned on the protocol. If the only evidence is self-report, the
check passes identically in both worlds, which is the repository's own
definition of a covariate.

**Discriminates:** Yes — either a trace exists or the honest answer is "self-
report only", and both are informative.

**Does not grade:** whether §3.1 is a good rule. It may be excellent and still
unverifiable.

---

### Q-10-03

**Question:** Dimension 10 (`SKILL.md:199`) instructs the author: "If you cannot
answer, do not ask the question." §3.1 (`SKILL.md:72-80`) forbids the author from
verifying their own questions. Which governs when they conflict? In the shipped
example, `Q-10-01` was asked — so did the author answer it first, in violation of
§3.1, or ask it without answering, in violation of dimension 10?

**Why it might fail:** Two normative statements in the same file give opposite
instructions for the same action, and the repository's only worked example must
have violated one of them to exist.

**Discriminates:** Yes.

**Does not grade:** which of the two should be amended.

---

### Q-10-04

**Question:** When the artifact under exam is a **document**, reading it *is*
verifying it — the author cannot write a question about §4 of a brief without
reading §4, and at that moment they hold the answer. What does §3.1 forbid in
that case, and what should a document-scoped author do instead of "not
verifying"? Does the protocol distinguish document-scoped exams from
system-scoped ones anywhere?

**Why it might fail:** §3.1's stated justification is that an author who knows
the answers only asks questions they could check — a real effect. But for the
default target the protocol names (a brief, a plan, a status claim), the author
necessarily knows a large fraction of the answers by the time they finish
reading, and the rule offers no procedure for that. An author following it
literally would have to avoid reading the artifact.

**Discriminates:** Yes — the distinction is either drawn in the text or it is
not.

**Does not grade:** how the rule should be rewritten.

---

### Q-11-01

**Question:** The protocol's own architecture-invariant question is "can this
value be changed without editing code?" Apply it: an adopter who needs a twelfth
dimension or a ninth rehearsal check must edit the vendored `SKILL.md`, which
`AGENTS.md:44-45` says is vendored precisely so it can be diffed against
upstream. Is there a documented extension point — a local supplement file, an
overlay, a numbering convention — that keeps local additions separable from
upstream?

**Why it might fail:** The two stated benefits are in tension: a single source of
truth you must fork to extend is no longer a single source of truth, and the
diff-against-upstream benefit degrades on the first local addition.

**Discriminates:** Yes.

**Does not grade:** whether local extension is a use case worth supporting.

---

### Q-11-02

**Question:** The directory name `exam-protocol` is written into install paths in
at least four documents (`README.md`, `AGENTS.md`, and both vendoring snippets),
and into `name:` in the frontmatter. What happens for an adopter who already has
a skill by that name, or whose organization requires a namespace prefix? Which
files must they edit, and is the relationship between the directory name and the
frontmatter `name` documented anywhere?

**Why it might fail:** A value repeated across four documents with no single
definition is the same failure mode the project's rule number one exists to
prevent, applied to a configuration value rather than a rule.

**Discriminates:** Yes.

**Does not grade:** whether name collisions are likely.

---

### Q-11-03

**Question:** `discrimination.md` §2.6: N doors require N mutations, and "for
each door, ask: if I deleted it, would anything go red?" This repository ships at
least 24 doors — 5 rules, 11 dimensions, 8 rehearsal checks. For each, if it were
deleted from `SKILL.md` today, what would go red? By the repository's own
criterion, how many of the 24 are tested, and what is the plan for the rest?

**Why it might fail:** §2.6 states the consequence of an untested door in the
repository's own words: the next person who sees it as dead code gets a green
light for deleting it. If the count of doors with a mutation behind them is
zero, the protocol's most-cited technique has never been applied to the protocol.

**Discriminates:** Yes — the count is enumerable and the honest answer may be
zero.

**Does not grade:** whether prose rules *can* be mutation-tested. "They cannot,
and here is why" is a legal and valuable answer — but it should then appear in
§9's `does_not_grade`, and its absence there is part of what this question asks.

---

## Note on the discriminating count

Quote **32**, not 34.

Non-discriminating or partial question IDs:

- `Q-7-02` — partial. The tension between §8.1 and §6 is checkable against the
  text; the "how much does it cancel" clause cannot be measured against this
  repository and can only be argued. Treat that clause as a prompt for the
  arbiter.
- `Q-10-01` — partial. The falsifiability clause is checkable; the "does it
  create pressure to manufacture a red" clause is a judgment, not a finding.

## Author's compliance statement

- The author did not answer, check, or verify any question above. No hash was
  computed, no install command was run, no git configuration was inspected, no
  guard was executed, and no external repository was consulted.
- Every `Author side note` records a **location only**.
- The author declares one structural weakness in this exam, arising from
  Q-10-04: because the artifact under exam is a set of documents, the act of
  reading them in order to author questions inevitably exposes some answers. The
  author has not stated any of them. The arbiter should treat questions whose
  answer is settled by reading a single line — **Q-3-02, Q-3-03, Q-4-03, Q-8-01,
  Q-8-02, Q-9-02, Q-10-03** — as having reduced discriminating power, not
  because they are wrong, but because an independent answerer is unlikely to
  disagree with an author who has already read the same line. They are retained
  because the point is the arbiter's ruling, not the discovery.

## Sealing

This exam is `AUTHORED_NOT_RUN` and **not yet sealed**. Whoever files it should
compute the SHA-256 and add a row to a seal record — and should note that doing
so on Windows interacts with `Q-3-01`, which is itself unanswered.
