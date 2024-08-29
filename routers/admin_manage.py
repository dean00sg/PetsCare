from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from sqlmodel import select
from models.user import UserProfile
from models.authen_user import User, UserUpdate
from deps import get_session
from typing import List

router = APIRouter(tags=["Admin Manage"])

# GET /users
@router.get("/", response_model=List[UserProfile])
def get_users(session: Session = Depends(get_session)):
    try:
        users = session.exec(select(UserProfile)).all()
        return users
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# GET /users/{user_id}
@router.get("/{user_id}", response_model=UserProfile)
def get_user(user_id: int, session: Session = Depends(get_session)):
    user = session.get(UserProfile, user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

