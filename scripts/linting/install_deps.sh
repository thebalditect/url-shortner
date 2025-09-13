#!/bin/bash
set -e

echo "Installing documentation linting dependencies..."

# Install markdown linters
echo "Installing markdownlint-cli2"
npm install -g markdownlint-cli2


# Download PlantUML jar
echo "Downloading PlantUML..."
if [ ! -f "plantuml.jar" ]; then
    wget -O plantuml.jar https://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar
    echo "PlantUML downloaded successfully"
else
    echo "PlantUML jar already exists"
fi

echo "All dependencies installed successfully!"