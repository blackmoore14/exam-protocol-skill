# exam-protocol

**Before you say "done", have someone else write you an exam you cannot answer.**

A portable protocol for adversarial verification, packaged as a skill that works
in both [Claude Code](#claude-code) and [Codex and other `AGENTS.md` agents](#codex-and-other-agentsmd-agents).

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

The canonical repository is `https://github.com/blackmoore14/exam-protocol`.

### Claude Code

Copy the skill into your skills directory — personal:

```bash
git clone https://github.com/blackmoore14/exam-protocol.git
rm -rf ~/.claude/skills/exam-protocol
cp -r exam-protocol/skills/exam-protocol ~/.claude/skills/exam-protocol
```

…or scoped to one project:

```bash
mkdir -p .claude/skills
rm -rf .claude/skills/exam-protocol
cp -r /path/to/exam-protocol/skills/exam-protocol .claude/skills/exam-protocol
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
#   version: "0.1.0"
```

Then invoke it by name (`/exam-protocol`), or describe the situation — the
skill's `description` field triggers on phrases like *"am I really done"*,
*"review my test plan"*, *"sealed exam"*, *"negative control"*, and *"before I
ship"*.

> **Scope of that last claim:** description-based triggering is a Claude Code
> feature. `AGENTS.md` agents have no skill loader and no frontmatter parser —
> see the next section.

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

There is no skill system on this path and no frontmatter parsing. The agent
reads `SKILL.md` because your `AGENTS.md` told it to; nothing triggers on a
phrase, and the YAML block at the top of the file is inert text.

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
Nothing else inside the skill directory refers to its own name.

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

## Repository layout

```
README.md                      you are here
AGENTS.md                      Codex entry point — a pointer, no rules
LICENSE                        MIT
CHANGELOG.md                   Keep a Changelog
CONTRIBUTING.md                including the one-source-of-truth rule
CODE_OF_CONDUCT.md             Contributor Covenant 2.1
.gitattributes                 pins .md to LF, because the seal hashes bytes
scripts/check.sh               the repository's own gates — run it before a PR
.github/workflows/check.yml    runs that script on push and pull request
skills/exam-protocol/
  SKILL.md                     the protocol (normative, single source of truth)
  references/
    discrimination.md          covariates, negative controls, mutation testing,
                               the N-doors rule, bypass inventory
    failure-modes.md           anonymized post-mortems behind every rule
  templates/
    exam.md  answers.md  seal.md
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
