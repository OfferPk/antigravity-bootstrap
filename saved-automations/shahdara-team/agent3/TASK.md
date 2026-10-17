# TASK - agent3 'shahdara-forms-qa': Billing correctness, forms, receipts, data safety, QA
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent3\shahdara-isp-billing
Branch prefix: feat/qa-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent3\STATE_agent3.md
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md and TEAM.md (must follow)

## HARD SCOPE RULE (added 2026-10-17, overrides older ideas in STATE files)
- This repo is a small Pakistani ISP's offline BILLING / BUSINESS app. ALL NEW work must be billing/business features only: customers, packages, monthly bills, payments, receipts (incl. WhatsApp), dues/ledger, expenses, staff/collectors, reports, settings, backup/restore, and UI/UX polish of these.
- FORBIDDEN for new work: network / optical / routing engineering tools, calculators or simulators (OTDR, BGP, MPLS, SRv6, EVPN, DWDM, ROADM, OTN, PON/DBA physics, fiber splicing/cleaving, Raman/EDFA, PMD, Kerr, microwave, etc.). Do not create new dashboard-*/nav-*/qa-* modules of this kind and do not extend the existing ones.
- NEVER remove, hide or break existing features (including the engineering panels already in the app). Only add new billing features and improve existing ones. Keep `npm test` 100% green.
- Test for every task: "Does this help the owner bill, collect, track dues/expenses or run the business faster?" If not, pick the next task from your TASK.md backlog.
- Before building, search the code (rg) for an existing version of the feature. If it exists, extend and improve it instead of creating a duplicate.
- Take tasks from your TASK.md backlog in order (top first). STATE "NEXT" ideas about network engineering are void.

## Your area: BILLING LOGIC CORRECTNESS, FORMS, RECEIPTS, BACKUP, TESTS, CI
- If main CI is red, fixing it is always your top priority.
- Keep fixes in agent1/agent2 areas minimal. Never change saved data shapes destructively; additive migrations only.
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
3. npm test 100% (never delete or weaken tests). git fetch origin, git rebase origin/main, npm test again.
4. Push (or PUSH RULE in TEAM.md), PR via GitHub MCP (title prefix [agent3]), merge only when CI is green. Confirm Pages deploy.
5. Update STATE_agent3.md: done, PR link, which backlog item number is next.
