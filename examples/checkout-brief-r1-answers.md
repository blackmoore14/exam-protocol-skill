# Answers: checkout release brief — revision 1

> **Fictional.** Worked example, paired with `checkout-brief-r1-exam.md`. The
> artifact under exam — a checkout release brief — does not exist, no system was
> ever queried, and **every measurement reported below is staged**. Evidence
> labels are therefore written `[API — ILLUSTRATIVE]` and so on: a fabricated
> measurement must not wear a real measurement's badge, which is this
> repository's own §3.4 failure if it happens here.
>
> The *shapes* are real. Each question below has drawn blood on a real brief,
> and the reasoning is what a second fresh reviewer would actually write.
>
> Answered by a second fresh reviewer who received only the sealed exam — not
> the exam author's reasoning and not the brief author's.

| Field | Value |
|---|---|
| Exam file | `examples/checkout-brief-r1-exam.md` |
| Exam SHA-256 | `8fd974c55e75756c83b126c75f7479b9b7d05029da6ad976c2e555eaa1035596` |
| Artifact SHA-256 | not recorded — the artifact is fictional |
| Answerer | Fresh reviewer C |
| Answered | 2026-08-18 |

## Result

| Status | Count |
|---|---|
| `FAIL` | 11 |
| `PASS` | 1 |
| `UNRESOLVED` | 2 |
| Withdrawn | 1 |
| **Total graded items** | 15 |

Fourteen sealed questions produce fifteen graded items, because `Q-11-01` was
split: clause (a) is answerable and red, clause (b) is out of scope and
withdrawn. Splitting at withdrawal time rather than deferring it to revision 2
is what keeps the arithmetic honest — a defect parked outside the count is
dimension 8's own failure, and the count is the number people quote.

**Eleven reds out of thirteen discriminating questions.** By §3.3 a rate that
high is a claim about the exam as much as about the artifact, so: the reds here
are overwhelmingly **mechanical** — a record that cannot be saved, a sign-in
page with no password-free path, a section containing only rejection cases, a
stop rule that cancels three sections. Those do not turn on a reading of intent.
The hypothesis is that the brief is genuinely not executable, not that the exam
was mis-aimed.

---

## Answers

### Q-1-01 — `FAIL`

**Finding:** Staging admin offers only email-and-password sign-in. No
single sign-on, no one-time link, no pre-established session. Every section from
§2 onward requires an authenticated admin session, and an automated tester is
prohibited from typing a password. **No one currently assigned to this cycle can
execute §2 onward.**

**Evidence:** Read the full sign-in page markup; the only form fields are email
and password, and the only other control is a password-reset link. Route listing
shows no alternate authentication endpoint.

**Verified by:** `[API — ILLUSTRATIVE]`

**Suggested fix:** Either mint a one-time signed sign-in link per cycle before
the brief is handed over, or have a human perform sign-in and hand over a live
session. Do not schedule the sections until one of those exists.

---

### Q-1-02 — `FAIL`

**Finding:** The Discounts entry is not in the main navigation for the test
account's role. It is reachable only from Settings → Commerce. A tester
following "open Discounts in the admin menu" would conclude the feature is
missing.

**Evidence:** Enumerated registered admin pages and their navigation
registration; this one is registered with navigation suppressed. Access check
requires an elevated role that the standard test account does hold.

**Verified by:** `[API — ILLUSTRATIVE]`

**Suggested fix:** Replace the instruction with the exact path, including the
Settings hub hop.

---

### Q-2-01 — `FAIL`

**Finding:** Saving a product bumps the storefront cache version by itself. The
storefront therefore shows the new price **whether or not the Refresh cache
button does anything**. §4 as written measures the save, not the button.

**Evidence:** Negative control — replaced the button's handler with a no-op and
re-ran the sequence. The storefront still showed the new price. Two independent
changes (save bumps the version; button pressed) with a single observation makes
attribution impossible.

**Verified by:** `[API — ILLUSTRATIVE]`

**Suggested fix:** Add an arm that changes the price and does **not** press the
button. The difference between the two arms is the only thing that measures the
button.

---

### Q-2-02 — `FAIL`

**Finding:** §6 contains only rejection cases. A discount engine that rejected
every code, valid or not, would pass §6 completely.

