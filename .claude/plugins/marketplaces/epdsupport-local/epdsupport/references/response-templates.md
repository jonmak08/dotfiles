# Response Templates

Reusable response fragments by category. The respond skill uses these as building blocks for Slack responses.

## Slack Response Wrapper

All responses posted to Slack use this wrapper:

```
*:robot_face: AI Generated Response*
———

{body}

_Confidence: {HIGH|MEDIUM|LOW} | If this doesn't look right, please flag and a team member will follow up._
```

## Status Check Response

```
The current status for company {company_id}:
- Tax period {tax_year}: {status}
- Latest calculation: {calc_status} (created {date})
- Credit amount: ${amount}
```

## Known Issue Response

```
This is a known issue: {title}

*Root cause:* {description}

*Recommended fix:*
{fix_description}
```

## Escalation Response (LOW confidence)

```
I've investigated this but need a team member to review:

*What I found:*
{findings}

*What I couldn't determine:*
{unknowns}

*Suggested next steps:*
{suggestions}

*Relevant domain:* {pack_name} pack
```

## How-To Response

```
{answer}

*Relevant code:* `{file_path}`
```

## Operational Response

```
*Service health check:*
{datadog_findings}

*Data state:*
{sql_findings}

*Recommended action:*
{action}
```
