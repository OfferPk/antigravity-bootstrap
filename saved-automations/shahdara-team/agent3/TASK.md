# TASK - agent3 'shahdara-forms-qa': Tables, forms, receipts, QA
Repo clone (your ONLY working copy): C:\Users\Perfect\shahdara-project\agent3\shahdara-isp-billing
Branch prefix: feat/qa-<topic>-YYYYMMDD
Your state file: C:\Users\Perfect\shahdara-project\agent3\STATE_agent3.md
Your lock file: C:\Users\Perfect\shahdara-project\agent3\RUNNING.lock
Shared rules: C:\Users\Perfect\shahdara-project\AGENTS.md (must follow)

## Your area: TABLES, FORMS, RECEIPTS, BUG FIXING, TESTS, CI
- Tables: sorting, search/filter, pagination, sticky headers, responsive (cards on mobile), empty states.
- Forms: consistent layout, inline validation with clear messages (phone numbers, amounts, dates, required fields), no data loss.
- Receipts / invoices / print views: clean printable layout (@media print), PDF-friendly.
- Bug fixing across the app (keep fixes minimal when they touch agent1/agent2 areas).
- Tests: keep `npm test` 100% green, add tests for new behaviour, never delete/weaken tests. Keep CI and .github/workflows/pages.yml healthy; if main CI is red, fixing it is your top priority.
- Do NOT redesign dashboard (agent1) or navigation/layout (agent2).
## Loop (each run)
1. Lock: handled by the shahdara-team orchestrator (C:\Users\Perfect\shahdara-project\TEAM.lock + TEAM.md). Do not use agent3\RUNNING.lock any more.
2. Working dir C:\Users\Perfect\shahdara-project\agent3\shahdara-isp-billing (if missing: git clone https://github.com/OfferPk/shahdara-isp-billing with working dir C:\Users\Perfect\shahdara-project\agent3). git fetch origin. Check your open PRs first: finish/merge or fix them before starting new work.
3. git checkout -B feat/qa-<topic>-YYYYMMDD origin/main. Implement ONE substantial feature/screen of your area COMPLETELY (code, UI, wiring, theme, mobile, empty states, tests). Minimum 20 minutes; if not finished by then, keep going until merged.
4. npm test until 100% pass (never delete or weaken tests). git fetch origin, git rebase origin/main, npm test again.
5. Push your branch, open PR via GitHub MCP (title prefix [agent3]). Merge only when npm test + CI are green and there are no conflicts. Then confirm Pages deploy.
6. Update STATE_agent3.md (done, PR link, next). Heartbeat C:\Users\Perfect\shahdara-project\TEAM.lock after each step (see TEAM.md).