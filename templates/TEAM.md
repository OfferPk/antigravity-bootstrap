# TEAM - sequential orchestrator (ONE run at a time, agents take turns)

Project: ONLY {{REPO_SLUG}} ({{REPO_URL}}). Default branch: {{DEFAULT_BRANCH}}. Tests: `{{TEST_CMD}}`.
Root: {{PROJECT_DIR}}
Agents (each has its OWN clone, area, TASK.md and STATE file):
{{AGENT_LIST}}

## SCOPE (always)
- stay within the target app's own business domain (read the README/ROADMAP to learn it). New work must add real value for that app's users. No unrelated simulators, calculators or tools from other domains, and no busywork modules added only to show activity. Never remove, hide or break existing features: only add new in-domain features and improve existing ones. Before building, search the code for an existing version of the feature and extend it instead of duplicating it.
- Pick tasks from the agent's TASK.md backlog in order. If an idea does not help the app's real users, skip it and take the next backlog item.
