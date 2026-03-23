# Technical Documentation - Slack Bot Chatty

## Overview

This document provides technical details for developers working on the Slack Bot Chatty project.

## Architecture

### Project Structure

```
src/botChatty/
├── __init__.py        # Package initialization
└── app.py             # Main application logic
```

### Dependencies

The bot uses the following key dependencies:

- `slack_bolt`: Slack API integration
- `python-dotenv`: Environment variable management
- `pytest`: Testing framework
- `ruff`: Linting and formatting

See `requirements.txt` for full dependency list.

## Application Flow

1. **Initialization**: Creates Slack Bolt app instance
2. **Event Registration**: Registers message handlers
3. **Error Handling**: Custom error handlers for logging
4. **Socket Mode**: Uses SocketModeHandler for local development

## Code Quality

- Linting: `ruff`
- Testing: `pytest` with coverage
- Formatting: `ruff format`
- Type hints: Not currently used (can be added)

## Testing Strategy

- Unit tests in `tests/test_app.py`
- Mock external services (Slack API)
- Test coverage tracking
- CI/CD integration with GitHub Actions

## Docker Deployment

The project includes Docker support for easy deployment:

```bash
make docker
docker run -d \
  --name bot-chatty \
  --env-file .env \
  -p 8080:8080 \
  slack-bot-chatty:latest

Link to technical document  [Technical Documentation](./technical.md)
``` 