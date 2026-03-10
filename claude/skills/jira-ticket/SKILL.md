---
name: jira-ticket
description: Fetch and display a Jira ticket's content using the Jira REST API. Use when the user shares a Jira URL or asks to view a Jira ticket.
argument-hint: <ticket-url-or-key> (e.g., https://example.atlassian.net/browse/PROJ-123 or PROJ-123)
allowed-tools: Bash, Read
---

# Fetch Jira Ticket

Fetch and display the content of a Jira ticket using the Jira REST API.

## Prerequisites

The following environment variables must be set (e.g., via `direnv` or shell profile):

- `JIRA_BASE_URL` - Atlassian instance URL (e.g., `https://example.atlassian.net`)
- `JIRA_USER_EMAIL` - Your Atlassian account email
- `JIRA_API_TOKEN` - API token generated at https://id.atlassian.com/manage-profile/security/api-tokens

## Steps

1. **Parse the input** from `$ARGUMENTS`:
   - If a full URL like `https://example.atlassian.net/browse/PROJ-123`, extract the ticket key (`PROJ-123`) and base URL
   - If just a ticket key like `PROJ-123`, use `$JIRA_BASE_URL` as the base URL
   - If `$ARGUMENTS` is empty, ask the user for the ticket key or URL

2. **Validate environment variables**:
   - Check that `JIRA_USER_EMAIL` and `JIRA_API_TOKEN` are set
   - If base URL was not extracted from the input, check that `JIRA_BASE_URL` is set
   - If any are missing, inform the user which variables need to be configured

3. **Fetch the ticket** via REST API:

```bash
curl -s -u "${JIRA_USER_EMAIL}:${JIRA_API_TOKEN}" \
  -H "Accept: application/json" \
  "${BASE_URL}/rest/api/3/issue/${TICKET_KEY}?fields=summary,status,assignee,reporter,priority,issuetype,description,comment,parent,subtasks,issuelinks,labels,components,fixVersions,created,updated"
```

4. **Parse and display** the response using `jq`:

```bash
# Extract key fields
echo "$RESPONSE" | jq -r '
  "## " + .key + ": " + .fields.summary,
  "",
  "| Field | Value |",
  "|-------|-------|",
  "| Type | " + (.fields.issuetype.name // "N/A") + " |",
  "| Status | " + (.fields.status.name // "N/A") + " |",
  "| Priority | " + (.fields.priority.name // "N/A") + " |",
  "| Assignee | " + (.fields.assignee.displayName // "Unassigned") + " |",
  "| Reporter | " + (.fields.reporter.displayName // "N/A") + " |",
  "| Labels | " + ((.fields.labels // []) | join(", ") | if . == "" then "None" else . end) + " |",
  "| Created | " + (.fields.created // "N/A") + " |",
  "| Updated | " + (.fields.updated // "N/A") + " |"
'
```

5. **Display description**: The description field uses Atlassian Document Format (ADF). Extract text content recursively:

```bash
echo "$RESPONSE" | jq -r '
  def extractText:
    if type == "object" then
      if .type == "text" then .text // ""
      elif .type == "hardBreak" then "\n"
      elif .type == "paragraph" then ([.content[]? | extractText] | join("")) + "\n"
      elif .type == "heading" then "\n" + ([.content[]? | extractText] | join("")) + "\n"
      elif .type == "bulletList" then ([.content[]? | extractText] | join(""))
      elif .type == "orderedList" then ([.content[]? | extractText] | join(""))
      elif .type == "listItem" then "- " + ([.content[]? | extractText] | join(""))
      elif .type == "codeBlock" then "```\n" + ([.content[]? | extractText] | join("")) + "```\n"
      else [.content[]? | extractText] | join("")
      end
    elif type == "array" then [.[] | extractText] | join("")
    else ""
    end;
  "### Description\n",
  (.fields.description | extractText)
'
```

6. **Display comments** (if any):

```bash
echo "$RESPONSE" | jq -r '
  if (.fields.comment.comments | length) > 0 then
    "### Comments (" + ((.fields.comment.comments | length) | tostring) + ")\n",
    (.fields.comment.comments[] |
      "**" + .author.displayName + "** (" + .created[0:10] + "):\n" +
      (.body | extractText) + "\n---\n"
    )
  else
    "### Comments\nNo comments."
  end
'
```

7. **Display subtasks and links** (if any exist).

## Error Handling

- If the API returns 401: inform the user that credentials are invalid
- If the API returns 404: inform the user the ticket was not found
- If `jq` is not installed, fall back to displaying raw JSON with `python3 -m json.tool`

## Notes

- API token can be created at: https://id.atlassian.com/manage-profile/security/api-tokens
- The ADF (Atlassian Document Format) description parsing covers common node types; complex formatting may be simplified
- Comments are shown in chronological order
