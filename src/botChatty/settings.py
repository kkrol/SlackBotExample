"""Settings configuration for Slack Bot."""
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

class Settings:
    """Settings class for Slack Bot configuration."""
    
    def __init__(self):
        self.slack_bot_token = os.getenv("SLACK_BOT_TOKEN", "")
        self.slack_app_token = os.getenv("SLACK_APP_TOKEN", "")
    
    @property
    def is_configured(self):
        """Check if all required settings are configured."""
        return bool(self.slack_bot_token) and bool(self.slack_app_token)

# Create global settings instance
settings = Settings()