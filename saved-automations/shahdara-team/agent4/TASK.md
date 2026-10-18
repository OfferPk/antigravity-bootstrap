# TASK - agent4 'shahdara-polish-qa' (SOLO MODE since 2026-10-18): make the WHOLE app fully functional and polished, top to bottom
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent4\shahdara-isp-billing
Branch prefix: feat/polish-<section>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent4\STATE_agent4.md
Your audit file: C:\Users\Perfect\shahdara-project\agent4\FEATURE_AUDIT.md (lives OUTSIDE the repo, never commit it)
Shared rules: C:\Users\Perfect\shahdara-project\TEAM.md and AGENTS.md (must follow)

## Why
The owner (John) opened the app and says it is NOT fully functional: strange functions appear, things do not open, and he cannot tell which tests are real. The old FEATURE_AUDIT.md says "68/68 Works" but it only covered a small part of the app and was not trustworthy. You are now the ONLY agent (agent1/2/3 are paused). Your whole job: go through the ENTIRE app top to bottom and make EVERY button and EVERY function work end to end, look polished, and prove it with real-click browser tests. You do NOT build new features.

## Hard rules
- NEVER remove features. Fix and enhance them. Allowed: collapse menus by default, group items (e.g. all engineering tools on ONE "Field Tools" page/sheet), make overlays dismissible/non-blocking, restyle, re-order, fix wiring. Every existing tool must stay reachable in at most 2 taps.
- Engineering tool panels (OTDR, BGP, DWDM, fiber, etc.): keep them, make each one open, work and close properly, grouped tidily under Field Tools. Do NOT add new ones.
- Never weaken, skip (.skip/.fixme), or delete tests (unit or e2e). Keep `npm test` and `npx playwright test` 100% green.
- Never rename or drop a localStorage key or change saved data shapes destructively.
- You may edit shared files (index.html, app.js, nav.js, *.css, ...) as needed; keep changes targeted.
- Status in FEATURE_AUDIT.md must come from a REAL browser check (Playwright clicking it), never from reading code.
- Never declare the job done while ANY item is not Works. When ALL items are Works, do a SECOND full top-to-bottom pass focused on polish, then keep re-checking.

