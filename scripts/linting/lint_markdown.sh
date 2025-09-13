#!/bin/bash


echo "## Markdown Linting Results" >> $GITHUB_STEP_SUMMARY

# Check if config file exists, otherwise use default
CONFIG_FILE="config/.markdownlint-cli2.yaml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found at $CONFIG_FILE, using default configuration"
    CONFIG_FILE=""
fi

echo "### Markdownlint Results" >> $GITHUB_STEP_SUMMARY

# Find all markdown files
MARKDOWN_FILES=$(find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | sort)

if [ -z "$MARKDOWN_FILES" ]; then
    echo "No markdown files found to lint" >> $GITHUB_STEP_SUMMARY
    echo "MARKDOWN_LINT_STATUS=success" >> $GITHUB_OUTPUT
    exit 0
fi

echo "Linting markdown files:"
echo "$MARKDOWN_FILES"

# Run markdownlint
if [ -n "$CONFIG_FILE" ] && [ -f "$CONFIG_FILE" ]; then
    if echo "$MARKDOWN_FILES" | xargs markdownlint-cli2 --config "$CONFIG_FILE" > markdown-lint.log 2>&1; then
        echo "Markdownlint passed successfully" >> $GITHUB_STEP_SUMMARY
        echo "MARKDOWN_LINT_STATUS=success" >> $GITHUB_OUTPUT
        exit 0
    else
        echo "Markdownlint found issues:" >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
        cat markdown-lint.log >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
        echo "MARKDOWN_LINT_STATUS=failure" >> $GITHUB_OUTPUT
        echo "MARKDOWN_LINT_FAILED=true" >> $GITHUB_ENV
        exit 1
    fi
else
    # Use default configuration inline
    if echo "$MARKDOWN_FILES" | xargs markdownlint-cli2 --config '{"MD013": false, "MD033": false, "MD041": false}' > markdown-lint.log 2>&1; then
        echo "Markdownlint passed successfully (using default config)" >> $GITHUB_STEP_SUMMARY
        echo "MARKDOWN_LINT_STATUS=success" >> $GITHUB_OUTPUT
        exit 0
    else
        echo "Markdownlint found issues:" >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
        cat markdown-lint.log >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
        echo "MARKDOWN_LINT_STATUS=failure" >> $GITHUB_OUTPUT
        echo "MARKDOWN_LINT_FAILED=true" >> $GITHUB_ENV
        exit 1
    fi
fi