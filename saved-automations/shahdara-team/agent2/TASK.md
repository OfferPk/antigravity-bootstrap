# TASK - agent2 'shahdara-mobile-nav': Mobile field-collection flows + navigation
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent2\shahdara-isp-billing
Branch prefix: feat/nav-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent2\STATE_agent2.md
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md and TEAM.md (must follow)

## HARD SCOPE RULE (added 2026-10-17, overrides older ideas in STATE files)
- This repo is a small Pakistani ISP's offline BILLING / BUSINESS app. ALL NEW work must be billing/business features only: customers, packages, monthly bills, payments, receipts (incl. WhatsApp), dues/ledger, expenses, staff/collectors, reports, settings, backup/restore, and UI/UX polish of these.
- FORBIDDEN for new work: network / optical / routing engineering tools, calculators or simulators (OTDR, BGP, MPLS, SRv6, EVPN, DWDM, ROADM, OTN, PON/DBA physics, fiber splicing/cleaving, Raman/EDFA, PMD, Kerr, microwave, etc.). Do not create new dashboard-*/nav-*/qa-* modules of this kind and do not extend the existing ones.
- NEVER remove, hide or break existing features (including the engineering panels already in the app). Only add new billing features and improve existing ones. Keep `npm test` 100% green.
- Test for every task: "Does this help the owner bill, collect, track dues/expenses or run the business faster?" If not, pick the next task from your TASK.md backlog.
- Before building, search the code (rg) for an existing version of the feature. If it exists, extend and improve it instead of creating a duplicate.
- Take tasks from your TASK.md backlog in order (top first). STATE "NEXT" ideas about network engineering are void.

## Your area: MOBILE FLOWS FOR THE OWNER AND FIELD COLLECTORS + NAVIGATION
- Phone-first layout, header, bottom nav, drawer/More sheet, fast flows for collecting money in the field, accessibility.
- Reuse existing billing/payment/receipt functions (core.js, app.js, receipt.js, form-validation.js). Never invent data; a receipt is created only after the user confirms.
- Do NOT change dashboard cards/charts (agent1) or forms/receipt internals beyond wiring (agent3).

## BACKLOG (prioritized; each item = one substantial 20+ min feature with UI, wiring to existing data/storage, dark/light theme, mobile layout, empty states and tests)
1. Quick Collect (2 taps): from the bottom nav Collection tab -> pick customer -> sheet prefilled with the remaining balance, today's date and last-used method (all visible and editable) -> Confirm creates the receipt through the existing payment function -> success screen with receipt. Partial amounts allowed; validation reused.
2. Fast customer search sheet: instant search by name, phone, customer number and area; recent customers; Paid/Partial/Pending chips; large touch targets; works offline; keyboard shortcut kept.
3. WhatsApp receipt share after payment: one tap opens the reviewed wa.me draft using the existing receipt/WhatsApp builders, copy-text fallback when no phone saved, "shared" mark on the receipt (new key, additive).
4. Collection rounds: per area/mohalla route list of customers with dues for today, sorted by outstanding, progress counter, collect via Quick Collect, call/WhatsApp buttons. Check the existing field route sheet (calculateFieldCollectionRoutes) first and extend it.
5. Mobile customer quick profile sheet: balance, current bill status, last payment, package, phone; buttons Collect / WhatsApp reminder / Call / Open full profile.
6. Urdu / English toggle: persisted language key, translate bottom nav, More sheet, Quick Collect, search, collection rounds and receipt share texts; RTL-safe layout for Urdu.
7. Pending actions center: badge + list of receipts not yet shared on WhatsApp and customers promised to pay today (reuse the existing offline queue where it fits).
8. Bottom nav and More sheet polish for billing: dues badge, active state, billing items listed first (Customers, Collection, Bills, Expenses, Reports, Backup). Do not remove or hide any existing entry.
9. Accessibility pass on billing flows: focus order, labels, aria-live for payment success, contrast, 44px targets, screen-reader test notes; add tests.
10. PWA shortcuts and speed: manifest shortcuts (Quick Collect, Add customer, Today's dues), install prompt, faster first paint on low-end phones (lazy init heavy panels without removing them).
When the backlog is done: polish speed and usability of the billing flows on phones (still billing only).

## Loop (each turn; locking is handled by TEAM.md / TEAM.lock)
1. Working dir C:\Users\Perfect\shahdara-project\agent2\shahdara-isp-billing. git fetch origin. Finish/merge your open PRs first.
2. git checkout -B feat/nav-<topic>-YYYYMMDD origin/main. Implement the next backlog item COMPLETELY. Minimum 20 minutes; if not finished, keep going until merged.
3. npm test 100% (never delete or weaken tests). git fetch origin, git rebase origin/main, npm test again.
4. Push (or PUSH RULE in TEAM.md), PR via GitHub MCP (title prefix [agent2]), merge only when CI is green. Confirm Pages deploy.
5. Update STATE_agent2.md: done, PR link, which backlog item number is next.
