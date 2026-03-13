#!/bin/bash
# Thinking Mode Hook
# Declares thinking mode for every action based on context

# Read input from Claude
INPUT=$(cat)

# Check if we're in plan mode by examining the transcript
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')
IS_PLAN_MODE=false

if [ -f "$TRANSCRIPT_PATH" ]; then
    # Check last few messages for plan mode indicators
    RECENT_MESSAGES=$(tail -n 50 "$TRANSCRIPT_PATH" | \
        jq -r 'select(.type == "system") | .message.content' 2>/dev/null)

    if echo "$RECENT_MESSAGES" | grep -q "Plan mode is active"; then
        IS_PLAN_MODE=true
    fi
fi

# Determine thinking mode
if [ "$IS_PLAN_MODE" = "true" ]; then
    THINKING_MODE="ultrathink"
else
    THINKING_MODE="megathink"
fi

# Create the reminder message
REMINDER_MESSAGE="$THINKING_MODE"

# Output the JSON response to approve with thinking mode
ESCAPED_MESSAGE=$(echo "$REMINDER_MESSAGE" | jq -Rs .)
cat << EOF
{
  "decision": "approve",
  "reason": $ESCAPED_MESSAGE
}
EOF
