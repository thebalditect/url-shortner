#!/bin/bash

echo "## Final Results Summary" >> $GITHUB_STEP_SUMMARY

overall_status=0

# Check markdown lint status
if [ -f "markdown-lint.log" ] && grep -q "error" markdown-lint.log; then
    echo "Markdown linting failed" >> $GITHUB_STEP_SUMMARY
    overall_status=1
else
    echo "Markdown linting passed" >> $GITHUB_STEP_SUMMARY
fi

# Check link check status
link_errors=false
for log_file in *-links.log; do
    if [ -f "$log_file" ] && grep -q "ERROR" "$log_file"; then
        link_errors=true
        break
    fi
done

if [ "$link_errors" = true ]; then
    echo "Link checking failed" >> $GITHUB_STEP_SUMMARY
    overall_status=1
else
    echo "Link checking passed" >> $GITHUB_STEP_SUMMARY
fi

# Check PlantUML status
plantuml_errors=false
for log_file in *-check.log; do
    if [ -f "$log_file" ] && grep -q -i "error\|exception" "$log_file"; then
        plantuml_errors=true
        break
    fi
done

if [ "$plantuml_errors" = true ]; then
    echo "PlantUML validation failed" >> $GITHUB_STEP_SUMMARY
    overall_status=1
else
    echo "PlantUML validation passed" >> $GITHUB_STEP_SUMMARY
fi

# Generate final status
if [ $overall_status -ne 0 ]; then
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "## Documentation linting failed - please fix the issues above" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "### Next Steps:" >> $GITHUB_STEP_SUMMARY
    echo "1. Review the specific error messages above" >> $GITHUB_STEP_SUMMARY
    echo "2. Fix the issues in your documentation files" >> $GITHUB_STEP_SUMMARY
    echo "3. Push your changes to re-run the validation" >> $GITHUB_STEP_SUMMARY
    exit 1
else
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "## All documentation linting checks passed successfully!" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "Your documentation meets all quality standards." >> $GITHUB_STEP_SUMMARY
fi