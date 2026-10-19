# TASK - agent4 'shahdara-polish-qa' (TEAM MODE since 2026-10-19, slot 4 after agent1/2/3): QA & Polish lane - verify everything works live, real click tests, shared-CSS polish
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent4\shahdara-isp-billing
Branch prefix: feat/polish-<section>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent4\STATE_agent4.md
Your audit file: C:\Users\Perfect\shahdara-project\agent4\FEATURE_AUDIT.md (lives OUTSIDE the repo, never commit it)
Shared rules: C:\Users\Perfect\shahdara-project\TEAM.md, LANES.md and AGENTS.md (must follow)

## Why
Solo mode (2026-10-18/19) brought the audit to 118/118 Works. Since 2026-10-19 the 4 agents run again in TEAM MODE, one at a time (agent1 -> agent2 -> agent3 -> agent4), each in its own LANE so code never collides. You run in slot 4, after the three feature lanes. Your job: click-test the WHOLE live app at 390x844 and 1280x800, review and verify the work the other agents merged since your last turn (on the LIVE site), write real click tests, keep FEATURE_AUDIT.md true, and polish small shared UI issues in shared CSS only, via small PRs. You do NOT own feature files: anything broken inside a feature file goes to the owner lane as an issue.

## TEAM MODE + YOUR LANE (2026-10-19, overrides anything below that conflicts)
- TEAM MODE (resumed 2026-10-19 by John): agents take turns ONE AT A TIME, sequential rotation agent1 -> agent2 -> agent3 -> agent4 -> agent1 (TEAM.md, TEAM.lock heartbeat after every step).
- LANE RULE: edit ONLY the files/areas of your lane below (full table: C:\Users\Perfect\shahdara-project\LANES.md). If a change needs another lane's file or a Grok-owned module (customer-plan.js, customer-import*.js, bulk-collect.*, collect-setup.js, nav-quick-collect.js, screen-router.*, ui-feedback.* toast/confirm, dark-contrast.css, payments-list.*, receipt.js, profile-ui.js ...), do NOT edit it: open a GitHub issue labeled `lane:agentN` / `lane:grok` and continue with in-lane work. Before committing run `git diff --name-only origin/main` and check every file is in your lane; put `Lane: <agent> - files: <list>` in the PR body.
- ALWAYS git fetch origin + git rebase origin/main right before opening the PR and again right before merging (rerun npm test + e2e).
- ORDER each turn: (1) finish your own open branch/PR, (2) open grok-review issues of YOUR lane (highest impact first, `Fixes #N` in the PR), (3) open `lane:agent4` issues, (4) the BACKLOG below.
- Every task follows the 7-step WORKFLOW RULE and the REA RULE in TEAM.md (understand repo + REA trace -> code -> tests on built dist at 390x844 and 1280x800 -> fix bugs -> self-review -> push/PR/CI green/squash-merge -> verify LIVE). Done only after live verification. Minimum 20 minutes per turn, keep going until merged.
- Never remove or hide features, never weaken/skip/delete tests, never rename/drop storage keys.

