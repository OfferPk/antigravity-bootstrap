# agent5 - Easypaisa Email Reader (shahdara-easypaisa) - TASK
ONLY job: GitHub issue #305 in OfferPk/shahdara-isp-billing ("Easypaisa email reader: Google Apps Script + Google Sheet + Payments Inbox"). Read the issue body first (it has the design, sample email and acceptance list). Work in C:\Users\Perfect\shahdara-project\agent5\shahdara-isp-billing, branches feat/easypaisa-*.

## LANE (see LANES.md)
- OWNS: integrations/gmail-easypaisa/** (Code.gs, README.md with John's 5-step setup), the pure parser module (e.g. easypaisa-parser.js), the new Payments Inbox module (e.g. payments-inbox.js / payments-inbox.css), their unit tests (tests/easypaisa-*.test.*) and e2e specs (tests/e2e/easypaisa-*.spec.mjs), and the route #/easypaisa.
- Wiring allowed (additive, minimal, mention it in the PR): ONE script/link tag in index.html for the new module, and ONE route entry for #/easypaisa in screen-router.js using its existing registration pattern. If that is not possible additively, open a `lane:agent4` issue with the exact route spec and meanwhile open the inbox from a button inside your own module.
- Payment recording: use the EXISTING payment API/functions (the same logic Quick Collect uses) and the existing toast/confirm system (ui-feedback). Do NOT edit other lanes' files (app.js customer/payment code, core.js behaviour, bulk-collect, payments-list, ...). If the API lacks something, open a `lane:agent4` issue (or `lane:agentN` for its owner) and work around it in your module.
- Never store passwords or API keys. No paid APIs. Never remove existing features. Never rename storage keys; your own settings use a new key (e.g. easypaisaInbox.*).

## PLAN (one focused PR per step; each fits a 45-min budget turn)
1. Parser: table-driven templates; fields type, txnId, datetime (PKT), senderName/Number, receiverName/Number, amount, fee, total; direction Sent/Received by setting ownerNumber; unparsed -> "Needs review". Unit tests: issue sample, missing-fee variant, garbage email. (Fixes nothing yet: "Part of #305".)
2. Apps Script: integrations/gmail-easypaisa/Code.gs (GmailApp read-only search, label crm-processed, append to Sheet, dedupe by txnId, setup() + 10-15 min trigger) reusing the parser logic; README with the 5-step setup and privacy note.
3. Payments Inbox screen #/easypaisa: Sheet CSV URL setting (published CSV, no key) + manual paste/CSV upload fallback; Today / This month Sent vs Received totals; list with filters.
4. Matching + record: match Received rows by sender number to customer phone; one-tap "Record payment" via the existing payment logic with txnId in the payment's Transaction ID field; never double-record (dedupe by txnId); manual link for unmatched rows.
5. PDF statement import (pdf.js via the same lazy loader as customer-import.js) -> same rows, dedupe by txnId.
6. e2e at 390x844 and 1280x800: import sample CSV, totals, match, record, no duplicate on second import. Final PR body: Fixes #305.
When #305 is merged and verified live: write DONE.txt in C:\Users\Perfect\shahdara-project\agent5 (the gate then stops scheduling agent5) and note it in STATE_agent5.md.

## Rules
Follow TEAM.md (lock/heartbeat, EFFICIENCY & QUOTA RULE, BUDGET MODE, HELP GROK RULE, WORKFLOW RULE, PUSH RULE), LANES.md and AGENTS.md. PR titles "[agent5] #305 <step>", label lane:agent5. Append STATE_agent5.md (LAST / PR / NEXT) after every milestone. On a 429: save STATE, delete TEAM.lock, end. Never switch accounts.
