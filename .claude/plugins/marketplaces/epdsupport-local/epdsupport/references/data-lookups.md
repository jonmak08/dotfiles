# Common Data Lookups

SQL queries for the tax-credits MCP (`mcp__tax-credits__execute_sql`). Always validate queries with `mcp__tax-credits__explain_query` before execution.

## Company Tax Credit Status

```sql
SELECT id, name, status
FROM companies
WHERE id = ?
```

## Tax Period Status

```sql
SELECT id, company_id, tax_year, status, created_at, updated_at
FROM tax_periods
WHERE company_id = ?
ORDER BY tax_year DESC
```

## Latest Calculation

```sql
SELECT id, tax_period_id, status, total_credit, created_at
FROM calculations
WHERE tax_period_id = ?
ORDER BY created_at DESC
LIMIT 1
```

## Filing Status

```sql
SELECT id, tax_period_id, status, filed_at
FROM filed_tax_returns
WHERE tax_period_id = ?
ORDER BY created_at DESC
LIMIT 1
```

## QRE Data

```sql
SELECT id, tax_period_id, category, amount, status
FROM qualified_research_expenses
WHERE tax_period_id = ?
ORDER BY category
```

<!-- Add new queries as patterns emerge. Use `mcp__tax-credits__get_schema` to discover table structure. -->
