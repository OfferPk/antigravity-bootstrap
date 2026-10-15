## Loop (every run)
1. {{LOOP_LOCK}}
2. Working dir `{{AGENT_REPO_DIR}}`. If it is missing: `git clone {{REPO_URL}} {{REPO_NAME}}` with working dir `{{AGENT_DIR}}`. Then `git fetch origin`.
3. Check YOUR open PRs first (title prefix `[agent{{AGENT_N}}]`): fix, rebase, finish or merge them before starting anything new.
4. `git checkout -B {{BRANCH_PREFIX}}<topic>-YYYYMMDD origin/{{DEFAULT_BRANCH}}`. {{LOOP_WORK}}
5. Install deps if needed, run `{{TEST_CMD}}` until 100% pass. `git fetch origin`, `git rebase origin/{{DEFAULT_BRANCH}}`, run the tests again.
6. `git push -u origin <branch>` (after a rebase of an already pushed branch: `git push --force-with-lease`). Open a PR via the GitHub MCP server `{{MCP_GITHUB}}` with title prefix `[agent{{AGENT_N}}]` and a short description.
7. Merge only when tests + CI are green and there are no conflicts (squash merge). Delete your merged branch.
8. Update `{{STATE_FILE}}`: what you did, PR link, result, what is NEXT. {{LOOP_END}}
