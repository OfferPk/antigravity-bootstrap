# HARD RULES (Shahdara UI project)
- ONLY project: OfferPk/shahdara-isp-billing (https://github.com/OfferPk/shahdara-isp-billing).
- Local repo: C:\Users\Perfect\shahdara-project\shahdara-isp-billing
- NEVER open, clone, edit, push to, or create any other repo (zen*, z*, ludo, shahdara-isp-billing-cloud, shahdara-fiber-net, or anything else). Never create new repos.
- IGNORE C:\Users\Perfect\app-factory completely, and ignore any old memories/state that mention other apps.
- No backend. Static web app only. Keep all billing features, saved data and localStorage/storage keys working (never rename or drop a storage key; migrate safely if a shape changes).
- Work on a feature branch -> open PR on GitHub (GitHub MCP) -> merge ONLY when `npm test` passes 100% locally and CI is green. main is protected (no force push, no delete).
- Keep the GitHub Pages preview workflow (.github/workflows/pages.yml) working. Preview: https://offerpk.github.io/shahdara-isp-billing/
- Run every terminal command as a single command: no cd/Set-Location chaining, no && or ;. Set the working directory via the tool.
- Do NOT commit AGENTS.md, STATE.md, PROMPT.md or .agent files into the repo; they live outside the repo in C:\Users\Perfect\shahdara-project.