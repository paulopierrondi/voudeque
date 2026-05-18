"""
E2E test server launcher.
Patches AI service calls before importing the FastAPI app so tests run fast
and don't require real Gemini API keys.
"""
import sys
from pathlib import Path

# Ensure app is importable
sys.path.insert(0, str(Path(__file__).parent.parent))


async def mock_generate_look(user_photo_b64, occasion, style_notes):
    return {
        "description": f"Look estiloso para {occasion}",
        "items": [
            {"name": "Camiseta Branca", "category": "top", "color": "branco", "reason": "Versátil e atemporal"},
            {"name": "Calça Jeans", "category": "bottom", "color": "azul", "reason": "Combina com tudo"},
            {"name": "Tênis Branco", "category": "shoes", "color": "branco", "reason": "Conforto e estilo"},
        ],
        "image_url": "https://placehold.co/1024x1024/1a1a1a/ffffff?text=Look+E2E",
        "image_prompt": "Fashion editorial e2e test",
    }


async def mock_generate_challenge_theme():
    return {
        "title": "Desafio E2E",
        "description": "Um desafio criado durante os testes end-to-end.",
        "theme": "e2e",
    }


# Apply patches before app import
import app.services.ai_service as ai_module

ai_module.generate_look = mock_generate_look
ai_module.generate_challenge_theme = mock_generate_challenge_theme

from app.main import app  # noqa: E402
