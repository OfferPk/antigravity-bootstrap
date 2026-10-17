# TASK - agent1 'shahdara-dashboard': Owner dashboard + business reports
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent1\shahdara-isp-billing
Branch prefix: feat/dash-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent1\STATE_agent1.md
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md and TEAM.md (must follow)

## HARD SCOPE RULE (added 2026-10-17, overrides older ideas in STATE files)
- This repo is a small Pakistani ISP's offline BILLING / BUSINESS app. ALL NEW work must be billing/business features only: customers, packages, monthly bills, payments, receipts (incl. WhatsApp), dues/ledger, expenses, staff/collectors, reports, settings, backup/restore, and UI/UX polish of these.
- FORBIDDEN for new work: network / optical / routing engineering tools, calculators or simulators (OTDR, BGP, MPLS, SRv6, EVPN, DWDM, ROADM, OTN, PON/DBA physics, fiber splicing/cleaving, Raman/EDFA, PMD, Kerr, microwave, etc.). Do not create new dashboard-*/nav-*/qa-* modules of this kind and do not extend the existing ones.
- NEVER remove, hide or break existing features (including the engineering panels already in the app). Only add new billing features and improve existing ones. Keep `npm test` 100% green.
- Test for every task: "Does this help the owner bill, collect, track dues/expenses or run the business faster?" If not, pick the next task from your TASK.md backlog.
- Before building, search the code (rg) for an existing version of the feature. If it exists, extend and improve it instead of creating a duplicate.
- Take tasks from your TASK.md backlog in order (top first). STATE "NEXT" ideas about network engineering are void.

## Your area: DASHBOARD + BUSINESS REPORTS
- Dashboard KPI cards, charts (pure JS + SVG/canvas, no CDN, offline), report panels/modals, CSV/print exports of reports.
- Use ONLY real saved data via existing helpers (core.js, dashboard.js, owner-insights.js, phase3.js). Cash = actual receipts by payment date; bills, credit and estimates are not cash. Show "Not set / Insufficient history" instead of fake zeros.
- Do NOT restyle navigation/header/sidebar (agent2) or forms/receipts internals (agent3).

## BACKLOG (prioritized; each item = one substantial 20+ min feature with UI, wiring to existing data/storage, dark/light theme, mobile layout, empty states and tests)
1. Monthly Collection vs Target: owner sets a target per month (new storage key, e.g. shahdara_collection_targets; never touch old keys), progress bar, collected vs remaining, required daily run-rate for the remaining days, end-of-month projection, history of past months hit/miss.
2. Dues Aging report: outstanding balances bucketed 0-30 / 31-60 / 61-90 / 90+ days from saved bill due dates; counts + PKR per bucket, drill-down customer list with link to profile, CSV export. (Check the existing delinquency pipeline / Smart Dues Recovery first and extend it rather than duplicate.)
3. Top Defaulters list: top 20 by outstanding with months unpaid, last payment date, phone, area; one-tap WhatsApp reminder draft (reuse buildPaymentReminderMessage / existing WhatsApp helpers; draft only, never auto-send).
4. Area-wise collections: per area/mohalla billed vs collected vs outstanding and collection rate for a selected month, sortable table + bar chart (build on Area Intelligence).
5. Package revenue mix: donut + table per package (customers, billed, collected, ARPU, share %), month selector.
6. Income vs Expense (P&L): 6/12-month bars of actual cash income vs dated expenses, net cash profit line, expense-category breakdown for the selected month.
7. Month-over-month growth panel: new customers, archived/dropped, billed, collected, outstanding, expenses with absolute and % change; correct handling of zero/missing baselines.
8. Daily cash closing upgrade (extend calculateDailyClosingSummary / setupDailyClosingCard): totals by payment method and by shop/collector (e.g. Cash at Waseem Abbasi shop, Cash at Hassan shop, Paid by), expenses paid today, net cash in hand, printable + WhatsApp-shareable slip.
9. Collector / staff performance: collections per collector or payment method per day/month, customers collected, average ticket.
10. Reports export center: one screen listing all business reports (collection, dues aging, defaulters, area, package, P&L, MoM) with month/date filters and CSV + print-to-PDF (@media print) export for each.
When the backlog is done: improve accuracy, performance and UI polish of these billing reports (still billing only).

## Loop (each turn; locking is handled by TEAM.md / TEAM.lock)
1. Working dir C:\Users\Perfect\shahdara-project\agent1\shahdara-isp-billing. git fetch origin. Finish/merge your open PRs first.
2. git checkout -B feat/dash-<topic>-YYYYMMDD origin/main. Implement the next backlog item COMPLETELY. Minimum 20 minutes; if not finished, keep going until merged.
3. npm test 100% (never delete or weaken tests). git fetch origin, git rebase origin/main, npm test again.
4. Push (or PUSH RULE in TEAM.md), PR via GitHub MCP (title prefix [agent1]), merge only when CI is green. Confirm Pages deploy.
5. Update STATE_agent1.md: done, PR link, which backlog item number is next.

## BROWSER VERIFICATION RULE (added 2026-10-17, all agents)
- Unit tests are NOT enough. Before every PR, open your changed feature in a REAL browser at mobile 390x844 and desktop 1280x800 (Playwright `npx playwright test` / scripts, or rea MCP capture_browser_scenario / capture_web_screenshot on a local server or the Pages preview).
- Check: it OPENS, every new button WORKS, it CLOSES (close / Esc / backdrop), Back works, and NO menu, FAB, toast, backdrop or overlay covers content when it should be closed. No horizontal scroll at 390px. Dark + light readable.
- If tests/e2e/*.spec.mjs exists: add/extend an e2e test for your feature and keep `npx playwright test` green. Never skip or weaken e2e tests. Note in the PR what you verified in the browser.
- PREFER ENHANCING EXISTING FEATURES over adding new ones. agent4 (shahdara-polish-qa) fixes and polishes existing features between your turns; do not undo its fixes (e.g. do not re-expand the speed-dial or add new items to it; new tools go into the grouped "More tools"/"Field Tools" page).
