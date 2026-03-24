import os
import logging
from logging import Logger
from dotenv import load_dotenv
from slack_bolt import App
from slack_bolt import BoltContext, Say
from slack_bolt.adapter.socket_mode import SocketModeHandler


# Load environment variables if settings are not fully defined in the settings module
# (Optional: Keep this if you rely on .env for fallback, otherwise remove)

from src.botChatty import settings


# Initialize the app with settings as suggested
app = App(
    token=settings.bot_token
)



# Register Listeners
@app.error
def custom_error_handler(error, body, logger):
    logger.exception(f"Error: {error}")
    logger.info(f"Request body: {body}")
    
# @app.event("app_mention")
# def handle_mention(body, say, logger):
#     user = body["event"]["user"]
#     # single logger call
#     # global logger is passed to listener
#     logger.debug(body)
#     say(f"{user} mentioned your app")
    
# @app.event("message")

# Updated listener to use settings if needed, or keep existing logic
# def sample_message_callback(context: BoltContext, say: Say, logger: Logger):
#def log_message_change(event, say, logger):
#         greeting = context["matches"][0]
#         say(f"{greeting}, how are you?")
#     except Exception as e:
#         logger.error(e)

@app.event("message")
def log_message_change(event,say,logger):
    user, text = event["user"], event["text"]
    logger.info(f"The user {user} changed the message to {text}")
    say(f"{user} message was {text}")
# @app.message("Whats up")
    # Create the socket mode handler using settings as suggested
    handler = SocketModeHandler(app, settings.bot_token)
    handler.start()
#     say(f"Hi there, <@{user}>!")
 
# Start Bolt app
if __name__ == "__main__":
    SocketModeHandler(app, settings.app_token).start()
