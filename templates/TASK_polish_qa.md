# TASK - optional POLISH / QA agent (real-browser checks + UI polish of EXISTING features)
Use this as the TASK.md of an extra agent (e.g. agentN 'polish-qa', branches feat/polish-*) when unit tests pass but the real UI is broken
(menus that cover the screen, buttons that do nothing, overlays that never close). Replace <repo>, <clone>, <agent> and <preview-url>.
Example: saved-automations/shahdara-team/agent4/TASK.md (John's Shahdara setup).

## Rules
- Do NOT build new features. Make every EXISTING feature and button actually work and look good, one feature at a time.
- Never remove features. Allowed: collapse menus by default, group many items into one "More tools" page/menu, make overlays dismissible and non-blocking, restyle, fix wiring. Every existing feature stays reachable in at most 2 taps.
- Never weaken, skip or delete tests (unit or e2e). Never rename/drop storage keys.

## Method (every turn)
a) Build + serve the app locally and check it in a REAL browser at mobile 390x844 and desktop 1280x800:
   Playwright (`npm install --save-dev @playwright/test`, `npx playwright install chromium`, a zero-dependency `tests/e2e/static-server.mjs`
   and `playwright.config.mjs` with `webServer` so Playwright starts/stops the server itself; mobile + desktop projects), and/or the
   rea MCP tools capture_browser_scenario / capture_web_screenshot on <preview-url>. Look at screenshots before and after each fix.
   Name e2e files `*.spec.mjs` so `node --test` does not pick them up.
b) Keep `<agent>/FEATURE_AUDIT.md` (outside the repo): every nav item, button, menu item, tile, dialog and form with status
   Works / Broken / Ugly / Unchecked, from real browser checks only.
c) Fix the highest-impact Broken items first (overlays covering content, menus stuck open, items that do not open their screen,
   dialogs that do not close, Back not working), then Ugly ones.
d) Add Playwright e2e tests that click each main button and assert the target view becomes visible and that nothing covers the
   main content when menus are closed. Add `"test:e2e": "playwright test"` and a separate CI `e2e` job.
e) Polish the fixed item: spacing, typography, cards, touch targets >= 44px, empty states, dark/light, RTL/Urdu-friendly where relevant,
   no horizontal scroll at 390px.
f) Rebase, unit tests + e2e 100%, PR, CI green, merge, re-check on <preview-url>.

## Recommended rotation in team mode
Run the polish agent after EVERY feature agent, e.g. with 3 feature agents:
agent1 -> polish -> agent2 -> polish -> agent3 -> polish -> repeat (6 slots). NEXT_AGENT.txt then holds '<slot> <agent>'.
See saved-automations/shahdara-team/TEAM.md for a complete working example.
