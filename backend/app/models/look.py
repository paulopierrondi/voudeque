from sqlalchemy import Column, String, Integer, DateTime, Text, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from datetime import datetime
from app.core.config import settings

Base = declarative_base()
engine = create_engine(settings.DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

class User(Base):
    __tablename__ = "users"
    
    id = Column(String, primary_key=True, index=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    looks = relationship("Look", back_populates="user", cascade="all, delete-orphan")
    votes = relationship("Vote", back_populates="user", cascade="all, delete-orphan")

class Look(Base):
    __tablename__ = "looks"
    
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    image_url = Column(String, nullable=True)
    description = Column(Text, nullable=False)
    occasion = Column(String, nullable=False)
    votes = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    user = relationship("User", back_populates="looks")
    items = relationship("LookItem", back_populates="look", cascade="all, delete-orphan")
    vote_records = relationship("Vote", back_populates="look", cascade="all, delete-orphan")

class LookItem(Base):
    __tablename__ = "look_items"
    
    id = Column(String, primary_key=True, index=True)
    look_id = Column(String, ForeignKey("looks.id"), nullable=False)
    name = Column(String, nullable=False)
    category = Column(String, nullable=False)
    color = Column(String, nullable=False)
    reason = Column(Text, nullable=False)
    
    look = relationship("Look", back_populates="items")

class Challenge(Base):
    __tablename__ = "challenges"
    
    id = Column(String, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(Text, nullable=False)
    theme = Column(String, nullable=False)
    ends_at = Column(DateTime, nullable=False)
    participants = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)

class Vote(Base):
    __tablename__ = "votes"
    
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    look_id = Column(String, ForeignKey("looks.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    user = relationship("User", back_populates="votes")
    look = relationship("Look", back_populates="vote_records")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
