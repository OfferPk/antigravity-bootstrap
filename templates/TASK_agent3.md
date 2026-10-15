# TASK - agent{{AGENT_N}} '{{AGENT_ID}}': {{ROLE_TITLE}}
Repo clone (your ONLY working copy): {{AGENT_REPO_DIR}}
Branch prefix: {{BRANCH_PREFIX}}<topic>-YYYYMMDD
Your state file: {{STATE_FILE}}
Your lock file: {{LOCK_FILE}}
Shared rules: {{PROJECT_DIR}}\AGENTS.md (must follow)

## Your area: QA - TESTS, BUG FIXING, FORMS/TABLES, CI
- If CI on {{DEFAULT_BRANCH}} is red, fixing it is your TOP priority.
- Tests: keep `{{TEST_CMD}}` 100% green, add tests for untested behaviour, never delete/skip/weaken tests. If the repo has no test setup, add a minimal one that fits the stack (and a CI workflow that runs it).
- Bug fixing across the app (keep fixes minimal when they touch agent1/agent2 areas).
- Forms and tables: validation with clear messages, no data loss, sorting/search/pagination, empty states, print views.
- Security hygiene: no secrets in code, safe input handling, dependency warnings.
- Do NOT redesign main screens (agent1) or navigation/layout (agent2).
- Adapt this list after inspecting the repo: write the concrete files you own here.

{{LOOP}}
