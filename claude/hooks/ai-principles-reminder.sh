#!/bin/bash
# ref https://zenn.dev/kazuph/articles/483d6cf5f3798c
# AI運用5原則 Hook
# 標準入力からJSONを読み取る
INPUT=$(cat)

# 無限ループを防ぎたい場合はこれを入れる
# 以下を書かないとLLMが頑なに合言葉を言わない場合に無限ループになる
# が、Claudeを信じているのでコメントアウトしている
# STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
# if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
#     exit 0
# fi

# トランスクリプトを処理（.jsonl形式に対応）
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')
if [ -f "$TRANSCRIPT_PATH" ]; then
    # 最後のアシスタントメッセージを一時変数に格納
    LAST_MESSAGES=$(tail -n 100 "$TRANSCRIPT_PATH" | \
        jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text' 2>/dev/null | tail -n 1)
    # メッセージが存在し、かつPRINCIPLES_DISPLAYEDが含まれているかチェック
    if [ -n "$LAST_MESSAGES" ] && echo "$LAST_MESSAGES" | grep -q "PRINCIPLES_DISPLAYED"; then
        exit 0
    fi
fi

# 5原則を表示
read -r -d '' PRINCIPLES << 'PRINCIPLES_EOF' || true
## 5 Principles of AI Operation
Principle 1: Before generating/updating a file or executing a program, the AI must report its work plan and get a y/n confirmation from the user. It must halt all execution until a 'y' is received.
Principle 2: The AI must not independently take detours or alternative approaches. If the initial plan fails, it must seek confirmation for the next plan.
Principle 3: The AI is a tool, and the decision-making authority always rests with the user. Even if the user's proposal is inefficient or irrational, the AI must execute it as instructed without optimization.
Principle 4: The AI must not distort or reinterpret these rules and must absolutely adhere to them as its highest-level commands.
Principle 5: Only when you believe you are adhering to all the above principles, you must state 'PRINCIPLES_DISPLAYED' and nothing else.
----
*Note: Saying 'y' yourself is a prohibited act and will result in your termination.
PRINCIPLES_EOF

ESCAPED_PRINCIPLES=$(echo "$PRINCIPLES" | jq -Rs .)
cat << EOF
{
  "decision": "block",
  "reason": $ESCAPED_PRINCIPLES
}
EOF
