> 2026-10-18 SOLO MODE: this audit is INCOMPLETE and its 'Works' marks are NOT trusted (John: the app is not fully functional). Rebuild it as an exhaustive top-to-bottom inventory per agent4\TASK.md Step A and re-verify every row in a real browser.

# FEATURE AUDIT - shahdara-isp-billing (maintained by agent4, real-browser checks only)
Viewports: mobile 390x844, desktop 1280x800. Status: Works / Broken / Ugly / Unchecked.

| Area | Item | Selector | Mobile | Desktop | Status | Notes | Fixed in PR |
|---|---|---|---|---|---|---|---|
| Mobile Navigation | Speed-dial trigger | #speedDialTrigger | Works | Hidden (N/A) | Works | Compact 50px FAB; rotates 45deg on expand; touch-friendly >= 44px | Fixed in PR #178 |
| Mobile Navigation | Speed-dial menu | #speedDialMenu | Works | Hidden (N/A) | Works | Collapsed on load; max 5 primary actions; closes on backdrop/outside/Esc/tap | Fixed in PR #178 |
| Mobile Navigation | Speed-dial backdrop | #speedDialBackdrop | Works | Hidden (N/A) | Works | Blur backdrop; tap to dismiss; hidden when closed | Fixed in PR #178 |
| Mobile Navigation | Field Tools sheet | #fieldToolsModal | Works | Works | Works | Grouped bottom sheet (Field Ops, Fiber & Optical, Outside Plant); closes on Esc/close/tool tap | Fixed in PR #178 |
| Connectivity | Offline Sync Banner | #offlineSyncBanner | Works | Works | Works | Top-safe above content; tap to dismiss; 6s auto-dismiss; sessionStorage persistence | Fixed in PR #178 |
| Feedback | Notification Toast | #toast | Works | Works | Works | Bottom-safe above bottom nav bar (calc(60px + 16px)); tap to dismiss; auto-dismiss | Fixed in PR #178 |
| Dashboard Ribbon | Receive Payment | [data-quick-action="payment"] | Works | Works | Works | Opens quick payment modal | Prior PRs |
| Dashboard Ribbon | Add Customer | [data-quick-action="customer"] | Works | Works | Works | Opens add customer modal | Prior PRs |
| Dashboard Ribbon | Record Expense | [data-quick-action="expense"] | Works | Works | Works | Navigates to expenses view | Prior PRs |
| Dashboard Ribbon | Monthly Report | [data-quick-action="report"] | Works | Works | Works | Navigates to monthly closing report | Prior PRs |
| Dashboard Ribbon | Area Intelligence | [data-quick-action="area"] | Works | Works | Works | Opens area performance view | Prior PRs |
| Dashboard Ribbon | Backup Ledger | [data-quick-action="backup"] | Works | Works | Works | Opens backup & restore dialog | Prior PRs |
| Dashboard Ribbon | Executive Briefing | [data-quick-action="briefing"] | Works | Works | Works | Opens executive digest dialog | Prior PRs |
| Dashboard Ribbon | Top Defaulters | #quickActionTopDefaulters | Works | Works | Works | Opens top defaulters & recovery suite; multi-trigger wired | Fixed in PR #180 |
| Dashboard Ribbon | Area Collections | #quickActionAreaCollections | Works | Works | Works | Opens area-wise recovery & collections | PR #177 |
| Mobile Action Sheet | Quick Actions Sheet | #mobileActionSheet | Works | Hidden (N/A) | Works | Max-height: 82vh; smooth scroll; closes via close btn, Esc, or upper backdrop tap | Fixed in PR #180 |
| Mobile Action Sheet | Action Sheet Backdrop | #mobileActionSheetBackdrop | Works | Hidden (N/A) | Works | Fullscreen blur backdrop; dismissed via tap without child interception | Fixed in PR #180 |
| Navigation Drawer | Off-canvas Drawer | #navDrawer | Works | Works | Works | Closes automatically on item navigation or close button / Esc | Verified |
| Topbar | Language Switcher | #languageToggle | Works | Works | Works | Bilingual toggle (English / اردو) with full RTL flow | PR #179 |
| Search | Global Search Input | #globalCustomerSearch | Works | Works | Works | Fast live search across names, phones, numbers | Prior PRs |
| Topbar | Theme Toggle | #themeToggleBtn | Works | Works | Works | Toggles light and dark themes smoothly | Prior PRs |
| Topbar | App Brand | .brand-mark | Works | Works | Works | Responsive brand badge and title | Prior PRs |
| Viewport | Mobile Overflow | html, body | Works | Works | Works | Zero horizontal scroll overflow at 390px (scrollWidth === clientWidth) | Verified |
| Customers | Add Customer Dialog | #addCustomerDialog | Works | Works | Works | Opens and creates customer with clean validation | Verified PR #182 |
| Customers | Profile Tab Config | #profileTabInfo | Works | Works | Works | Package speed and custom rate updates save without reload | Verified PR #182 |
| Billing | Month Card Disclosure | details.month-card | Works | Works | Works | Preserves open state across profile/bill re-renders, defaults first open | Fixed in PR #182 |
| Billing | Payment Submission | form.payment-form | Works | Works | Works | Records cash & digital payments, updates balance immediately | Verified PR #182 |
| Receipts | Thermal Print Layouts | .receipt-preview-dialog | Works | Works | Works | A4, 80mm, and 58mm layouts render and trigger window.print() | Verified PR #181, #182 |
| Receipts | WhatsApp Notice Draft | a[href*="whatsapp.com"] | Works | Works | Works | Encodes customer balance, period, and ISP details | Verified PR #182 |
| Customers | Technical QA Accordion | #customerTechnicalToolsDetails | Works | Works | Works | 24 engineering & field certificates grouped cleanly; reduces height from 850px to 10-button billing suite | Fixed in PR #184 |
| Receipts | Batch Billing Slips Modal | #batchReceiptModal | Works | Works | Works | Month selector dropdown, wired close handlers, scoped print styling | Fixed in PR #184 |
| Billing | Customer Account Statement | #statementModal | Works | Works | Works | Esc key dismiss, responsive 390px mobile table & 44px touch targets | Fixed in PR #184 |
| Billing | Payment Reminder Modal | #reminderModal | Works | Works | Works | Esc key dismiss, full-width mobile actions & responsive preview | Fixed in PR #184 |
| Transactions | Payment History View | #transactionsView | Works | Works | Works | Real-time payment records, filter by date/recency/method, summary metrics | Fixed in PR #186 |
| Transactions | Filter Action Grid | .transaction-filter-actions | Works | Works | Works | Clear filters & Export CSV buttons, 44px mobile touch targets, zero overflow | Fixed in PR #186 |
| Transactions | Export CSV | #exportTransactionsCsvBtn | Works | Works | Works | RFC-4180 CSV export with filtered payments & date | Fixed in PR #186 |
| Monthly Reports | Monthly Closing View | #billingReportsView | Works | Works | Works | Month picker, status filter chips, customer search, billed/collected metrics | Fixed in PR #186 |
| Monthly Reports | Search & Export Bar | .report-search-bar | Works | Works | Works | Flex search input, Export CSV and Print Slips actions, responsive 390px grid | Fixed in PR #186 |
| Monthly Reports | Auto-Credit Detail Panel | .report-credit-cell | Works | Works | Works | Full-width spanning panel, dark theme support, clean financial column alignment | Fixed in PR #186 |
| Table Pagination | Responsive Pagination Bar | .table-pagination | Works | Works | Works | Touch-friendly >= 44px buttons & page size selector on <= 620px mobile screens | Fixed in PR #186 |
| Backup & Restore | Backup Actions Mobile Grid | .backup-actions | Works | Works | Works | #verifyStorageIntegrityBtn spans full width (grid-column: 1 / -1) on <= 620px mobile viewports | Fixed in PR #188 |
| Backup & Restore | CSV Customer Import Modal | #csvImportDialog | Works | Works | Works | Esc key / backdrop click / close button dismiss cleanly; wipe pending buffers; touch scroll table | Fixed in PR #188 |
| Backup & Restore | Storage Health Audit | #verifyStorageIntegrityBtn | Works | Works | Works | Resilient local storage catalog roundtrip audit with toast status | Fixed in PR #188 |
| Modals | Dark Mode Backup Colors | .backup-modal | Works | Works | Works | Replaced white modal actions with dark surface token; legible preview, rules, and conflict text | Fixed in PR #188 |
| Expenses | Month Filter Dropdown | #expenseMonthFilter | Works | Works | Works | Populated from historical expense/payroll months, instant filtering | Fixed in PR #190 |
| Expenses | Filtered Total KPI Metric | #expenseFilteredTotal | Works | Works | Works | Real-time calculated expenditure for active filters + contextual help | Fixed in PR #190 |
| Expenses | Filtered CSV Export | #exportExpensesCsvBtn | Works | Works | Works | Exports active filtered expense rows or all rows when unfiltered | Fixed in PR #190 |
| Expenses | Mobile Touch Targets & Dark Theme | .table-filter-toolbar, .expense-actions | Works | Works | Works | 44px min-height touch targets, dark theme button backgrounds and hover styles | Fixed in PR #190 |
| Inventory | Equipment Register View | #inventoryView | Works | Works | Works | Live metric cards, item definitions, stock movements trail | Verified PR #192 |
| Inventory | Stock Level Status Filter | #inventoryStockFilter | Works | Works | Works | Filters items by All, Low stock (<= min), Out of stock (0), In stock (> min), Unrecorded | Fixed in PR #192 |
| Inventory | Visual Stock Status Pills | .stock-status-pill | Works | Works | Works | In stock (green), Low stock (amber), Out of stock (red), Unrecorded (gray) with dark mode | Fixed in PR #192 |
| Inventory | Filtered CSV Export | #exportInventoryCsvBtn | Works | Works | Works | Exports live stock balances, unit costs, values, movements breakdown, and status | Fixed in PR #192 |
| Inventory | Mobile Touch Targets & Dark Theme | .inventory-actions, .table-filter-toolbar | Works | Works | Works | 44px min-height touch targets, dark theme buttons and responsive inputs | Fixed in PR #192 |
| Billing | Customer Statement WhatsApp Sharing | #shareStatementWhatsAppBtn | Works | Works | Works | One-tap bilingual Urdu & English WhatsApp summary dispatch, clipboard fallback | Fixed in PR #194 |
| Billing | Batch Slip Direct WhatsApp Reminders | .batch-slip-wa-btn | Works | Works | Works | Direct reminder dispatch on batch slips with customerNumber display; hidden during print | Fixed in PR #194 |
| Monthly Reports | Bulk Pending Reminders Action | #bulkReminderDispatchBtn | Works | Works | Works | Pre-filters batch slips to pending with >= 44px mobile touch target | Fixed in PR #194 |
| Mobile Navigation | Reminders Speed-Dial Auto-Select | [data-speed-action="reminders"] | Works | Hidden (N/A) | Works | Automatically selects active or first pending dues customer and opens reminder modal | Fixed in PR #194 |
| Customer Tables | Customer Roster Desktop Expand Mode | #customerTableExpandBtn | Hidden (N/A) | Works | Works | Full-width 1320px master ledger view; auto-collapses on row selection | Fixed in PR #200 |
| Customer Tables | Accessible Keyboard Table Headers | th[data-sort-cust] | Works | Works | Works | role="columnheader", tabindex="0", dynamic aria-sort, visible sort arrows, keyboard Enter/Space sorting | Fixed in PR #200 |
| Customer Tables | Contextual Table Empty State | .customer-table-empty | Works | Works | Works | Contextual query/area message and 1-click #resetCustomerTableFiltersBtn | Fixed in PR #200 |
| Customer Tables | RFC-4180 Roster CSV Export | #exportCustomerRosterCsvBtn | Works | Works | Works | RFC-4180 compliant CSV export with UTF-8 BOM, escaped values, and toast notification | Fixed in PR #200 |
| Area Analytics | Area Intelligence 10-Column Sorting | th[data-sort-area] | Works | Works | Works | All 10 columns sortable with keyboard Enter/Space, aria-sort, and sort arrows | Fixed in PR #202 |
| Area Analytics | Area Intelligence Live Search Toolbar | #areaIntelSearch | Works | Works | Works | Instant search filtering with dynamic #areaIntelRowCount badge and contextual empty state with reset | Fixed in PR #202 |
| Area Analytics | Area Intelligence RFC-4180 CSV Export | #exportAreaIntelCsvBtn | Works | Works | Works | UTF-8 BOM CSV export of date-filtered area/zone finances, rates, and expenses | Fixed in PR #202 |
| Area Analytics | Package Summary Full Column Sorting & CSV | th[data-sort-pkgsum], #exportPackageSummaryCsvBtn | Works | Works | Works | Interactive column sorting across 10 metrics + RFC-4180 CSV export | Fixed in PR #202 |
| Area Analytics | Location Summary RFC-4180 CSV Export | #exportAreaSummaryCsvBtn | Works | Works | Works | RFC-4180 CSV export of location hierarchy summary with ARPU and online status | Fixed in PR #202 |
| Daily Register | Daily Closing Receipts Live Search | #dailyClosingReceiptsSearch | Works | Works | Works | Live receipts search toolbar with dynamic count badge and 1-click filter reset | Fixed in PR #204 |
| Daily Register | Daily Closing Receipts Column Sorting | th[data-sort-dcr] | Works | Works | Works | Interactive keyboard/click sorting across 7 columns (customerNumber, amount, etc.) | Fixed in PR #204 |
| Daily Register | Daily Closing SVG Standards & Mobile UI | #dailyClosingSvgContainer svg | Works | Works | Works | Removed invalid height=auto attribute, valid rx rects, 44px mobile touch targets | Fixed in PR #204 |
| Expenses | Expense Table 4-Column Accessible Sorting | th[data-sort-expense] | Works | Works | Works | role="columnheader", tabindex="0", dynamic aria-sort, visible sort arrows (▲, ▼, ⇅), keyboard Enter/Space | Fixed in PR #206 |
| Expenses | Expense Empty State 1-Click Clear Filters | #resetExpenseFiltersInlineBtn | Works | Works | Works | Contextual empty message with 1-click filter reset button; 44px mobile touch target | Fixed in PR #206 |
| Expenses | Dismissible Payroll Prefill Notice | #dismissExpensePayrollNoticeBtn | Works | Works | Works | Dismiss button hides notice without clearing prefilled salary fields | Fixed in PR #206 |
| Expenses | RFC-4180 Expense CSV Export with Location | #exportExpensesCsvBtn | Works | Works | Works | RFC-4180 CSV export with UTF-8 BOM, Area / Mohalla column, and active filter criteria | Fixed in PR #206 |



