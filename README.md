# antigravity-bootstrap

Turn **any GitHub repo** into a project that several **Antigravity** agents improve **continuously, in parallel**, pushing their work to GitHub as pull requests - with one line pasted into Antigravity.

> Roman Urdu neeche hai. / Roman Urdu version is below.

## What it does
- Creates `%USERPROFILE%\ag-projects\<repo>\` with one folder and one **own clone** per agent (`agent1`, `agent2`, `agent3` by default).
- Writes shared rules (`AGENTS.md`, `GEMINI.md`, `.agent\rules\`) and a role + loop for each agent (`TASK.md`, `STATE_agentN.md`) **outside** the repo, so nothing agent-related is committed.
- Creates one Antigravity automation (sidecar) per agent with **staggered schedules** and a **per-agent lock file**, so agents never block each other.
- Adds the **GitHub MCP server** to Antigravity if it is not there yet (backup first, token never printed).
- Every agent: branch from latest main -> one focused change -> tests 100% -> rebase -> push -> PR -> merge only when tests + CI are green. Never force-pushes main, never touches other repos.

Default roles: **agent1** features + UI, **agent2** mobile/responsive + navigation + accessibility, **agent3** QA (tests, bugs, forms/tables, CI). Agent 4+ do docs/performance/refactors. Antigravity adapts the roles to your repo after inspecting it.

## The ONE line to paste into Antigravity
Open Antigravity on your Windows PC, start a **new chat**, and paste (put your repo URL at the end):

```
Set up and run https://github.com/OfferPk/antigravity-bootstrap for target repo https://github.com/YOUR-NAME/YOUR-REPO - read BOOTSTRAP.md in that repo and follow it exactly.
```

Want a different number of agents? Add `with 2 agents` (1-6).

## Prerequisites
- Windows 10/11 with **Antigravity** installed and opened at least once
- **Git** for Windows - https://git-scm.com/download/win
- **Node.js** (for JavaScript projects) - https://nodejs.org
- A **GitHub account** with write access to the target repo (your own repo, or a fork)
- A GitHub login for the agents, one of:
  - **GitHub CLI**: install https://cli.github.com and run `gh auth login` once (recommended), or
  - a **GitHub token** (fine-grained, only the target repo, permissions: Contents, Pull requests, Workflows read/write) in the env var `GITHUB_PERSONAL_ACCESS_TOKEN`, or typed into the hidden prompt of `setup.ps1 -AskToken` in your own PowerShell.

## What YOU must do once
1. **Approve** the first permission prompts in Antigravity (click *Allow*). Antigravity cannot approve its own permissions.
2. Provide the GitHub login/token as above. **Never paste the token into the chat and never commit it.**
3. After setup: **fully quit and restart Antigravity**, open the Automations list and **enable** each new automation (`<repo>-a1-ui`, `<repo>-a2-nav`, `<repo>-a3-qa`). They are not enabled automatically.
4. Recommended: protect `main` on GitHub (Settings > Branches): block force pushes and deletion.

## Run it yourself (optional)
```
git clone https://github.com/OfferPk/antigravity-bootstrap %USERPROFILE%\ag-projects\_bootstrap
powershell -NoProfile -ExecutionPolicy Bypass -File %USERPROFILE%\ag-projects\_bootstrap\scripts\setup.ps1 -RepoUrl https://github.com/YOUR-NAME/YOUR-REPO -Agents 3
```
Options: `-Agents 1..6`, `-IntervalMinutes 10`, `-LockMinutes 40`, `-CronTimeZone UTC`, `-TestCommand "npm test"`, `-AskToken`, `-SkipMcp`, `-Force`.
Safe to run again (idempotent). Overwritten files are backed up to `<project>\_backup_<time>\`.

Stop the agents: `powershell -NoProfile -ExecutionPolicy Bypass -File %USERPROFILE%\ag-projects\_bootstrap\scripts\disable.ps1 -RepoName YOUR-REPO`, then restart Antigravity (nothing is deleted).

## Repo contents
| Path | Purpose |
|---|---|
| `BOOTSTRAP.md` | Step-by-step instructions written for the Antigravity agent |
| `scripts/setup.ps1` | Does the whole setup in one run (Windows PowerShell 5.1 / PowerShell 7) |
| `scripts/disable.ps1` | Disables a project's automations (renames to `sidecar.json.disabled`) |
| `templates/` | `AGENTS.md`, `TASK_agent1..3.md`, `TASK_generic.md`, `LOOP.md`, `STATE_agent.md`, `GEMINI.md`, `sidecar.template.json` |

## Limitations
- All agents use **your one Gemini/Antigravity quota**; 3 agents use it up ~3x faster. Start with 2 if you hit limits.
- Antigravity's automation (sidecar) format is not officially documented; this follows a working setup. If an update changes it, the script may need an update.
- Agents only run while the PC is on and Antigravity is open.
- Agents merge their own PRs when tests + CI pass. Quality depends on the repo's tests: weak tests = more risk. Review merged work from time to time.
- Nothing is deployed to your servers. Existing GitHub Pages / CI workflows keep running as they are.

---

# Roman Urdu

## Yeh kya karta hai
Aap ki kisi bhi GitHub repo par Antigravity ke **kai agents ek saath** lagataar kaam karte hain aur apna code **GitHub par PR** bana kar push karte hain. Aap ko bas ek line Antigravity mein paste karni hai.
- `%USERPROFILE%\ag-projects\<repo>\` folder banta hai, har agent ka apna folder aur repo ki **apni alag copy** (`agent1`, `agent2`, `agent3`).
- Har agent ki apni automation, alag time aur alag lock file, is liye koi agent doosre ka kaam nahi rokta.
- Agar Antigravity mein GitHub MCP nahi hai to khud add ho jata hai (pehle backup, token kabhi screen par nahi aata).
- Har agent: nayi branch -> ek chhota kaam -> saare tests pass -> PR -> tests aur CI green hon to merge. `main` par kabhi force push nahi, kisi aur repo ko haath nahi lagata.

## Antigravity mein paste karne wali EK line
Antigravity mein **nayi chat** kholein aur yeh paste karein (aakhir mein apni repo ka link):
```
Set up and run https://github.com/OfferPk/antigravity-bootstrap for target repo https://github.com/YOUR-NAME/YOUR-REPO - read BOOTSTRAP.md in that repo and follow it exactly.
```
Kam ya zyada agents chahiye to aakhir mein `with 2 agents` likh dein (1 se 6).

## Pehle se kya chahiye
- Windows PC jis par Antigravity install ho aur ek dafa khul chuki ho
- Git for Windows, aur JavaScript projects ke liye Node.js
- GitHub account jis ko target repo mein likhne ki ijazat ho
- GitHub login: `gh auth login` (GitHub CLI, behtar tareeqa) ya GitHub token env var `GITHUB_PERSONAL_ACCESS_TOKEN` mein

## Aap ko sirf ek dafa yeh karna hai
1. Antigravity jab permission maange to **Allow** dabayein. Antigravity apni permission khud approve nahi kar sakti.
2. GitHub login/token dein. **Token kabhi chat mein paste na karein aur kabhi repo mein commit na karein.**
3. Setup ke baad Antigravity **poori band kar ke dobara kholein**, Automations list mein har nayi automation **on** karein.
4. Behtar hai ke GitHub par `main` branch protect kar dein (force push aur delete band).

## Rukawatein
- Saare agents aap ke ek hi Gemini quota se chalte hain, 3 agents quota jaldi khatam karte hain.
- Agents sirf tab chalte hain jab PC on ho aur Antigravity khuli ho.
- Agents tests pass hone par khud merge karte hain, is liye kabhi kabhi kaam check kar liya karein.
- Band karna ho: `scripts\disable.ps1 -RepoName YOUR-REPO` chala kar Antigravity restart karein. Kuch delete nahi hota.
