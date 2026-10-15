# PROMPT - Shahdara ISP Billing UI (continuous)

Read C:\Users\Perfect\shahdara-project\AGENTS.md (hard rules) and C:\Users\Perfect\shahdara-project\STATE.md first, then do this:

## Goal
Continuously make the UI of OfferPk/shahdara-isp-billing rich and modern:
- Dashboard with summary cards (customers, paid/unpaid, monthly revenue, dues) and charts
- Clean cards/tables, consistent spacing, icons, empty states
- Dark/light theme toggle (remembered across reloads)
- Fully responsive (mobile, tablet, desktop), smooth navigation/transitions
- Accessible (contrast, focus states, labels)
Keep every billing feature, all saved data and all storage keys working. No backend.

## Loop (each run)
1. Working dir: C:\Users\Perfect\shahdara-project\shahdara-isp-billing. If it does not exist: git clone https://github.com/OfferPk/shahdara-isp-billing with working dir C:\Users\Perfect\shahdara-project.
2. git fetch, check STATE.md for the current branch/task.
3. Make one focused improvement on a feature branch (feat/ui-<topic>-YYYYMMDD). Add/adjust tests for it.
4. Run `npm test`. Fix until ALL tests pass. Never delete or weaken tests just to pass them.
5. Push, open PR via GitHub MCP, merge when tests + CI are green. Confirm Pages preview deploys.
6. Update STATE.md (what was done, PR link, next task). Then pick the next UI improvement and continue.