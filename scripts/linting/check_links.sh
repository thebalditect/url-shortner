#!/bin/bash
set -e

echo "### Link Check Results" >> $GITHUB_STEP_SUMMARY

# Check if config file exists
CONFIG_FILE="config/link-check.json"
CONFIG_PARAM=""
if [ -f "$CONFIG_FILE" ]; then
    CONFIG_PARAM="--config $CONFIG_FILE"
    echo "Using link check config: $CONFIG_FILE"
else
    echo "No config file found at $CONFIG_FILE, using default settings"
fi

link_check_failed=false

# Find all markdown files
MARKDOWN_FILES=$(find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | sort)

if [ -z "$MARKDOWN_FILES" ]; then
    echo "No markdown files found to check for links" >> $GITHUB_STEP_SUMMARY
    echo "LINK_CHECK_STATUS=success" >> $GITHUB_OUTPUT
    exit 0
fi

echo "Checking links in markdown files:"
echo "$MARKDOWN_FILES"

# Check each markdown file
for file in $MARKDOWN_FILES; do
    echo "Checking links in: $file"
    
    if markdown-link-check "$file" $CONFIG_PARAM > "${file}-links.log" 2>&1; then
        echo "$file links are valid" >> $GITHUB_STEP_SUMMARY
    else
        echo "$file has broken links:" >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
        cat "${file}-links.log" >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
        link_check_failed=true
    fi
done

if [ "$link_check_failed" = true ]; then
    echo "LINK_CHECK_STATUS=failure" >> $GITHUB_OUTPUT
    exit 1
else
    echo "LINK_CHECK_STATUS=success" >> $GITHUB_OUTPUT
fi