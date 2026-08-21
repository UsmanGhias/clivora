# Speaker notes — CLIVORA Quantic MSSE Capstone

**Target runtime:** 18 minutes of speaking inside a 15–20 minute recording.
**Deck:** `CLIVORA-MSSE-Capstone.pptx` (40 slides, 16:9). The same script is embedded in
the notes pane of every slide, so present in PowerPoint's Presenter View and you will
never need this file on screen.

Present from the **PDF** if you are on a machine without the Inter font family. Install
`fonts/*.ttf` first if you want the PPTX to look identical to the PDF.

---

## Non-negotiables

| Rule | Why |
|---|---|
| Show photo ID on camera in the first minute, held still for five seconds | Handbook requirement. Missing it can void the submission. |
| Say the word **baseline** whenever you show a pre-Capstone feature | Protects you from being accused of claiming the whole product as three sprints. |
| Never say Stripe, escrow or payments are live | They are not. Say "payment is recorded, not processed." |
| Stay under 20 minutes | Over-length recordings get marked down. |
| Submit the **video link** in the presentation slot, never this deck | The deck is a speaking aid. Slide 36 repeats this warning. |

---

## Minute-by-minute plan

| Time | Slides | What you are doing |
|---|---|---|
| 0:00–1:00 | 1 | ID on camera, name, programme, product, and the fact that you are solo |
| 1:00–1:40 | 2 | Agenda — read the six headings only |
| 1:40–2:40 | 3 | Scope statement: baseline versus the graded increment |
| 2:40–5:00 | 4–6 | The problem, the four constraints it creates, and who the users are |
| 5:00–7:50 | 7–12 | Product: module map, then the web workspace, daily loop, Connect, client side |
| 7:50–10:40 | 13–17 | Real Android screens (three triptychs), automation engine, one-account story |
| 10:40–14:35 | 18–23 | Architecture, sync outbox, security model, patterns, money correctness |
| 14:35–17:40 | 24–27 | Ask AI as an AI system, test strategy, CI/CD, deployment recommendation |
| 17:40–19:45 | 28–32 | Baseline vs Capstone, sprint timeline, sprint detail, board and definition of done |
| 19:45–20:15 | 33–34 | Frame the demo, then **switch to the live product** |
| — | live | Run `docs/capstone/DEMO_SCRIPT.md`. Budget 5–6 minutes inside the total. |
| 20:15–21:30 | 35–37 | Results and open risks, submission map, close |

Slides 38–40 are appendix. Do **not** present them. Open them only if a grader asks
about the roadmap, the go-to-market work, or your recording process.

If you are running long, the slides you can compress hardest are 10, 12, 22 and 31 —
they are supporting evidence rather than new argument.

---

## The four sentences that earn the marks

Rehearse these until they are automatic. Everything else is commentary.

1. **Scope (slide 3).** "CLIVORA was already live before this Capstone. I am not claiming
   the whole product as three sprints. What Quantic is grading is a new increment on a real
   production system: testing and CI, an AI retrieval layer, and one end-to-end demo loop."

2. **Architecture (slide 19).** "Both clients are untrusted. Authorisation is row-level
   security in Postgres, so hiding a button is never the security control."

3. **AI engineering (slide 24).** "Sprint 2 turned Ask AI from a wrapper around aggregates
   into a retrieval system grounded in the user's own invoices and clients — and the model
   proposes while a human commits. Auto-pay and auto-publish are forbidden."

4. **Honesty (slide 35).** "Web end-to-end coverage is still my largest open risk, tracked
   as QA-001. The outbox is untested under process death. Payments are recorded, not
   processed."

---

## Slide-by-slide script

The authoritative script lives in the PPTX notes pane. This section is the condensed
version for rehearsal.

### 1 · Cover
ID up. "My name is Usman Ghias. This is my Quantic MSSE Capstone presentation for CLIVORA,
the freelance operating system. Web is live at clivora.io, Android is on Google Play. I am
the sole engineer, and I acted as Product Owner and Scrum Master across three sprints."

