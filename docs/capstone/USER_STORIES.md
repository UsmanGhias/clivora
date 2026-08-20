# Capstone product backlog (user stories)

Format: *As a … I want … so that …*  
Only these stories are in the Capstone increment. Baseline product features are already shipped.

Status is also tracked on the GitHub Project / Issues (`label: capstone`).

## Sprint 1 — Engineering bar

| ID | Story | Acceptance | Status |
|---|---|---|---|
| US-1 | As a Quantic grader, I want a README that links the live app, board, and design/testing doc so that I can score the submission without hunting. | Root README contains clivora.io, Play Store, design doc, board, `quantic-grader` note. | Done |
| US-2 | As a Product Owner, I want an accessible agile board of Capstone tasks so that sprint scope is visible. | GitHub Issues with sprint labels; this file kept in sync. | Done |
| US-3 | As a maintainer, I want Hostinger SSH keys ignored by git so that secrets never reach the grader clone. | `.ssh-hostinger/` in `.gitignore`; folder untracked. | Done |
| US-4 | As a developer, I want plan and money rules covered by unit tests so that Free/Pro limits cannot silently break. | Vitest for `plan`, `plan-gates`, `money`; `npm test` in CI. | Done |
| US-5 | As a grader, I want a design-and-testing document that names patterns, reasons, tests, and deploy cost so that rubric item 4 is met. | `docs/capstone/DESIGN_AND_TESTING.md` in the repo. | Done |

## Sprint 2 — AI system

| ID | Story | Acceptance | Status |
|---|---|---|---|
| US-6 | As a Pro freelancer, I want Ask AI to retrieve my own clients/invoices (not only totals) so that answers are grounded. | Keyword/recent retrieval over `crm_embeddings` with aggregate fallback. Opt-in `POST /api/ai/index-crm`. Live CRM saves unchanged. | In progress |
| US-7 | As a Product Owner, I want a small Ask AI eval set so that we can show AI engineering (not only a chat wrapper). | Documented questions + expected behavior in `docs/capstone/ASK_AI_EVAL.md`. | Done |
| US-8 | As a freelancer, I want AI suggestions to require my review so that the system never auto-pays or auto-publishes. | Existing human-review copy remains; flags documented. | Done |

## Sprint 3 — Demo loop

| ID | Story | Acceptance | Status |
|---|---|---|---|
| US-9 | As a client, I want to post a job, review a proposal, and mutually accept so that contact can unlock in a live demo. | Scripted path on clivora.io with seed/test accounts. | Backlog |
| US-10 | As a freelancer, I want to open a project, track time, and share an invoice link so that the OS loop is visible end-to-end. | `/i/[token]` shown in the demo; timesheet uses approved rate. | Backlog |
| US-11 | As a Capstone student, I want a 15–20 minute recorded demo with ID on camera so that the presentation rubric is met. | Single .mp4 on Google Drive; all speakers visible. | Backlog |
| US-12 | As a grader, I want sprint-end demo recordings for the Product Owner so that the three-sprint journey is evidenced. | Three short recordings linked from `docs/capstone/`. | Backlog |
