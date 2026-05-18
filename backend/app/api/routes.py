from fastapi import APIRouter, HTTPException, Depends, Header
from typing import List, Optional
from uuid import uuid4
from datetime import datetime, timedelta

from app.schemas.look import LookCreate, LookResponse, LookItem, ChallengeResponse, VoteRequest
from app.services.ai_service import generate_look, generate_challenge_theme
from app.models.look import get_db, User, Look, LookItem as LookItemModel, Challenge, Vote
from app.core.auth import issue_token, verify_token
from sqlalchemy.orm import Session

router = APIRouter()

def get_current_user(authorization: Optional[str] = Header(None), db: Session = Depends(get_db)) -> User:
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing authorization header")
    token = authorization.split(" ")[1]
    payload = verify_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    user = db.query(User).filter(User.id == payload["sub"]).first()
    if not user:
        raise HTTPException(status_code=401, detail="User not found")
    return user

@router.post("/auth/anonymous")
async def anonymous_session(db: Session = Depends(get_db)):
    user_id = f"anon:{uuid4().hex}"
    user = User(id=user_id)
    db.add(user)
    db.commit()
    db.refresh(user)
    token = issue_token(user_id)
    return {"user_id": user_id, "token": token}

@router.post("/looks/generate", response_model=LookResponse)
async def create_look(payload: LookCreate, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    try:
        result = await generate_look(None, payload.occasion, payload.style_notes)
        look_id = str(uuid4())
        look = Look(
            id=look_id,
            user_id=user.id,
            image_url=result.get("image_url", ""),
            description=result["description"],
            occasion=payload.occasion,
            votes=0,
            created_at=datetime.utcnow()
        )
        db.add(look)
        db.commit()
        db.refresh(look)
        
        for item_data in result.get("items", []):
            item = LookItemModel(
                id=str(uuid4()),
                look_id=look_id,
                name=item_data["name"],
                category=item_data["category"],
                color=item_data["color"],
                reason=item_data["reason"]
            )
            db.add(item)
        db.commit()
        
        return LookResponse(
            id=look.id,
            image_url=look.image_url,
            description=look.description,
            items=[LookItem(name=i.name, category=i.category, color=i.color, reason=i.reason) for i in look.items],
            occasion=look.occasion,
            votes=look.votes,
            created_at=look.created_at
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/looks/feed", response_model=List[LookResponse])
async def get_feed(limit: int = 20, offset: int = 0, db: Session = Depends(get_db)):
    looks = db.query(Look).order_by(Look.created_at.desc()).offset(offset).limit(limit).all()
    return [
        LookResponse(
            id=l.id,
            image_url=l.image_url,
            description=l.description,
            items=[LookItem(name=i.name, category=i.category, color=i.color, reason=i.reason) for i in l.items],
            occasion=l.occasion,
            votes=l.votes,
            created_at=l.created_at
        )
        for l in looks
    ]

@router.post("/looks/vote")
async def vote_look(payload: VoteRequest, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    look = db.query(Look).filter(Look.id == payload.look_id).first()
    if not look:
        raise HTTPException(status_code=404, detail="Look not found")
    existing = db.query(Vote).filter(Vote.user_id == user.id, Vote.look_id == payload.look_id).first()
    if existing:
        raise HTTPException(status_code=400, detail="Already voted")
    vote = Vote(id=str(uuid4()), user_id=user.id, look_id=payload.look_id)
    db.add(vote)
    look.votes += 1
    db.commit()
    return {"success": True, "votes": look.votes}

@router.get("/challenges/daily", response_model=ChallengeResponse)
async def get_daily_challenge(db: Session = Depends(get_db)):
    challenge = db.query(Challenge).order_by(Challenge.created_at.desc()).first()
    if not challenge:
        theme = await generate_challenge_theme()
        challenge = Challenge(
            id=str(uuid4()),
            title=theme["title"],
            description=theme["description"],
            theme=theme["theme"],
            ends_at=datetime.utcnow() + timedelta(days=1),
            participants=0
        )
        db.add(challenge)
        db.commit()
        db.refresh(challenge)
    return ChallengeResponse(
        id=challenge.id,
        title=challenge.title,
        description=challenge.description,
        theme=challenge.theme,
        ends_at=challenge.ends_at,
        participants=challenge.participants
    )

@router.get("/challenges/ranking")
async def get_ranking(db: Session = Depends(get_db)):
    sorted_looks = db.query(Look).order_by(Look.votes.desc()).limit(10).all()
    return [{"rank": i+1, "look_id": l.id, "votes": l.votes} for i, l in enumerate(sorted_looks)]

@router.delete("/users/me")
async def delete_account(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    db.delete(user)
    db.commit()
    return {"success": True}
