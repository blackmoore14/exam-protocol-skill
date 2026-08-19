# exam-protocol

**Before you say "done", have someone else write you an exam you cannot answer.**

A portable protocol for adversarial verification, packaged as a Claude Code
plugin, a standalone Claude Code skill, and a plain file that `AGENTS.md` agents
can read. [Jump to install](#install).

---

## The problem

Self-review does not work, and the reason is structural rather than a matter of
diligence:

> **The person writing the checklist is the person answering it.**

You review your own work against your own intent, so every assumption you made
while building it gets made a second time while checking it. Reviewing harder
does not help, because the questions that would catch you are questions that do
not occur to you.

The first time this protocol was run against a team's own artifacts — two
documents the author considered correct at the moment of writing — a fresh
reviewer's exam came back:

> **36 questions. 30 red.** `[PRIOR]`

Including a guard the documentation claimed was wired into CI **that no pipeline
had ever invoked**; a cell marked "verified" whose cited evidence did not exist;
and a defect report that had been *withdrawn* on reasoning the code did not
support.

Every number on this page carries `[PRIOR]`, which in this protocol's own
vocabulary (§7) means **treat as unverified**: it is an observation made then,
in a private repository you cannot open. See `does_not_grade` below.

Nothing about the authors was careless. Self-review simply cannot see this.

## Where this sits

This is a **verification** tool, and it runs late. The complementary move —
sharpening a plan *before* anyone builds it — is a different job, and the
`grilling` / `grill-me` skill in
[`mattpocock-skills`](https://github.com/anthropics/claude-plugins-official)
does it well. Requirements first, verification after; they are not substitutes,
and pairing them is the intended use.

The comparison below was read from that skill's own source on one machine
(**`mattpocock-skills` v1.2.3, read 2026-08-19**). Skills change; by this
project's own rule (§7) a description of a file is an observation of the moment
it was read, so the version is part of the claim.

| | `grilling` / `grill-me` | `exam-protocol` |
|---|---|---|
| When it runs | **Before** you act — "Do not act on it until the user confirms you have reached a shared understanding." | **After** the work exists and someone is about to call it done |
| What it examines | **A human's decisions** — a plan, a design, an idea | **A produced artifact** — a brief, a ledger, a "done" claim |
| Shape | An interactive interview, in rounds over a design tree | A sealed exam, delivered once |
| **The asker and the answer** | The asker **supplies their own recommended answer** to every question (`➡️ <your recommended answer>`) | The author is **forbidden from answering their own questions**, and records locations rather than conclusions |
| Who answers | The user | A second agent in fresh context, who never sees the author's reasoning |
| Arbitration | None — the user decides | A separate arbiter, who may not answer |
| Mutation testing / negative controls / evidence labels | None | Yes |
| Is it a CI gate? | **No** | **No, either** |
| The core question | *"What am I missing?"* | *"Can you prove it?"* |

The fourth row is the real inversion, and it is a design choice on both sides
rather than a defect on either. An interview is more useful when the interviewer
commits to an answer you can push back on. An exam is only useful when the
author has not already written the answer down, because the second fresh reader
*is* the mechanism.

Two things worth stating plainly. `grill-me` carries
`disable-model-invocation: true`, so it is invoked by slash command and does not
fire from a description — do not expect it to trigger on its own. And **neither
tool is a gate**: that row is a similarity, not a difference, and admitting it
is what makes the rest of the table worth reading.

### The neighbour that runs at the same time

`grilling` runs *before*. The tool that runs at exactly the same moment as this
one is `verification-before-completion` in
[`superpowers`](https://github.com/anthropics/claude-plugins-official) — its
description is literally "when about to claim work is complete, fixed, or
passing." Omitting it from a comparison page would be avoidance, so:

Its Iron Law is **"If you haven't run the verification command in this message,
you cannot claim it passes"** (`superpowers` v6.2.0, read 2026-08-19). That is a
strictly better default than claiming without evidence, and most of the time it
is the right amount of process.

The difference is one word: **self**. It asks *you* to run the command and read
the output. This protocol's whole premise is that the person who did the work
cannot generate the questions that would expose it — not through carelessness,
but because those questions do not occur to someone who already knows what they
meant. So the two stack rather than compete:

| | `verification-before-completion` | `exam-protocol` |
|---|---|---|
| Who verifies | **You**, in the same session | A second reader who never saw your reasoning |
| What it catches | Claims made with no evidence at all | Claims made with evidence that **does not discriminate** |
| Cost | Seconds | Two extra sessions |
| Use it | **Every time** | When someone downstream will act on the artifact without re-checking it |

Run the Iron Law always. Reach for an exam when being wrong costs a cycle rather
than a re-run.

### What kind of project this came from

The five rules, the four roles, the seal, `does_not_grade`, and everything in
[discrimination](skills/exam-protocol/references/discrimination.md) are
domain-neutral — they are about evidence, not about stacks.

The **rehearsal checks R1–R8 are not**. They were shaped by a web application
with authentication, an admin panel, and third-party payment providers, and it
shows: R1 assumes screens you log into, R4 assumes a browser, R7 assumes a
routing table, R8 assumes payment vendors. Translate rather than skip —

- **R1** *"walk it authenticated"* → run it the way the user runs it, in their
  environment, not in your test harness.
- **R3** *"count fixtures through the app's own read path"* → do not count with a
  query the application itself would never issue.
- **R7** *"compute entry points"* → derive the real surface (CLI flags, exported
  functions, routes) from the code, do not recall it.
- **R8** *"verify the provider, not the label"* → check what is actually
  configured, not what the display name says.

R2 (close the loop) and R6 (count what you promised; do not `grep -c`) need no
translation at all, and in measured use they catch the most.

## What a confident pass looks like — and what actually caught each one

Anonymized, all real, all from work that had already passed review. **The exam
did not find most of these**, and saying so is the more useful claim: what an
exam buys you is one gate in a portfolio, and the fourth column is where you
should look for the technique you are missing.

| What passed | What was actually true | Found by | Written up in |
|---|---|---|---|
| A test named `deduct_prevents_negative_stock`, green | It **skipped itself at the exact moment stock went negative** — the behavior its name claimed to verify. A real inventory defect showed green. | **Not recorded.** See the note below. | — |
| A brief: *change a setting, press the cache-purge button, check the public page updated* | Saving the setting bumped the cache version by itself, so the page updated **whether the button worked or not**. The tester reported the feature as working; the truth was the opposite. | **A negative control at design time** — wiring the button to a no-op and re-running. Later also asked as an exam question. | [discrimination](skills/exam-protocol/references/discrimination.md) §1.1 |
| A single-use, signature-verified, allowlist-restricted access link, with a **fully green** suite | Deleting the signature check: still fully green. Deleting the allowlist check: still fully green. Two of three defenses had never been tested — every test was satisfied by whichever door rejected first. | **Mutation testing** — removing each door in turn. | [discrimination](skills/exam-protocol/references/discrimination.md) §2.6 |
| Paywalled article content stripped server-side, six access combinations covered | A **public syndication feed** on the same data checked "published and active" and never checked access level. The paid content was one plain HTTP request away. | **Bypass inventory** — enumerating every exit that can emit the same data. | [discrimination](skills/exam-protocol/references/discrimination.md) §3 |

None of these produced a red where anyone was looking. That is the point: a
broken check does not announce itself, it issues a confident pass.

> **On row one.** This repository does not record which gate found it, and we
> are not going to guess. It is carried here as an illustration of the shape,
> at `[PRIOR]` strength — an observation made then, not an audited fact now.
> Leaving the gap visible is cheaper than inventing an attribution, and this
> project has no standing to do the second.

## How it works

Four roles, and the separations between them do the work:

```
Implementer  ──▶ builds it, then arbitrates. Never authors. Never answers.
Author       ──▶ fresh context, read-only, writes the exam,
                 and is forbidden from checking their own questions.
                 ↓  seal (sha256)
Answerer     ──▶ fresh context, receives ONLY the sealed exam.
                 ↓
Arbiter      ──▶ fix, withdraw with a reason, or accept as UNRESOLVED.
```

Plus the parts that make it more than ceremony:

- **An 11-dimension authoring checklist**, so coverage stops being a function of
  the author's imagination on the day.
- **8 rehearsal checks (R1–R8)** — perform every step yourself before handing it
  to anyone, because "it opens" is not "it works."
- **Covariate detection**: a mechanical test for whether an experiment would
  give the same answer if the system were broken.
- **Mutation testing of guards**, including the two ways a mutation can be
  invalid and still look convincing.
- **Evidence-strength labels** so a reader can see whether a claim was walked,
  called, queried, read, or inherited from last week.
- **A mandatory `does_not_grade` header**, because green is necessary and never
  sufficient.

## 30 seconds

*Illustrative. The exam below is the worked example in
[`examples/`](examples/), whose artifact — a checkout release brief — is
fictional. The question shapes are real; the findings are staged.*

You are about to hand a colleague a test plan. Instead of sending it:

```
"Author a sealed exam over docs/release-plan.md following
 .agents/exam-protocol/SKILL.md. You are read-only. Do not verify your own
 questions. Cover all 11 dimensions."
```

Twelve questions come back. Three of them:

> **Q-3-01** — §2 names product record `#70` as the control. Can that record be
> **saved** in the admin UI right now, or only viewed?
>
> **Q-2-01** — §4 has the tester press "purge cache" and check the public page.
> Does saving the setting invalidate that cache on its own? If so, what does
> this step measure?
>
> **Q-10-01** — §5 says attribution "must not appear" for a clean URL. Is there
> any attribution window that would make it appear by design?

All three are red. The control record has a blank required field and cannot be
saved. The cache experiment measures the save, not the button. The attribution
window is 30 days, so the control was demanding behavior the system is designed
not to produce — and had it shipped, the tester would have filed correct
behavior as a major defect.

Cost: a few minutes. Cost of shipping it: two blocked sections, one wrong defect
report, and a full round trip.

---

## Install

The canonical repository is
`https://github.com/blackmoore14/exam-protocol-skill`. Pick **one** path below —
installing by two paths at once gives you two copies of a protocol document that
nothing compares, which is the exact failure this project exists to catch. See
[If you use both](#if-you-use-both--keep-one-copy-not-two).

### Claude Code — as a plugin

This repository is its own marketplace, so both steps point at the same place:

```
/plugin marketplace add blackmoore14/exam-protocol-skill
/plugin install exam-protocol@exam-protocol-marketplace
```

The equivalent outside a session:

```bash
claude plugin marketplace add blackmoore14/exam-protocol-skill
claude plugin install exam-protocol@exam-protocol-marketplace
```

Read back what actually landed, rather than trusting the success message:

```bash
claude plugin details exam-protocol@exam-protocol-marketplace
#   Component inventory
#     Skills (1)  exam-protocol
```

`Skills (1)` is the line that matters. The plugin manifest deliberately declares
**no** `skills` field: skills are auto-discovered from the top-level `skills/`
directory, so the plugin and the standalone skill are the *same bytes on disk*
rather than two copies that can drift. If that line says `Skills (0)`, the
plugin loaded but the protocol did not.

To try it from a local clone before trusting the network, add the working tree
directly — the leading `./` is required:

```bash
git clone https://github.com/blackmoore14/exam-protocol-skill.git
cd exam-protocol-skill
claude plugin marketplace add ./
claude plugin install exam-protocol@exam-protocol-marketplace
```

### Claude Code — as a standalone skill

If you would rather not add a marketplace, copy the skill directory. Personal:

```bash
git clone https://github.com/blackmoore14/exam-protocol-skill.git
rm -rf ~/.claude/skills/exam-protocol
cp -r exam-protocol-skill/skills/exam-protocol ~/.claude/skills/exam-protocol
```

…or scoped to one project:

```bash
mkdir -p .claude/skills
rm -rf .claude/skills/exam-protocol
cp -r /path/to/exam-protocol-skill/skills/exam-protocol .claude/skills/exam-protocol
```

**The `rm -rf` is the upgrade, and it is not optional.** `cp -r src dst` where
`dst` already exists copies *into* it. So on a second run the old `SKILL.md`
survives at the path the loader reads, and the new one is buried at
`exam-protocol/exam-protocol/SKILL.md` where nothing looks. You would then be
running the superseded protocol, with the new copy on disk as proof that you
had upgraded. This is POSIX-specified behaviour for `cp`, so macOS and BSD
`cp -R` do it too, and a skill that fails to load says nothing.

Read the version back after every install:

```bash
grep -A2 '^metadata:' ~/.claude/skills/exam-protocol/SKILL.md
#   version: "0.2.0"
```

The plugin path has no equivalent hazard: `claude plugin update` replaces rather
than merges. That is the reason to prefer it.

### Codex and other `AGENTS.md` agents

Vendor the skill directory and point at it from your project's `AGENTS.md`:

<!-- shared-snippet — defined here, repeated verbatim in this repo's own AGENTS.md
     because an agent reading that file will never open this one. Text for the
     reader to paste, not a normative statement. -->
```bash
mkdir -p .agents
rm -rf .agents/exam-protocol
cp -r /path/to/exam-protocol/skills/exam-protocol .agents/exam-protocol
```

```markdown
## Verification

Before claiming work is complete, before handing an execution brief to anyone,
and before marking anything "verified" in a status document, follow
`.agents/exam-protocol/SKILL.md`.
```
<!-- /shared-snippet -->

**There is no skill system on this path.** No plugin, no marketplace, no
frontmatter parsing, no `/exam-protocol`, and nothing that fires on a phrase.
The agent reads `SKILL.md` for exactly one reason: your `AGENTS.md` told it to.
The YAML block at the top of the file is inert text there. Everything the
protocol asks for still works — it is prose and templates, not machinery — but
the loading is manual and it is on you to keep the pointer accurate.

This repository's own [`AGENTS.md`](AGENTS.md) is that entry point. It is a
pointer plus harness-specific loading guidance, and it defines no rules.

### If you use both — keep one copy, not two

Upstream is one file. **Your tree is not.** Installing into both
`.claude/skills/` and `.agents/` gives you two copies of a protocol document
that nothing compares, and you own the synchronisation. That is the exact
failure this protocol exists to catch, handed to you by an install instruction.

Vendor once and point the other path at it:

```bash
mkdir -p .agents .claude/skills
cp -r /path/to/exam-protocol/skills/exam-protocol .agents/exam-protocol
ln -s ../../.agents/exam-protocol .claude/skills/exam-protocol
```

Where symlinks are unavailable, keep both copies and add a gate that fails when
they diverge:

```bash
diff -r .agents/exam-protocol .claude/skills/exam-protocol
```

Nothing detects that drift on its own, and a second source of truth disagrees
quietly.

### Renaming the skill

The directory name and the `name:` field in `SKILL.md`'s frontmatter are two
independent copies of one value. Claude Code resolves `/exam-protocol` from the
frontmatter; the install path is the directory. If they disagree you find out
by trial. Change both together:

| Where | What to change |
|---|---|
| installed directory | `~/.claude/skills/<new-name>`, or `.agents/<new-name>` |
| `SKILL.md` frontmatter | `name: <new-name>` |
| your project's `AGENTS.md` | the path inside the `## Verification` block |

If your organization namespaces skills, use `<org>-exam-protocol` in both.
Nothing else inside the skill directory refers to its own name. In this
repository `scripts/check.sh` check 13 fails when those copies disagree.

## I installed it — now what?

The protocol needs **three separate sessions**, because the separations are the
entire mechanism. Run them in this order.

**1. Author the exam** — a fresh session that has not seen how the work was
built. On the plugin or skill path, invoke by name:

```
/exam-protocol docs/release-plan.md
```

…or describe the situation and let the description trigger it:

> *"I'm about to tell the client this migration is done. Am I really done?"*
>
> *"Review this test plan before I hand it to QA — I want the questions I'm not
> asking myself."*
>
> *"Write me a sealed exam over `CHANGELOG.md` and the release checklist. You
> are read-only; do not answer your own questions."*

Trigger phrases the skill's `description` carries include *"am I really done"*,
*"sealed exam"*, *"before I ship"*, *"negative control"*, *"covariate"*,
*"mutation test"*, and *"does_not_grade"*. On the `AGENTS.md` path none of this
applies — say "follow `.agents/exam-protocol/SKILL.md`" instead.

**2. Seal it, then answer it in a different session.** The answerer gets the
sealed exam file and nothing else — not your reasoning, not the author's:

> *"Answer the sealed exam at `exams/release-r1-exam.md`. Verify both hashes
> first. Use only FAIL, PASS, or UNRESOLVED, and cite where you checked."*

**3. Arbitrate, in your own session.** Fix, withdraw with a stated reason, or
accept as `UNRESOLVED`. You do not answer.

Two shortcuts worth knowing on day one. If the exam comes back **all green**,
that is a claim about the exam and not about your work — damage a copy of the
artifact deliberately and re-answer; if it stays green the questions are loose
(`SKILL.md` §3.3). And if you are writing something *another person or agent*
will execute, paste
[`templates/rehearsal-handoff.md`](skills/exam-protocol/templates/rehearsal-handoff.md)
as its first section: it costs the executor five minutes and it is the single
highest-yield piece of the protocol.

## Compatibility

What each host actually provides. The asymmetry is real and worth reading before
you pick a path.

| | Claude Code — plugin | Claude Code — skill | Codex / other `AGENTS.md` agents |
|---|---|---|---|
| Install mechanism | `/plugin install` from a marketplace | copy a directory | copy a directory |
| Reads `SKILL.md` frontmatter | yes | yes | **no** — inert text |
| `/exam-protocol` invocation | yes | yes | **no** |
| Triggers on a described situation | yes | yes | **no** |
| How it gets loaded | the plugin loader | the skill loader | **your `AGENTS.md` tells the agent to read the file** |
| Managed updates | `claude plugin update` | manual `rm -rf` + `cp -r` | manual `rm -rf` + `cp -r` |
| The protocol itself works | yes | yes | **yes** |
| Templates and references usable | yes | yes | yes |

The last two rows are the point. `AGENTS.md` agents lose the *ergonomics* — the
name, the trigger, the update path — and lose none of the *protocol*, because
the protocol is prose and forms rather than machinery. What you give up is
convenience and a guarantee that it was loaded at all.

## Updating

| Path | Command |
|---|---|
| Plugin | `/plugin marketplace update` then `/plugin install` again, or `claude plugin update exam-protocol@exam-protocol-marketplace` |
| Standalone skill | `git pull`, then `rm -rf ~/.claude/skills/exam-protocol` and `cp -r` again — **the `rm -rf` is mandatory**, see above |
| `AGENTS.md` | `git pull`, then `rm -rf .agents/exam-protocol` and `cp -r` again |

After a plugin update, `/reload-plugins` applies it without restarting the
session. After a manual copy, re-read the version out of the installed file
rather than the repository — that is the copy the loader will use:

```bash
grep -A2 '^metadata:' ~/.claude/skills/exam-protocol/SKILL.md
```

If you vendored the skill into a project, `diff -r` your copy against upstream
before overwriting. Local edits to a vendored `SKILL.md` are the thing
[`SKILL.md` §10](skills/exam-protocol/SKILL.md) exists to prevent — put local
rules in `SKILL.local.md` beside it and the diff keeps working.

## Uninstalling

| Path | Command |
|---|---|
| Plugin | `claude plugin uninstall exam-protocol@exam-protocol-marketplace` and, if you want the source gone too, `claude plugin marketplace remove exam-protocol-marketplace` |
| Standalone skill | `rm -rf ~/.claude/skills/exam-protocol` or `rm -rf .claude/skills/exam-protocol` |
| `AGENTS.md` | `rm -rf .agents/exam-protocol` **and delete the `## Verification` block from your `AGENTS.md`** |

The `AGENTS.md` row has a second step for a reason: a pointer left behind after
the file is gone tells an agent to read something that does not exist, and how
each harness reacts to that is not something this project can promise.

Nothing here writes outside those directories. Exams you have already produced
live in your own repository and are yours to keep — they are the audit trail.

## Distribution

This repository is **its own marketplace**. `.claude-plugin/marketplace.json`
names one plugin, whose `source` is `"./"` — the repository root, which is also
the plugin root. Adding the repository as a marketplace and installing the
plugin from it are two steps over the same bytes.

**It is not listed in any Anthropic marketplace, and nothing here has been
submitted to one.** If you found this expecting an official listing, there
isn't one. Getting listed would mean meeting whatever the receiving marketplace
requires and being accepted by its owners; the official docs available to this
project do not state that process, so it is not described here rather than
guessed at. Until then, `/plugin marketplace add blackmoore14/exam-protocol-skill`
is the distribution channel, and it is a first-party one: you are adding *this*
repository, not trusting an intermediary.

Both manifests are checked in CI-adjacent form by `scripts/check.sh` (checks
10–12) and can be validated directly:

```bash
claude plugin validate .claude-plugin/plugin.json
claude plugin validate .claude-plugin/marketplace.json
```

That command validates **schema**. Measured on this repository, it does not
resolve a plugin `source` — a marketplace pointing at a directory that does not
exist still passes — and it does not reject a reserved marketplace name. Check
12 resolves the source and check 11 rejects reserved names, which is why both
exist alongside it rather than deferring to it.

## What it does not do — `does_not_grade`

This section is the reason to trust the rest of the page.

- **An exam is a sample, not coverage.** Thirty reds means thirty fingerprints
  were found. It says nothing about the ones nobody looked for.
- **It does not grade your source code by default.** The default target is a
  *document* — a brief, a plan, a status claim. A hardcoded vendor identifier
  sitting in the application is invisible to an exam scoped at a brief. This is
  an observed miss, not a theoretical one.
- **It does not grade files it was not pointed at.** Credential tables and
  prior-cycle reports fall outside scope unless the author deliberately drags
  them in.
- **It is not a gate.** It does not block a commit and it does not fail a build.
  Its entire value is that someone asked you a question you would not have asked
  yourself.
- **Authors write broken questions too.** In one review round, four defects were
  found inside a single exam and **all four were in the harness or setup**, none
  in the behavioral assertions. "This question is itself wrong" is a legal
  answer, and the templates have a section for it.
- **Discrimination is mechanical; meaning is not.** The tooling here can tell
  you whether your measurement distinguishes two worlds. It can never tell you
  which world is correct.
- **The ceiling is your own capability.** An author who cannot perform
  authenticated write actions cannot verify anything below "the interface
  responded" — and that is exactly where most plan errors live. The protocol's
  response is to hand those checks to whoever *can* perform them, not to pretend
  the ceiling is not there.
- **The numbers on this page are unauditable, by design.** Every quantitative
  claim here comes from a private repository, and the anonymization rules in
  [CONTRIBUTING.md](CONTRIBUTING.md) forbid the file paths that would let you
  check one. That is a deliberate trade, and it means the provenance section is
  `[PRIOR]` — treat it as unverified. The *techniques* are reproducible on your
  own code in minutes; the evidence that they were needed is not.
- **The protocol's own rules have never been mutation-tested.** Delete a rule, a
  dimension, or a rehearsal check from `SKILL.md` and nothing in this repository
  goes red — the gates in [`scripts/check.sh`](scripts/check.sh) enforce
  structure, not doctrine. By this project's own N-doors argument that means the
  individual rules are untested, and we have not done the one experiment that
  would fix it.
- **Packaging is verified; publication is not.** The manifests validate, and the
  plugin has been installed from a local clone and confirmed to expose the skill.
  Installing from the GitHub URL, on a machine that is not this one, has not been
  measured — the first person to run it is the test.

## Repository layout

```
README.md                      you are here
AGENTS.md                      Codex entry point — a pointer, no rules
LICENSE                        MIT
CHANGELOG.md                   Keep a Changelog
CONTRIBUTING.md                including the one-source-of-truth rule
CODE_OF_CONDUCT.md             Contributor Covenant 2.1
.gitattributes                 pins .md to LF, because the seal hashes bytes
.claude-plugin/
  plugin.json                  plugin manifest — no skills field on purpose
  marketplace.json             this repository as a single-plugin marketplace
scripts/check.sh               the repository's own gates — run it before a PR
.github/workflows/check.yml    runs that script on push and pull request
skills/exam-protocol/          auto-discovered by the plugin loader; also the
                               directory you copy for the other two install paths
  SKILL.md                     the protocol (normative, single source of truth)
  references/            discrimination.md, failure-modes.md, extending.md
    discrimination.md          covariates, negative controls, mutation testing,
                               the N-doors rule, bypass inventory
    failure-modes.md           anonymized post-mortems behind every rule
  templates/
    exam.md  answers.md  seal.md  rehearsal-handoff.md
examples/                      FICTIONAL artifact, staged findings
  checkout-brief-r1-exam.md    a complete worked exam — 14 questions
  checkout-brief-r1-answers.md its answer sheet — 11 red, 1 green,
                               2 unresolved, 1 withdrawn clause
  SEAL.md                      the matching seal record
exams/                         this protocol run against ITSELF, reds still open
  exam-protocol-self-r1-exam.md
  exam-protocol-self-r1-answers.md
  SEAL.md
```

There is exactly one `SKILL.md` in this tree and `scripts/check.sh` check 14
keeps it that way. All three install paths distribute that same file.

## Provenance

Distilled from dozens of review cycles on one production application, where each
rule was added after a specific failure got through everything that existed at
the time. Every incident in
[`references/failure-modes.md`](skills/exam-protocol/references/failure-modes.md)
really happened; all identifying detail has been removed and the shapes kept.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). New rules must name the incident that
produced them, what they do **not** catch, and how anyone would know they are
working. Case material must be anonymized before the PR is opened.

## License

MIT — see [LICENSE](LICENSE).
