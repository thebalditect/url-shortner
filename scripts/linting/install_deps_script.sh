#!/bin/bash
set -e

echo "Installing documentation linting dependencies..."

# Install markdown linters
echo "Installing markdownlint-cli2..."
npm install -g markdownlint-cli2

echo "Installing markdown-link-check..."
npm install -g markdown-link-check

# Download PlantUML jar
echo "Downloading PlantUML..."
if [ ! -f "plantuml.jar" ]; then
    wget -O plantuml.jar https://github.com/plantuml/plantuml/releases/latest/download/plantuml-1.2024.7.jar
    echo "PlantUML downloaded successfully"
else
    echo "PlantUML jar already exists"
fi

echo "All dependencies installed successfully!"