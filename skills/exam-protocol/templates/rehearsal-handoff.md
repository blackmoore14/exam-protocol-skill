# Rehearsal handoff — `§0-R`

The block below is required by [`../SKILL.md`](../SKILL.md) §8.2 as the **first
section of every downstream artifact**. It is a form, not a rule: `SKILL.md`
says why it must be there, this file is what you paste.

It exists because an author who cannot enter a password cannot verify anything
below "the interface responds", and the two layers underneath — *can the user
find it*, *can the user finish it* — are where the errors accumulate. The block
hands exactly those checks to the one person who can perform them.

Paste it verbatim, at the top, above the first task:

```markdown
## §0-R Before testing, spend five minutes rehearsing for me

This section is not testing. It is a precondition check. Report and stop.

- [ ] Are you currently signed in? (If not, say so now — several sections
      below assume an authenticated session.)
- [ ] Every page named below: does it open? Which menu is it under?
- [ ] Every record named below: does it open? **Does it save?**
- [ ] Every "you will see X": do you actually see X?

If any item fails, report it and do not proceed. That section gets fixed this
cycle rather than being forced through.
```

Add one line per external dependency the executor will meet — a third-party
component, a payment page, a consent screen — naming it and saying "if you get
stuck here, stop and report the position." That is R5, and without it the
executor burns a session on something you could not have fixed anyway.

## Honest limit

The cost is five minutes of the executor's time, and the cost of skipping it —
measured repeatedly — is an entire section wasted plus a full round trip.

But this block only reveals a missing capability *afterwards*. If a section
needs an authenticated session and no password-free path exists, `§0-R` tells
you on the day of the run, not on the day of writing. Preventing that is §8.1's
job, and nothing automated enforces it: somebody has to mint the link each
cycle. A cycle that happens to go smoothly makes this gap look closed. It is
not.
