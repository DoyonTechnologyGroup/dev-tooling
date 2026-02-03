#!/bin/bash
# Create a new project from a template
# Usage: new-project.sh <template> <project-name> [destination]

set -e

TEMPLATES_DIR="$HOME/code/dev-tooling/templates"

usage() {
    echo "Usage: $0 <template> <project-name> [destination]"
    echo ""
    echo "Templates available:"
    ls -1 "$TEMPLATES_DIR" 2>/dev/null | sed 's/^/  - /'
    echo ""
    echo "Examples:"
    echo "  $0 python my-api"
    echo "  $0 nextjs my-app ~/projects"
    exit 1
}

if [ -z "$1" ] || [ -z "$2" ]; then
    usage
fi

TEMPLATE="$1"
PROJECT_NAME="$2"
DESTINATION="${3:-.}"

TEMPLATE_PATH="$TEMPLATES_DIR/$TEMPLATE"
PROJECT_PATH="$DESTINATION/$PROJECT_NAME"

# Validate template exists
if [ ! -d "$TEMPLATE_PATH" ]; then
    echo "Error: Template '$TEMPLATE' not found."
    echo ""
    echo "Available templates:"
    ls -1 "$TEMPLATES_DIR" 2>/dev/null | sed 's/^/  - /'
    exit 1
fi

# Check if destination already exists
if [ -d "$PROJECT_PATH" ]; then
    echo "Error: Directory '$PROJECT_PATH' already exists."
    exit 1
fi

# Create project directory and copy template
echo "Creating project '$PROJECT_NAME' from '$TEMPLATE' template..."
mkdir -p "$PROJECT_PATH"
cp -r "$TEMPLATE_PATH/." "$PROJECT_PATH/"

# Initialize git repository
cd "$PROJECT_PATH"
if [ ! -d ".git" ]; then
    git init -q
    echo "Initialized git repository"
fi

echo ""
echo "Project created at: $PROJECT_PATH"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_PATH"
echo "  # Start coding with Claude Code!"
