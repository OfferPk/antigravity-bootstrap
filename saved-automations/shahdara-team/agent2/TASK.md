# TASK - agent2 'shahdara-mobile-nav': Mobile field-collection flows + navigation
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent2\shahdara-isp-billing
Branch prefix: feat/nav-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent2\STATE_agent2.md
Shared rules: C:\Users\Perfect\shahdara-project\TEAM.md, LANES.md and AGENTS.md (must follow)


## TEAM MODE + YOUR LANE (2026-10-19, overrides anything below that conflicts)
- TEAM MODE (resumed 2026-10-19 by John): agents take turns ONE AT A TIME, sequential rotation agent1 -> agent2 -> agent3 -> agent4 -> agent1 (TEAM.md, TEAM.lock heartbeat after every step).
- LANE RULE: edit ONLY the files/areas of your lane below (full table: C:\Users\Perfect\shahdara-project\LANES.md). If a change needs another lane's file or a agent4-owned (ex-Grok) module (customer-plan.js, customer-import*.js, bulk-collect.*, collect-setup.js, nav-quick-collect.js, screen-router.*, ui-feedback.* toast/confirm, dark-contrast.css, payments-list.*, receipt.js, profile-ui.js ...), do NOT edit it: open a GitHub issue labeled `lane:agentN` / `lane:agent4` and continue with in-lane work. Before committing run `git diff --name-only origin/main` and check every file is in your lane; put `Lane: <agent> - files: <list>` in the PR body.
- ALWAYS git fetch origin + git rebase origin/main right before opening the PR and again right before merging (rerun npm test + e2e).
- ORDER each turn: (1) finish your own open branch/PR, (2) open grok-review issues of YOUR lane (highest impact first, `Fixes #N` in the PR), (3) open `lane:agent2` issues, (4) the BACKLOG below.
- Every task follows the 7-step WORKFLOW RULE and the REA RULE in TEAM.md (understand repo + REA trace -> code -> tests on built dist at 390x844 and 1280x800 -> fix bugs -> self-review -> push/PR/CI green/squash-merge -> verify LIVE). Done only after live verification. Minimum 20 minutes per turn, keep going until merged.
- Never remove or hide features, never weaken/skip/delete tests, never rename/drop storage keys.

### Your lane
- Owns: `nav.js`, `nav.css`, `nav-accessibility.js`, `nav-language.js`, `nav-pwa.js`, `nav-customer-search.js`, `sw.js`, `build.mjs` (performance only), manifest/PWA files.
- index.html areas: header/top bar, desktop sidebar, mobile drawer, bottom nav, More menu, speed dial (`#mobileSpeedDial`), global search, language toggle.
- Integrates with `screen-router.js` through its public hooks (`updateNavActive`, `data-screen` on body); changes inside `screen-router.js` -> `lane:agent4` issue.
- Issues: #285 bottom nav highlights Home on Backup / Settings / Owner Assistant + the + button covers the More menu, #280 leftovers (nav polish), any nav highlight bug, #228 Urdu mode (nav-language.js and labels), #219 performance (bundle / lazy-load in build.mjs + sw.js; no index.html restructuring of other lanes' blocks).

## HARD SCOPE RULE (added 2026-10-17, overrides older ideas in STATE files)
- This repo is a small Pakistani ISP's offline BILLING / BUSINESS app. ALL NEW work must be billing/business features only: customers, packages, monthly bills, payments, receipts (incl. WhatsApp), dues/ledger, expenses, staff/collectors, reports, settings, backup/restore, and UI/UX polish of these.
- FORBIDDEN for new work: network / optical / routing engineering tools, calculators or simulators (OTDR, BGP, MPLS, SRv6, EVPN, DWDM, ROADM, OTN, PON/DBA physics, fiber splicing/cleaving, Raman/EDFA, PMD, Kerr, microwave, etc.). Do not create new dashboard-*/nav-*/qa-* modules of this kind and do not extend the existing ones.
- NEVER remove, hide or break existing features (including the engineering panels already in the app). Only add new billing features and improve existing ones. Keep `npm test` 100% green.
- Test for every task: "Does this help the owner bill, collect, track dues/expenses or run the business faster?" If not, pick the next task from your TASK.md backlog.
- Before building, search the code (rg) for an existing version of the feature. If it exists, extend and improve it instead of creating a duplicate.
- Take tasks from your TASK.md backlog in order (top first). STATE "NEXT" ideas about network engineering are void.

## Your area: MOBILE FLOWS FOR THE OWNER AND FIELD COLLECTORS + NAVIGATION
- Phone-first layout, header, bottom nav, drawer/More sheet, fast flows for collecting money in the field, accessibility.
- Reuse existing billing/payment/receipt functions (core.js, app.js, receipt.js, form-validation.js) by CALLING them; do not edit them (Grok/agent3 lanes). Never invent data; a receipt is created only after the user confirms.
- Quick Collect, quick profile and customer screens are agent4-owned (ex-Grok) now: backlog items 1, 3, 5 below only via `lane:agent4` issues; continue with nav/header/drawer/More/bottom-nav/PWA/Urdu/performance items.
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
3. npm test 100% + npm run build + npx playwright test on dist (never delete or weaken tests). git fetch origin, git rebase origin/main, run them again (also right before merge).
4. Push (or PUSH RULE in TEAM.md), PR via GitHub MCP (title prefix [agent2]), merge only when CI is green. Confirm Pages deploy.
5. Update STATE_agent2.md: done, PR link, which backlog item number is next.

## BROWSER VERIFICATION RULE (added 2026-10-17, all agents)
- Unit tests are NOT enough. Before every PR, open your changed feature in a REAL browser at mobile 390x844 and desktop 1280x800 (Playwright `npx playwright test` / scripts, or rea MCP capture_browser_scenario / capture_web_screenshot on a local server or the Pages preview).
- Check: it OPENS, every new button WORKS, it CLOSES (close / Esc / backdrop), Back works, and NO menu, FAB, toast, backdrop or overlay covers content when it should be closed. No horizontal scroll at 390px. Dark + light readable.
- If tests/e2e/*.spec.mjs exists: add/extend an e2e test for your feature and keep `npx playwright test` green. Never skip or weaken e2e tests. Note in the PR what you verified in the browser.
- PREFER ENHANCING EXISTING FEATURES over adding new ones. agent4 (shahdara-polish-qa) fixes and polishes existing features between your turns; do not undo its fixes (e.g. do not re-expand the speed-dial or add new items to it; new tools go into the grouped "More tools"/"Field Tools" page).
