# TASK - agent{{AGENT_N}} '{{AGENT_ID}}': {{ROLE_TITLE}}
Repo clone (your ONLY working copy): {{AGENT_REPO_DIR}}
Branch prefix: {{BRANCH_PREFIX}}<topic>-YYYYMMDD
Your state file: {{STATE_FILE}}
Your lock file: {{LOCK_FILE}}
Shared rules: {{PROJECT_DIR}}\AGENTS.md (must follow)

## Your area: FEATURES + UI (main screens)
- Main screens / pages / dashboard: modern, clean, consistent visual design (spacing, typography, colours, cards, icons, empty states, loading states).
- Complete half-finished features you find (TODOs, stub pages, dead buttons) so the app is fully usable end to end.
- Dark/light theme support if the project is a UI app; reuse existing design tokens/CSS variables, add them if missing.
- No new external CDNs or heavy libraries unless the project already uses that stack.
- Do NOT restyle navigation/layout/mobile (agent2) or forms/tables/tests infrastructure (agent3). If the project has no UI (library/CLI/API), your area is: new features, API completeness and docs.
- Adapt this list after inspecting the repo: write the concrete screens/modules you own here.

{{LOOP}}