**Evidence:** Read §6; three cases, all "should be rejected" (expired, below
threshold, already used). No case applies a valid code.

**Verified by:** `[CODE — ILLUSTRATIVE]` — document reading only; no system access needed.

**Suggested fix:** Add one control applying a currently valid code and asserting
the discounted total.

---

### Q-3-01 — `FAIL`

**Finding:** Product `#70` has an empty required stock-keeping identifier. It
opens in the admin UI and **cannot be saved** — submitting returns the form with
a field-level error. The control arm of §2 cannot be performed on this record.

**Evidence:** Field is null in storage; the admin form declares it required.
Note the limit below.

**Verified by:** `[DB — ILLUSTRATIVE]` + `[CODE — ILLUSTRATIVE]`

**Suggested fix:** Populate the field, or name a different control record. Then
re-check under R3 that the replacement is visible **within the tester's account
scope**.

**Limit on this answer:** I could not attempt the save myself — that is an
authenticated write action. Present in storage plus declared-required is strong,
but the definitive check is the tester's §0-R rehearsal.

---

### Q-3-02 — `PASS`

**Finding:** Published content pages do have a reachable public route for a
signed-out visitor. Three sampled pages returned content, not a redirect and not
a not-found.

**Evidence:** Three unauthenticated requests to published page addresses, each
returning the rendered page including its title element.

**Verified by:** `[API — ILLUSTRATIVE]`

**Limit:** This confirms the route resolves. It does not confirm the indexing
directive §5 actually asks about is populated — the exam did not ask that, and
it is a gap worth adding in revision 2.

---

### Q-4-01 — `FAIL`

