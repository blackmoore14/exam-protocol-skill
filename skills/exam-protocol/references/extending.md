# Extending the protocol locally

Moved out of `SKILL.md` §10 when a measured addition to §3.2 pushed the file over
its line budget. The budget is enforced by `scripts/check.sh`; `CONTRIBUTING.md`
requires an addition to name what it replaces, and this is what §3.2 replaced.

Your project will need a twelfth dimension or a ninth rehearsal check, and editing
this vendored file to get one destroys the reason you vendored it: you can no
longer tell your change from an upstream one.

- **Numbers 12+ and R9+ are reserved for you.** Upstream never allocates them,
  so a local and an upstream addition cannot collide.
- **Put them in `SKILL.local.md`, beside this file, loaded after it**, naming the
  upstream version it extends. `SKILL.md` then stays byte-identical to upstream
  and `diff` keeps working.
- **A local addition binds like an upstream one**, at the `CONTRIBUTING.md` bar:
  name the incident, what it does not catch, and how you would know it works.
- **Sharpening an existing dimension beats adding one.** If that would have
  caught it, do that and open a pull request — the gap is an upstream bug.

## Why the budget is real

A skill file is loaded into every session that triggers it. Prose that is merely
interesting competes for attention with prose that changes behaviour. When the
gate goes red, the question is not "how do I make room" but **"is the new thing
worth more than the thing it displaces"** — and that comparison only happens
because something forces it.
