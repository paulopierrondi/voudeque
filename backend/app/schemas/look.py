from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class LookCreate(BaseModel):
    user_photo_url: Optional[str] = None
    occasion: str = "casual"
    style_notes: Optional[str] = None

class LookItem(BaseModel):
    name: str
    category: str
    color: str
    reason: str

class LookResponse(BaseModel):
    id: str
    image_url: str
    description: str
    items: List[LookItem]
    occasion: str
    votes: int = 0
    created_at: datetime

class ChallengeResponse(BaseModel):
    id: str
    title: str
    description: str
    theme: str
    ends_at: datetime
    participants: int = 0

class VoteRequest(BaseModel):
    look_id: str
