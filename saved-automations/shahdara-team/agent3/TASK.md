# TASK - agent3 'shahdara-forms-qa': Billing correctness, forms, receipts, data safety, QA
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent3\shahdara-isp-billing
Branch prefix: feat/qa-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent3\STATE_agent3.md
Shared rules: C:\Users\Perfect\shahdara-project\TEAM.md, LANES.md and AGENTS.md (must follow)


## TEAM MODE + YOUR LANE (2026-10-19, overrides anything below that conflicts)
- TEAM MODE (resumed 2026-10-19 by John): agents take turns ONE AT A TIME, sequential rotation agent1 -> agent2 -> agent3 -> agent4 -> agent1 (TEAM.md, TEAM.lock heartbeat after every step).
- LANE RULE: edit ONLY the files/areas of your lane below (full table: C:\Users\Perfect\shahdara-project\LANES.md). If a change needs another lane's file or a agent4-owned (ex-Grok) module (customer-plan.js, customer-import*.js, bulk-collect.*, collect-setup.js, nav-quick-collect.js, screen-router.*, ui-feedback.* toast/confirm, dark-contrast.css, payments-list.*, receipt.js, profile-ui.js ...), do NOT edit it: open a GitHub issue labeled `lane:agentN` / `lane:agent4` and continue with in-lane work. Before committing run `git diff --name-only origin/main` and check every file is in your lane; put `Lane: <agent> - files: <list>` in the PR body.
- ALWAYS git fetch origin + git rebase origin/main right before opening the PR and again right before merging (rerun npm test + e2e).
- ORDER each turn: (1) finish your own open branch/PR, (2) open grok-review issues of YOUR lane (highest impact first, `Fixes #N` in the PR), (3) open `lane:agent3` issues, (4) the BACKLOG below.
- Every task follows the 7-step WORKFLOW RULE and the REA RULE in TEAM.md (understand repo + REA trace -> code -> tests on built dist at 390x844 and 1280x800 -> fix bugs -> self-review -> push/PR/CI green/squash-merge -> verify LIVE). Done only after live verification. Minimum 20 minutes per turn, keep going until merged.
- Never remove or hide features, never weaken/skip/delete tests, never rename/drop storage keys.

### Your lane
- Owns: `form-validation.js`, every field-tool module `nav-<tool>.js` (nav-optical-attenuator.js, nav-optical-return-loss.js, nav-otdr-*.js, nav-fiber-*.js, nav-fusion-splice.js, nav-gps-tracking.js, nav-tube-shaving.js, nav-mpo-polarity.js, nav-olts-cert.js, nav-wdm-spectrum.js, nav-van-inventory.js, nav-collection-rounds.js, ... all field tools), every `qa-*.js`, `reminder-queue.js`, `nav-pending-actions.js`, `digital-payments-settings.js`, `backup-store.js`, `qa-backup-csv-import.js`.
- index.html areas: Field Tools sheet/page and each tool dialog, Reminders / Pending Actions, Settings, Backup / Restore / CSV import, Expenses & Staff forms, Inventory forms.
- Issues: #283 Field Tools sheet - Attenuator and Return Loss open nothing (only the first [data-open-*] button is wired), the remaining field-tool `confirm()` popups (nav-mpo-polarity.js, nav-fiber-identifier.js, nav-gps-tracking.js, nav-tube-shaving.js, nav-olts-cert.js; dashboard-collection-target.js is agent1's) -> use `await window.appConfirm({tone, title, message, confirmLabel})` (agent4-owned (ex-Grok) ui-feedback.js, already used in app.js), #284 Reminders Today Queue empty (catch-up stages), #232 optional encrypted backup, #226 Bluetooth thermal printing (new module; receipt.js changes via `lane:agent4` issue).

## HARD SCOPE RULE (added 2026-10-17, overrides older ideas in STATE files)
- This repo is a small Pakistani ISP's offline BILLING / BUSINESS app. ALL NEW work must be billing/business features only: customers, packages, monthly bills, payments, receipts (incl. WhatsApp), dues/ledger, expenses, staff/collectors, reports, settings, backup/restore, and UI/UX polish of these.
- FORBIDDEN for new work: network / optical / routing engineering tools, calculators or simulators (OTDR, BGP, MPLS, SRv6, EVPN, DWDM, ROADM, OTN, PON/DBA physics, fiber splicing/cleaving, Raman/EDFA, PMD, Kerr, microwave, etc.). Do not create new dashboard-*/nav-*/qa-* modules of this kind and do not extend the existing ones.
- NEVER remove, hide or break existing features (including the engineering panels already in the app). Only add new billing features and improve existing ones. Keep `npm test` 100% green.
- Test for every task: "Does this help the owner bill, collect, track dues/expenses or run the business faster?" If not, pick the next task from your TASK.md backlog.
- Before building, search the code (rg) for an existing version of the feature. If it exists, extend and improve it instead of creating a duplicate.
- Take tasks from your TASK.md backlog in order (top first). STATE "NEXT" ideas about network engineering are void.

