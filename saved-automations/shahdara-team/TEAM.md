# SHAHDARA TEAM - sequential orchestrator (ONE run at a time, agents take turns)

Project: ONLY OfferPk/shahdara-isp-billing (https://github.com/OfferPk/shahdara-isp-billing).
Root: C:\Users\Perfect\shahdara-project
Agents (each has its OWN clone, area, TASK.md and STATE file):
- agent1 shahdara-dashboard  -> C:\Users\Perfect\shahdara-project\agent1 (branches feat/dash-*)
- agent2 shahdara-mobile-nav -> C:\Users\Perfect\shahdara-project\agent2 (branches feat/nav-*)
- agent3 shahdara-forms-qa   -> C:\Users\Perfect\shahdara-project\agent3 (branches feat/qa-*)

Only ONE agent works at a time, in this order, forever: agent1 -> agent2 -> agent3 -> agent1 -> ...
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md (must follow; this file wins if they differ).

## Files
- TEAM.lock      C:\Users\Perfect\shahdara-project\TEAM.lock   (heartbeat lock for this run)
- NEXT_AGENT.txt C:\Users\Perfect\shahdara-project\NEXT_AGENT.txt (one word: agent1, agent2 or agent3)
- TEAM_STATE.md  C:\Users\Perfect\shahdara-project\TEAM_STATE.md (turn log: agent, start, end, minutes, PR, result)

## 0. Lock (start of run)
- If TEAM.lock exists, was modified less than 90 minutes ago AND its content does not start with "gate-started" or "conversation", another team run is active: stop immediately and do nothing else.
- Otherwise overwrite TEAM.lock with: `running <current time from Get-Date -Format o>`.
- HEARTBEAT: after EVERY step (each command, file edit, test run, PR action), overwrite TEAM.lock with `running <Get-Date -Format o>`. Never let it go 30 minutes without a heartbeat. Waiting for CI: heartbeat between every check.

## 1. Start a turn
- Read NEXT_AGENT.txt (if missing or invalid, use agent1). Call it agentN.
- If C:\Users\Perfect\shahdara-project\agentN\RUNNING.lock was modified less than 15 minutes ago, it is a leftover run from the old parallel setup: append a note to TEAM_STATE.md and skip to the next agent (agent1->agent2->agent3->agent1).
- Record the turn start: run `Get-Date -Format o` and append `## agentN turn start <time>` to TEAM_STATE.md.
- Read C:\Users\Perfect\shahdara-project\agentN\TASK.md and STATE_agentN.md. IGNORE the RUNNING.lock step in TASK.md (TEAM.lock replaces it) and IGNORE any "small/one focused improvement" wording: this turn is a BIG task.
- Work ONLY in C:\Users\Perfect\shahdara-project\agentN\shahdara-isp-billing and ONLY in agentN's area.

## 2. Do a LONG, COMPLETE task (minimum 20 minutes, no maximum)
- First: if agentN has an unfinished local branch or open PR, finish it completely (rebase on origin/main, tests, PR, CI, merge).
- Then pick ONE substantial feature/screen from agentN's TASK.md (not a tiny tweak) and implement it FULLY: complete code, UI, wiring to existing data/functions, dark/light theme, mobile responsive, empty states, and tests.
- `npm test` must pass 100% (never delete or weaken tests). git fetch origin, git rebase origin/main, npm test again.
- Commit, push the agentN branch, open a PR via GitHub MCP (title prefix [agentN]), wait for CI green, merge it, then confirm the GitHub Pages preview workflow builds.
- TIME RULE: before handing off, run `Get-Date -Format o` and compare with the turn start.
  - Less than 20 minutes and the feature is merged: start the NEXT substantial feature from agentN's TASK.md (same agent, same rules) and keep going.
  - 20 minutes or more but the current feature is NOT finished/merged: keep going until it is complete and merged. Never hand off half-done work.
  - 20 minutes or more AND the current feature is merged: the turn is complete.
- Never end a turn early after a small change. Never stop to ask the user anything; decide yourself and continue.

## 3. Hand off to the next agent
- Update agentN's STATE_agentN.md (done, PR links, NEXT ideas).
- Append to TEAM_STATE.md: `agentN turn end <time>, <minutes> min, PRs: <links>, result`.
- Write the next agent into NEXT_AGENT.txt (agent1->agent2, agent2->agent3, agent3->agent1).
- Heartbeat TEAM.lock.

## 4. Continue
- IMMEDIATELY start the next agent's turn in this same run (go to step 1). Do NOT end the conversation between agents.
- After 3 completed turns in this run (one full cycle agent1, agent2, agent3), delete TEAM.lock (Remove-Item C:\Users\Perfect\shahdara-project\TEAM.lock) and end this conversation, so a fresh conversation (fresh context) continues the cycle automatically within 5 minutes from NEXT_AGENT.txt.
- If quota/rate limits stop you, first save STATE_agentN.md and TEAM_STATE.md (do not advance NEXT_AGENT.txt if the turn is unfinished), then delete TEAM.lock.

## Command rules
- Run every terminal command as ONE single command: no cd/Set-Location, no && or ;. Set the working directory via the tool.
- Never commit agent files (AGENTS.md, GEMINI.md, TEAM*.md, NEXT_AGENT.txt, STATE*.md, TASK.md, *.lock, .agent) into the repo.
- Never touch any other repo, never create repos, never push to main directly, never force-push main.
