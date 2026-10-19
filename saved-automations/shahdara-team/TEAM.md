# SHAHDARA TEAM - sequential orchestrator (ONE run at a time, agents take turns)

Project: ONLY OfferPk/shahdara-isp-billing (https://github.com/OfferPk/shahdara-isp-billing).
Root: C:\Users\Perfect\shahdara-project
Agents (each has its OWN clone, area, TASK.md and STATE file):
- agent1 shahdara-dashboard  -> C:\Users\Perfect\shahdara-project\agent1 (branches feat/dash-*)
- agent2 shahdara-mobile-nav -> C:\Users\Perfect\shahdara-project\agent2 (branches feat/nav-*)
- agent3 shahdara-forms-qa   -> C:\Users\Perfect\shahdara-project\agent3 (branches feat/qa-*)
- agent4 shahdara-polish-qa  -> C:\Users\Perfect\shahdara-project\agent4 (branches feat/polish-*): QA + click tests + shared-CSS polish, owns no feature files (see agent4\TASK.md)

TEAM MODE (resumed 2026-10-19 by John; replaces the 2026-10-18 SOLO mode). Only ONE agent works at a time. ROTATION (4 slots, sequential, repeats forever):
  slot 1 = agent1 (Dashboard & Reports)
  slot 2 = agent2 (Mobile & Navigation)
  slot 3 = agent3 (Forms, Field Tools & Settings)
  slot 4 = agent4 (QA & Polish: verifies the merged work of slots 1-3 on the live site)
  after slot 4 comes slot 1 again.
Each agent works ONLY in its LANE (owned files/areas): see C:\Users\Perfect\shahdara-project\LANES.md (must follow; it is copied in short form into every agentN\TASK.md).
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md (must follow; this file wins if they differ).

## HARD SCOPE RULE (added 2026-10-17, overrides older ideas in STATE files)
- This repo is a small Pakistani ISP's offline BILLING / BUSINESS app. ALL NEW work must be billing/business features only: customers, packages, monthly bills, payments, receipts (incl. WhatsApp), dues/ledger, expenses, staff/collectors, reports, settings, backup/restore, and UI/UX polish of these.
- FORBIDDEN for new work: network / optical / routing engineering tools, calculators or simulators (OTDR, BGP, MPLS, SRv6, EVPN, DWDM, ROADM, OTN, PON/DBA physics, fiber splicing/cleaving, Raman/EDFA, PMD, Kerr, microwave, etc.). Do not create new dashboard-*/nav-*/qa-* modules of this kind and do not extend the existing ones.
- NEVER remove, hide or break existing features (including the engineering panels already in the app). Only add new billing features and improve existing ones. Grouping tools into one menu/page, collapsing menus by default and making overlays dismissible is allowed (every tool must stay reachable in at most 2 taps). Keep `npm test` 100% green.
- PREFER ENHANCING EXISTING FEATURES over adding new ones: before adding anything new, check whether an existing screen does it and make that one work and look better.
- Test for every task: "Does this help the owner bill, collect, track dues/expenses or run the business faster?" If not, pick the next task from your TASK.md backlog.
- Before building, search the code (rg) for an existing version of the feature. If it exists, extend and improve it instead of creating a duplicate.
- Take tasks from your TASK.md backlog in order (top first). STATE "NEXT" ideas about network engineering are void.


## LANE RULE (added 2026-10-19, all agents) - code must never collide
- Read LANES.md at the start of every turn. Edit ONLY files/areas owned by your lane. Shared files (index.html, app.js, styles.css, core.js) only inside your lane's blocks/functions, as LANES.md describes.
- A change needs another lane's file (or a agent4-owned (ex-Grok) module: customer-plan.js, customer-import*.js, bulk-collect.*, collect-setup.js, nav-quick-collect.js, screen-router.*, ui-feedback.* (toast/confirm), dark-contrast.css, payments-list.*, receipt.js, ...): do NOT edit it. Open a GitHub issue (GitHub MCP issue_write / create_issue) in OfferPk/shahdara-isp-billing with label `lane:agentN` or `lane:agent4`: file, function, what is needed, why, how to check. Note it in STATE_agentN.md and continue with work you can do in your lane.
- ALWAYS git fetch origin + git rebase origin/main right before opening the PR and again right before merging; rerun npm test and the e2e tests after every rebase. Resolve conflicts keeping the other lanes' work.
- grok-review issues FIRST, but only those in your lane (LANES.md lists them; a new grok-review issue belongs to the lane that owns its files).
- Before every edit, run `git diff --name-only origin/main` and check every listed file is in your lane. Put the line `Lane: agentN - files: <list>` in every PR body.

## BROWSER VERIFICATION RULE (all agents, added 2026-10-17)
- Unit tests are NOT enough. Before opening a PR, every agent opens the changed feature in a REAL browser at mobile 390x844 and desktop 1280x800: Playwright (`npx playwright test`; config + static server are added to the repo by agent4) or rea MCP capture_browser_scenario / capture_web_screenshot on a local server or the Pages preview.
- Check: the screen/dialog OPENS, every new button WORKS (click it), it CLOSES (close button / Esc / backdrop), Back works, and NO overlay, menu, FAB, toast or backdrop covers content when it should be closed. No horizontal scroll at 390px. Dark and light theme readable.
- When tests/e2e/*.spec.mjs exist, add or extend an e2e test for your feature (click its entry button, assert it becomes visible) and keep `npx playwright test` green. Never skip or weaken e2e tests.
- Write in the PR description what you verified in the browser (viewport + steps). If the browser check fails, fix it before the PR.

## Files
- TEAM.lock      C:\Users\Perfect\shahdara-project\TEAM.lock   (heartbeat lock for this run)
- NEXT_AGENT.txt C:\Users\Perfect\shahdara-project\NEXT_AGENT.txt  one line: `<slot> <agent>`, e.g. `2 agent2` (slot 1-4 from the ROTATION above)
- LANES.md       C:\Users\Perfect\shahdara-project\LANES.md (file ownership per agent)
- TEAM_STATE.md  C:\Users\Perfect\shahdara-project\TEAM_STATE.md (turn log: agent, slot, start, end, minutes, PR, result)
- QUOTA_WAIT.txt C:\Users\Perfect\shahdara-project\QUOTA_WAIT.txt  written ONLY by team-gate.ps1 after a 429 run (reset time, next hourly retry). Agents never edit/delete it; John may delete it to force a retry.
- LAST_CONV.txt  last conversation id started by the gate (gate-owned).
- AGENT_MODEL.txt (optional, John only) flash_lite | flash | pro -> passed to agentapi --model; absent = Antigravity default.

## 0. Lock (start of run)
- If TEAM.lock exists, was modified less than 90 minutes ago AND its content does not start with "gate-started" or "conversation", another team run is active: stop immediately and do nothing else.
- Otherwise overwrite TEAM.lock with: `running <current time from Get-Date -Format o>`.
- HEARTBEAT: after EVERY step (each command, file edit, test run, PR action), overwrite TEAM.lock with `running <Get-Date -Format o>`. Never let it go 30 minutes without a heartbeat. Waiting for CI: heartbeat between every check.

## 1. Start a turn
- Read NEXT_AGENT.txt to get slot S and agent:
  - Normal format `<slot> <agent>` (e.g. `3 agent3`): use slot S; the agent is the one the ROTATION gives for slot S.
  - Old 6-slot values: `1 agent1` -> slot 1; `3 agent2` -> slot 2; `5 agent3` -> slot 3; `2 agent4`, `4 agent4`, `6 agent4` -> slot 4. One-word `agentN` -> the slot of agentN.
  - Missing or invalid: slot 1 (agent1).
  Call the agent agentN.
- If C:\Users\Perfect\shahdara-project\agentN\RUNNING.lock was modified less than 15 minutes ago, it is a leftover from the old parallel setup: append a note to TEAM_STATE.md and skip to the next slot.
- Record the turn start: run `Get-Date -Format o` and append `## agentN (slot S) turn start <time>` to TEAM_STATE.md.
- Read LANES.md, then C:\Users\Perfect\shahdara-project\agentN\TASK.md and STATE_agentN.md (agent4 also reads FEATURE_AUDIT.md). List the open grok-review issues (GitHub MCP list_issues labels=["grok-review"], state open/OPEN) and the open `lane:agentN` issues; take the ones in YOUR lane first. IGNORE the RUNNING.lock step in any TASK.md (TEAM.lock replaces it) and IGNORE any "small/one focused improvement" wording: this turn is a BIG task.
- Work ONLY in C:\Users\Perfect\shahdara-project\agentN\shahdara-isp-billing and ONLY in agentN's LANE (LANES.md). Never edit another agent's folder, clone, branch or PR (exception: agent1 takes over PR #286 `feat/polish-home-height-278`, see agent1\TASK.md).

## 2. Do a LONG, COMPLETE task (minimum 20 minutes, no maximum)
- First: if agentN has an unfinished local branch or open PR, finish it completely (rebase on origin/main, tests, PR, CI, merge).
- Then take the open grok-review / lane:agentN issues of your lane (highest impact first), then the next item of agentN's TASK.md backlog (not a tiny tweak), and implement it FULLY following the 7-step WORKFLOW RULE and the REA RULE below: complete code, UI, wiring to existing data/functions, dark/light theme, mobile responsive, empty states, and tests. (agent4: verify slots 1-3's merged PRs on the live site, then QA + click tests + shared-CSS polish, see agent4\TASK.md.)
- Verify it in a real browser at 390x844 and 1280x800 (BROWSER VERIFICATION RULE).
- `npm test` must pass 100% (never delete or weaken tests). If tests/e2e exists, `npx playwright test` must pass too. git fetch origin, git rebase origin/main, run the tests again.
- Commit, push the agentN branch, open a PR via GitHub MCP (title prefix [agentN], body has `Fixes #N` per issue and the `Lane:` line), wait for CI green, merge it, then confirm the GitHub Pages preview workflow builds.
- TIME RULE: before handing off, run `Get-Date -Format o` and compare with the turn start.
  - Less than 20 minutes and the feature is merged: start the NEXT substantial item from agentN's TASK.md (same agent, same rules) and keep going.
  - 20 minutes or more but the current feature is NOT finished/merged: keep going until it is complete and merged. Never hand off half-done work.
  - 20 minutes or more AND the current feature is merged: the turn is complete.
- Never end a turn early after a small change. Never stop to ask the user anything; decide yourself and continue.

## 3. Hand off to the next slot
- Update agentN's STATE_agentN.md (done, PR links, NEXT ideas). agent4 also updates FEATURE_AUDIT.md.
- Append to TEAM_STATE.md: `agentN (slot S) turn end <time>, <minutes> min, PRs: <links>, result`.
- ADVANCE: next slot = S + 1 (after 4 comes 1). Overwrite NEXT_AGENT.txt with exactly:
  - finished slot 1 (agent1) -> `2 agent2`
  - finished slot 2 (agent2) -> `3 agent3`
  - finished slot 3 (agent3) -> `4 agent4`
  - finished slot 4 (agent4) -> `1 agent1`
- Heartbeat TEAM.lock.

## 4. Continue
- IMMEDIATELY start the next slot's turn in this same run (go to step 1). Do NOT end the conversation between agents.
- After 4 completed turns in this run (one full rotation), delete TEAM.lock (Remove-Item C:\Users\Perfect\shahdara-project\TEAM.lock) and end this conversation, so a fresh conversation (fresh context) continues the cycle automatically within 5 minutes from NEXT_AGENT.txt.
- QUOTA RULE: if a model call fails with quota / rate limit (429, RESOURCE_EXHAUSTED, 'Individual quota reached'), save STATE_agentN.md and TEAM_STATE.md (write the reset time if shown; do not advance NEXT_AGENT.txt if the turn is unfinished), then delete TEAM.lock and end. NEVER switch, rotate or add accounts/API keys to get around a quota; just wait for the reset.

## EFFICIENCY & QUOTA RULE (John, 2026-10-19) - save model quota, every agent, every turn
- START SMALL: read LANES.md, your agentN\TASK.md and the LATEST part of your STATE_agentN.md first (the top summary + the last NEXT/milestone section, e.g. Get-Content -Tail 120; agent4 also the open rows of FEATURE_AUDIT.md). Do NOT re-read whole STATE/TEAM_STATE history or the whole repo every turn.
- TARGETED READING: find code with rg/grep and REA aimed at YOUR lane (rea/trace_application_feature, rea/trace_web_source_location, inspect_web_event_listeners) and open only the files/line ranges you need. Run rea/analyze_javascript_application at most once per turn, only if the feature map is really needed.
- TESTS: while iterating run only the targeted tests (npm test -- <file/pattern>, npx playwright test <spec> --project <one>). Run the FULL npm test + full e2e suite (390x844 and 1280x800) ONCE before opening the PR, and again only if a rebase pulled new commits from main. CI is the final gate. (WORKFLOW RULE steps 3/4/6 still apply; this only removes repeated full runs while coding.)
- ONE FOCUSED ISSUE PER PR: each PR fixes one issue / one feature (Fixes #N). A turn can still contain several PRs; the 20-minute LONG turn rule stays.
- STATE AFTER EACH MILESTONE: after each milestone (root cause found, code done, tests green, PR opened, merged, live verified) append a short dated entry to STATE_agentN.md (what, PR/issue, NEXT). Keep entries short; never rewrite history. Then a quota stop loses nothing.
- ON A 429 / RESOURCE_EXHAUSTED / 'Individual quota reached': save STATE_agentN.md + TEAM_STATE.md (reset time if shown, do not advance NEXT_AGENT.txt if the turn is unfinished), remove TEAM.lock (Remove-Item C:\Users\Perfect\shahdara-project\TEAM.lock) and STOP. Never switch, rotate or add accounts/API keys. The gate (team-gate.ps1) then writes QUOTA_WAIT.txt and retries once per hour; never delete QUOTA_WAIT.txt yourself.

## BUDGET MODE (John, 2026-10-19 -> until the Oct 21 quota refresh, BUDGET.json "until" = 2026-10-21 12:30 PKT) - overrides the long-turn rules while active
- WHY: the bought quota must last ~2 days until the Oct 21 refresh. Before, one 3-hour run (4 long turns) used most of a day's quota; now runs are short and capped.
- The gate (team-gate.ps1) reads C:\Users\Perfect\shahdara-project\BUDGET.json: at most maxPerDay = 4 runs per local day, at least minGapMinutes = 240 (4 h) between run starts, ONE agent turn per run. The gate picks the agent from BUDGET.json "order" (agent1 -> agent3 -> agent2 -> agent4 -> agent1 -> agent3 -> agent2, i.e. agent4 only every other cycle) and writes NEXT_AGENT.txt itself; agents must NOT change NEXT_AGENT.txt in budget mode. agent4 (QA) runs with the cheaper flash_lite model ("models" in BUDGET.json); agents 1-3 use the default model. A run that dies on 429 is not counted.
- The gate prepends BUDGET_PROMPT.txt to TEAM_PROMPT.txt. Each turn = ONE focused issue, HARD CAP 45 minutes (the 20-minute minimum / keep-going / 4-turns-per-run rules are paused). Not done at 45 min: push the branch, DRAFT PR, short PLAN comment on the issue, write STATE, delete TEAM.lock, end.
- Read narrowly (LANES.md, TASK.md, latest STATE entry, the issue, then rg/REA on that issue's files only). No full-repo scans, no rea/analyze_javascript_application. Locally run only the targeted unit test + targeted e2e spec; CI runs the full suite (CI must be green before merge).
- Priority order: agent1 = #278 by finishing PR #286 (feat/polish-home-height-278), then #287; agent3 = #283, then #284; agent2 = #285; agent4 = live verification of the PRs merged since its last turn, results posted on the issues.
- AUTO-EXPIRY: after BUDGET.json "until" the gate ignores the budget and the normal cadence above returns (a full rotation per run, long turns). John can end it early by deleting BUDGET.json, or change maxPerDay / minGapMinutes / until / order / models in it.

## HELP GROK RULE (John, 2026-10-19) - Grok ONLY reviews the live app every 2 hours (Grok writes NO code; the agents do ALL coding)
- PR title `[agentN] #<issue> <short summary>`; body: `Fixes #N`, `Lane: agentN`, what you verified (tests, 390x844/1280x800, live). Label your issues/PRs `lane:agentN`.
- Write a PLAN only for yourself in the issue when a task is too big for one 45-min turn, then do it in small PRs over the next turns. Keep STATE_agentN.md current: after each milestone append a short dated entry `LAST: ... / PR: ... / NEXT: ...`; append one TEAM_STATE.md line per turn. Grok reads these to verify your work.
- Former Grok-owned modules (customer-plan, customer-import, bulk-collect, collect-setup, nav-quick-collect/profile, screen-router, ui-feedback toast/confirm, payments-list, receipt, dark-contrast) are now agent4's lane. Other agents: open a `lane:agent4` issue. Never edit another agent's open PRs.

## REA RULE (all agents) - understand before you fix (REA MCP `rea`, granted in the sidecar)
- When a feature/button is unclear or broken without an obvious cause, FIRST use REA before editing: rea/trace_application_feature, rea/inspect_web_event_listeners, rea/trace_web_source_location / rea/trace_javascript_semantics, then rea/observe_web_execution and rea/capture_browser_scenario; record what you still cannot explain with rea/record_unknown (rea/list_unknowns at turn start).
- After fixing, verify with rea/capture_browser_scenario + rea/compare_web_screenshots (390x844 and 1280x800) plus the Playwright e2e test; mention the REA evidence in the PR. If REA errors, note it in STATE and continue with Playwright.

## WORKFLOW RULE (John, 2026-10-18) - MANDATORY 7 steps for EVERY task, every agent, never skip one
1. UNDERSTAND THE REPO: git fetch + git switch main + git pull. Read the relevant files end to end (in your lane) and trace button -> listener -> handler -> data with REA. Write the root cause / plan in STATE_agentN.md before coding.
2. WRITE CODE: new branch (your lane prefix) from fresh origin/main. Complete fix/feature (UI + wiring + data + validation + feedback), never remove features, only lane files.
3. RUN TESTS: npm test AND npm run build AND the Playwright e2e tests against the BUILT dist/ folder at 390x844 and 1280x800. Add/extend an e2e test that clicks the control and asserts the real result.
4. FIX BUGS: anything failing (tests, console errors, 404s, overlays) -> fix and re-run step 3 until 100% green. Never weaken, skip or delete tests.
5. REVIEW: self-review git diff origin/main like a senior reviewer (dead code, duplicates, other screens, mobile, dark/light, accessibility, lane check). Short review summary in the PR body.
6. PUSH: git fetch + git rebase origin/main, re-test, commit, push (or the PUSH RULE fallback), PR with `Fixes #N`, wait for ALL CI checks green, rebase again if main moved, squash-merge.
7. VERIFY DEPLOYMENT: wait for the GitHub Pages deploy to succeed, then open the LIVE site https://offerpk.github.io/shahdara-isp-billing/ in Playwright (mobile + desktop, hard reload / bypass the service worker) and confirm it works live (opens, does its job, 0 console errors, 0 failed requests). Screenshots as evidence, comment on the issue. If live is broken the task is NOT done: back to step 1.
A task counts as done only after step 7 passes. Record each step's result in STATE_agentN.md.

## Command rules
- Run every terminal command as ONE single command: no cd/Set-Location, no && or ;. Set the working directory via the tool.
- Never start long-running background servers by hand; let Playwright's webServer config start and stop the static server.
- Never commit agent files (AGENTS.md, GEMINI.md, TEAM*.md, LANES.md, NEXT_AGENT.txt, STATE*.md, TASK.md, FEATURE_AUDIT.md, *.lock, .agent) into the repo.
- Never touch any other repo, never create repos, never push to main directly, never force-push main.

## PUSH RULE (important)
- This PC has NO saved git login. If `git push` fails, asks for credentials, or does not finish within 2 minutes, do NOT retry it and do NOT wait. Instead upload the branch with the GitHub MCP: mcp(github/create_branch) from main, then mcp(github/push_files) with ALL changed files of your commit (read them from the local clone; include package.json AND package-lock.json when dependencies changed), then create_pull_request, wait for CI, merge_pull_request. After merge: git fetch origin, then git switch main, then git pull, so the local clone matches GitHub.
- Never stop the turn because of a push problem.
