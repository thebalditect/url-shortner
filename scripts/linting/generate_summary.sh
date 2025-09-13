#!/bin/bash

echo "## Final Results Summary" >> $GITHUB_STEP_SUMMARY

overall_status=0

# Check environment variables set by the GitHub workflow
if [ "$MARKDOWN_LINT_FAILED" = "true" ]; then
    echo "Markdown linting failed" >> $GITHUB_STEP_SUMMARY
    overall_status=1
else
    echo "Markdown linting passed" >> $GITHUB_STEP_SUMMARY
fi

if [ "$PLANTUML_LINT_FAILED" = "true" ]; then
    echo "PlantUML validation failed" >> $GITHUB_STEP_SUMMARY
    overall_status=1
else
    echo "PlantUML validation passed" >> $GITHUB_STEP_SUMMARY
fi

# Generate final status
if [ $overall_status -ne 0 ]; then
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "## Documentation linting pipeline failed" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "### Issues Found:" >> $GITHUB_STEP_SUMMARY
    echo "Please review the detailed error messages above for each failed check." >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "### Next Steps:" >> $GITHUB_STEP_SUMMARY
    echo "1. Review the specific error messages above" >> $GITHUB_STEP_SUMMARY
    echo "2. Fix the issues in your documentation files" >> $GITHUB_STEP_SUMMARY
    echo "3. Push your changes to re-run the validation" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "All linting checks were executed to provide complete feedback." >> $GITHUB_STEP_SUMMARY
    exit 1
else
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "## All documentation linting checks passed successfully!" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "Your documentation meets all quality standards. Great work! 🎉" >> $GITHUB_STEP_SUMMARY
    exit 0
fi