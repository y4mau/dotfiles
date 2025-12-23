# Claude Code Custom Agents

This directory contains custom Claude Code subagents.

## Available Subagents

### 1. google-sheets-reader

**Purpose**: Retrieve content from authenticated Google Spreadsheets

**Features**:
- Read data using Google Sheets API v4
- Service account authentication support
- Error handling and rate limiting
- Multiple sheets and cell range support

**Setup**:
1. See `~/.claude/credentials/setup-google-sheets.md`
2. Create a service account in Google Cloud Console
3. Save credentials to `~/.claude/credentials/google-service-account.json`
4. Share the target Google Sheet with the service account

**Usage**:
```
Use the google-sheets-reader agent to extract data from: https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/edit
```

### 2. pr-review-implementer

**Purpose**: Implement improvements based on Pull Request review comments

**Details**: Existing implemented subagent

### 3. ci-failure-investigator

**Purpose**: Investigate and identify CI test failures

**Features**:
- Check PR status (gh pr checks)
- Retrieve CircleCI / AWS CodeBuild logs
- Extract build logs from CloudWatch Logs
- Identify failing test file names and line numbers
- Analyze error messages
- Determine if failure is PR-related vs environmental

**Required Environment Variables**:
- `CIRCLECI_TOKEN`: For CircleCI API access (optional)
- AWS CLI configuration: For CloudWatch Logs access

**Usage**:
```
# Investigate CI failures on current branch's PR
Use the ci-failure-investigator agent to check failing tests on this branch

# Identify failures from CloudWatch Logs
Use the ci-failure-investigator agent to analyze: https://console.aws.amazon.com/cloudwatch/...
```

**Output**:
- Failing test file paths and line numbers
- Error messages
- Root cause analysis (PR-related or environmental)
- Recommended actions

### 4. issue-sync-updater

**Purpose**: Update GitHub issue descriptions with implementation status

**Features**:
- Identify related issues from branch names and commits
- Update issue descriptions with implementation status
- Add timestamps and PR references

### 5. tdd-test-designer

**Purpose**: Design comprehensive tests following TDD methodology

**Features**:
- Design tests before implementation
- Follow t-wada's TDD principles
- Run tests during implementation
- Ensure all tests pass before completion

### 6. requirements-generator-v5

**Purpose**: Generate comprehensive requirement documents

**Features**:
- Create full-stack feature implementation documents
- Follow issue template format
- Generate technical specifications

## Reloading Subagents

After adding new subagents, restart Claude Code or use the following commands:

```bash
# Check available agents
/agents

# View specific agent details
/agents show google-sheets-reader
```

## Troubleshooting

1. **Subagent not recognized**
   - Verify YAML frontmatter format in `.md` file
   - Restart Claude Code
   - Check file permissions

2. **Authentication errors**
   - Follow setup instructions in `~/.claude/credentials/setup-google-sheets.md`
   - Verify Google Cloud Console settings

3. **API limit errors**
   - Check Google Sheets API usage limits
   - Verify rate limiting is properly implemented
