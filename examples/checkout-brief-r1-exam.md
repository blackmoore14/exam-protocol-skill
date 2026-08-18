# Exam: checkout release brief — revision 1

> Worked example. The artifact under exam is a fictional but representative
> execution brief: a two-page document telling a human tester how to verify a
> checkout release on a staging environment. Every question shape here has drawn
> blood on a real brief.

| Field | Value |
|---|---|
| Artifact under exam | `docs/testing/checkout-release-brief.md` |
| Artifact SHA-256 | not recorded — the artifact is fictional and has no bytes |
| Decision this unblocks | Handing the brief to two testers and starting the cycle |
| Author | Fresh reviewer B (read-only, did not write the brief) |
| Author independence | independent |
| Authored | 2026-08-18 |
| Status | `AUTHORED_NOT_RUN` |
| Question count | 14 |
| Of which discriminating | 13 — see the note at the bottom |

## does_not_grade

This exam does **not** evaluate:

- **The application source.** Only the brief is in scope. If checkout is broken
  in a way the brief does not mention, this exam will not find it.
- **Whether the tests the brief refers to are themselves honest.** Assertion
  quality is a separate review.
- **Anything requiring an authenticated write action.** The author is read-only,
  so every question about "can this be saved" is asked *of the brief's author*
  rather than answered here.
- **Commercial correctness** — whether the discount rules being tested are the
  rules the business wants.

Green here is necessary, not sufficient.

## Documents in scope

| Document | Why the tester would open it | Checked for contradictions? |
|---|---|---|
| `docs/testing/checkout-release-brief.md` | It is the instruction | yes |
| `docs/testing/staging-accounts.md` | The brief says "sign in as the standard test account" without giving credentials | yes — see Q-9-01 |
| `docs/testing/previous-cycle-report.md` | The brief cites it twice as background | yes — see Q-9-02 |

## Dimension coverage

| # | Dimension | Questions | If none, why |
|---|---|---|---|
| 1 | Executability | 2 | |
| 2 | Covariates / false findings | 2 | |
| 3 | Operability of named fixtures | 2 | |
| 4 | Stability of expected values | 1 | |
| 5 | Concurrency | 1 | |
| 6 | Assumed tooling | 1 | |
| 7 | Blast radius of stop rules | 1 | |
| 8 | Withdrawn items | 0 | Nothing was removed from scope between revisions; this is revision 1 |
| 9 | Documents outside this one | 2 | |
| 10 | Can the system satisfy the control? | 1 | |
| 11 | Architecture invariants | 1 | |

---

## Questions

### Q-1-01

**Question:** §1 instructs the tester to "sign in to the admin area." Does the
staging admin area offer any sign-in method that does not require typing a
password — a one-time signed link, a pre-established session, single sign-on?
If not, name the person who will perform that step.

**Why it might fail:** Automated testers are commonly prohibited from entering
passwords. If that is the only route in, every section after §1 is impossible
for them, and previous cycles may only have appeared to work because a session
had not yet expired.

**Discriminates:** Yes. If a password-free path exists, this is answered with a
location; if not, it is red regardless of anything else in the brief.

---

### Q-1-02

**Question:** §3 says "open Discounts in the admin menu." Is that entry actually
present in the main navigation for the role the test account holds, or is it
reachable only from a settings hub?

**Why it might fail:** Admin entry points that are excluded from the main
navigation are common, and "find it in the menu" then fails silently — the
tester concludes the feature does not exist.

**Discriminates:** Yes.

---

### Q-2-01

**Question:** §4 has the tester change a product price, press **Refresh cache**,
then confirm the storefront shows the new price. Does saving the product
invalidate that cache on its own? If it does, what is this step measuring?

**Why it might fail:** If the save already busts the cache, the storefront
updates whether the button works or not. The step would then confirm the feature
"works" in every possible world, including the one where the button is wired to
nothing.

**Discriminates:** Yes — and it is checkable at design time, before any tester
is involved, by wiring the button to a no-op and re-running the experiment.

---

### Q-2-02

**Question:** §6 asks the tester to confirm that an invalid discount code is
"rejected at checkout." Is there any control case in which a **valid** code is
accepted? Without one, does a system that rejects every code pass §6?

**Why it might fail:** A rejection-only test is satisfied by a totally broken
discount engine.

**Discriminates:** Yes.

---

### Q-3-01

