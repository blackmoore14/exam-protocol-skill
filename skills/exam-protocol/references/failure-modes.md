# Failure modes: exams that passed while the work was broken

Companion to [`../SKILL.md`](../SKILL.md). Every rule, dimension, and rehearsal
check in the protocol exists because of something in this file. Nothing here is
hypothetical; all of it is anonymized from real review cycles.

Read this when you want to know **why an exam misses things**, which is a more
useful question than *what* it missed.

**Every figure in this file is `[PRIOR]`.** The incidents are real and the
counts were real when recorded, but they come from a private repository and the
anonymization rules in `CONTRIBUTING.md` forbid the paths that would let you
audit one. Treat the numbers as unverified and the *mechanisms* as the content —
the mechanisms are reproducible on your own code, which is the whole point of
keeping them.

---

## 1. The first measurement: what self-review does not catch

An author reviewed two of their own artifacts — an execution brief and a status
ledger — and considered both correct at the moment of writing. A fresh reviewer
was then asked to write an exam over each.

| Artifact | Questions | Red |
|---|---|---|
| Brief: is it executable? | 20 | **16** |
| Ledger: are its claims real? | 16 | **14** |

Thirty of thirty-six. Included:

- A guard the ledger stated was wired into continuous integration, which **no
  pipeline had ever invoked**. Note the doubling: not only was the guard not
  running, the documentation asserted that it was.
- A cell marked verified whose cited evidence **did not exist** in the record it
  pointed at.
- A defect report that had been **withdrawn**, where the withdrawal reasoning
  did not survive contact with the code.

None of these is subtle in hindsight. All of them were invisible to the author,
because the author was reading their own intent rather than the text.

---

## 2. Why a passing exam still failed the executors

One brief cleared four exam revisions — final round twenty questions, zero red.
Two executors then ran it and got stuck or diverged in **six** places.

| # | What was wrong | Cost | Why the exam missed it |
|---|---|---|---|
| 1 | A record named as the control could not be saved in the admin UI (a required field was blank) | One executor lost the entire control arm; the other misdiagnosed it as a caching problem | The exam verified that the address responded and the value was correct. It never asked **"can it be saved today?"** → dimension 3 |
| 2 | The public route for the chosen content type returned not-found | Both executors blocked on the same section | The exam asked whether data existed to choose from. It never asked whether **the public route reached it** → dimension 3 |
| 3 | An expected value was written as specific record *content* | Executor saw different content, judged the control failed, and skipped two dependent sections | The exam had no dimension for **expectations bound to mutable content** → dimension 4 |
| 4 | Two executors ran the same brief simultaneously | Values overwrote each other; one executor repeatedly observed a value spontaneously becoming the number required by the next step | The exam **imagined a single reader** → dimension 5 |
| 5 | A step required a specific developer-tools capability | One executor's tooling lacked it; they improvised an equivalent — by luck | The exam never asked **whether the executor has that tool** → dimension 6 |
| 6 | "If the control fails, stop here" | Directly caused #3's cascade: two sections never ran | **This instruction was added on a previous exam's recommendation, and nobody measured its blast radius** → dimension 7 |

### The structural reason

> **The author and the answerer are restricted to reading. The executor has to
> write.**

"Can this record be saved?" and "is this authenticated route reachable?" are
**structurally unanswerable** under a read-only constraint — so they are also
never asked. The exam verifies that the document is literally correct; the
executor has to perform the operation.

The second reason: **the dimensions were improvised.** Before the checklist
existed, coverage equaled the author's imagination on the day — the same disease
as "the QA suite passed, therefore we are fine", one level up.

---

## 3. Controls: the most expensive kind of wrong question

Three separate cycles, all the same error, all in the **control** arm:

| Control written | Why it could never hold |
|---|---|
| "Open this record; that section should be absent" | The record belonged to a different account than the executor's — a genuine not-found |
| "Configure a per-day limit for this item" | That account's business type had the relevant module disabled — **the settings screen structurally does not exist there** |
| "Order via a clean URL; no attribution should be recorded" | Attribution has a multi-week window and the same browser had visited a tagged link the previous day — **by design, attribution appears** |

Common shape:

> Verified that **the thing exists**. Did not verify that **in the executor's
> situation, the system would produce the expected answer.**

The third is the one to remember: data present, account correct, route
reachable — and the *expectation itself* contradicted the design. The executor
followed instructions and filed it as a major defect. **The product was right.**

> **A wrong control converts correct behavior into a defect report.** Opposite
> direction from a false pass, equally expensive.

Three questions before writing any "X must not appear" control (dimension 10):

1. Does this record or situation exist **within the executor's account and
   permissions**?
2. Is there **any mechanism** by which X appears here **by design** — carried
   state, cache, a time window, a default?
3. What must the executor do first for the expectation to hold — clear cookies,
   use a private window, switch accounts? **If anything, put it in the steps.**
   Never assume a clean environment.

---

## 4. Rehearsing and still shipping six blockers