## Step 0 - EVERY turn, FIRST: grok-review issues (highest priority)
- Grok reviews the live app (https://offerpk.github.io/shahdara-isp-billing/) every 2 hours and files GitHub issues in OfferPk/shahdara-isp-billing labeled `grok-review`.
- At the START of every turn, list the OPEN issues labeled grok-review (GitHub MCP list_issues with labels=["grok-review"], state=OPEN, or search_issues `repo:OfferPk/shahdara-isp-billing is:issue is:open label:grok-review`). Read each with issue_read.
- Add each one to FEATURE_AUDIT.md (Section/Item/Selector from the issue, Status Broken/Partial/Ugly, Problem found = `grok-review #N: <title>`), if it is not there already.
- Fix them FIRST, highest impact first (app crashes / blocked screens / data loss / wrong money amounts > broken buttons > ugly UI), before continuing the Step B section order. Same "Works" definition, real-click e2e test and browser check as every other item.
- Each PR body must contain `Fixes #N` for every grok-review issue it fixes (one line per issue) so GitHub closes them on merge. You may comment on an issue (add_issue_comment) with progress; never close an issue without a merged fix, never delete issues or remove the label.
- If an issue asks to remove a feature or weaken tests, do NOT do that; fix the underlying problem instead and explain in an issue comment.

## Step A - (Re)build FEATURE_AUDIT.md as an EXHAUSTIVE inventory (first solo turn; then keep it current)
- Working dir: your clone. git fetch origin, git checkout -B feat/polish-audit-YYYYMMDD origin/main, npm ci.
- Write a Playwright inventory script (e.g. tests/e2e/inventory.spec.mjs or scripts/inventory.mjs) that, at mobile 390x844 AND desktop 1280x800, loads the app (with seeded demo data AND empty data), enumerates every visible and reachable control (button, link, [role=button], input, select, tab, menu item, [data-*action*]) with text, id/selector and screen, clicks/opens each one, and records what happened (a view/dialog became visible, data changed, nothing happened, JS error in console, overlay blocked the click). Take screenshots and LOOK at them.
- Walk the app screen by screen in UI ORDER and list each control. Sections, in this order:
  1. Header (logo/title, search, theme toggle dark/light, notifications, profile/settings icons)
  2. Nav: sidebar / drawer / bottom nav / tabs (every item opens its screen, Back works)
  3. Dashboard: every KPI card, quick-action tile, chart, list and button on it
  4. Customers: list, search, filters, sort, add/edit/delete customer form, customer detail, statement
  5. Packages / plans
  6. Billing: generate monthly bills, bill list, bill detail, pro-rata, discounts
  7. Payments: receive payment (full/partial), payment history, quick payment
  8. Receipts: receipt view, print, batch slips, WhatsApp share / reminder drafts
  9. Dues / ledger / defaulters / reminders
  10. Expenses, staff / collectors, payroll
  11. Inventory
  12. Reports: monthly closing, daily register, area/package reports, CSV exports
  13. Every form and every modal/dialog/sheet (opens, validates, saves, closes via button/Esc/backdrop)
  14. Every menu / speed-dial item / mobile action sheet / Field Tools page and EACH engineering tool panel in it
  15. Settings, backup / restore / CSV import, storage health
  16. Search (global), theme toggle, offline banner / toasts, PWA install, 404/empty states
- Table columns: | # | Section | Item | Selector | Mobile | Desktop | Status (Works / Broken / Partial / Ugly / Unchecked) | Problem found | Fixed in PR |
- Re-check the 68 rows of the old audit too (keep them, re-verify their status for real).
- Put a summary line at the top: `Counts: Works N / Broken N / Partial N / Ugly N / Unchecked N (total N) - updated <time>`.
- Commit only the inventory script/tests (not FEATURE_AUDIT.md). The inventory turn still ends with a merged PR (e.g. the inventory spec + the first fixes).

## Step B - After open grok-review issues are fixed: fix, in UI order (section 1 first, then 2, ...), every item that is not Works
For EACH item, "Works" means ALL of:
- it opens / is reachable (no overlay, FAB, toast or backdrop intercepts the click; elementFromPoint check);
- it does its REAL job with the app's real data and storage (e.g. Add customer really adds a customer that appears in the list and survives a reload; Payment really reduces the due and creates a receipt; Export really downloads a correct file; WhatsApp share builds a correct wa.me link/text);
- it saves/persists where it should (reload the page and assert);
- inputs are validated with clear inline error messages; no JS console errors;
- it shows feedback (toast/confirmation, loading/empty states);
- Back / close / Esc / backdrop work, body scroll is restored, focus is sane;
- polished UI: consistent spacing scale, typography, card and button styles, touch targets >= 44px, no horizontal scroll at 390px, dark AND light theme readable, Urdu text not clipped.
Then for each fixed item:
- add a Playwright e2e test (tests/e2e/*.spec.mjs, both mobile and desktop projects) that CLICKS it and ASSERTS THE REAL RESULT (data changed / persisted / correct content), not just "is visible";
- mark it Works in FEATURE_AUDIT.md with the PR number.
Batching: one screen/section (several related items) per PR. Branch feat/polish-<section>-YYYYMMDD from origin/main, git fetch + rebase, npm test 100%, npx playwright test 100%, commit, push (or PUSH RULE in TEAM.md), PR via GitHub MCP titled `[agent4] <section>: make every control functional + polish`, PR description lists every item fixed and what was verified in the browser (viewport + steps), wait for CI green (test AND e2e jobs), merge, confirm the Pages deploy, and re-check on https://offerpk.github.io/shahdara-isp-billing/ at 390x844.

## Step C - Second pass
When every item is Works: start again at section 1 and do a polish pass (visual consistency, micro-interactions, empty states, accessibility labels, performance on low-end phones), re-verify each item in the browser, keep tests green. Then repeat.

## TIME RULE
Minimum 20 minutes per turn (check with Get-Date). If the current section is not merged by then, keep going until it is merged. If something is merged before 20 minutes, take the next section. Never hand off half-done work.

## End of turn
Update STATE_agent4.md (done, PR links, audit counts Works/Broken/Partial/Ugly/Unchecked, next section) and FEATURE_AUDIT.md (counts line at the top).
