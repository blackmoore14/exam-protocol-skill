# AGENTS.md

Entry point for agents that read `AGENTS.md` (Codex CLI, Codex Cloud, Jules,
Cursor, Aider, and others that follow the convention).

## The protocol lives in one file

> **Read [`skills/exam-protocol/SKILL.md`](skills/exam-protocol/SKILL.md).**
> That file is the protocol. This file is a pointer.

This document deliberately contains **no rules**. Two copies of the same rules
drift apart, and the drift is silent — which is precisely the failure this
protocol exists to catch. If you are looking for what to do, open `SKILL.md`.

This repository also ships a Claude Code plugin manifest under
`.claude-plugin/`. **Ignore it.** None of that machinery — plugins,
marketplaces, frontmatter, slash-command invocation, description-based
triggering — exists on this path. You are here because a human wrote a pointer
in a file and you read it, and that is the whole loading mechanism. The protocol
itself is unaffected: it is prose and forms, and it works the same either way.

Supporting material, loaded only when the task calls for it:

| File | Load it when |
|---|---|
| `skills/exam-protocol/SKILL.md` | **Always.** The protocol. |
| `skills/exam-protocol/references/discrimination.md` | You need to judge whether a check, test, or experiment is capable of failing — covariates, negative controls, mutation testing, bypass inventory. |
| `skills/exam-protocol/references/failure-modes.md` | You want the evidence behind a rule, or you are proposing to change one. |
| `skills/exam-protocol/templates/` | You are producing an exam, an answer sheet, a seal record, or the `§0-R` rehearsal handoff. |
| `examples/` | You want to see a finished exam and answer sheet. **Fictional artifact, staged findings.** |
| `exams/` | You want a real one: this protocol run against this repository, 30 of 34 red, findings left open. |

## Using it in your own project

Copy the skill directory into the project you want to examine:

<!-- shared-snippet — defined in README.md "Codex and other AGENTS.md agents".
     Repeated here verbatim because an agent reading this file will not open the
     README. Text for the reader to paste; not a normative statement. -->
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

The `rm -rf` matters on upgrade: `cp -r` into an existing directory copies
*into* it, leaving the old `SKILL.md` in place and burying the new one.

Vendoring the whole directory rather than copying prose keeps a single source of
truth, and lets you diff against upstream when this project updates. If you also
install into `.claude/skills/`, see the README — two vendored copies are two
sources of truth and nothing compares them for you.

## Role separation without a skill system

The protocol requires four roles with fresh context between them
(`SKILL.md` §2). Harnesses that lack a sub-agent primitive can satisfy this
with plain sessions — the requirement is informational isolation, not any
particular technology:

| Role | How to run it |
|---|---|
| Author | A **new session** whose only inputs are the artifact under exam and `SKILL.md`. Do not paste the implementation rationale, the commit messages, or the prior discussion. |
| Answerer | Another **new session** whose only inputs are the sealed exam file and, if needed, read access to the system. Do not give it the author's notes. |
| Arbiter | Your main session. Rules on findings. **Does not answer.** |

If you cannot get a genuinely fresh session, **`SKILL.md` §2 tells you what to
do** — declare it in the exam header's author-independence field. The rule and
the field are defined there, not here.

## Sanity check before you claim an exam is done

**`SKILL.md` §4.1 has the five-item completion check.** Answer all five in your
report; an unanswered item means the exam is not finished.

It lives in `SKILL.md` because it is a completion condition, and completion
conditions are rules. This file used to carry its own copy, which is how a
pointer file grows a second source of truth.
