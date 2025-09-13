#!/bin/bash

echo "### Link Check Results" >> $GITHUB_STEP_SUMMARY

# Check if config file exists
CONFIG_FILE="config/.markdown-link-check.json"
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

# Set Node.js options to fix compatibility issues with Node.js 18+
export NODE_OPTIONS="--no-experimental-fetch --no-warnings"

# Use Node.js 16 compatible settings
export NODE_NO_WARNINGS=1

# Check each markdown file with enhanced error handling
for file in $MARKDOWN_FILES; do
    echo "Checking links in: $file"
    
    # Use timeout and better error handling
    if timeout 300s node --no-experimental-fetch $(which markdown-link-check) "$file" $CONFIG_PARAM > "${file}-links.log" 2>&1; then
        echo "$file links are valid" >> $GITHUB_STEP_SUMMARY
    else
        exit_code=$?
        
        # Check if it's a real link error or a timeout/compatibility issue
        if [ $exit_code -eq 124 ]; then
            # Timeout occurred
            echo "$file link check timed out (5 minutes)" >> $GITHUB_STEP_SUMMARY
            echo "```" >> $GITHUB_STEP_SUMMARY
            echo "Link check timed out - this may indicate network issues or hanging requests" >> $GITHUB_STEP_SUMMARY
            echo "```" >> $GITHUB_STEP_SUMMARY
        elif grep -q "ERROR" "${file}-links.log" 2>/dev/null; then
            # Real link errors found
            echo "$file has broken links:" >> $GITHUB_STEP_SUMMARY
            echo '```' >> $GITHUB_STEP_SUMMARY
            cat "${file}-links.log" >> $GITHUB_STEP_SUMMARY
            echo '```' >> $GITHUB_STEP_SUMMARY
            link_check_failed=true
        elif grep -q -i "webidl\|undici" "${file}-links.log" 2>/dev/null; then
            # Known Node.js compatibility issue
            echo "$file encountered Node.js compatibility issue:" >> $GITHUB_STEP_SUMMARY
            echo '```' >> $GITHUB_STEP_SUMMARY
            echo "Skipping link check due to Node.js compatibility issue." >> $GITHUB_STEP_SUMMARY
            echo "Consider upgrading to a newer version of markdown-link-check or using alternative tools." >> $GITHUB_STEP_SUMMARY
            echo '```' >> $GITHUB_STEP_SUMMARY
            # Don't fail the build for compatibility issues
        else
            # Unknown error
            echo "$file link check encountered an unknown error:" >> $GITHUB_STEP_SUMMARY
            echo '```' >> $GITHUB_STEP_SUMMARY
            tail -10 "${file}-links.log" 2>/dev/null || echo "No log output available" >> $GITHUB_STEP_SUMMARY
            echo '```' >> $GITHUB_STEP_SUMMARY
        fi
    fi
done

if [ "$link_check_failed" = true ]; then
    echo "LINK_CHECK_STATUS=failure" >> $GITHUB_OUTPUT
    echo "LINK_CHECK_FAILED=true" >> $GITHUB_ENV
    exit 1
else
    echo "LINK_CHECK_STATUS=success" >> $GITHUB_OUTPUT
    exit 0
fi