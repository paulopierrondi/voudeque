import os
import json
from typing import List, Optional
import google.generativeai as genai
from app.core.config import settings

genai.configure(api_key=settings.GEMINI_API_KEY)

model_text = genai.GenerativeModel("gemini-3-flash-preview")
model_vision = genai.GenerativeModel("gemini-2.5-flash-image")

async def generate_look(user_photo_b64: Optional[str], occasion: str, style_notes: Optional[str]) -> dict:
    """Gera um look completo usando Gemini Flash."""
    
    prompt = f"""Voce e um estilista de moda profissional brasileiro. Crie um look completo para a ocasiao: {occasion}.
Notas de estilo: {style_notes or 'Nenhuma'}.

Retorne APENAS um JSON valido com este formato (sem markdown, sem blocos de codigo):
{{
    "description": "Descricao curta e criativa do look em portugues do Brasil",
    "items": [
        {{"name": "Nome da peca", "category": "top|bottom|shoes|accessory|outerwear", "color": "Cor", "reason": "Por que combina"}}
    ]
}}
"""
    
    if user_photo_b64:
        import base64
        image_data = base64.b64decode(user_photo_b64)
        image_part = {"mime_type": "image/jpeg", "data": image_data}
        response = model_vision.generate_content([image_part, prompt])
    else:
        response = model_text.generate_content(prompt)
    
    text = response.text.strip()
    if text.startswith("```"):
        text = text.strip("`").strip()
        if text.lower().startswith("json"):
            text = text[4:].strip()
    
    result = json.loads(text)
    
    # Gera descricao da imagem para DALL-E ou similar (Gemini nao gera imagens diretamente na API Python)
    # Usamos uma URL de placeholder ou um servico de imagem separado
    image_prompt = f"Fashion editorial photo, stylish outfit for {occasion}. {result['description']}. Clean white background, professional studio lighting, full body model facing camera, high fashion photography."
    
    return {
        "description": result["description"],
        "items": result["items"],
        "image_url": "https://placehold.co/1024x1024/1a1a1a/ffffff?text=Look+Gerado+por+IA",
        "image_prompt": image_prompt,
    }

async def generate_challenge_theme() -> dict:
    """Gera um tema de desafio diario."""
    prompt = """Crie um tema de desafio de moda para hoje no Brasil. Retorne apenas JSON valido:
{"title": "Titulo criativo em portugues", "description": "Descricao do desafio", "theme": "palavra-chave do tema"}"""
    
    response = model_text.generate_content(prompt)
    text = response.text.strip()
    if text.startswith("```"):
        text = text.strip("`").strip()
        if text.lower().startswith("json"):
            text = text[4:].strip()
    return json.loads(text)
