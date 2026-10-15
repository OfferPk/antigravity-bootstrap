# BOOTSTRAP - instructions for the Antigravity agent

You (the Antigravity agent) were asked to "set up and run antigravity-bootstrap" for a target GitHub repository.
Follow these steps in order. Be brief with the user, and do everything you can yourself.

## Hard rules while bootstrapping
- Run every terminal command as ONE single command: no `cd`/`Set-Location`, no `&&`, no `;`. Set the working directory through the tool.
- NEVER print, echo, log, commit or paste a GitHub token. Never ask the user to paste a token into the chat.
- Only touch: `%USERPROFILE%\ag-projects\`, `%USERPROFILE%\.gemini\config\sidecars\<new agent names>\`, and (only when no GitHub server exists yet) `%USERPROFILE%\.gemini\config\mcp_config.json`. Never delete or change other sidecars, other projects or other MCP servers.
- Only the target repo is worked on. Never create repositories.
- You cannot approve your own permission prompts. When Antigravity asks the user to Allow a command, tell the user to click Allow.

## Step 1 - Inputs
1. Target repo URL (`https://github.com/<owner>/<repo>`). If the user did not give one, ASK for it and wait.
2. Number of agents: default **3** (allowed 1-6). Use what the user asked for, if anything.
3. Optional: interval in minutes between runs per agent (default 10; agents are staggered and skip a run while their lock is fresh).

