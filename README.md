# Slack Bot Chatty 🤖

A Slack bot built with [Slack Bolt](https://github.com/slackapi/bolt-python) for conversational AI.

## ✨ Features

- Real-time message handling
- Socket mode support
- Docker/Podman deployment
- CI/CD integration
- Comprehensive testing

## 🛠️ Installation

### Using UV (Recommended)
```

```markdown
# Slack Bot Chatty 🤖

A Slack bot built with [Slack Bolt](https://github.com/slackapi/bolt-python) for conversational AI.

## ✨ Features

- Real-time message handling
- Socket mode support
- Docker/Podman deployment
- CI/CD integration
- Comprehensive testing

## 🛠️ Installation

### Using UV (Recommended)

```bash
# Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or using pip
pip install uv

# Clone and install
git clone <repo-url>
cd botChatty

# Install production dependencies
uv sync

# Install with development dependencies
uv sync --all-extras

# Install in editable mode
uv pip install -e .
```

### Run the Bot

```bash
# Activate virtual environment
uv venv

# Source the virtual environment
source .venv/bin/activate

# Run the bot
uv run python src/botChatty/app.py

# Or directly
uv run python src/botChatty/app.py
```

### Development Mode

```bash
# Makefile commands
make install           # Install dependencies
make run               # Run the bot
make test              # Run tests
make lint              # Run linter
make format            # Format code
make docker            # Build Docker image
make podman            # Build Podman image
```

## 🐳 Deployment

### Docker

```bash
# Build Docker image
make docker

# Run locally
docker run -d \
  --name bot-chatty \
  --env-file .env \
  slack-bot-chatty:latest

# Or with docker-compose
docker-compose up -d
```

### Podman (Recommended for production)

```bash
# Build Podman image
make podman

# Run locally
podman run -d \
  --name bot-chatty \
  --env-file .env \
  slack-bot-chatty:latest

# Save image for transfer
make podman-save

# Load on another system
make podman-load
```

## 📋 Configuration

Create a `.env` file:

```env
SLACK_BOT_TOKEN=xoxb-xxxxx
SLACK_APP_TOKEN=xapp-xxxxx
```

## 🧪 Testing

```bash
# Run tests
make test

# Test with coverage
make test-coverage

# Run coverage report
open docs/coverage_html/index.html
```

## 📁 Project Structure

```
botChatty/
├── src/botChatty/          # Source code
│   └── app.py              # Main application
├── tests/                  # Unit tests
├── docs/                   # Documentation
├── scripts/                # Build scripts
├── pyproject.toml         # Project metadata
├── uv.lock                 # UV lock file
├── Makefile               # Task runner
└── .env                   # Environment variables
```

## 🚀 Quick Start

```bash
# 1. Clone and setup
git clone <repo-url>
cd botChatty

# 2. Install dependencies
uv sync

# 3. Copy env template
make env

# 4. Edit .env with your tokens
# See .env.samples for example

# 5. Run the bot
uv run python src/botChatty/app.py

# Or use make
make run
```

## 📊 Testing

```bash
# Run all tests
make test

# Test with coverage
make test-coverage

# View coverage report
open docs/coverage_html/index.html
```

## 🐳 Deployment

### Docker

```bash
# Build
make docker

# Run
docker run -d --env-file .env slack-bot-chatty:latest
```

### Podman (Production)

```bash
# Build
make podman

# Run
podman run -d --env-file .env slack-bot-chatty:latest

# Save for transfer
make podman-save
```

## 📝 License

[MIT](LICENSE)
```

## 5. Verify tests run correctly

```bash
#!/bin/bash
# Test verification script

set -e

echo "🧪 Running tests with uv..."

# Run tests with coverage
uv run pytest tests/ -v --cov=src/botChatty --cov-report=term-missing --cov-fail-under=80

echo "✅ Tests completed successfully!"

# Generate HTML report
uv run pytest tests/ --cov=src/botChatty --cov-report=html:docs/coverage_html

echo "📊 Coverage report: docs/coverage_html/index.html"
```

## Summary

I've created a comprehensive solution that:

1. **Uses uv** - Fast Python package management
2. **Updated pyproject.toml** - Modern project configuration
3. **Created Makefile** - Includes podman, docker, uv commands
4. **Updated README.md** - Shows uv commands
5. **Added test verification** - Ensures tests pass

### Quick Commands

```bash
# Install
uv sync --all-extras

# Run
uv run python src/botChatty/app.py

# Test
make test

# Docker
make docker

# Podman
make podman

# Save for transfer
make podman-save