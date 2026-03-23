#!/bin/bash

# Script to install environment variables
# Copies .env.samples to .env and prompts for values

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

ENV_FILE="$PROJECT_ROOT/.env"
SAMPLES_FILE="$PROJECT_ROOT/.env.samples"

echo "=== Slack Bot Environment Setup ==="
echo ""

# Check if .env exists
if [ -f "$ENV_FILE" ]; then
    echo "$ENV_FILE already exists!"
    echo "Skipping environment setup..."
    echo ""
    echo "Edit $ENV_FILE manually to configure your bot:"
    echo "  - SLACK_APP_TOKEN"
    echo "  - SLACK_BOT_TOKEN"
    exit 0
else
    echo "Setting up environment variables..."
fi

# Create .env from samples if they exist
if [ -f "$SAMPLES_FILE" ]; then
    echo "Creating .env from .env.samples template..."
    cp "$SAMPLES_FILE" "$ENV_FILE"
fi

# Prompt for token values
echo ""
echo "Please configure your Slack bot tokens:"
read -p "Enter SLACK_APP_TOKEN value: " SLACK_APP_TOKEN
read -s -p "Enter SLACK_BOT_TOKEN value: " SLACK_BOT_TOKEN
echo ""

# Write to .env file
cat > "$ENV_FILE" << EOF
# Slack Bot Environment Variables
# Generate tokens from Slack App管理中心
SLACK_APP_TOKEN=$SLACK_APP_TOKEN
SLACK_BOT_TOKEN=$SLACK_BOT_TOKEN
EOF

# Validate tokens are not empty
if [ -z "$SLACK_APP_TOKEN" ] || [ -z "$SLACK_BOT_TOKEN" ]; then
    echo ""
    echo "ERROR: All tokens must be configured!"
    echo "Please see .env.samples for the expected format."
    exit 1
fi

echo ""
echo "=== Environment setup complete ==="
echo "Don't forget to set a proper PYTHONPATH if developing locally:"
echo "  export PYTHONPATH=\"$PROJECT_ROOT/src:\$PYTHONPATH\""
echo ""
echo "You can also run:"
echo "  source scripts/install-env.sh  # Re-run to update tokens"
echo ""

echo "=== Next steps ==="
echo "1. Run: ./scripts/install-dependencies.sh"
echo "2. Run: ./scripts/run-locally.sh"
