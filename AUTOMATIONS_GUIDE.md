# Automations Guide - OfferPk / John

Roman Urdu pehle, English neeche. / Roman Urdu first, English below.

Saari Antigravity automations ki copies is repo mein `saved-automations/` mein mehfooz hain, kisi mein koi token ya secret nahi hai. Un mein paths `C:\Users\Perfect` ke hain; `enable-saved.ps1` inhein khud aap ke `%USERPROFILE%` mein badal deta hai.

---

## Roman Urdu

### Saari automations ek nazar mein

| Naam | Kya karti hai | Kahan chalti hai | Abhi ka haal |
|---|---|---|---|
| `offerpk-app-factory` | Offline game factory: ek waqt mein ek nayi offline game (JS + Capacitor Android) naye OfferPk repo mein banati hai, CI, Pages demo aur APK ke saath. Ek mukammal ho to agli shuru. | Aap ke PC par Antigravity (har 5 min, lock 40 min) | Band (saved) |
| `shahdara-ui` | Akela agent jo `shahdara-isp-billing` ka UI lagataar behtar karta hai | Aap ke PC par Antigravity (har 5 min) | Band (saved) |
| `shahdara-team` | **Naya, recommended.** Ek hi orchestrator: agent1 (dashboard) -> agent2 (mobile-nav) -> agent3 (forms-qa) -> phir agent1, **ek waqt mein ek**. Har agent ki baari kam az kam 20 minute, aur kaam poora na ho to jab tak PR merge na ho chalti rehti hai. Phir foran agla agent. | Aap ke PC par Antigravity (har 5 min sirf gate check, lock 90 min) | **On** (2026-10-15 se) |
| `shahdara-dashboard` | agent1: Shahdara billing ka dashboard, KPI cards, charts (purana parallel mode) | Aap ke PC par Antigravity (minute 0,5,10...) | Band (saved) |
| `shahdara-mobile-nav` | agent2: mobile layout, navigation, accessibility (purana parallel mode) | Aap ke PC par Antigravity (minute 2,7,12...) | Band (saved) |
| `shahdara-forms-qa` | agent3: tables, forms, receipts, bugs, tests, CI (purana parallel mode) | Aap ke PC par Antigravity (minute 4,9,14...) | Band (saved) |
| `fb-autopost` (GitHub Actions) | Roz 10:00 PKT 5 Facebook Pages par 1 photo + 1 reel post karti hai | GitHub cloud, repo `OfferPk/fb-autopost` (private) | On |
| Grok routine "Auto app factory" | Cloud mein apps banati thi, aakhri focus Offline Ludo | Grok Bot cloud | Paused |
| Grok routine "FB daily autopost" | Purani Facebook posting | Grok Bot cloud | Paused (GitHub Actions ne jagah le li) |
| App Factory Dashboard | Har OfferPk app ka status: commit, CI, APK, Pages, PRs | https://offerpk.github.io/app-factory-dashboard/ | Hamesha on (sirf dekhne ke liye) |

### Antigravity wali automation ON kaise karein
1. Pehli dafa: `git clone https://github.com/OfferPk/antigravity-bootstrap %USERPROFILE%\ag-projects\_bootstrap` (agar pehle se hai to us folder mein `git pull`).
2. List dekhein: `powershell -NoProfile -ExecutionPolicy Bypass -File %USERPROFILE%\ag-projects\_bootstrap\scripts\enable-saved.ps1 -List`
3. On karein (misaal):
   - Shahdara team (recommended, baari baari): `... enable-saved.ps1 -Name shahdara-team -RestoreFiles -Clone -DisableConflicts`
   - 3 Shahdara agents parallel (purana tareeqa): `... enable-saved.ps1 -Name shahdara-dashboard,shahdara-mobile-nav,shahdara-forms-qa -RestoreFiles -Clone`
   - Akela shahdara-ui (3 agents band kar ke): `... enable-saved.ps1 -Name shahdara-ui -RestoreFiles -Force -DisableConflicts`
   - Game factory: `... enable-saved.ps1 -Name offerpk-app-factory -RestoreFiles -Force`
4. Antigravity **poori band kar ke dobara kholein**, Automations list mein us automation ko **on** karein, pehli permission par **Allow** dabayein.

`-RestoreFiles` prompt/TASK/STATE files wapas rakhta hai (sirf jo nahi hain). `-Force` purani files ka `.bak-<time>` bana kar saved wali rakh deta hai. `-Clone` zaroori repo clone karta hai. Purana `sidecar.json` hamesha pehle backup hota hai.

