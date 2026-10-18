# saved-automations
Saved copies of John's Antigravity automations (sidecars + their prompt/task files). No tokens or secrets.
Paths are stored as `C:\Users\Perfect`; `scripts/enable-saved.ps1` rewrites them to the current `%USERPROFILE%`.

See [../AUTOMATIONS_GUIDE.md](../AUTOMATIONS_GUIDE.md) for what each one does and how to turn it on/off.

- `offerpk-app-factory` - offline game factory (original .bak4 copy, not reconstructed)
- `shahdara-ui` - single UI agent for shahdara-isp-billing (conflicts with the 3 agents)
- `shahdara-team` - SOLO MODE since 2026-10-18 (only agent4 polish-qa, full functional pass, grok-review issues first; team-mode files in `shahdara-team/team-mode/`). Team mode: one orchestrator, 4 Shahdara agents take turns in a 6-slot rotation (agent1 -> agent4 polish-qa -> agent2 -> agent4 -> agent3 -> agent4), each turn min 20 min until merged; agent4 checks and fixes existing features in a real browser
- `shahdara-dashboard`, `shahdara-mobile-nav`, `shahdara-forms-qa` - the 3 parallel Shahdara agents (old parallel mode; conflicts with shahdara-team)
