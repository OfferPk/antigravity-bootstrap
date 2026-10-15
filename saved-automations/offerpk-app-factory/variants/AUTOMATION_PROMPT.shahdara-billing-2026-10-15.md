# Automation Prompt (OfferPk) - Shahdara ISP Billing ONLY

HARD RULE: ONLY project: OfferPk/shahdara-isp-billing (https://github.com/OfferPk/shahdara-isp-billing). NEVER open, clone, edit, or pick any zen*, z*, ludo, shahdara-isp-billing-cloud, shahdara-fiber-net or any other repo. Ignore any old state or memories that mention other apps. Do not search for new app ideas. Clone command: git clone https://github.com/OfferPk/shahdara-isp-billing (run it with working directory C:\Users\Perfect\app-factory\work only if C:\Users\Perfect\app-factory\work\shahdara-isp-billing does not exist yet). Local path: C:\Users\Perfect\app-factory\work\shahdara-isp-billing.

You run as a scheduled job. Each run is a fresh conversation with no memory: ALWAYS start by reading C:\Users\Perfect\app-factory\STATE.md and continue from its "Next step". Update STATE.md after every milestone (before ending the run). Never read STATE_OLD_zen.md or anything in C:\Users\Perfect\app-factory\work_old.

## Project
- Repo: https://github.com/OfferPk/shahdara-isp-billing (exists, public, default branch main). Owner account: OfferPk.
- Clone: git clone https://github.com/OfferPk/shahdara-isp-billing (working directory C:\Users\Perfect\app-factory\work), only if C:\Users\Perfect\app-factory\work\shahdara-isp-billing is missing.
- Preview: https://offerpk.github.io/shahdara-isp-billing/ (GitHub Pages from the gh-pages branch; keep it updated by a pages.yml workflow that builds dist/ and publishes it to gh-pages on push to main).
- Forbidden repos: shahdara-isp-billing-cloud, shahdara-fiber-net, every zen*/z* repo, offline-ludo, ludo, manusailudo, and every other repo.

## Task (continuous)
Continuously make this existing app's UI rich and polished: modern design, dashboard with cards and charts, responsive (phone-first, also tablet/desktop), dark/light theme, smooth navigation, clear empty states, accessibility. Keep every existing billing feature working, fix bugs, no TODO/FIXME, no stubs, no dead buttons. When one improvement cycle is merged, start the next one (more polish, more charts/insights, better forms, tests). Never start another app.

## Data safety
- Never change storage keys or the saved data schema; migrations only additive and non-destructive. Existing users' saved data must keep loading.
- Keep the 74 starter names unchanged; no fake/demo ledger data; no backend, no data upload.
- Bump the service worker cache version when assets change.

## Workflow rules
- Feature branch from latest main -> commit -> push -> PR -> merge only when CI is green. Never force-push or rewrite main. Never delete repos or branches other than your own merged feature branches.
- Use the github MCP server for PRs, merges, Actions and Pages status.
- Run every terminal command as a single separate command: no cd/Set-Location chaining, no && or ; . Set the working directory via the tool. Work only inside C:\Users\Perfect\app-factory\work\shahdara-isp-billing.
- npm test and npm run build must pass before every PR. Add tests for new logic.
- QA with REA on our own live preview (capture_web_screenshot at mobile/desktop sizes, inspect_web_event_listeners / observe_web_execution for dead buttons and console errors). Only analyze our own app or public pages; never copy others' code or assets.
- Never commit secrets, keystores or tokens. No deploy to John's own server.
- If blocked (missing permission, CI failing after 3 fix attempts), write it under "Blockers" in STATE.md and stop the run.

## Output at end of run
Short summary: what changed, PR link, Pages link, Actions run, blockers.