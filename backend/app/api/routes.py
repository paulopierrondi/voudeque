from fastapi import APIRouter, HTTPException
from typing import List
from app.schemas.look import LookCreate, LookResponse, ChallengeResponse, VoteRequest
from app.services.ai_service import generate_look, generate_challenge_theme

router = APIRouter()

# Mock in-memory store (substituir por DB)
looks_db = []
challenges_db = []

@router.post("/looks/generate", response_model=LookResponse)
async def create_look(payload: LookCreate):
    """Gera um novo look com IA."""
    try:
        result = await generate_look(None, payload.occasion, payload.style_notes)
        look = LookResponse(
            id=str(len(looks_db) + 1),
            image_url=result["image_url"],
            description=result["description"],
            items=result["items"],
            occasion=payload.occasion,
            votes=0,
            created_at="2026-05-17T22:00:00",
        )
        looks_db.append(look)
        return look
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/looks/feed", response_model=List[LookResponse])
async def get_feed(limit: int = 20, offset: int = 0):
    """Feed social de looks."""
    return looks_db[offset:offset + limit]

@router.post("/looks/vote")
async def vote_look(payload: VoteRequest):
    """Vota em um look."""
    for look in looks_db:
        if look.id == payload.look_id:
            look.votes += 1
            return {"success": True, "votes": look.votes}
    raise HTTPException(status_code=404, detail="Look not found")

@router.get("/challenges/daily", response_model=ChallengeResponse)
async def get_daily_challenge():
    """Retorna o desafio diario atual."""
    if not challenges_db:
        theme = await generate_challenge_theme()
        challenge = ChallengeResponse(
            id="1",
            title=theme["title"],
            description=theme["description"],
            theme=theme["theme"],
            ends_at="2026-05-18T23:59:59",
            participants=0,
        )
        challenges_db.append(challenge)
    return challenges_db[0]

@router.get("/challenges/ranking")
async def get_ranking():
    """Ranking dos looks mais votados do desafio atual."""
    sorted_looks = sorted(looks_db, key=lambda x: x.votes, reverse=True)[:10]
    return [{"rank": i+1, "look_id": l.id, "votes": l.votes} for i, l in enumerate(sorted_looks)]
