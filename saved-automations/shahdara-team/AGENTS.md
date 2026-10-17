# HARD RULES (Shahdara project, 3 agents taking turns ONE AT A TIME via the shahdara-team orchestrator - see TEAM.md)
## HARD SCOPE RULE (added 2026-10-17, overrides older ideas in STATE files)
- This repo is a small Pakistani ISP's offline BILLING / BUSINESS app. ALL NEW work must be billing/business features only: customers, packages, monthly bills, payments, receipts (incl. WhatsApp), dues/ledger, expenses, staff/collectors, reports, settings, backup/restore, and UI/UX polish of these.
- FORBIDDEN for new work: network / optical / routing engineering tools, calculators or simulators (OTDR, BGP, MPLS, SRv6, EVPN, DWDM, ROADM, OTN, PON/DBA physics, fiber splicing/cleaving, Raman/EDFA, PMD, Kerr, microwave, etc.). Do not create new dashboard-*/nav-*/qa-* modules of this kind and do not extend the existing ones.
- NEVER remove, hide or break existing features (including the engineering panels already in the app). Only add new billing features and improve existing ones. Keep `npm test` 100% green.
- Test for every task: "Does this help the owner bill, collect, track dues/expenses or run the business faster?" If not, pick the next task from your TASK.md backlog.
- Before building, search the code (rg) for an existing version of the feature. If it exists, extend and improve it instead of creating a duplicate.
- Take tasks from your TASK.md backlog in order (top first). STATE "NEXT" ideas about network engineering are void.
- ONLY project: OfferPk/shahdara-isp-billing (https://github.com/OfferPk/shahdara-isp-billing).
- 3 agents, each with its OWN clone, work one after another (agent1 -> agent2 -> agent3 -> agent1 ...):
  - agent1 shahdara-dashboard  -> C:\Users\Perfect\shahdara-project\agent1\shahdara-isp-billing (branches feat/dash-*)
  - agent2 shahdara-mobile-nav -> C:\Users\Perfect\shahdara-project\agent2\shahdara-isp-billing (branches feat/nav-*)
  - agent3 shahdara-forms-qa   -> C:\Users\Perfect\shahdara-project\agent3\shahdara-isp-billing (branches feat/qa-*)
  Work ONLY in your own agentN folder and clone. Never edit another agent's folder, files, branches or PRs. C:\Users\Perfect\shahdara-project\shahdara-isp-billing is an old reference copy: do not use it.
- NEVER open, clone, edit, push to, or create any other repo (zen*, z*, ludo, shahdara-isp-billing-cloud, shahdara-fiber-net, or anything else). Never create new repos. IGNORE C:\Users\Perfect\app-factory and any old memories/state about other apps.
- No backend. Static web app only. Keep all billing features, saved data and localStorage/storage keys working (never rename or drop a storage key; migrate safely if a shape changes).
- Each agent turn = ONE substantial feature/screen implemented completely (minimum 20 minutes; keep going until it is merged). No tiny edits. ALWAYS start from latest origin/main: git fetch origin, then create the branch from origin/main. Before opening/merging a PR: git fetch origin and git rebase origin/main (or git merge origin/main), rerun npm test.
- Stay inside your area; avoid editing files outside it. Prefer adding new files over editing shared ones. If a merge conflict happens: rebase onto origin/main and resolve KEEPING the other agents' work (never revert or overwrite their changes).
- Merge a PR ONLY when `npm test` passes 100% locally AND CI is green on GitHub. main is protected: never force-push main, never delete main, never push directly to main. (Force-push only your own feature branch after a rebase: git push --force-with-lease.)
- Keep the GitHub Pages preview workflow (.github/workflows/pages.yml) working. Preview: https://offerpk.github.io/shahdara-isp-billing/
- Run every terminal command as a single command: no cd/Set-Location, no && or ;. Set the working directory via the tool.
- Never commit agent files (AGENTS.md, GEMINI.md, PROMPT.md, STATE*.md, TASK.md, RUNNING.lock, .agent) into the repo; they live outside the repo folder.