## Step 2 - Check prerequisites (one command each)
- `git --version` (required; if missing tell the user to install Git for Windows from https://git-scm.com/download/win and stop)
- `node --version` (needed for JavaScript projects; https://nodejs.org)
- `gh --version` and `gh auth status` (optional but recommended; https://cli.github.com). If gh is installed but not logged in, ask the user to run `gh auth login` in their OWN terminal and tell you when done.

The agents need a GitHub login to push (git) and a GitHub MCP server to open and merge PRs. The setup script finds a token in this order:
an existing GitHub server in mcp_config.json (it is kept as is), env `GITHUB_PERSONAL_ACCESS_TOKEN` / `GITHUB_TOKEN` / `GH_TOKEN`, then `gh auth token`.
If none of these exist, the user must either run `gh auth login`, or run the setup script themselves in their own PowerShell with `-AskToken` (hidden input). Never collect the token in chat.

## Step 3 - Get this bootstrap repo
- If `%USERPROFILE%\ag-projects\_bootstrap\.git` does not exist: `git clone https://github.com/OfferPk/antigravity-bootstrap <USERPROFILE>\ag-projects\_bootstrap`
- Else run `git pull --ff-only` with working dir `<USERPROFILE>\ag-projects\_bootstrap`.
(Replace `<USERPROFILE>` with the real path, for example `C:\Users\Ali`.)

## Step 4 - Run the setup script ONCE (preferred: a single approval)
```
powershell -NoProfile -ExecutionPolicy Bypass -File <USERPROFILE>\ag-projects\_bootstrap\scripts\setup.ps1 -RepoUrl <TARGET_REPO_URL> -Agents 3
```
Optional flags: `-IntervalMinutes 10`, `-LockMinutes 40`, `-CronTimeZone Asia/Karachi` (default UTC; schedules are minute-based so the zone barely matters), `-TestCommand "npm test"`, `-SkipMcp`, `-Force` (overwrite edited TASK/AGENTS files, re-enable disabled agents; backups are made).

The script is idempotent (safe to run again), backs up every file it overwrites into `<project>\_backup_<time>\`, validates every JSON file and writes UTF-8 without BOM.
It creates:
```
%USERPROFILE%\ag-projects\<repo>\
  AGENTS.md  GEMINI.md  .agent\rules\project-only.md  STATE.md  project.json
  agent1\  <repo>\ (own clone)  TASK.md  STATE_agent1.md  GEMINI.md  .agent\rules\agent1.md
  agent2\  ...
  agent3\  ...
%USERPROFILE%\.gemini\config\sidecars\<repo>-a1-ui\sidecar.json
%USERPROFILE%\.gemini\config\sidecars\<repo>-a2-nav\sidecar.json
%USERPROFILE%\.gemini\config\sidecars\<repo>-a3-qa\sidecar.json
```
If the output shows an error, fix the cause (wrong URL, no git, no access) and run it again. Show the user any WARNING lines in plain words.

## Step 5 - Verify (one command each)
- `Get-Content <USERPROFILE>\ag-projects\<repo>\project.json`
- For each sidecar listed there: `Get-Content <USERPROFILE>\.gemini\config\sidecars\<name>\sidecar.json -Raw | ConvertFrom-Json` must succeed.
- `git status` in each `agentN\<repo>` must show a clean clone on the default branch.
- Do NOT open mcp_config.json in a way that prints the token. If you must check it, only check that a server named `github` exists (`(Get-Content ... -Raw | ConvertFrom-Json).mcpServers.PSObject.Properties.Name`).

## Step 6 - Adapt the agent roles to the repo
Inspect the target repo (README, package.json / pyproject, folder structure, existing tests, workflows). Then edit ONLY the "Your area" section of each `agentN\TASK.md` (outside the repo) so it names the concrete screens/modules/files that agent owns. Default split:
- agent1 = features + UI of the main screens
- agent2 = mobile/responsive layout, navigation, accessibility
- agent3 = QA: tests, bug fixing, forms/tables, CI
- agent4+ = docs, performance, refactors
Areas must not overlap. Keep the Loop section unchanged. If the repo has no tests, write into agent3's TASK.md that adding a test setup is its first job.

## Step 7 - Hand over to the user
Tell the user, short and clear:
1. Fully quit Antigravity and open it again (sidecars and MCP servers load only at start).
2. Open the Automations list and **enable** each new automation (`<repo>-a1-ui`, `<repo>-a2-nav`, `<repo>-a3-qa`, ...). They are not enabled automatically.
3. During the first runs Antigravity will ask for permission for some commands/tools: click **Allow** (agents cannot approve themselves).
4. Recommended: protect the default branch on GitHub (Settings > Branches > add rule: block force pushes and deletion).
5. To stop the agents later: `powershell -NoProfile -ExecutionPolicy Bypass -File <USERPROFILE>\ag-projects\_bootstrap\scripts\disable.ps1 -RepoName <repo>` then restart Antigravity.

## Manual fallback (only if the script cannot run)
Create the same layout by hand using `templates/`:
- `templates/AGENTS.md` -> `<project>\AGENTS.md`, `<project>\GEMINI.md`, `<project>\.agent\rules\project-only.md`
- `templates/TASK_agent1.md`..`TASK_agent3.md` (`TASK_generic.md` for agent4+) with `templates/LOOP.md` inserted at `{{LOOP}}` -> `<project>\agentN\TASK.md`
- `templates/STATE_agent.md` -> `<project>\agentN\STATE_agentN.md`; `templates/GEMINI.md` -> `<project>\agentN\GEMINI.md` and `.agent\rules\agentN.md`
- `templates/sidecar.template.json` -> `%USERPROFILE%\.gemini\config\sidecars\<repo>-aN-<role>\sidecar.json`
Replace every `{{PLACEHOLDER}}` (JSON-escape values inside the sidecar: backslashes become `\\`). Stagger schedules (agent1 minute 0, agent2 minute 3, agent3 minute 6, every 10 minutes), one lock file per agent (`<project>\agentN\RUNNING.lock`). Write files as UTF-8 without BOM and check each JSON parses.
GitHub MCP entry (only if no GitHub server exists; back up the file first; merge, never replace other servers):
```json
"github": { "url": "https://api.githubcopilot.com/mcp/", "headers": { "Authorization": "Bearer <TOKEN - never print it>" } }
```

## Work loop rules (what every agent does on each run)
These are already written into AGENTS.md / TASK.md / the sidecar prompts:
- Own folder and own clone only; own branch prefix (`feat/ui-`, `feat/nav-`, `feat/qa-`, `feat/aN-`).
- Lock file check first (skip if another run of the same agent is younger than 40 min).
- Branch from latest `origin/<default>`, one small focused change, tests for it.
- Tests must pass 100% locally, `git fetch` + `git rebase origin/<default>`, tests again.
- Push the branch, open a PR via GitHub MCP with `[agentN]` prefix, merge only when tests + CI are green and there are no conflicts.
- Never force-push or delete the default branch; never push directly to it; `--force-with-lease` only on your own branch.
- Never touch other repos, other agents' folders/branches/PRs; keep other agents' work when resolving conflicts.
- One command at a time: no `&&`, no `;`, no `cd`.
- Update the agent's STATE file, delete the lock, finish.
