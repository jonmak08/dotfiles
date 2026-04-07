# Known Issues

Pattern-matched error and issue catalog. Each entry helps the investigate and respond skills recognize common problems and provide high-confidence responses.

## Entry Format

Each entry follows this structure:

### [Short title]
- **Pattern:** Keywords or error messages that match this issue
- **Category:** Data lookup | Error diagnosis | Bug report | How-to | Operational
- **Diagnosis:** Steps to confirm this is the issue
- **Fix:**
  - Immediate: [quick fix, e.g., console command]
  - Long-term: [code change or process fix]
- **Confidence:** HIGH | MEDIUM

---

## Entries

### Update First Year of Revenue / First Year Sales
- **Pattern:** first year of revenue, first_year_sales, first year sales, wrong first year, incorrect first year
- **Category:** Data lookup
- **Diagnosis:** Check `TaxPeriodFilingSurvey.find_by(tax_period_id: ?).first_year_sales` — value is wrong or nil
- **Fix:**
  - Immediate: `TaxPeriodFilingSurvey.find_by(tax_period_id: TAX_PERIOD_ID).update!(first_year_sales: YEAR)` via console
  - Long-term: N/A — this is a manual data correction when client provides updated info
- **Confidence:** HIGH

### Update Utilization Strategy
- **Pattern:** utilization strategy, allowed_utilization_strategy, liability, carryforward, payroll, wrong utilization
- **Category:** Data lookup
- **Diagnosis:** Check `TaxPeriodFilingSurvey.find_by(tax_period_id: ?).allowed_utilization_strategy` — value doesn't match client's election
- **Fix:**
  - Immediate: `TaxPeriodFilingSurvey.find_by(tax_period_id: TAX_PERIOD_ID).update!(allowed_utilization_strategy: 'STRATEGY')` where STRATEGY is liability/carryforward/payroll
  - Long-term: N/A — manual correction
- **Confidence:** HIGH

### ExtendFilingPlan Backfill
- **Pattern:** extend filing, extended filing plan, filing extension, upcoming filing date, tax_return_filed_status extended
- **Category:** Operational
- **Diagnosis:** Company filed for extension — need to update filing survey status and date
- **Fix:**
  - Immediate: `bin/rails 'backfill:run_service[ExtendFilingPlan]' -- --dry_run false --tax_period_id TAX_PERIOD_ID` then optionally `TaxPeriodFilingSurvey.find_by(tax_period_id: TAX_PERIOD_ID).update!(upcoming_tax_filing_date: "YYYY-MM-DD 07:00:00")`
  - Long-term: N/A — standard operational procedure
- **Confidence:** HIGH

### Update CPA Contact Info
- **Pattern:** CPA email, CPA name, update CPA, accountant email, accountant contact
- **Category:** Data lookup
- **Diagnosis:** Navigate to company tax period info page to verify current CPA details
- **Fix:**
  - Immediate: Update via admin UI at `credits.gusto.com/company/COMPANY_ID/taxPeriod/TAX_PERIOD_ID/info` or via console
  - Long-term: N/A — manual correction
- **Confidence:** HIGH

### Link Gusto/Panda Account
- **Pattern:** gusto uuid, panda, link gusto, link company, gusto_uuid, GustoCompany uuid
- **Category:** Operational
- **Diagnosis:** Company in Mithrin not linked to corresponding Gusto Panda account — check `Company.find(ID).gusto_uuid`
- **Fix:**
  - Immediate: `Company.find(COMPANY_ID).update!(gusto_uuid: 'UUID')` — find UUID from Gusto Panda admin
  - Long-term: N/A — manual linking
- **Confidence:** HIGH

### Update Study Status (Mark as Lost)
- **Pattern:** mark as lost, study lost, study status, unable to file, cancel study
- **Category:** Operational
- **Diagnosis:** Check `Study.find(ID).status` — study needs to be marked lost
- **Fix:**
  - Immediate: `Study.find(STUDY_ID).mark_as_lost!(primary_lost_reason: 'REASON')`
  - Long-term: N/A — standard operational procedure
- **Confidence:** HIGH

### Mark Study as Unlost
- **Pattern:** unlost, reactivate study, un-lost, reopen study, mark_as_unlost
- **Category:** Operational
- **Diagnosis:** Check `Study.find(ID).status` — study was marked lost but should be active
- **Fix:**
  - Immediate: `study = Study.find(STUDY_ID)` then `study.mark_as_unlost!`
  - Long-term: N/A
- **Confidence:** HIGH

### Invoice Adjustments (Cancel Future Orders)
- **Pattern:** cancel invoice, cancel future orders, void invoice, invoice status, wrong invoice
- **Category:** Operational
- **Diagnosis:** Check invoice/order status for the study
- **Fix:**
  - Immediate: `bin/rake 'backfill:run_service[Invoicing::CancelFutureOrders]' -- --dry_run false --study_ids '"STUDY_ID"'`
  - Long-term: N/A
- **Confidence:** HIGH

### Update Wages/Expenses/Gross Receipts
- **Pattern:** wages, expenses, gross receipts, year-end values, QRE amounts, update amounts
- **Category:** Data lookup
- **Diagnosis:** Check QRE and wage data for the tax period — values incorrect or need updating
- **Fix:**
  - Immediate: Update via console — specific fields depend on the data type. Requires console access.
  - Long-term: N/A — manual correction when client provides updated financial data
- **Confidence:** MEDIUM

