# Discrimination: can this check fail at all?

Companion to [`../SKILL.md`](../SKILL.md) §3.4. That section states the rule.
This file is the mechanics.

The single question underneath everything here:

> **Would this measurement give the same answer whether the system were working
> or broken?**

If yes, the measurement is a **covariate**: it is measuring something other than
what you think, and its green tells you nothing. Covariates are worse than
missing checks, because a missing check is visibly missing, while a covariate
issues a confident pass.

---

## 1. Three ways to detect a covariate, in increasing cost

### 1.1 Negative control — strongest, and usually cheapest

**Deliberately break the system, then run the same experiment.** If it still
passes, there is a covariate — and you have proved that without needing to know
what the covariate is.

Worked example. A brief said: change a setting, press the cache-purge button,
confirm the public page changed. Wiring the button to a function that does
nothing and re-running the experiment produced **the same visible change**,
because saving the setting bumped the cache version on its own. The experiment
was measuring "did you save", not "does the button work". This was settled
before any executor touched it.

### 1.2 Count the independent changes — a diff, not a judgment

Between the two observed states, how many things changed independently?

- "the save bumped the version" — change 1
- "the button was pressed" — change 2
- observations: 1

**Two independent changes and one observation makes attribution impossible.
Full stop.** This is countable at design time and needs no system access.

### 1.3 Run every case's setup against a refuse-everything stub

Substitute a component that denies every request, then run the setup phase of
each case. The setups that break were silently depending on a privilege,
resource, or behavior they never declared. Those undeclared dependencies are
where "works on my machine" comes from.

### Honest limit

None of these tells you *what should be rejected*. They tell you only whether
your measurement can tell two worlds apart. **Discrimination is mechanical;
meaning stays yours.**

---

## 2. Mutation testing a guard

A guard, linter, gate, or assertion is a claim: "if this property breaks, I go
red." That claim is unproven until you have watched it happen.

### 2.1 A new guard must go red against real history

> **A guard that finds nothing on its first run against a real corpus has not
> been shown capable of failing.**

Run it against the existing, unedited body of work — not a hand-built fixture.
If it comes back clean on the first run, that is a signal to investigate, not
good news. One guard reported OK on its first run purely because a pattern
failed to match values wrapped in backticks; once fixed, it immediately found
genuine contradictions across four documents.

### 2.2 Going red is an obligation to discharge, not a state to live in

This appears to contradict a well-documented fact: **a guard that is permanently
red gets disabled, and a disabled guard is worse than no guard.** Both are true;
they operate on different timescales.

| | "must go red first" | "must not stay red" |
|---|---|---|
| Concerns | proof of capability | steady state |
| Timescale | the first run | every day after |

Reconciled:

> **Red is a proof obligation, not a condition you leave running.**

1. First run against the real corpus **must** be red.
2. Make it green **the same day** — by fixing what it found, or by recording
   named exceptions with a stated reason and a named decider. **Never by
   loosening the criterion.**
3. If you cannot finish that day, record who owns it and by when. Otherwise the
   guard is on the path to being disabled and you have merely delayed it.

A related trap: **false positives get guards disabled.** Before shipping one,
run it on the real corpus and drive false positives to zero. One guard, written
in a hurry, mistook a display-name column for a secret, and separately swallowed
an entire sentence because its pattern assumed word boundaries the text did not
have. Both would have gotten it switched off within a week.

### 2.3 Two shapes of an invalid mutation

You broke something, the check went red, and you concluded the check works.
Maybe. There are two ways to be wrong.

**Shape A — you broke it into a crash.** The mutation prevented execution from
ever reaching the assertion. Fingerprint: the run reports **zero assertions**,
or an exception unrelated to the property. You measured "does it crash", not
"does the assertion hold."

**Shape B — it stayed green.** The assertions all ran and the result did not
change, because you removed only *one of several reasons* the property holds.
Example: a check required "at least one navigable link to this area exists."
Deleting the link from one component changed nothing — another component still
provided one. The property was never broken, so the check was never tested.

Shape B is the dangerous one. Shape A throws an error and you notice. Shape B
hands you a green light, which reads as "this guard is useless" and invites
someone to delete it.

> **Before mutating, ask: how many independent ways can this property be
> satisfied? Removing one of them proves nothing.**

### 2.4 A valid mutation leaves the system runnable

> **The mutation must leave the system able to run, while the property you
> claim to protect is gone.**

Contrast, from one real pair of attempts at proving an idempotency guard:

