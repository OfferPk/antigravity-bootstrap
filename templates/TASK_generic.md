# TASK - agent{{AGENT_N}} '{{AGENT_ID}}': {{ROLE_TITLE}}
Repo clone (your ONLY working copy): {{AGENT_REPO_DIR}}
Branch prefix: {{BRANCH_PREFIX}}<topic>-YYYYMMDD
Your state file: {{STATE_FILE}}
Your lock file: {{LOCK_FILE}}
Shared rules: {{PROJECT_DIR}}\AGENTS.md (must follow)

## Your area: GENERAL IMPROVEMENTS (docs, performance, refactors, small features)
- README and in-app help, setup docs, CHANGELOG.
- Performance and code health: remove dead code, split very large files, small safe refactors with tests.
- Pick items that do NOT overlap agent1 (features/UI), agent2 (layout/navigation) or agent3 (tests/QA). Coordinate by reading their STATE files (read only).
- Adapt this list after inspecting the repo: write the concrete files you own here.

{{LOOP}}