## Your area: FORMS, FIELD TOOLS, REMINDERS, SETTINGS, BACKUP (+ billing correctness tests)
- If main CI is red because of a file in your lane, fixing it is your top priority; otherwise open an issue for the owner lane.
- Do not edit agent1/agent2 or agent4-owned (ex-Grok) files (LANE RULE): open a lane issue instead. Never change saved data shapes destructively; additive migrations only.
- Do NOT redesign dashboard (agent1) or navigation/layout (agent2).

## BACKLOG (prioritized; each item = one substantial 20+ min feature with UI where relevant, wiring to existing data/storage, and tests)
1. Billing correctness suite + fixes: end-to-end tests for monthly bill generation (effective month, due date on the 5th, archived customers, price edits not rewriting history), partial payments, excess -> credit allocation, edit/delete receipt recalculation, Paid/Partial/Pending/Not set status. Fix every bug found.
2. Customer add/edit validation: wire validatePakistanCnic / validatePakistanPhone into the main customer form (03xx and +92 formats), inline messages, duplicate phone/CNIC warning (reuse duplicate-detection.js), required fields, no data loss on error.
3. Package change with pro-rata: change a customer's package mid-month with a preview of the pro-rated current-bill amount, saved as an explicit adjustment, history and old bill snapshots kept. Check existing pro-rata/adjustment voucher code first and integrate.
4. Discounts and late fee: per-receipt discount field and an owner-configured late fee (OFF by default, applied only by an explicit owner action, never automatic), correct balance math, shown on receipts and reports, tests.
5. Receipt print layouts: 58mm and 80mm thermal + A4 options, permanent receipt number, Urdu note, partial/balance shown correctly, @media print tests.
6. Backup / restore hardening: round-trip tests for every storage key, corrupted/old-version file handling, preview before merge, never silent overwrite. Add CSV import of customers with validation preview (merge-only).
7. Data integrity checker: scan for orphan receipts, negative or impossible balances, duplicate receipt numbers, bills without amounts, customers without numbers; report screen + safe fixes only after confirmation.
8. Billing tables: sorting, filters, pagination, sticky headers and mobile cards for customers, bills, payments and expenses tables (reuse paginateRows).
9. Expense and staff forms: validation, categories, payroll-to-expense link clarity, edit/delete with confirm, tests.
10. Bug bash + CI health: walk the full flow (add customer -> bill -> partial payment -> receipt -> WhatsApp draft -> reports -> backup) and fix bugs; keep tests fast and non-flaky.
When the backlog is done: keep improving billing correctness, validation and test coverage (still billing only).

## Loop (each turn; locking is handled by TEAM.md / TEAM.lock)
1. Working dir C:\Users\Perfect\shahdara-project\agent3\shahdara-isp-billing. git fetch origin. Finish/merge your open PRs first.
2. git checkout -B feat/qa-<topic>-YYYYMMDD origin/main. Implement the next backlog item COMPLETELY. Minimum 20 minutes; if not finished, keep going until merged.
3. npm test 100% + npm run build + npx playwright test on dist (never delete or weaken tests). git fetch origin, git rebase origin/main, run them again (also right before merge).
4. Push (or PUSH RULE in TEAM.md), PR via GitHub MCP (title prefix [agent3]), merge only when CI is green. Confirm Pages deploy.
5. Update STATE_agent3.md: done, PR link, which backlog item number is next.

## BROWSER VERIFICATION RULE (added 2026-10-17, all agents)
- Unit tests are NOT enough. Before every PR, open your changed feature in a REAL browser at mobile 390x844 and desktop 1280x800 (Playwright `npx playwright test` / scripts, or rea MCP capture_browser_scenario / capture_web_screenshot on a local server or the Pages preview).
- Check: it OPENS, every new button WORKS, it CLOSES (close / Esc / backdrop), Back works, and NO menu, FAB, toast, backdrop or overlay covers content when it should be closed. No horizontal scroll at 390px. Dark + light readable.
- If tests/e2e/*.spec.mjs exists: add/extend an e2e test for your feature and keep `npx playwright test` green. Never skip or weaken e2e tests. Note in the PR what you verified in the browser.
- PREFER ENHANCING EXISTING FEATURES over adding new ones. agent4 (shahdara-polish-qa) fixes and polishes existing features between your turns; do not undo its fixes (e.g. do not re-expand the speed-dial or add new items to it; new tools go into the grouped "More tools"/"Field Tools" page).
