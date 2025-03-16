#!/bin/bash

# GitHub Actions Summaryに結果を出力する共通関数
# Usage: report_result <title> <status_code> <output_var> <output_content>
#   - title: レポートのタイトル (例: "Ruff Linter Results")
#   - status_code: コマンドの終了ステータス ($? の値)
#   - output_var: GitHub出力変数名 (例: "lint_failed")
#   - output_content: 詳細な出力内容

report_result() {
  local title="$1"
  local status="$2"
  local output_var="$3"
  local content="$4"

  # GitHub Step Summaryへの書き込み (直接ファイルパスを使用)
  if [ -n "$GITHUB_STEP_SUMMARY" ]; then
    echo "## $title" >> "$GITHUB_STEP_SUMMARY"
    echo "" >> "$GITHUB_STEP_SUMMARY"

    if [ "$status" -eq 0 ]; then
      echo "✅ Passed" >> "$GITHUB_STEP_SUMMARY"
      echo "" >> "$GITHUB_STEP_SUMMARY"
      echo "No issues found." >> "$GITHUB_STEP_SUMMARY"
    else
      echo "❌ Failed" >> "$GITHUB_STEP_SUMMARY"
      echo "" >> "$GITHUB_STEP_SUMMARY"
      if [ -n "$content" ]; then
        echo '```' >> "$GITHUB_STEP_SUMMARY"
        echo "$content" >> "$GITHUB_STEP_SUMMARY"
        echo '```' >> "$GITHUB_STEP_SUMMARY"
      else
        echo "Command failed with status code $status" >> "$GITHUB_STEP_SUMMARY"
      fi
    fi

    echo "" >> "$GITHUB_STEP_SUMMARY"
    echo "---" >> "$GITHUB_STEP_SUMMARY"
    echo "" >> "$GITHUB_STEP_SUMMARY"
  else
    echo "WARNING: GITHUB_STEP_SUMMARY is not set!"
  fi

  # GitHub Outputへの書き込み
  if [ -n "$GITHUB_OUTPUT" ]; then
    if [ "$status" -eq 0 ]; then
      echo "${output_var}=false" >> "$GITHUB_OUTPUT"
    else
      echo "${output_var}=true" >> "$GITHUB_OUTPUT"
    fi
    echo "Output ${output_var}=${status} written to GITHUB_OUTPUT"
  else
    echo "WARNING: GITHUB_OUTPUT is not set!"
  fi
}