### shahdara-team kaise kaam karti hai
- Har 5 minute Antigravity sirf ek chhota script `shahdara-project\team-gate.ps1` chalati hai. Agar `TEAM.lock` 90 minute se naya hai (yani koi run chal raha hai) to woh kuch nahi karta, na nayi chat banti hai, na chalta kaam rukta hai. Lock na ho ya purana ho tab hi nayi chat shuru hoti hai.
- Chat `TEAM.md` follow karti hai: `NEXT_AGENT.txt` se agent leti hai, us ka bara kaam (feature/screen) poora karti hai: code, UI, tests, PR, CI, merge. Kam az kam 20 minute; 20 minute par kaam adhoora ho to merge hone tak chalti hai. Har qadam par `TEAM.lock` refresh hota hai.
- Phir STATE update, `NEXT_AGENT.txt` agle agent par, aur **usi chat mein foran agla agent**. 3 baariyan (ek poora chakkar) ke baad chat lock hata kar khatam hoti hai, aur 5 minute mein nayi chat (taaza context) agle agent se shuru ho jati hai. Yeh quota khatam hone tak chalta rehta hai.
- Log: `shahdara-project\team-gate.log` (gate), `TEAM_STATE.md` (har baari ka waqt aur PR). Foran dobara shuru karna ho: `TEAM.lock` delete kar dein.
- Parallel wapas chahiye: `enable-saved.ps1 -Name shahdara-dashboard,shahdara-mobile-nav,shahdara-forms-qa -RestoreFiles -Force -DisableConflicts` (yeh shahdara-team band kar dega).

### OFF kaise karein
- `powershell -NoProfile -ExecutionPolicy Bypass -File %USERPROFILE%\ag-projects\_bootstrap\scripts\disable.ps1 -Name shahdara-ui` (kai naam comma se), phir Antigravity restart.
- Ya khud: `%USERPROFILE%\.gemini\config\sidecars\<naam>\sidecar.json` ka naam `sidecar.json.disabled` kar dein. Kuch delete nahi hota.
- Ya sirf Antigravity ki Automations list mein switch off kar dein.

### Cloud wali automations
- **fb-autopost (GitHub Actions)**: on/off: GitHub > OfferPk/fb-autopost > Actions > "daily-fb-autopost" > *Disable workflow* / *Enable workflow*. Haath se chalana: *Run workflow* (default `dry_run` = true, yani post nahi hoti; asli post ke liye dry_run hata dein). Zaroori: repo secret `PAGE_TOKENS_JSON` (5 Pages ke tokens). Tokens expire hon to post fail hogi, naya token secret mein daalein.
- **Grok routines**: Grok Bot ko chat mein kahein, jaise "Auto app factory routine resume karo" ya "pause karo". "FB daily autopost" ko on **na** karein jab tak GitHub Actions wali on hai, warna har post do dafa jayegi.
- **Dashboard**: kuch on/off nahi karna, bas link kholein. GitHub ki free API limit (60 request/ghanta) istemal karti hai.

### Takraav (ek saath na chalayein)
- `shahdara-team`, `shahdara-ui` aur 3 parallel Shahdara agents (`shahdara-dashboard`, `shahdara-mobile-nav`, `shahdara-forms-qa`) ek hi repo aur files badalte hain: **in mein se sirf ek chalayein**. Script yeh khud rokta hai.
- `offerpk-app-factory` aur Grok ki "Auto app factory" ek hi repos par na chalayein. Factory sirf naye repos banati hai, Ludo repos (`offline-ludo`, `ludo`, `manusailudo`) ko haath na lagaye.
- Grok "FB daily autopost" + GitHub Actions `fb-autopost` = double posting.

### Quota
- Saari Antigravity automations aap ke **ek hi Gemini/Antigravity quota** se chalti hain. Har 5 minute wali automation bohat quota khati hai. Ek waqt mein 3 se zyada na chalayein; quota khatam ho to sab ruk jati hain.
- Antigravity wali sirf tab chalti hain jab PC on ho aur Antigravity khuli ho.
- Grok routines Grok Bot ke credits istemal karti hain. GitHub Actions private repo par mahine ke free minutes (2000) se chalti hai.

---

## English

### All automations at a glance

