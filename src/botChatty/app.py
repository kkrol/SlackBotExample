import os
import logging
from logging import Logger
from dotenv import load_dotenv
from slack_bolt import App
from slack_bolt import BoltContext, Say
from slack_bolt.adapter.socket_mode import SocketModeHandler
load_dotenv() 
 

logging.basicConfig(level=logging.INFO)

# Initialization
app = App(token=os.environ.get("SLACK_BOT_TOKEN"))

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
# def sample_message_callback(context: BoltContext, say: Say, logger: Logger):
#     try:
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
# def say_hello(message, say):
#     user = message['user']
#     say(f"Hi there, <@{user}>!")
 
# Start Bolt app
if __name__ == "__main__":
    SocketModeHandler(app, os.environ.get("SLACK_APP_TOKEN")).start()
