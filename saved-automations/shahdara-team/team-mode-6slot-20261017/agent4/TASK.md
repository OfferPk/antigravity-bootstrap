# TASK - agent4 'shahdara-polish-qa': make EVERY existing feature and button actually work and look great
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent4\shahdara-isp-billing
Branch prefix: feat/polish-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent4\STATE_agent4.md
Your audit file: C:\Users\Perfect\shahdara-project\agent4\FEATURE_AUDIT.md (lives OUTSIDE the repo, never commit it)
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md and TEAM.md (must follow)

## Why you exist
The owner opened the app on his phone and "nothing opens": a floating speed-dial menu (Wi-Fi Survey, Optical Budget, FAT Matrix, ONT Diag, Fiber Probe, Splitter Tree, Macro-Bend, Attenuator, Return Loss, Reminders, Scroll to Top) stays EXPANDED and covers the whole mobile screen, an "offline" toast overlaps content, and buttons do nothing. 1,400+ unit tests pass but none of them checks the real UI in a browser. Your job: make the app WORK in a real browser, one feature at a time. You do NOT build new features.

## Hard rules for agent4
- NEVER remove features. Fix and enhance them. Allowed: collapse menus by default, move items into a grouped menu/page (e.g. one "Field Tools" / "More tools" page listing every engineering tool), make overlays dismissible and non-blocking, restyle, re-order, fix wiring. Every existing tool must stay reachable in at most 2 taps.
- Never weaken, skip or delete tests (unit or e2e). Never mark an e2e test .skip/.fixme to get green. Keep `npm test` 100% green.
- Never rename or drop a localStorage key or change saved data shapes destructively.
- You may edit shared files (index.html, app.js, nav.js, nav.css, styles.css, dashboard.css, ...) because polish needs it, but keep each change minimal and targeted, and never revert other agents' work.

## Method (EVERY turn)
a) Build + serve + real browser checks
   - Working dir: your clone. git fetch origin, git checkout -B feat/polish-<topic>-YYYYMMDD origin/main, npm ci (or npm install).
   - First turn only (if missing): add Playwright: `npm install --save-dev @playwright/test`, then `npx playwright install chromium`.
   - Add (once) a tiny zero-dependency static server `tests/e2e/static-server.mjs` (node:http serving the repo root, or ./dist after `npm run build`, on port 4173) and `playwright.config.mjs` with testDir 'tests/e2e', testMatch '**/*.spec.mjs', webServer { command: 'node tests/e2e/static-server.mjs', port: 4173, reuseExistingServer: true }, and 2 projects: mobile (viewport 390x844, isMobile, hasTouch) and desktop (1280x800). Playwright starts/stops the server itself, so you never need a background process.
   - Run `npx playwright test` (one single command). Use Playwright screenshots (page.screenshot) and/or rea MCP capture_browser_scenario / capture_web_screenshot (on the Pages preview https://offerpk.github.io/shahdara-isp-billing/ or a local server) to SEE the screens at 390x844 and 1280x800. Look at the screenshots before and after every fix.
   - Name e2e files `*.spec.mjs` so `node --test` (npm test) does not pick them up.
b) FEATURE_AUDIT.md (outside the repo, in your agent4 folder)
   - One table of EVERY nav item, drawer item, bottom-bar item, speed-dial item, quick-action tile, header button, dialog/panel and main form: | Area | Item | Selector | Mobile | Desktop | Status (Works / Broken / Ugly / Unchecked) | Notes | Fixed in PR |
   - First turn: fill it by enumerating the DOM (e.g. a Playwright script that lists all buttons/links with text, id, data-* attributes and whether clicking them makes a view/dialog visible). Update it every turn. Status must come from a real browser check, not from reading code.
c) Fix the highest-impact Broken items first, then Ugly ones. Priority order:
   1. FIRST TASK: the mobile speed-dial (index.html #mobileSpeedDial / #speedDialMenu / #speedDialBackdrop, nav.js setupMobileSpeedDial, nav.css .speed-dial-*, plus nav-*.js files that inject speedDial*Btn items). It must be COLLAPSED by default on load, open only on trigger tap, close on outside tap / backdrop / Esc / item click / navigation, never cover content when closed, show max 5 items (billing first: Search, Payment, Add customer, Reminders, Scroll to top), and put ALL the other tools (Wi-Fi Survey, Optical Budget, FAT Matrix, ONT Diag, Fiber Probe, Splitter Tree, Macro-Bend, Attenuator, Return Loss, ...) into ONE "More tools" / "Field Tools" item that opens a grouped page or sheet listing every tool. Check whether CSS display rules override the `hidden` attribute (add `[hidden]{display:none !important}` for these components if so). Every tool must still open from the new menu.
   2. Toasts/snackbars (offline / connection / sync): bottom-safe, never covering the bottom nav or form buttons, auto-dismiss, tap to dismiss, max one at a time, no repeated offline toast on every load.
   3. Every bottom-nav / drawer / sidebar item opens its screen; every dialog opens AND closes (close button, Esc, backdrop); Back (browser back + in-app back) returns to the previous screen; no stuck overlay/backdrop; body scroll restored after closing.
   4. Main billing flow click-through: add customer -> generate bill -> take (partial) payment -> receipt -> WhatsApp draft -> reports -> backup. Fix what breaks.
   5. Quick-action tiles and dashboard cards: each opens the right thing.
d) Playwright e2e tests in tests/e2e/*.spec.mjs: for each main button/menu item, click it and assert the target view/dialog becomes visible (toBeVisible / toBeInViewport), and that no overlay intercepts clicks on main content when menus are closed (e.g. speed-dial menu hidden on load; document.elementFromPoint at screen center is not inside the speed-dial). Run both mobile and desktop projects. Wire them in: add "test:e2e": "playwright test" to package.json and a separate `e2e` job in .github/workflows/ci.yml (npm ci, npx playwright install --with-deps chromium, npx playwright test, upload playwright-report on failure). Keep `npm test` (node --test) unchanged and green. Keep e2e fast (< 3 min) and non-flaky (no fixed sleeps; auto-waiting locators).
e) UI polish of the item you fixed: consistent spacing scale, typography, card style, touch targets >= 44px, clear empty states, dark AND light theme, Urdu-friendly text (no clipped Urdu, RTL where Urdu), no horizontal scroll at 390px. Before/after notes in the PR description.
f) git fetch origin, git rebase origin/main, npm test 100%, npx playwright test 100%, commit, push (or PUSH RULE in TEAM.md), PR via GitHub MCP with title prefix [agent4], wait for CI green (test AND e2e jobs), merge, confirm the Pages deploy and re-check the fixed item on https://offerpk.github.io/shahdara-isp-billing/ at 390x844.

## TIME RULE
Minimum 20 minutes per turn (check with Get-Date). If the current fix is not merged by then, keep going until it is merged. If something is merged before 20 minutes, take the next Broken item from FEATURE_AUDIT.md. Never hand off half-done work.

## End of turn
Update STATE_agent4.md (done, PR links, audit counts Works/Broken/Ugly/Unchecked, next item) and FEATURE_AUDIT.md.