**Finding:** The expectation is bound to notification **content** ("Order
confirmed"). Notification text on this account varies with order state, and
other activity between now and the run can change which notifications are at the
top.

**Evidence:** Read §4; the expectation quotes literal text and a literal count
of two.

**Verified by:** `[CODE — ILLUSTRATIVE]`

**Suggested fix:** Rewrite as structure, not content: "you should see at least
two notifications, each with a title and a timestamp; report the titles you
see." Bind expectations to shape, never to data.

---

### Q-5-01 — `FAIL`

**Finding:** §4 is genuinely concurrency-unsafe: both testers are sent to edit
product `#70` and will overwrite each other's values. The brief does contain a
per-tester assignment table in its appendix — but the body never references it,
so as written the brief is unsafe to hand to two people.

**Evidence:** Appendix B assigns tester A and tester B different product ranges.
§4 hardcodes `#70` and never mentions Appendix B.

**Verified by:** `[CODE — ILLUSTRATIVE]`

**Suggested fix:** One sentence — have §4 reference the assignment table instead
of naming a record, and state at the top of the brief which lane the reader is
in. The mechanism already exists; the document does not use it, and a document
that does not use its own mechanism is a document that does not hold.

---

### Q-6-01 — `UNRESOLVED`

**Finding:** I cannot determine which tooling each tester has. The brief names a
specific developer-tools feature and offers no alternative.

**Evidence:** §7 names the feature; no equivalent path appears anywhere in the
document.

**Verified by:** `[CODE — ILLUSTRATIVE]`

**Who is blocked, on what:** The brief author, on a question only the testers can
answer. Ask both testers before the cycle starts, and write down an equivalent
approach (intercepting the request in the console achieves the same thing) so
that the answer stops mattering.

---

### Q-7-01 — `FAIL`

**Finding:** "If the control fails, stop here" sits at the end of §4 and cancels
§5, §6, and §7 — three sections, none of which depends on §4's outcome. The
control most likely to fail is the one in Q-2-01, which is itself mis-designed;
a wrong control would therefore cancel three unrelated sections.

**Evidence:** Section ordering in the brief; no dependency between §4 and §5–§7
is stated or implied.

**Verified by:** `[CODE — ILLUSTRATIVE]`

**Suggested fix:** Narrow it to "stop **this section**", and add "continue to
§5". Every defensive instruction needs its blast radius measured once.

---

### Q-9-01 — `UNRESOLVED`

**Finding:** `staging-accounts.md` does contain a password value for the
standard test account, and the brief contains a different one. **At least one of
them is wrong, and I cannot determine which** — verifying would require
attempting a sign-in, which I am not permitted to do.

**Evidence:** Both files list the same account identifier with different secret
values. Neither value is reproduced here, deliberately.

**Verified by:** `[CODE — ILLUSTRATIVE]`

**Who is blocked, on what:** Whoever owns the staging environment. Regardless of
which one is correct, the contradiction is itself the defect: a reader will copy
whichever they open first. Delete the stale value rather than annotating it, and
consider a check that fails when one account appears with two different secrets
across the documentation set.

---

### Q-9-02 — `FAIL`

**Finding:** The carried-forward claim that the per-item quantity limit "has no
admin screen" is **false as of today**. The screen exists and is registered. The
previous cycle's conclusion was either wrong when written or has since been
overtaken.

**Evidence:** The settings page is registered and reachable; the field is
present on the form definition.

**Verified by:** `[API — ILLUSTRATIVE]`

**Suggested fix:** Remove the claim. Then apply the general rule: a previous
cycle's conclusion is an observation made then, and must be re-verified at
`[API]` strength or better before being restated as a premise.

---

### Q-10-01 — `FAIL`

**Finding:** The control is achievable, but only with a step the brief omits.
Campaign attribution uses a 30-day stored touch, so a browser that visited a
tagged link within the last month will attribute the order **by design**.

**Evidence:** The attribution window is configured at 30 days; the stored touch
survives across sessions.

**Verified by:** `[API — ILLUSTRATIVE]`

**Suggested fix:** Add "use a fresh private window with no prior browsing" as an
explicit step in §8.

The system *can* produce the expected answer, but only under a precondition the
brief omits — and as written, a tester on an ordinary browser will file correct
behavior as a major defect. That is the most expensive shape of wrong control
there is, and grading it green would seal it into the contract. "The mechanism
exists" belongs in this line, never in the status.

---

### Q-11-01a — `FAIL`

**Finding:** The provider configured for this account is **not** the one §6
assumes. §6's payment steps would exercise a path the release does not use, so
the section measures nothing about the release.

**Evidence:** Read the provider code for the account, not the display label.
"Credit Card" is the label of a different integration.

**Verified by:** `[API — ILLUSTRATIVE]`

**Suggested fix:** Name the provider explicitly in §6, and re-check it each
cycle — R8. Different services from the same vendor are configured separately;
invoicing being live does not mean checkout is.

---

### Q-11-01b — Withdrawn

Out of scope for a document-scoped exam. See the withdrawal table.

---

## Questions I believe are themselves wrong

| ID | Why the question is wrong | What it should have asked |
|---|---|---|
| Q-11-01 | It bundles two questions with different evidence requirements into one, so it cannot receive a single status. Its own footnote admits this by counting it as half. | Split it, which the arbiter did: **(a)** which provider is configured for this account, read from the provider code — answerable, and red; **(b)** is the provider selectable from configuration — an architecture-invariant question that belongs in a source-scoped exam, not this one. |

## Withdrawals

*Filled in by the arbiter at step 6, after this answer sheet was complete.
Everything above this heading is the answerer's.*

| ID | Reason | Who decided |
|---|---|---|
| Q-11-01b | Architecture-invariant clause, out of scope for a document-scoped exam. Original text of Q-11-01 preserved in the exam file. **Split rather than deferred**, so that clause (a)'s red is counted rather than parked outside the arithmetic — re-issued in full in revision 2. | Arbiter |

---

## Arbiter note

Eleven reds, one green, two unresolved, and one withdrawn clause. Three of the
reds (Q-1-01, Q-3-01, Q-11-01a) block execution outright: nobody assigned to
this cycle can sign in, the named control record cannot be saved, and §6 would
have exercised a payment path this release does not use. Revision 2 is required
before this brief goes anywhere.

**On the count.** An earlier draft of this sheet reported six reds, by grading
Q-5-01 and Q-10-01 as passes whose own findings said the brief did not hold
("counted as pass because the mechanism exists"), and by leaving Q-11-01's red
inside a withdrawal footnote. Both are the same mistake: an expectation generous
enough that a defective artifact satisfies it. There are three statuses, the
nuance goes in the **Suggested fix** line, and the number is the thing people
quote.

Do not read the one pass as "the rest is fine." This exam graded a document. It
did not grade checkout.
