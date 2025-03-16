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

  echo "## $title" >> $GITHUB_STEP_SUMMARY

  if [ "$status" -eq 0 ]; then
    echo "✅ $title passed" >> $GITHUB_STEP_SUMMARY
    echo "No issues found." >> $GITHUB_STEP_SUMMARY
    echo "${output_var}=false" >> $GITHUB_OUTPUT
  else
    echo "❌ $title failed" >> $GITHUB_STEP_SUMMARY
    echo '```' >> $GITHUB_STEP_SUMMARY
    echo "$content" >> $GITHUB_STEP_SUMMARY
    echo '```' >> $GITHUB_STEP_SUMMARY
    echo "${output_var}=true" >> $GITHUB_OUTPUT
  fi
}
