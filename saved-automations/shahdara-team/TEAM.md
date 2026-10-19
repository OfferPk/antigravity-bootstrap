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
- A change needs another lane's file (or a Grok-owned module: customer-plan.js, customer-import*.js, bulk-collect.*, collect-setup.js, nav-quick-collect.js, screen-router.*, ui-feedback.* (toast/confirm), dark-contrast.css, payments-list.*, receipt.js, ...): do NOT edit it. Open a GitHub issue (GitHub MCP issue_write / create_issue) in OfferPk/shahdara-isp-billing with label `lane:agentN` or `lane:grok`: file, function, what is needed, why, how to check. Note it in STATE_agentN.md and continue with work you can do in your lane.
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