| Mutation | Result | What it proved |
|---|---|---|
| Replace an upsert with a plain insert | Constraint violation on the **first** run; `0 assertions` | **Nothing.** Never reached the idempotency comparison. |
| Keep the upsert, make its lookup key unique per run | Failed on the comparison itself, after 9 assertions ran | The guard genuinely protects idempotency. |

### 2.5 Mutation as a design comparison

The same mutation run against two candidate designs is the cheapest design
comparison available. If a test can never go red under design A but does under
design B, design A is not merely untested — it makes that test *incapable* of
failing.

Corollary, learned expensively: **an isolation mechanism must have a scope
exactly equal to the side effect you are suppressing.** A broader mechanism
"for safety" changes the flow under test, and that change looks identical to
correct behavior in the report. In one measured instance, switching a test
harness to a stricter execution mode turned a dozen passing cases red, and every
one of those reds was shaped exactly like a genuine product defect.

> **"Stricter, therefore safer" is false for isolation mechanisms.**

### 2.6 N doors require N mutations

When a single outcome has several independent reasons to occur, a test is
satisfied by whichever reason fires first — so the other doors are untested even
though every one of them was deliberately built.

Measured example: a single-use, signature-verified, allowlist-restricted access
link shipped with a full green suite and an explicit claim that no security
assertion had been relaxed. Removing each door in turn:

| Door removed | Suite result |
|---|---|
| single-use enforcement | 1 red — genuinely protected |
| **signature verification** | **fully green** |
| **allowlist check** | **fully green** |

Two causes, and they are different:

1. **Another door did its job.** The tampering case tampered with the token,
   whose own hash already failed, so the outcome was identical with or without
   signature verification.
2. **The test asserted "rejected", not "rejected by whom".** The account used in
   the allowlist case also lacked the underlying permission, so removing the
   allowlist produced the same rejection code and the same green.

Rules:

- **Every door needs a case in which only that door can reject.** Construct it
  by making all other doors pass.
- **Assert the reason, not just the outcome.** A single status code is the
  shared answer of four different doors.
- **For each door, ask: if I deleted it, would anything go red?** If you cannot
  answer, it is untested — and the next person to see it as dead code will get
  a green light for deleting it.

This generalizes far beyond security: payment preconditions, validation chains,
layered authorization, multi-trigger cache invalidation.

---

## 3. Bypass inventory — the guard is correct, the side road is not

A guard can be correctly implemented, well tested, and completely bypassed,
because **the bypass belongs to a different feature**, and whoever wrote the
tests was thinking about *this* feature.

Observed pairs, all from independent investigations that arrived at the same
shape:

| Main path (correct) | The road around it | Consequence |
|---|---|---|
| Paywalled content is stripped server-side; six access combinations covered by tests | A public syndication feed checks published-and-active but **not access level**, enabled by default, no token | The paid content is one plain request away |
| Same paywall | A content-distribution job forwards every text block to a third party | The tenant exports their own paid content by pressing one button |
| Checkout genuinely validates discount codes (expiry, threshold, prior use) | The **preview** endpoint checks only active-and-unexpired | The quote promises one discount, the invoice charges another — silently |
| Discount selection and final calculation are two separate implementations | The selector ignores the maximum-discount cap | The screen shows one number, the charge is another |
| Cancelling an order restores stock, points, and coupons — with locking and tests | The **refund** branch restores stock only | Points evaporate, coupons stay consumed, the refund is worth less than a cancellation |
| Automated menu deployment removes the previous version | The **manual** deployment path does not | Orphaned artifacts nobody can find or delete |

What they share: the main path had tests. **Not one of the side roads had a
single test.**

Procedure:

1. Identify the gating condition — the field or predicate that decides access.
2. Grep every **reader** of that field or predicate. Then grep every **exit**
   that can emit the same data: endpoints, scheduled jobs, background workers,
   feeds, exports, webhooks, third-party syncs.
   **The exits that are not in the readers list are your bypasses.**
3. For each bypass ask: *why does this one not have to check the condition?*
   No answer means it is a gap.
4. **Two independent implementations of the same calculation** — preview versus
   actual, display versus charge — count as a gap **regardless of whether they
   currently agree.** They will diverge, and on the day they do nobody will
   notice. The fix is one shared decision function called from both.

Criterion: a gate is only as strong as its weakest exit. If a second path can
emit the same data or the same number, you must be able to point at where *that*
path asks the same question. "It is probably fine" is not a location.