### 2 · Agenda
Six headings. No sub-lines. Twenty seconds.

### 3 · Team, roles, scope
Deliver sentence 1 above. Do not rush.

### 4–6 · The problem
Four seams: discovery is walled off, delivery is scattered, money leaks, clients guess.
Then the four constraints those seams create: two-sided, zero platform fee, offline-capable,
one auditable record. Then the three users, and why marketplaces, project tools, accounting
apps and spreadsheets each miss.

### 7–12 · The product
Trace the module map with your cursor: Connect → CRM → Money → Client hub, all resolving to
one Postgres record. Then move quickly through the web workspace, the six-step daily loop
(emphasise the hand-off from tracked time to invoice line), Connect's mutual-accept and $0
fee, and the client as a first-class user.

### 13–15 · Real Android screens
Say "unretouched" and point at a phone status bar. Triptych one is the freelancer's day.
Triptych two is Connect and getting paid — the paid invoice is from your own account.
Triptych three is the client experience from the same binary.

### 16 · Automation engine
Six trigger-action rules, executing on the device. The offline angle is the point: an
overdue invoice still creates a follow-up task with no signal, and syncs later.

### 17 · One account
Not a port. One contract, one database, mirrored business rules, unit-tested on both sides.

### 19 · Architecture
Deliver sentence 2 above after walking the three tiers top to bottom, once.

### 20 · Sync outbox
Your strongest engineering story. Name the pattern (transactional outbox), describe the
happy path, then dwell on the failure path: unknown operation kinds are marked
`permanently_failed` and kept, because a silently dropped invoice is worse than a visible
error.

### 21 · Security model
Client hostile, server holds secrets and session, Postgres has the last word. The best
concrete example is that Connect emails are unreachable until mutual accept — a database
policy, not a hidden UI field.

### 22–23 · Patterns and money
Pick three patterns, not six. Then: money is stored as major units *and* integer minor
units, migrated with expand-contract, and the free-plan caps are pure functions with the
UTC month boundary pinned by tests.

### 24 · Ask AI
Deliver sentence 3 above. Cover the three engineering decisions: fail open honestly,
indexing is opt-in so the money path could not regress, and there is a written eval set.

### 25–26 · Tests and CI/CD
Cheap deterministic tests where the blast radius is largest. Eight suites. Manual testing
is a release smoke check, not evidence. Then: wiring `npm test` into CI was a Sprint 1
story — before it, the web tests existed but nothing forced them to run.

### 27 · Deployment
Managed cloud, recommended and already in use. Heavier public cloud, deferred. On-premises,
rejected — and the reason is architectural: Connect is a two-sided network.

### 28–32 · Agile record
Baseline on the left, three graded sprints on the right. Then the timeline: four weeks each,
each ending in a recorded demo. Acknowledge that you were both developer and Product Owner,
then explain that you still ran accept/reject before re-planning. Close with the definition
of done, especially the two unusual clauses: no secrets committed, and baseline features are
never relabelled as Capstone work.

### 33–34 · Demo framing
Six steps, two real accounts, both clients. State the payment caveat before you share your
screen. **Then switch to the live product and follow `DEMO_SCRIPT.md`.**

### 35 · Results
Four numbers, then the open risks. Deliver sentence 4 above. The gaps list is what makes the
wins list believable.

### 36 · Submission
Read the red band out loud.

### 37 · Close
"Discover the work. Do the work. Own the momentum." Invite questions. Stop the recording.

---

## Pre-record checklist

Slide 40 carries this list. Short version:

- Photo ID in hand; 1920×1080 display; notifications silenced
- Freelancer **and** client accounts both signed in, on separate windows
- Demo data reset per `DEMO_SCRIPT.md`
- Presenter View open with these notes
- After recording: upload to Google Drive with anyone-with-link access, test the link in a
  private window, attach the Group Project Agreement, give the grader account read access
  to the repository, and submit **both** buttons
