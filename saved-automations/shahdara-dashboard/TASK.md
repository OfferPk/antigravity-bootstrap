# TASK - agent1 'shahdara-dashboard': Dashboard (cards, KPIs, charts)
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent1\shahdara-isp-billing
Branch prefix: feat/dash-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent1\STATE_agent1.md
Your lock file: C:\Users\Perfect\shahdara-project\agent1\RUNNING.lock
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md (must follow)

## Your area: DASHBOARD ONLY
- Dashboard page: summary/KPI cards (total customers, active, paid/unpaid this month, monthly revenue, total dues, collections today/this month, new connections), trends.
- Charts in pure JS + SVG or <canvas> (NO CDN, no external libraries, works offline): monthly revenue bar/line, paid vs unpaid donut, dues by area/package, collections trend. Tooltips, legends, empty states, dark/light theme aware.
- Quick-action tiles on the dashboard (add customer, receive payment, etc.) that link to EXISTING pages/functions.
- Files you own: dashboard-related sections/markup, dashboard JS module(s) and dashboard styles (put new code in separate files like dashboard*.js / dashboard*.css / charts*.js where possible).
- Do NOT restyle navigation/header/sidebar (agent2) or tables/forms/receipts (agent3).
## Loop (each run)
1. Lock: if C:\Users\Perfect\shahdara-project\agent1\RUNNING.lock exists and was modified less than 40 minutes ago, stop immediately. Otherwise write the current time into it.
2. Working dir C:\Users\Perfect\shahdara-project\agent1\shahdara-isp-billing (if missing: git clone https://github.com/OfferPk/shahdara-isp-billing with working dir C:\Users\Perfect\shahdara-project\agent1). git fetch origin. Check your open PRs first: finish/merge or fix them before starting new work.
3. git checkout -B feat/dash-<topic>-YYYYMMDD origin/main. Make ONE focused improvement in your area. Add/adjust tests.
4. npm test until 100% pass (never delete or weaken tests). git fetch origin, git rebase origin/main, npm test again.
5. Push your branch, open PR via GitHub MCP (title prefix [agent1]). Merge only when npm test + CI are green and there are no conflicts. Then confirm Pages deploy.
6. Update STATE_agent1.md (done, PR link, next). Touch RUNNING.lock after each step; delete it before finishing.