# HARD RULES ({{REPO_SLUG}}, {{AGENT_COUNT}} parallel agents)
- ONLY project: {{REPO_SLUG}} ({{REPO_URL}}). Default branch: {{DEFAULT_BRANCH}}.
- {{AGENT_COUNT}} agents work at the same time, each in its OWN clone:
{{AGENT_LIST}}
  Work ONLY in your own agentN folder and clone. Never edit another agent's folder, files, branches or PRs.
- NEVER open, clone, edit, push to, or create any other repository. Never create new repos. Ignore any old memories, chats or state files about other projects.
- Keep every existing feature, saved user data and storage key working (never rename or drop a storage key / DB column / config key; migrate safely if a shape changes).
- Small focused PRs (one improvement each). ALWAYS start from the latest origin/{{DEFAULT_BRANCH}}: `git fetch origin`, then create your branch from origin/{{DEFAULT_BRANCH}}. Before opening or merging a PR: `git fetch origin`, `git rebase origin/{{DEFAULT_BRANCH}}`, then run the tests again.
- Stay inside your area; avoid editing files outside it. Prefer adding new files over editing shared ones. On a merge conflict: rebase onto origin/{{DEFAULT_BRANCH}} and resolve KEEPING the other agents' work (never revert or overwrite their changes).
- Tests: `{{TEST_CMD}}`. Merge a PR ONLY when the tests pass 100% locally AND CI on GitHub is green (if the repo has CI). Never delete, skip or weaken tests to make them pass.
- {{DEFAULT_BRANCH}} is protected: never force-push {{DEFAULT_BRANCH}}, never delete {{DEFAULT_BRANCH}}, never push directly to {{DEFAULT_BRANCH}}. Only your own feature branch may be force-pushed after a rebase, and only with `git push --force-with-lease`.
- Keep existing CI / GitHub Pages / build workflows working. Do not deploy to any server and do not add secrets.
- Never commit secrets, tokens, .env files or agent files (AGENTS.md, GEMINI.md, STATE*.md, TASK.md, RUNNING.lock, .agent) into the repo. Agent files live OUTSIDE the repo folder.
- Run every terminal command as ONE single command: no `cd`/`Set-Location`, no `&&`, no `;`. Set the working directory through the tool instead.
- If you are blocked (missing permission, failing auth, quota), write the problem into your STATE file and stop. Do not try to work around permissions.