### Your lane
- Does NOT own feature files. Owns: `tests/e2e/**` (new click-test specs), `scripts/**`, `playwright.config.*`, `FEATURE_AUDIT.md`, shared look in `styles.css` (small PRs), new `tokens.css` / styleguide for #230.
- Job: click-test the whole LIVE app at 390x844 and 1280x800, review and verify every other lane's merged PR on the live site, write real click tests, polish small shared UI issues. For anything in a feature file: open an issue for the owner lane (`lane:agentN` / `lane:grok`) with steps, screenshot path and expected result.
- Issues: #229 accessibility baseline in CI (axe), #230 design tokens / styleguide (shared CSS only), QA of all merged work. PR #286 is handed over to agent1 (do not continue it).
- Small fixes in Grok-owned modules are allowed ONLY after reading `docs/` / PR notes of the last Grok PRs (#291 #295 #299), keep them tiny, and mention `lane:grok` in the PR.
- PR #286 (`feat/polish-home-height-278`, Home length #278, e2e failing) is HANDED OVER to agent1. Do not push to it; leave your local branch as it is (agent1 continues it from GitHub).
- Turn order for you: (1) list PRs merged since your last turn (GitHub MCP list_pull_requests state closed) and verify each one LIVE at both sizes; anything broken -> issue for the owner lane (`lane:agentN`), with steps + screenshot; (2) grok-review issues in your lane (#229, #230); (3) Step B/C below as a QA pass: fix only test files and shared CSS yourself, file issues for everything else.

## Hard rules
- NEVER remove features. Fix and enhance them. Allowed: collapse menus by default, group items (e.g. all engineering tools on ONE "Field Tools" page/sheet), make overlays dismissible/non-blocking, restyle, re-order, fix wiring. Every existing tool must stay reachable in at most 2 taps.
- Engineering tool panels (OTDR, BGP, DWDM, fiber, etc.): keep them, make each one open, work and close properly, grouped tidily under Field Tools. Do NOT add new ones.
- Never weaken, skip (.skip/.fixme), or delete tests (unit or e2e). Keep `npm test` and `npx playwright test` 100% green.
- Never rename or drop a localStorage key or change saved data shapes destructively.
- LANE: you may edit tests/e2e/**, scripts/**, playwright config, styles.css (shared look, small PRs) and new tokens.css/styleguide files. Feature files (index.html blocks, app.js, nav*.js, dashboard*.js, qa-*.js, Grok-owned modules) belong to other lanes: open an issue labeled `lane:agentN` / `lane:grok` instead (tiny Grok-module fixes only per LANES.md).
- Status in FEATURE_AUDIT.md must come from a REAL browser check (Playwright clicking it), never from reading code.
- Never declare the job done while ANY item is not Works. When ALL items are Works, do a SECOND full top-to-bottom pass focused on polish, then keep re-checking.

## REA RULE - understand before you fix (REA MCP `rea`, already granted in the sidecar)
- START OF A FULL QA PASS (once per full pass, and again if the audit is rebuilt): run `rea/analyze_javascript_application` on the app (the agent4 clone, or the local Playwright server http://localhost:4173 / https://offerpk.github.io/shahdara-isp-billing/) to build a FEATURE MAP: every screen, module, button/control, event handler and storage key. Use that map to make the FEATURE_AUDIT.md inventory COMPLETE (every control REA finds must have a row), and save a short summary of the map at the bottom of FEATURE_AUDIT.md under `## REA feature map`.
- WHENEVER a feature/function/button's behaviour is unclear, or it is broken without an obvious cause, FIRST use REA to understand it, BEFORE editing code:
  1. trace it: `rea/trace_application_feature` (button -> event listener -> handler -> data/storage), `rea/inspect_web_event_listeners` (what is actually bound to the element, or nothing), `rea/trace_web_source_location` / `rea/trace_javascript_semantics` (which source code runs and what it does);
  2. watch it run: `rea/observe_web_execution` (click it and observe calls, errors, storage writes) and `rea/capture_browser_scenario` (reproduce the steps, capture screens/console);
  3. anything you still cannot explain: `rea/record_unknown` (and `rea/list_unknowns` at the start of each turn; `rea/update_unknown` / `rea/verify_unknown_resolution` when solved).
  Write the findings into the item's row in FEATURE_AUDIT.md (`Problem found`: listener/handler/storage path and root cause, e.g. "no listener bound - setupX() never called", "overlay #y intercepts click", "writes key z but list reads key w").
- THEN fix. AFTER fixing, verify with REA `rea/capture_browser_scenario` (same steps, now working) and `rea/compare_web_screenshots` (before vs after, 390x844 and 1280x800) PLUS the Playwright e2e test. Mention the REA evidence in the PR description.
- If the rea MCP is unavailable or errors, note it in STATE_agent4.md and continue with Playwright (do not stop the turn).

## Step 0 - EVERY turn, FIRST: grok-review issues (highest priority)
- Grok reviews the live app (https://offerpk.github.io/shahdara-isp-billing/) every 2 hours and files GitHub issues in OfferPk/shahdara-isp-billing labeled `grok-review`.
- At the START of every turn, list the OPEN issues labeled grok-review (fix only those in YOUR lane; for the others check they are listed in LANES.md / labeled for the owner lane, and add a `lane:agentN` label or comment if missing) (GitHub MCP list_issues with labels=["grok-review"] and the open state value that tool accepts (e.g. "open" or "OPEN"; if one is rejected use the other), or search_issues `repo:OfferPk/shahdara-isp-billing is:issue is:open label:grok-review`). Read each with issue_read.
- Add each one to FEATURE_AUDIT.md (Section/Item/Selector from the issue, Status Broken/Partial/Ugly, Problem found = `grok-review #N: <title>`), if it is not there already.
- Fix them FIRST, highest impact first (app crashes / blocked screens / data loss / wrong money amounts > broken buttons > ugly UI), before continuing the Step B section order. Same "Works" definition, real-click e2e test and browser check as every other item.
- Each PR body must contain `Fixes #N` for every grok-review issue it fixes (one line per issue) so GitHub closes them on merge. You may comment on an issue (add_issue_comment) with progress; never close an issue without a merged fix, never delete issues or remove the label.
- If an issue asks to remove a feature or weaken tests, do NOT do that; fix the underlying problem instead and explain in an issue comment.

## Step A - (Re)build FEATURE_AUDIT.md as an EXHAUSTIVE inventory (already built: 118 rows; keep it current, add rows for every new control the other lanes merge)
- Working dir: your clone. git fetch origin, git checkout -B feat/polish-audit-YYYYMMDD origin/main, npm ci.
- FIRST run `rea/analyze_javascript_application` (REA RULE) to get the feature map; the inventory must cover every control it finds.
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
For EACH item that is not Works or behaves unclearly: apply the REA RULE first (trace -> observe -> record unknowns -> write findings), then fix, then verify with REA capture_browser_scenario/compare_web_screenshots + Playwright.
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

## MANDATORY FULL WORKFLOW FOR EVERY TASK (John, 2026-10-18) - never skip a step
1. UNDERSTAND THE REPO: git fetch + git switch main + git pull. Read the relevant files end to end (index.html, app.js and the modules the feature uses, storage/data layer, CSS, existing tests). Use REA (analyze_javascript_application / trace_application_feature / inspect_web_event_listeners) to trace button -> listener -> handler -> data. Write the root cause / plan in FEATURE_AUDIT.md before coding.
2. WRITE CODE: new branch feat/polish-* from fresh origin/main. Implement the complete fix (tests / shared CSS only, per LANE), never remove features.
3. RUN TESTS: npm test (unit) AND npm run build AND the Playwright e2e tests against the BUILT dist/ folder (not the repo folder) at 390x844 and 1280x800. Add/extend an e2e test that clicks the control and asserts the real result.
4. FIX BUGS: if anything fails (tests, console errors, 404s, overlays), fix and re-run step 3 until 100% green. Never weaken or delete tests.
5. REVIEW: self-review the full diff (git diff origin/main) like a senior reviewer: dead code, duplicated logic, broken other screens, mobile layout, dark/light, accessibility, console errors. Re-test anything touched. Write a short review summary in the PR body.
6. PUSH: git fetch + git rebase origin/main, re-test, commit, push (or GitHub MCP push fallback per TEAM.md), open PR with 'Fixes #N', wait for ALL CI checks green, squash-merge.
7. VERIFY DEPLOYMENT: wait for the GitHub Pages deploy workflow to finish successfully, then open the LIVE site https://offerpk.github.io/shahdara-isp-billing/ in Playwright (mobile + desktop, hard reload / bypass service worker cache) and confirm the fix works live: control opens, does its job, 0 console errors, 0 failed requests. Capture REA/Playwright screenshots as evidence and comment on the issue. If live is broken, the task is NOT done: go back to step 1 immediately.
A task counts as done only after step 7 passes. Record each step's result in STATE_agent4.md.