### Update Post-Published Status
- **Pattern:** post_published_status, qual_service, credits_approved, declaration_statement
- **Category:** Operational
- **Diagnosis:** Check `Study.find(ID).post_published_status` — status needs manual advancement
- **Fix:**
  - Immediate: Update post_published_status hash via console (see audit log for specific status transitions)
  - Long-term: N/A
- **Confidence:** MEDIUM

### Stuck Codat Import
- **Pattern:** codat import stuck, import never completed, codat pull, import stuck
- **Category:** Error diagnosis
- **Diagnosis:** Check `CodatImport.where(company_id: COMPANY_ID)` for incomplete imports. Verify Codat pull-history for errors.
- **Fix:**
  - Immediate: Re-trigger: `stuck_import = CodatImport.find(ID)` then `ImportCodatJob.perform_now(stuck_import.user, stuck_import.company_id, stuck_import.tax_period_id)`
  - Long-term: Investigate root cause (Codat sync issue vs Mithrin processing bug)
- **Confidence:** MEDIUM

### Update Calculation Method (RdCredit aux_data)
- **Pattern:** calculation method, aux_data, method_used, asc method, regular method, use_280c, payroll_offset
- **Category:** Data lookup
- **Diagnosis:** Check `RdCredit.find_by(tax_period_id: ?).aux_data` — method or flags are wrong
- **Fix:**
  - Immediate: `RdCredit.find_by(tax_period_id: TAX_PERIOD_ID).update!(aux_data: {"method"=>"METHOD", "use_280c"=>false, "method_used"=>"METHOD", "use_payroll_offset"=>false})`
  - Long-term: N/A — manual correction
- **Confidence:** HIGH

### Update Company Year-End Date
- **Pattern:** year end date, year_end_month, year_end_day, fiscal year end
- **Category:** Data lookup
- **Diagnosis:** Check `Company.find(ID).year_end_month` and `year_end_day`
- **Fix:**
  - Immediate: `Company.find(COMPANY_ID).update!(year_end_month: MONTH, year_end_day: DAY)`
  - Long-term: N/A — manual correction
- **Confidence:** HIGH

### Salesforce Opportunity Sync
- **Pattern:** salesforce, sfdc, opportunity_sfdc_id, export opportunity, sync salesforce
- **Category:** Operational
- **Diagnosis:** Study missing or has wrong Salesforce opportunity ID
- **Fix:**
  - Immediate: `study = Study.find_by(tax_period_id: TAX_PERIOD_ID)` then `study.update!(opportunity_sfdc_id: 'SFDC_ID')` then `user = User.find_by(email: 'YOUR_EMAIL')` then `Salesforce::ExportOpportunityInfoJob.perform_now(user, study.id)` then `Salesforce::ExportTicketInfoJob.perform_later(user, study.id)`
  - Long-term: N/A
- **Confidence:** HIGH

### Update Filing Survey Status
- **Pattern:** tax_return_filed_status, filing status, filed on time, supersede, tax_return_filed
- **Category:** Data lookup
- **Diagnosis:** Check `TaxPeriodFilingSurvey.find_by(tax_period_id: ?).tax_return_filed_status`
- **Fix:**
  - Immediate: `TaxPeriodFilingSurvey.find_by(tax_period_id: TAX_PERIOD_ID).update!(tax_return_filed_status: 'STATUS')` where STATUS is Yes/Extended/Supersede/etc.
  - Long-term: N/A
- **Confidence:** HIGH

### Unpublish Claimed Credits
- **Pattern:** unpublish credits, claimed credits, unpublish_claimed_credits
- **Category:** Operational
- **Diagnosis:** Credits were published but need to be rolled back
- **Fix:**
  - Immediate: `bin/rake 'unpublish_claimed_credits[TAX_PERIOD_ID]'`
  - Long-term: N/A
- **Confidence:** HIGH

### Update Credit Calculation Status
- **Pattern:** CreditCalculationStatus, calculation stuck, recalculate, CalculateCredits
- **Category:** Error diagnosis
- **Diagnosis:** Check `CreditCalculationStatus.find_by(tax_period_id: ?)` — status may be stuck or incorrect
- **Fix:**
  - Immediate: `CreditCalculationStatus.find_by(tax_period_id: TAX_PERIOD_ID).update!(tag: Tag.completed_status)` then `Calculator::TaxPeriods::CalculateCredits.new(Company.find(COMPANY_ID), TaxPeriod.find(TAX_PERIOD_ID), user).call`
  - Long-term: Investigate why calculation got stuck
- **Confidence:** MEDIUM

### Update User Type to Mithrandir
- **Pattern:** user type, mithrandir, admin access, grant access
- **Category:** Operational
- **Diagnosis:** User needs elevated access in Mithrin
- **Fix:**
  - Immediate: `User.find_by(email: 'EMAIL').update!(type: 'Mithrandir')`
  - Long-term: N/A
- **Confidence:** HIGH

### Update Parent/Subsidiary Ownership Flag
- **Pattern:** parent or subsidiary, majority ownership, parent_or_subsidiary_majority_ownership, sibling companies
- **Category:** Data lookup
- **Diagnosis:** Check `TaxPeriodFilingSurvey.find_by(tax_period_id: ?).parent_or_subsidiary_majority_ownership`
- **Fix:**
  - Immediate: `TaxPeriodFilingSurvey.find_by(tax_period_id: TAX_PERIOD_ID).update!(parent_or_subsidiary_majority_ownership: true/false)`
  - Long-term: N/A
- **Confidence:** HIGH