| Name | What it does | Where it runs | How to turn on / off | Prerequisites |
|---|---|---|---|---|
| `offerpk-app-factory` | Offline game factory: builds ONE new offline casual game at a time (vanilla JS + Capacitor Android) as a new public OfferPk repo, with CI, GitHub Pages demo, APK artifact and Play listing text; starts the next when DONE. | Antigravity on John's PC, `*/5` min, `app-factory\RUNNING.lock` 40-min guard, workspace `%USERPROFILE%\app-factory` | On: `enable-saved.ps1 -Name offerpk-app-factory -RestoreFiles -Force`. Off: `disable.ps1 -Name offerpk-app-factory` | GitHub MCP token that can create repos; Node; Android build runs in GitHub Actions |
| `shahdara-ui` | Single agent continuously polishing the UI of `OfferPk/shahdara-isp-billing` | Antigravity, `*/5` min, workspace `%USERPROFILE%\shahdara-project` | On: `enable-saved.ps1 -Name shahdara-ui -RestoreFiles -Force -DisableConflicts`. Off: `disable.ps1 -Name shahdara-ui` | GitHub MCP, Node, clone `shahdara-project\shahdara-isp-billing` (`-Clone`) |
| `shahdara-team` | **Recommended (active since 2026-10-15).** ONE orchestrator: agent1 dashboard -> agent2 mobile-nav -> agent3 forms-qa -> agent1 ..., one at a time. Each turn is one substantial feature, min 20 min and until its PR is merged, then the next agent starts immediately in the same run | Antigravity, `*/5` gate (`shahdara-project\team-gate.ps1`): starts a run only if `TEAM.lock` is missing or older than 90 min; workspaces `shahdara-project` + `agent1..3` | On: `enable-saved.ps1 -Name shahdara-team -RestoreFiles -Clone -DisableConflicts`. Off: `disable.ps1 -Name shahdara-team` | GitHub MCP, Node, the 3 clones (`-Clone`) |
| `shahdara-dashboard` | agent1 (old parallel mode): dashboard KPI cards, charts, quick actions (`feat/dash-*`) | Antigravity, minutes 0,5,...,55, workspace `shahdara-project\agent1` | On: `enable-saved.ps1 -Name shahdara-dashboard -RestoreFiles -Clone`. Off: `disable.ps1 -Name shahdara-dashboard` | same |
| `shahdara-mobile-nav` | agent2: mobile layout, navigation, a11y (`feat/nav-*`) | Antigravity, minutes 2,7,...,57, workspace `shahdara-project\agent2` | same pattern | same |
| `shahdara-forms-qa` | agent3: tables, forms, receipts, bug fixing, tests, CI (`feat/qa-*`) | Antigravity, minutes 4,9,...,59, workspace `shahdara-project\agent3` | same pattern | same |
| `fb-autopost` | Daily 10:00 PKT (05:00 UTC): 1 photo + 1 reel on 5 Facebook Pages; commits `post_log.json` | GitHub Actions, private repo `OfferPk/fb-autopost`, workflow `daily-fb-autopost` (`schedule` + `workflow_dispatch`) | GitHub > Actions > daily-fb-autopost > Disable / Enable workflow (or `gh workflow disable/enable daily-fb-autopost -R OfferPk/fb-autopost`). Manual run: *Run workflow* (`dry_run` defaults to true = no posting) | Repo secret `PAGE_TOKENS_JSON` (Page tokens; refresh when they expire) |
| Grok routine "Auto app factory" | Cloud app builder; last focus: Offline Ludo | Grok Bot cloud | Ask Grok Bot in chat to resume / pause it | none on the PC |
| Grok routine "FB daily autopost" | Old Facebook posting routine | Grok Bot cloud | Paused; replaced by GitHub Actions. Keep it paused | - |
| App Factory Dashboard | Read-only status page for every OfferPk app (latest commit, CI, Android build, Pages, open PRs, demo/APK links), auto-refresh 60 s | GitHub Pages: https://offerpk.github.io/app-factory-dashboard/ | Always on; nothing to enable | none (public GitHub API, 60 req/hour) |

### Enabling a saved Antigravity automation
1. Once: `git clone https://github.com/OfferPk/antigravity-bootstrap %USERPROFILE%\ag-projects\_bootstrap` (or `git pull` in that folder).
2. `powershell -NoProfile -ExecutionPolicy Bypass -File %USERPROFILE%\ag-projects\_bootstrap\scripts\enable-saved.ps1 -List`
3. `... enable-saved.ps1 -Name <name>[,<name2>] [-RestoreFiles] [-Clone] [-Force] [-DisableConflicts]`
   - writes `%USERPROFILE%\.gemini\config\sidecars\<name>\sidecar.json` (existing one backed up as `sidecar.json.bak-<time>`), JSON validated, no BOM
   - rewrites `C:\Users\Perfect` paths to your `%USERPROFILE%`
   - creates missing workspace folders and warns; `-RestoreFiles` puts back the prompt/TASK/STATE files (missing ones only; `-Force` overwrites after a `.bak-<time>` copy); `-Clone` clones the expected repos
   - refuses to enable conflicting ones together; warns (or with `-DisableConflicts` disables) conflicting ones already installed
