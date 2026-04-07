# EPDSUPPORT Plugin Notes

## Slack Channel
- Channel ID: `C05HVU79PQC` (#taxcred-epd-support)

## Triage Workflow
- Don't skip team member messages (they file requests too)
- Team member replies mark a message as "answered"
- Default lookback: 7 days

## Picking Up Issues
When investigating a support item:
1. Post `:eyes: Looking into this` as a thread reply (no reaction API available)
2. Transition JIRA ticket to "Dev In Progress" (transition ID: 61)
3. Assign JIRA ticket to Jon Mak (account ID: 60fee35aec92ab0070559e0d)

## Slack Message Format
All Slack messages posted by this plugin must use this header:
```
:robot_face: *AI Generated Response*
*Source:* <Jira/Sentry/Datadog link> | *Priority:* :large_orange_circle: HIGH | *Company:* 12345 | *Env:* production
───────────────────────────
[body]
```
Priority emoji: :red_circle: CRITICAL, :large_orange_circle: HIGH, :large_yellow_circle: MEDIUM, :white_circle: LOW
Omit Company/Env fields when not applicable.
Company links: Mithrin ID → `credits.gusto.com/admin/companies/{id}`, ZenPayroll ID/UUID → `app.gusto.com/panda/companies/{id_or_uuid}`

## Plugin Location
`/Users/jon.mak/.claude/plugins/cache/epdsupport-local/epdsupport/0.1.0/`

## Skill Names (standardized)
- `support-triage`, `support-investigate`, `support-respond`, `support-poll`, `support-seed`
- `alert-triage`, `alert-investigate`
