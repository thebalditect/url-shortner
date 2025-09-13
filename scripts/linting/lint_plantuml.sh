#!/bin/bash

echo "### PlantUML Validation Results" >> $GITHUB_STEP_SUMMARY

# Check if PlantUML jar exists
if [ ! -f "plantuml.jar" ]; then
    echo "PlantUML jar not found. Please run install-deps.sh first." >> $GITHUB_STEP_SUMMARY
    echo "PLANTUML_STATUS=failure" >> $GITHUB_OUTPUT
    exit 1
fi

plantuml_failed=false

# Find all PlantUML files
PLANTUML_FILES=$(find docs -name "*.puml" -o -name "*.plantuml" 2>/dev/null | sort || true)

if [ -z "$PLANTUML_FILES" ]; then
    echo "No PlantUML files found in docs folder" >> $GITHUB_STEP_SUMMARY
    echo "PLANTUML_STATUS=success" >> $GITHUB_OUTPUT
    exit 0
fi

echo "Validating PlantUML files:"
echo "$PLANTUML_FILES"

# Check each PlantUML file
for file in $PLANTUML_FILES; do
    echo "Checking $file..."
    
    if java -jar plantuml.jar -checkonly "$file" > "${file}-check.log" 2>&1; then
        echo "$file syntax is valid" >> $GITHUB_STEP_SUMMARY
    else
        echo "$file has syntax errors:" >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
        cat "${file}-check.log" >> $GITHUB_STEP_SUMMARY
        echo '```' >> $GITHUB_STEP_SUMMARY
        plantuml_failed=true
    fi
done

if [ "$plantuml_failed" = true ]; then
    echo "PLANTUML_STATUS=failure" >> $GITHUB_OUTPUT
    exit 1
else
    echo "PLANTUML_STATUS=success" >> $GITHUB_OUTPUT
    exit 0
fi