4. Fully restart Antigravity, open Automations, **turn the automation on**, click **Allow** on the first permission prompts.

### How shahdara-team / `setup.ps1 -Mode team` works
- Why: in parallel mode every schedule tick of every agent opened a NEW conversation. While an agent was busy, the other ticks' conversations only found a fresh lock and quit after 1-4 min, so the list showed a chat "stopping" every ~2 min, and each check burned quota. Long runs were not actually killed, but nothing visibly finished and the 3 agents competed for one quota.
- Now the schedule runs `team-gate.ps1`, not `agentapi` directly. The gate starts `agentapi new-conversation` ONLY when `TEAM.lock` is missing or older than 90 min (the run heartbeats it after every step), so ticks never open a second chat and never interrupt the active one.
- The run follows `TEAM.md`: agent from `NEXT_AGENT.txt`; one substantial feature fully done (code, UI, tests, PR, CI green, merge); minimum 20 min, extended until merged; update STATE + `TEAM_STATE.md`; advance `NEXT_AGENT.txt`; continue with the next agent in the same run. After one full cycle (3 turns) it deletes the lock and ends, so a fresh conversation (fresh context) continues within 5 min. Loops until the quota runs out.
- Logs: `team-gate.log`, `TEAM_STATE.md`. Restart a stuck cycle: delete `TEAM.lock`.
- For any repo: `setup.ps1 -RepoUrl ... ` uses `-Mode team` by default (`-MinTurnMinutes 20`, lock 90, gate every 5 min); `-Mode parallel` gives the old one-sidecar-per-agent setup. Switching mode disables the other mode's sidecars (switch back to parallel with `-Mode parallel -Force` if its sidecars were disabled).

### Disabling
`disable.ps1 -Name <name>[,<name2>]` (or `-RepoName <repo>` for bootstrap projects) renames `sidecar.json` to `sidecar.json.disabled`; nothing is deleted. Or rename it by hand, or switch it off in the Automations list. Restart Antigravity afterwards.

### Conflicts
- Run only ONE of `shahdara-team`, `shahdara-ui`, or the 3 parallel Shahdara agents: same repo, same files. `enable-saved.ps1` refuses/disables the others.
- Do not run `offerpk-app-factory` and the Grok "Auto app factory" routine on the same repos; the factory creates new repos only and must not touch the Ludo repos (`offline-ludo`, `ludo`, `manusailudo`).
- Never run Grok "FB daily autopost" while the GitHub Actions `fb-autopost` is enabled (double posts).
- Agents created by `setup.ps1` for another repo are fine alongside these, as long as they target different repos.

### Quota
- All Antigravity automations share one Gemini/Antigravity quota. Every-5-minute automations are heavy; keep at most about 3 running at once. When the quota runs out, all of them stop until it resets.
- Antigravity automations run only while the PC is on and Antigravity is open.
- Grok routines use Grok Bot credits; `fb-autopost` uses GitHub Actions minutes (private repo free tier: 2000 min/month).

### What is saved where
| Folder | Contents | Origin |
|---|---|---|
| `saved-automations/offerpk-app-factory/` | `sidecar.json`, `AUTOMATION_PROMPT.md`, `STATE.games.md` (completed games list), `variants/` (last Shahdara-billing version, history only) | Original files `sidecar.json.bak4` and `AUTOMATION_PROMPT.md.bak4` from John's PC (game-factory mode). Not reconstructed. |
| `saved-automations/shahdara-ui/` | `sidecar.json`, `AGENTS.md`, `PROMPT.md`, `STATE.md` | Original `sidecar.json.disabled` + `_backup_20261015-163130` files |
| `saved-automations/shahdara-team/` | `sidecar.json`, `TEAM.md`, `TEAM_PROMPT.txt`, `team-gate.ps1`, `NEXT_AGENT.txt`, team-wording `AGENTS.md`, `agentN/TASK.md` | Current files from John's PC (2026-10-15) |
| `saved-automations/shahdara-dashboard/`, `shahdara-mobile-nav/`, `shahdara-forms-qa/` | `sidecar.json`, `TASK.md`, `STATE_agentN.md` | Current files from John's PC (2026-10-15) |
| `saved-automations/shahdara-shared/` | `AGENTS.md` shared by the 3 agents | Current file |
Every folder has a `manifest.json` (workspace, files, repos, conflicts, notes) used by `enable-saved.ps1`.
STATE files in the repo are fresh stubs, not the live progress logs. No tokens, secrets or Page tokens are stored anywhere in this repo.