A later cycle **did** rehearse. Six blockers still landed. Every one has the
same shape: *I verified that it opens; the executor had to make it work.*

| Blocker | Why the rehearsal missed it |
|---|---|
| Notification badge showed a count, the panel rendered nothing | The rehearsal used **unauthenticated** probes only → R1 |
| A page's robots metadata was null | The rehearsal never ran **change a record, then look at the public page** → R2 |
| Checkout stalled inside a third-party component embedded in the payment step | **External dependency not flagged**; the executor walked into it → R5 |
| Seven expected navigation tiles were not where the brief said | The location was **assumed**, never confirmed → R1 |
| A content type had "no generation entry point" | The rehearsal confirmed the page redirected — proving it exists — but never checked **whether that content type appears on it once authenticated** → R1 |
| One executor could not run their section: only one qualifying record existed and the other executor had it | Fixtures were **assigned without counting them first** → R3 |

> **A redirect is not a working feature.** This single line is why R1 exists.

### R3 has been violated in three distinct ways

1. **Wrong scope.** A control record was selected, confirmed by query, and even
   run through the live decision function — but it belonged to a different
   account than the executor's, and the executor's account had exactly one
   qualifying record, which had the opposite property. **The control was
   structurally impossible.** Count *within the executor's scope*; disabling
   global scopes to count filters out the only condition that matters.
2. **Wrong read path.** A batch of notification records was created and verified
   by direct datastore query. Both executors saw **two**, because the framework
   stores a short alias in the polymorphic type column while the fixture wrote a
   fully-qualified class name, so the relationship query never saw the rest.
   **Read it back the way the application reads it.**
   And when sampling an existing row to copy its shape, make sure the sample is
   **not one you just created** — otherwise you are checking your work against
   itself.
3. **Insufficient quantity.** Fixtures split between two executors when only one
   existed. Either create more, or state plainly that only one party can run
   that section.

### R6: read the output, not the source

A navigation tile list was produced by a lookup table plus one resolver
function. The author read that source repeatedly, comparing every destination
and scope by eye, and **still did not notice that the largest tile pointed at
the full desktop menu** — because it was declared in a different block from the
list, far enough away that the eye reads it as a heading.

An eight-line script that called the function and printed *what the executor
would actually see*, with destinations resolved, exposed it instantly — and as a
bonus confirmed a fallback behaved correctly.

> **If what the user sees is computed by a function, run the function. Do not
> read it.** The cost is near zero and reading misses things.

### R6's counting corollary: the one that changed a security conclusion

The same rule applies to counting, and there it has cost more than a number.

An inventory of a tool registry was compiled with `grep -c` over the source. But
`grep -c` counts **how many times a string appears**, not **how many items have
a property**: comments, docblocks, type declarations and examples are all
counted. Four of the resulting figures were wrong.

Three were merely wrong. The fourth reported a sensitive-field-masking setting as
present on nearly every item in the registry. Enumerating the registry through
its own interface showed it populated on **two**. The written conclusion had been
"masking is essentially universal here"; the true one was the opposite, and the
difference is a security posture, not a statistic.

The wrong numbers had already been copied into three documents and used as a
baseline before anyone re-counted.

> **If an interface can enumerate it, do not count it with `grep`.**

Worse, the arithmetic was checkable without any tooling: the component counts
sat in the adjacent column of the author's own table and summed to the correct
figure. Nobody added them up. Reading source tells you what you think it
contains; running it tells you what it contains.

---

## 5. Three gates, and the executor still got stuck at the login form

An executor was blocked repeatedly during sign-in because they copied an expired
password from a **credential table that was not the brief**. Three separate
quality gates existed. None caught it.

| Gate | Why it could not see it | Fixable? |
|---|---|---|
| Rehearsal (R1: walk it authenticated) | The author is prohibited from entering passwords, so the credential table is **structurally outside rehearsal scope** | **No.** A capability boundary. |
| Automated test-quality scanner | It scans **test files** for weak-assertion fingerprints. Documents are not in scope | Yes — by writing a different scanner, not extending that one |
| The exam | Author and answerer both targeted **the brief**. The credential table was not the target | Yes → dimension 9 |

> **All three gates looked only at what we assumed the executor would use.
> Not one asked what the executor would actually open.**

The brief did contain the sentence "the environment section of this document is
authoritative." It did not help. Readers do not finish the disclaimer before
consulting another file.

> **Declaring precedence does not work. Make the wrong value stop existing.**

Fixes adopted:

1. A guard asserting that **one account never appears with two different
   passwords across the documentation set**. It deliberately does **not** verify
   whether a password is correct — only that the documents do not contradict
   each other.
2. A writing rule: **when stating that a value is wrong, do not write it in a
   copy-pasteable form.** Redact it, keep the conclusion.
3. Dimension 9.

That guard, incidentally, shipped with three of its own defects — it mistook a
display-name column for a secret, had a control-flow error, and over-consumed
text whose word boundaries its pattern did not anticipate. Each would have
produced false positives, and **false positives get guards switched off, which
is worse than having none.**

