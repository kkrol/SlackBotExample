import pytest
from unittest.mock import MagicMock, patch
import sys
import os

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from botChatty.app import log_message_change

class TestSlackBot:
    
    @pytest.fixture
    def mock_event(self):
        """Mock event object"""
        return {
            "user": "U12345678",
            "text": "Hello world"
        }
    
    @pytest.fixture
    def mock_say(self):
        """Mock say function"""
        say = MagicMock()
        say.return_value = None
        return say
    
    @pytest.fixture
    def mock_logger(self):
        """Mock logger"""
        logger = MagicMock()
        return logger
    
    def test_log_message_change_event(self, mock_event, mock_say, mock_logger):
        """Test message change event handling"""
        event = mock_event
        say = mock_say
        logger = mock_logger
        
        log_message_change(event, say, logger)
        
        # Verify say was called with correct message
        say.assert_called_once_with("U12345678 message was Hello world")
        
        # Verify logger was called
        logger.info.assert_called_once_with("The user U12345678 changed the message to Hello world")
    
    @pytest.mark.parametrize("user_id,text", [
        ("U12345678", "Hello"),
        ("U87654321", "Good morning"),
        ("U11111111", "Test message")
    ])
    def test_log_message_change_various_inputs(self, user_id, text, mock_say, mock_logger):
        """Test various input combinations"""
        event = {"user": user_id, "text": text}
        
        log_message_change(event, mock_say, mock_logger)
        
        expected_message = f"{user_id} message was {text}"
        mock_say.assert_called_with(expected_message)
        
        expected_log = f"The user {user_id} changed the message to {text}"
        mock_logger.info.assert_called_with(expected_log)
    
    def test_log_message_change_missing_user(self, mock_say, mock_logger):
        """Test handling when user field is missing"""
        event = {"text": "Hello"}
        
        with pytest.raises(KeyError):
            log_message_change(event, mock_say, mock_logger)
    
    def test_log_message_change_missing_text(self, mock_say, mock_logger):
        """Test handling when text field is missing"""
        event = {"user": "U12345678"}
        
        with pytest.raises(KeyError):
            log_message_change(event, mock_say, mock_logger)
    
    def test_error_handler(self, mock_logger, caplog):
        """Test error handler functionality"""
        # Mock app.error handler
        with patch('botChatty.app.app') as mock_app:
            mock_app.error = None
            mock_app = MagicMock()
            mock_app.error = None
            
            # Test custom error handler logic
            error = "TestError"
            body = {"test": "body"}
            
            logger = MagicMock()
            logger.exception.side_effect = Exception("Logged error")
            
            # Should log the error and body
            custom_error_handler(error, body, logger)
            
            logger.exception.assert_called()
            logger.info.assert_called()

if __name__ == '__main__':
    pytest.main([__file__, '-v'])