**Question:** §2 names product record `#70` as the control item. Can that record
be **opened and saved** in the admin UI right now — not merely viewed? Are all
of its required fields populated?

**Why it might fail:** A record with a blank required field opens fine and
refuses to save. The tester loses the entire control arm and is likely to
misdiagnose it as a caching or permissions problem.

**Discriminates:** Yes.

---

### Q-3-02

**Question:** §5 tells the tester to pick any published content page and check
its indexing directives. Do the pages that exist have a reachable public route,
for a signed-out visitor?

**Why it might fail:** Content can exist while its public route returns
not-found, in which case the whole section is unverifiable and the tester
discovers this only after wasting time on it.

**Discriminates:** Yes.

---

### Q-4-01

**Question:** §4 states the tester "should see two notifications reading
*Order confirmed*." Is that expectation bound to record **content** that other
activity can change between now and the test run?

**Why it might fail:** Expectations bound to content rather than structure go
stale. A tester who sees different text concludes the control failed and skips
everything downstream. The safe form is "you should see N notifications, each
with a title and a timestamp."

**Discriminates:** Yes.

---

### Q-5-01

**Question:** The brief will be given to two testers at once. §4 has both of
them edit the price of product `#70`. Which steps overwrite each other, and
should each tester be assigned a different product?

**Why it might fail:** Concurrent editing of the same record produces values
that appear to change by themselves — including a value spontaneously becoming
the number required by the next step, which reads as a product defect.

**Discriminates:** Yes.

---

### Q-6-01

**Question:** §7 requires blocking a specific network request using browser
developer tools. Does every tester's tooling support that? Is an equivalent
approach written down for the ones that do not?

**Why it might fail:** A tester without the capability either improvises
something not equivalent, or stops. Both outcomes are invisible in the report.

**Discriminates:** Yes.

---

### Q-7-01

**Question:** §4 ends with "if the control fails, stop here and report." How
many subsequent items does that cancel? Is a narrower stop condition available?

**Why it might fail:** Broad stop rules cascade. One control failure — including
a control that was wrong to begin with — can cancel several unrelated sections,
and nobody measures that when the instruction is written.

**Discriminates:** Yes.

---

### Q-9-01

**Question:** `staging-accounts.md` lists a password for the standard test
account. Does it match the one intended for this cycle? If the file's value is
stale, does the brief's precedence statement ("the environment section of this
document is authoritative") actually prevent a tester from copying it?

**Why it might fail:** Readers do not finish a disclaimer before consulting
another file. Declaring precedence has been shown not to work; the wrong value
must stop existing.

**Discriminates:** Yes.

---

### Q-9-02

**Question:** The brief carries forward a conclusion from
`previous-cycle-report.md` — that a per-item quantity limit "has no admin
screen." Was that re-verified this cycle, and at what evidence strength?

**Why it might fail:** A previous cycle's conclusion is an observation made
then, not a fact now. Inheriting one unchecked has already cost an entire
section that was written on a false premise.

**Discriminates:** Yes.

---

### Q-10-01

**Question:** §8 states that ordering through a clean URL "must not record any
campaign attribution." Is there an attribution window — a cookie or stored touch
— under which the system records attribution here **by design**? What must the
tester do first for the expectation to hold?

**Why it might fail:** If attribution has a multi-week window and the tester's
browser visited a tagged link recently, the system will attribute the order
exactly as designed. The tester then files correct behavior as a defect, which
costs as much as a missed one and is harder to unwind.

**Discriminates:** Yes.

---

### Q-11-01

**Question:** §6 refers to "the payment provider" without naming it. Which
provider is configured for this account — read from the provider code, not the
display label? Is the provider selectable from configuration, or fixed in
source?

**Why it might fail:** A display label of "Credit Card" says nothing about who
is behind it, and a brief that assumes one provider while another is configured
means the intended path is never exercised at all. Separately, a provider fixed
in source violates the "can this value be changed without editing code"
invariant.

**Discriminates:** Partially. It reliably determines *which* provider is
configured, but "is it selectable from configuration" needs a source reading the
author is not permitted to conclude from.

---

## Note on the discriminating count

Quote **13**, not 14. `Q-11-01` is counted as half a question: its first clause
discriminates, its second clause depends on a source inspection this exam's
scope excludes. Treat that second clause as a prompt for the arbiter rather than
a graded item.

Non-discriminating question IDs: none fully; `Q-11-01` partial as described.