---

## 6. What none of the gates were even pointed at

A model identifier costing several times the cheaper alternative was hardcoded
in four places, one of them on a path exercised in every review cycle. Three
gates; none could see it.

| Gate | Scope | Why blind |
|---|---|---|
| The exam | briefs and ledgers — **documents** | Product source was never in scope |
| Test-quality scanner | assertion shapes in **test files** | Application source not scanned |
| Existing guards | each one specific thing | **None watched architecture invariants** |

> **Every gate we had grew in response to a specific past incident, and each
> covers only the shape of its own incident.** None asked: *does this code
> violate an invariant we ourselves wrote down?*

Adopted: dimension 11, plus a general rule worth more than the dimension —

> **Whenever you write down a new invariant, immediately ask which existing gate
> would catch a violation of it. If the answer is none, the invariant does not
> exist.**

---

## 7. Why the plan is never fully correct

Nine documented errors across four cycles. Grouped by **how the author verified
the claim**, not by subject:

| Error | How it was verified |
|---|---|
| Named record could not be saved | checked that it existed |
| Public route returned not-found | checked that data existed to choose from |
| Checkout page showed no payment methods | **counted rows directly** — while the interface reads a different relation |
| Account lacked the module → forbidden | precondition never checked |
| Location was outside business hours | precondition never checked |
| "There is no admin screen for this" | **copied the previous cycle's conclusion** — which was wrong |
| Vendor account identifier mismatched | inferred, choosing the convenient interpretation |
| "That table has zero rows" | **queried the wrong table** — the model is backed by another |
| "The field is now visible on the page" | **server-side test only**; nobody looked at the screen |

Single shape:

> **Each time, verification happened somewhere earlier and cheaper than where
> the user lives, and the result was then written down as a fact about the
> user's experience.**

```
present in storage ≠ interface returns it ≠ rendered ≠ user can find it ≠ user can finish it
```

**"Try harder at rehearsing" does not fix this**, and it is important to
understand why: the checks that would have caught it require authenticated write
actions the author is forbidden to perform. The deepest reachable layer is "the
interface responds." Every one of the nine errors lives below that line. That is
not carelessness; it is the shape of a capability boundary.

Hence the three countermeasures in `SKILL.md`: evidence-strength labels (§7), the
`§0-R` rehearsal handoff (§8.2), and the ban on inheriting a previous cycle's
conclusion as a premise (`[PRIOR]` is treated as unverified).

Honest limits of those three:

- Labels and the handoff **do not catch "I checked, but I checked the wrong
  thing"** — the wrong-table error passes both. Only the executor's rehearsal
  report catches that, which makes §0-R the real safety net; the labels only
  tell the reader what to distrust.
- **Nothing makes a plan correct.** The honest goal is that an error surfaces in
  five minutes rather than after a section has been wasted.

---

## 8. The same batch of work, blocked three cycles running, for three different reasons

| Cycle | Stated reason | What was done |
|---|---|---|
| 1 | The location was outside business hours | Fixed the hours |
| 2 | Believed no admin screen existed | Added the settings entry point |
| 3 | The browser session had no authenticated state at all | Nearly fixed "just this once" again |

Because the proximate cause differed each time, **each looked like a fresh
accident.**

The actual root cause:

> **The executor's safety policy lists "enter a password to sign in" as
> non-negotiable — and it is the same policy that binds the author.**

So "the coordinator will log in for them" does not exist as an option. And the
system in question offered only email-and-password sign-in: no single sign-on,
no magic link (an executor verified this by reading the entire login page).

> **Any item requiring prior sign-in was, on that system, impossible for
> anyone.** The earlier cycles only appeared to work because a session happened
> not to have expired. That is luck, not capability, and it ran out.

Two rules, both in `SKILL.md` §8:

1. **Capability first, plan second.** If an item needs authentication, confirm a
   password-free path exists — a one-time signed link, a pre-established
   session, a human doing that step. Without one, do not schedule the section.
2. **The first item of the rehearsal handoff is always "are you signed in right
   now?"** so it surfaces in minute one rather than section four.

Honest limits:

- This does not stop **"the capability was built and nobody used it."** Somebody
  must actually mint a link each cycle. Nothing guards that; §0-R only reveals
  it *afterwards*.
- **A cycle that happens to go smoothly makes this gap look closed.** It is
  not. Do not cross it off on the strength of one good run.

---

## 9. The two-cycle rule

A related pattern that exams do not catch, because each individual instance is
legitimate:

> **If the same item is marked "not tested / blocked" for two consecutive
> cycles with the same reason, that reason is no longer an exclusion. It is the
> first work item of this cycle.**

Observed: a feature area was excluded for three consecutive cycles with an
identical, entirely true reason — a piece of setup data the coordinator needed
to create. Being true each time, it passed review each time. In between, other
work shipped. The stakeholder discovered the gap personally.

A true reason repeated twice means nobody is solving it. Record, per excluded
item, **who the blocker is on** and **how many cycles it has been excluded.**
