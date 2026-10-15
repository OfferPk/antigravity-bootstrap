# TASK - agent{{AGENT_N}} '{{AGENT_ID}}': {{ROLE_TITLE}}
Repo clone (your ONLY working copy): {{AGENT_REPO_DIR}}
Branch prefix: {{BRANCH_PREFIX}}<topic>-YYYYMMDD
Your state file: {{STATE_FILE}}
Your lock file: {{LOCK_FILE}}
Shared rules: {{PROJECT_DIR}}\AGENTS.md (must follow)

## Your area: MOBILE / RESPONSIVE LAYOUT + NAVIGATION + ACCESSIBILITY
- Mobile-first responsive layout (phone, tablet, desktop breakpoints), no horizontal scroll, safe touch target sizes.
- Header, sidebar/drawer, bottom navigation on mobile, active-page highlighting, back behaviour, routing.
- Smooth transitions (respect prefers-reduced-motion).
- Accessibility: keyboard navigation, visible focus, aria labels/roles, skip link, colour contrast.
- Performance of page load (lazy loading, smaller assets) when it touches layout.
- Do NOT change main screen content/features (agent1) or forms/tables/tests infrastructure (agent3). If the project has no UI, your area is: CLI/API ergonomics, error messages, configuration and developer experience.
- Adapt this list after inspecting the repo: write the concrete files you own here.

{{LOOP}}
