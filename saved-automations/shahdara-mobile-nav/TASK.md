# TASK - agent2 'shahdara-mobile-nav': Mobile layout + navigation
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent2\shahdara-isp-billing
Branch prefix: feat/nav-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent2\STATE_agent2.md
Your lock file: C:\Users\Perfect\shahdara-project\agent2\RUNNING.lock
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md (must follow)

## Your area: MOBILE RESPONSIVE LAYOUT + NAVIGATION
- Mobile-first responsive layout (phone, tablet, desktop breakpoints), no horizontal scroll.
- Header, sidebar (collapsible on desktop, drawer on mobile), bottom navigation bar on mobile, active-page highlighting, back behaviour.
- Smooth page transitions/animations (respect prefers-reduced-motion).
- Accessibility: keyboard navigation, visible focus states, aria labels/roles, skip link, colour contrast, touch target sizes.
- Files you own: layout/nav/header/sidebar markup, nav JS, layout/nav styles (prefer separate files like layout*.css / nav*.js).
- Do NOT change dashboard cards/charts (agent1) or table/form/receipt internals (agent3).
## Loop (each run)
1. Lock: if C:\Users\Perfect\shahdara-project\agent2\RUNNING.lock exists and was modified less than 40 minutes ago, stop immediately. Otherwise write the current time into it.
2. Working dir C:\Users\Perfect\shahdara-project\agent2\shahdara-isp-billing (if missing: git clone https://github.com/OfferPk/shahdara-isp-billing with working dir C:\Users\Perfect\shahdara-project\agent2). git fetch origin. Check your open PRs first: finish/merge or fix them before starting new work.
3. git checkout -B feat/nav-<topic>-YYYYMMDD origin/main. Make ONE focused improvement in your area. Add/adjust tests.
4. npm test until 100% pass (never delete or weaken tests). git fetch origin, git rebase origin/main, npm test again.
5. Push your branch, open PR via GitHub MCP (title prefix [agent2]). Merge only when npm test + CI are green and there are no conflicts. Then confirm Pages deploy.
6. Update STATE_agent2.md (done, PR link, next). Touch RUNNING.lock after each step; delete it before finishing.