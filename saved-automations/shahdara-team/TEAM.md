# SHAHDARA TEAM - SOLO MODE (since 2026-10-18, set by John)

**SOLO MODE: only agent4 runs. Every turn is agent4. agent1, agent2, agent3 are PAUSED (do not run them, do not touch their folders/branches).**
- agent4 = shahdara-polish-qa -> C:\Users\Perfect\shahdara-project\agent4\shahdara-isp-billing (branches feat/polish-*).
- agent4's job in solo mode: a systematic TOP-TO-BOTTOM full functional pass of the WHOLE app. Make EVERY button and EVERY function fully functional end to end and polished. Follow C:\Users\Perfect\shahdara-project\agent4\TASK.md exactly.
- NEVER remove features (engineering tool panels included: keep them, make them work, group them tidily). Never weaken, skip or delete tests.
- agent1/2/3 folders, clones, branches (e.g. agent1's unfinished feat/dash-staff-collector-performance-20261018) and PRs: do NOT read, run, edit, rebase, push, close or delete them.
- ROTATION (solo): agent4, agent4, agent4, ... forever. Ignore any 6-slot rotation mentioned in older prompts, AGENTS.md, GEMINI.md or STATE files.

Project: ONLY OfferPk/shahdara-isp-billing (https://github.com/OfferPk/shahdara-isp-billing).
Root: C:\Users\Perfect\shahdara-project
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md (must follow; this file wins if they differ).

## HARD SCOPE RULE (added 2026-10-17, overrides older ideas in STATE files)
- This repo is a small Pakistani ISP's offline BILLING / BUSINESS app. ALL NEW work must be billing/business features only: customers, packages, monthly bills, payments, receipts (incl. WhatsApp), dues/ledger, expenses, staff/collectors, reports, settings, backup/restore, and UI/UX polish of these.
- FORBIDDEN for new work: network / optical / routing engineering tools, calculators or simulators (OTDR, BGP, MPLS, SRv6, EVPN, DWDM, ROADM, OTN, PON/DBA physics, fiber splicing/cleaving, Raman/EDFA, PMD, Kerr, microwave, etc.). Do not create new dashboard-*/nav-*/qa-* modules of this kind and do not extend the existing ones.
- NEVER remove, hide or break existing features (including the engineering panels already in the app). Only add new billing features and improve existing ones. Grouping tools into one menu/page, collapsing menus by default and making overlays dismissible is allowed (every tool must stay reachable in at most 2 taps). Keep `npm test` 100% green.
- PREFER ENHANCING EXISTING FEATURES over adding new ones: before adding anything new, check whether an existing screen does it and make that one work and look better.
- Test for every task: "Does this help the owner bill, collect, track dues/expenses or run the business faster?" If not, pick the next task from your TASK.md backlog.
- Before building, search the code (rg) for an existing version of the feature. If it exists, extend and improve it instead of creating a duplicate.
- Take tasks from your TASK.md backlog in order (top first). STATE "NEXT" ideas about network engineering are void.

## BROWSER VERIFICATION RULE (all agents, added 2026-10-17)
- Unit tests are NOT enough. Before opening a PR, every agent opens the changed feature in a REAL browser at mobile 390x844 and desktop 1280x800: Playwright (`npx playwright test`; config + static server are added to the repo by agent4) or rea MCP capture_browser_scenario / capture_web_screenshot on a local server or the Pages preview.
- Check: the screen/dialog OPENS, every new button WORKS (click it), it CLOSES (close button / Esc / backdrop), Back works, and NO overlay, menu, FAB, toast or backdrop covers content when it should be closed. No horizontal scroll at 390px. Dark and light theme readable.
- When tests/e2e/*.spec.mjs exist, add or extend an e2e test for your feature (click its entry button, assert it becomes visible) and keep `npx playwright test` green. Never skip or weaken e2e tests.
- Write in the PR description what you verified in the browser (viewport + steps). If the browser check fails, fix it before the PR.

## Files
- TEAM.lock      C:\Users\Perfect\shahdara-project\TEAM.lock   (heartbeat lock for this run)
- NEXT_AGENT.txt C:\Users\Perfect\shahdara-project\NEXT_AGENT.txt  in solo mode it always contains `2 agent4` (any other content also means agent4)
- TEAM_STATE.md  C:\Users\Perfect\shahdara-project\TEAM_STATE.md (turn log: agent, start, end, minutes, PR, result)

## 0. Lock (start of run)
- If TEAM.lock exists, was modified less than 90 minutes ago AND its content does not start with "gate-started" or "conversation", another team run is active: stop immediately and do nothing else.
- Otherwise overwrite TEAM.lock with: `running <current time from Get-Date -Format o>`.
- HEARTBEAT: after EVERY step (each command, file edit, test run, PR action), overwrite TEAM.lock with `running <Get-Date -Format o>`. Never let it go 30 minutes without a heartbeat. Waiting for CI: heartbeat between every check.

## 1. Start a turn (solo)
- The agent is ALWAYS agent4. (Read NEXT_AGENT.txt only to confirm; whatever it says, run agent4.)
- Record the turn start: run `Get-Date -Format o` and append `## agent4 (solo) turn start <time>` to TEAM_STATE.md.
- Read C:\Users\Perfect\shahdara-project\agent4\TASK.md, STATE_agent4.md and FEATURE_AUDIT.md. Then list open `grok-review` issues (see step 2). IGNORE any RUNNING.lock step and any "small/one focused improvement" wording: this turn is a BIG task.
- Work ONLY in C:\Users\Perfect\shahdara-project\agent4\shahdara-isp-billing.

## 2. Do a LONG, COMPLETE task (minimum 20 minutes, no maximum)
- First: if agent4 has an unfinished local branch or open PR, finish it completely (rebase on origin/main, tests, PR, CI, merge).
- grok-review FIRST: list OPEN GitHub issues labeled `grok-review` in OfferPk/shahdara-isp-billing (GitHub MCP list_issues / search_issues), add them to FEATURE_AUDIT.md and fix them before anything else, highest impact first. Every PR that fixes one contains `Fixes #N` so it closes on merge (agent4\TASK.md Step 0).
- REA RULE (agent4\TASK.md): at the start of the solo pass run rea/analyze_javascript_application once to build the feature map and complete the inventory. Whenever a button/function is unclear or broken without obvious cause, FIRST understand it with REA (trace_application_feature, inspect_web_event_listeners, trace_web_source_location/trace_javascript_semantics, observe_web_execution, record_unknown), write the findings in FEATURE_AUDIT.md, then fix, then verify with rea capture_browser_scenario + compare_web_screenshots AND Playwright.
- Then take the NEXT section of the top-to-bottom pass from agent4\TASK.md / FEATURE_AUDIT.md (one screen/section = several related items) and make every item in it fully functional and polished, with real-click e2e tests.
- Verify it in a real browser at 390x844 and 1280x800 (BROWSER VERIFICATION RULE).
- `npm test` must pass 100% (never delete or weaken tests). `npx playwright test` must pass too. git fetch origin, git rebase origin/main, run the tests again.
- Commit, push the agent4 branch (or PUSH RULE), open a PR via GitHub MCP (title prefix [agent4]), wait for CI green, merge it, then confirm the GitHub Pages preview workflow builds.
- TIME RULE: before handing off, run `Get-Date -Format o` and compare with the turn start.
  - Less than 20 minutes and the section is merged: take the NEXT section (same rules) and keep going.
  - 20 minutes or more but the current section is NOT finished/merged: keep going until it is complete and merged. Never hand off half-done work.
  - 20 minutes or more AND the current section is merged: the turn is complete.
- Never end a turn early after a small change. Never stop to ask the user anything; decide yourself and continue.

## 3. End of turn (solo)
- Update STATE_agent4.md (done, PR links, audit counts, next section) and FEATURE_AUDIT.md.
- Append to TEAM_STATE.md: `agent4 (solo) turn end <time>, <minutes> min, PRs: <links>, result`.
- Overwrite NEXT_AGENT.txt with exactly `2 agent4`.
- Heartbeat TEAM.lock.

## 4. Continue
- IMMEDIATELY start the next agent4 turn in this same run (go to step 1). Do NOT end the conversation between turns.
- After 3 completed agent4 turns in this run, delete TEAM.lock (Remove-Item C:\Users\Perfect\shahdara-project\TEAM.lock) and end this conversation, so a fresh conversation (fresh context) continues automatically within 5 minutes.
- If quota/rate limits stop you, first save STATE_agent4.md and TEAM_STATE.md, then delete TEAM.lock.

## Command rules
- Run every terminal command as ONE single command: no cd/Set-Location, no && or ;. Set the working directory via the tool.
- Never start long-running background servers by hand; let Playwright's webServer config start and stop the static server.
- Never commit agent files (AGENTS.md, GEMINI.md, TEAM*.md, NEXT_AGENT.txt, STATE*.md, TASK.md, FEATURE_AUDIT.md, *.lock, .agent) into the repo.
- Never touch any other repo, never create repos, never push to main directly, never force-push main.

## PUSH RULE (important)
- This PC has NO saved git login. If `git push` fails, asks for credentials, or does not finish within 2 minutes, do NOT retry it and do NOT wait. Instead upload the branch with the GitHub MCP: mcp(github/create_branch) from main, then mcp(github/push_files) with ALL changed files of your commit (read them from the local clone; include package.json AND package-lock.json when dependencies changed), then create_pull_request, wait for CI, merge_pull_request. After merge: git fetch origin, then git switch main, then git pull, so the local clone matches GitHub.
- Never stop the turn because of a push problem.

---

# Team mode (PAUSED since 2026-10-18 - kept for re-enabling)
To re-enable: restore the team-mode TEAM.md / TEAM_PROMPT.txt from the bootstrap repo (saved-automations/shahdara-team/team-mode/: copy TEAM.md, TEAM_PROMPT.txt, AGENTS.md, NEXT_AGENT.txt, agent4/TASK.md over the solo files) or from C:\Users\Perfect\shahdara-project\_backup_20261018-solo, set NEXT_AGENT.txt to `1 agent1`, and remove the PAUSED note from the agent1/2/3 STATE files. Nothing below applies while SOLO MODE is active.

Agents (each has its OWN clone, area, TASK.md and STATE file):
- agent1 shahdara-dashboard  -> C:\Users\Perfect\shahdara-project\agent1 (branches feat/dash-*)
- agent2 shahdara-mobile-nav -> C:\Users\Perfect\shahdara-project\agent2 (branches feat/nav-*)
- agent3 shahdara-forms-qa   -> C:\Users\Perfect\shahdara-project\agent3 (branches feat/qa-*)
- agent4 shahdara-polish-qa  -> C:\Users\Perfect\shahdara-project\agent4 (branches feat/polish-*): real-browser QA + UI polish of EXISTING features (see agent4\TASK.md)

Only ONE agent works at a time. ROTATION (6 slots, repeats forever):
  slot 1 = agent1
  slot 2 = agent4
  slot 3 = agent2
  slot 4 = agent4
  slot 5 = agent3
  slot 6 = agent4
  after slot 6 comes slot 1 again.
So polish/QA (agent4) runs after EVERY feature agent: agent1 -> agent4 -> agent2 -> agent4 -> agent3 -> agent4 -> agent1 ...
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md (must follow; this file wins if they differ).

## 1. Start a turn
- Read NEXT_AGENT.txt to get slot S and agent:
  - Normal format `<slot> <agent>` (e.g. `4 agent4`): use slot S; the agent is the one the ROTATION gives for slot S.
  - Old one-word format (from the older 3-agent rules): `agent2` -> slot 2 (agent4), `agent3` -> slot 4 (agent4), `agent1` -> slot 6 (agent4), `agent4` -> slot 2.
  - Missing or invalid: slot 1 (agent1).
  Call the agent agentN.
- If C:\Users\Perfect\shahdara-project\agentN\RUNNING.lock was modified less than 15 minutes ago, it is a leftover from the old parallel setup: append a note to TEAM_STATE.md and skip to the next slot.
- Record the turn start: run `Get-Date -Format o` and append `## agentN (slot S) turn start <time>` to TEAM_STATE.md.
- Read C:\Users\Perfect\shahdara-project\agentN\TASK.md and STATE_agentN.md (agent4 also reads FEATURE_AUDIT.md). IGNORE the RUNNING.lock step in any TASK.md (TEAM.lock replaces it) and IGNORE any "small/one focused improvement" wording: this turn is a BIG task.
- Work ONLY in C:\Users\Perfect\shahdara-project\agentN\shahdara-isp-billing and ONLY in agentN's area (agent4's area = QA + polish of any existing feature).

## 3. Hand off to the next slot
- Update agentN's STATE_agentN.md (done, PR links, NEXT ideas). agent4 also updates FEATURE_AUDIT.md.
- Append to TEAM_STATE.md: `agentN (slot S) turn end <time>, <minutes> min, PRs: <links>, result`.
- ADVANCE: next slot = S + 1 (after 6 comes 1). Overwrite NEXT_AGENT.txt with exactly:
  - finished slot 1 (agent1) -> `2 agent4`
  - finished slot 2 (agent4) -> `3 agent2`
  - finished slot 3 (agent2) -> `4 agent4`
  - finished slot 4 (agent4) -> `5 agent3`
  - finished slot 5 (agent3) -> `6 agent4`
  - finished slot 6 (agent4) -> `1 agent1`
- Heartbeat TEAM.lock.

## 4. Continue
- IMMEDIATELY start the next slot's turn in this same run (go to step 1). Do NOT end the conversation between agents.
- After 6 completed turns in this run (one full rotation), delete TEAM.lock (Remove-Item C:\Users\Perfect\shahdara-project\TEAM.lock) and end this conversation, so a fresh conversation (fresh context) continues the cycle automatically within 5 minutes from NEXT_AGENT.txt.
- If quota/rate limits stop you, first save STATE_agentN.md and TEAM_STATE.md (do not advance NEXT_AGENT.txt if the turn is unfinished), then delete TEAM.lock.
