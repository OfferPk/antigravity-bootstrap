# LANES - strict file ownership (team mode, set 2026-10-19 by John)

Every agent edits ONLY the files/areas of its own lane. This is what keeps the four agents from colliding.

## Lane rules (all agents)
1. Before editing ANY file, check it is in your lane below. If it is not, do NOT edit it.
2. A change needs a file from another lane -> open a GitHub issue in OfferPk/shahdara-isp-billing with label `lane:agentN` describing exactly what is needed (file, function, why, acceptance check), link it in your STATE file, and continue with work that does not need it. Never "just quickly" edit another lane's file.
3. Shared files (`index.html`, `app.js`, `styles.css`, `core.js`) are split by AREA:
   - `index.html`: edit only the markup blocks of your lane's views/dialogs (listed per lane). New screens = new `<section>`/`<dialog>` blocks, appended, never restructure other blocks.
   - `app.js`: edit only the functions of your lane's area. Prefer a NEW module file (`<lane-topic>.js`) imported/loaded once, over growing app.js. Customer / payment / Quick Collect / toast code in app.js is agent4-owned (ex-Grok).
   - `core.js` (data layer): ADDITIVE only (a new exported function + unit test). Never change an existing function's behaviour or a storage key/shape; that needs a `lane:agent4` issue.
   - `styles.css`: lane-scoped selectors only (your views' ids/classes). Global/shared visual changes = agent4 only, small PRs.
   - `tests/`: add your own new spec/test files. Change another lane's test only when your required behaviour change breaks it, and say so in the PR (never weaken it).
4. ALWAYS: `git fetch origin` then `git rebase origin/main` right before opening the PR AND again right before merging (rerun `npm test` + e2e after a rebase). Resolve conflicts KEEPING the other lane's work.
5. One agent at a time (TEAM.lock). Your branch prefix is your lane's (feat/dash-*, feat/nav-*, feat/qa-*, feat/polish-*).
6. grok-review issues FIRST, but only the ones in your lane (list below; new grok-review issues: take it if its files are in your lane, otherwise leave it for the owner lane).

## agent1 - Dashboard & Reports (shahdara-dashboard, branches feat/dash-*)
- Owns: `dashboard.js`, `dashboard.css`, `dashboard-charts.js`, `dashboard-collection-target.js`, `dashboard-daily-closing.js`, `dashboard-dues-aging.js`, `dashboard-top-defaulters.js`, `dashboard-area-collections.js`, `dashboard-package-revenue.js`, `dashboard-pnl.js`, `dashboard-mom-growth.js`, `owner-insights.js`, `owner-ui.js`, `phase3.js`, `home-today.js` (arrives with PR #286), every other `dashboard-*.js` (engineering panels: keep working, do not extend), new report modules you create (e.g. `reports-*.js`, `bills-screen.js`).
- index.html areas: Home / dashboard (`#homePrimaryActions`, `#homeKpiStrip`, `#homeActionDuesList` and the dashboard sections), Monthly Bills, Monthly Report, Analytics, Dues Recovery, Smart Alerts, report modals.
- Issues: #278 Home ~33,000 px (take over / finish agent4's PR #286 `feat/polish-home-height-278`, e2e is failing; do NOT hide Daily Closing or Backup), #287 separate Bills / Monthly Report / Dues Recovery / Smart Alerts screens with Generate bills + print invoices, #231 owner daily summary card, #227 disconnect / reconnect work lists, and the last `confirm()` popup in `dashboard-collection-target.js` (Remove target) -> `await window.appConfirm({...})`.
- Old paused branch `feat/dash-staff-collector-performance-20261018` (agent1 clone): no commits, 2 uncommitted files (`dashboard.js` changes + new `dashboard-staff-performance.js`). If still useful (staff / collector performance), commit it, rebase on origin/main and finish it as one task; otherwise `git stash` it with a note in STATE_agent1.md. Do not throw the work away.
- Routing: a new screen route needs `screen-router.js` (agent4-owned, ex-Grok) -> open a `lane:agent4` issue with the route spec (hash, view id, primary action); until then render inside the existing view.

## agent2 - Mobile & Navigation (shahdara-mobile-nav, branches feat/nav-*)
- Owns: `nav.js`, `nav.css`, `nav-accessibility.js`, `nav-language.js`, `nav-pwa.js`, `nav-customer-search.js`, `sw.js`, `build.mjs` (performance only), manifest/PWA files.
- index.html areas: header/top bar, desktop sidebar, mobile drawer, bottom nav, More menu, speed dial (`#mobileSpeedDial`), global search, language toggle.
- Integrates with `screen-router.js` through its public hooks (`updateNavActive`, `data-screen` on body); changes inside `screen-router.js` -> `lane:agent4` issue.
- Issues: #285 bottom nav highlights Home on Backup / Settings / Owner Assistant + the + button covers the More menu, #280 leftovers (nav polish), any nav highlight bug, #228 Urdu mode (nav-language.js and labels), #219 performance (bundle / lazy-load in build.mjs + sw.js; no index.html restructuring of other lanes' blocks).

## agent3 - Forms, Field Tools & Settings (shahdara-forms-qa, branches feat/qa-*)
- Owns: `form-validation.js`, every field-tool module `nav-<tool>.js` (nav-optical-attenuator.js, nav-optical-return-loss.js, nav-otdr-*.js, nav-fiber-*.js, nav-fusion-splice.js, nav-gps-tracking.js, nav-tube-shaving.js, nav-mpo-polarity.js, nav-olts-cert.js, nav-wdm-spectrum.js, nav-van-inventory.js, nav-collection-rounds.js, ... all field tools), every `qa-*.js`, `reminder-queue.js`, `nav-pending-actions.js`, `digital-payments-settings.js`, `backup-store.js`, `qa-backup-csv-import.js`.
- index.html areas: Field Tools sheet/page and each tool dialog, Reminders / Pending Actions, Settings, Backup / Restore / CSV import, Expenses & Staff forms, Inventory forms.
- Issues: #283 Field Tools sheet - Attenuator and Return Loss open nothing (only the first [data-open-*] button is wired), the remaining field-tool `confirm()` popups (nav-mpo-polarity.js, nav-fiber-identifier.js, nav-gps-tracking.js, nav-tube-shaving.js, nav-olts-cert.js; dashboard-collection-target.js is agent1's) -> use `await window.appConfirm({tone, title, message, confirmLabel})` (agent4-owned (ex-Grok) ui-feedback.js, already used in app.js), #284 Reminders Today Queue empty (catch-up stages), #232 optional encrypted backup, #226 Bluetooth thermal printing (new module; receipt.js changes via `lane:agent4` issue).

## agent4 - QA & Polish (shahdara-polish-qa, branches feat/polish-*)
- Does NOT own feature files. Owns: `tests/e2e/**` (new click-test specs), `scripts/**`, `playwright.config.*`, `FEATURE_AUDIT.md`, shared look in `styles.css` (small PRs), new `tokens.css` / styleguide for #230.
- Job: click-test the whole LIVE app at 390x844 and 1280x800, review and verify every other lane's merged PR on the live site, write real click tests, polish small shared UI issues. For anything in a feature file: open an issue for the owner lane (`lane:agentN` / `lane:agent4`) with steps, screenshot path and expected result.
- Issues: #229 accessibility baseline in CI (axe), #230 design tokens / styleguide (shared CSS only), QA of all merged work. PR #286 is handed over to agent1 (do not continue it).
- agent4 OWNS the former Grok modules (see LANES.md): fix them in small focused PRs after reading the notes of PRs #291 #295 #299; never remove their features.

## agent4 lane: former Grok-owned files (John, 2026-10-19: Grok no longer writes code; agent4 owns these now)
`customer-plan.js`, `customer-import.js`, `customer-import-core.js`, `customer-import.css`, `bulk-collect.js`, `bulk-collect.css`, `collect-setup.js`, `nav-quick-collect.js`, `nav-quick-profile.js`, `screen-router.js`, `screen-router.css`, `ui-feedback.js`, `ui-feedback.css` (toast + in-app confirm), `dark-contrast.css`, `payments-list.js`, `payments-list.css`, `profile-ui.js`, `profile-labels.js`, `package-catalog.js`, `receipt.js`, `duplicate-detection.js`, and the customer / payment / Quick Collect parts of `app.js`. Issues #225 (customer statement) stay with Grok.
agent4 implements fixes here (small focused PRs; read the notes of PRs #291 #295 #299 first). Other agents: bugs here -> open an issue labeled `lane:agent4`.

## agent5 - Easypaisa Email Reader (added 2026-10-19, John) - issue #305 only
- Folder/clone: C:\Users\Perfect\shahdara-project\agent5\shahdara-isp-billing, branches feat/easypaisa-*, label lane:agent5.
- OWNS: integrations/gmail-easypaisa/**, the Easypaisa parser module, the new Payments Inbox module (payments-inbox.* / easypaisa-*.js/css), their unit tests and e2e specs (tests/easypaisa-*, tests/e2e/easypaisa-*), and the route #/easypaisa.
- Additive wiring allowed: one script/link tag in index.html and one #/easypaisa route entry in screen-router.js (existing pattern); otherwise a lane:agent4 issue.
- Payment recording ONLY through the existing payment API/logic and toast/confirm system; never edit other lanes' files for it (open a lane:agent4 / lane:agentN issue if the API lacks something).
- Issue: #305. When merged + live-verified, agent5 writes agent5\DONE.txt and leaves the rotation.
