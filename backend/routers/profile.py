from datetime import datetime
from fastapi import APIRouter, HTTPException, Depends, Body,status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError
from pydantic import BaseModel
from sqlalchemy.orm import Session
from security import AuthHandler, Token
from models.user import LogUserLogin, LogUserProfile, UpdateUser, UserCreate, UserUpdate, UpdateUserResponse, UserProfile, UserWithPets, DeleteResponse, UserAuthen
from deps import get_session, get_current_user
from sqlalchemy.exc import IntegrityError

router = APIRouter(tags=["Profile"])

auth_handler = AuthHandler()

class UserProfileUpdate(BaseModel):
    first_name: str
    last_name: str
    contact_number: str


#----------------------------------------------------------------------------------------------------------------------------------------
@router.get("/")
async def get_user_profile(db: Session = Depends(get_session), token: str = Depends(OAuth2PasswordBearer(tokenUrl="/login"))):
    try:
     
        user_data = auth_handler.decode_access_token(token)
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

   
    user_profile = db.query(UserProfile).filter(UserProfile.email == user_data['username']).first()

    if not user_profile:
        raise HTTPException(status_code=404, detail="User not found")

    
    return {
        "first_name": user_profile.first_name,
        "last_name": user_profile.last_name,
        "email": user_profile.email,
        "contact_number": user_profile.contact_number
    }


@router.put("/")
async def update_user_profile(
    profile_update: UserProfileUpdate,
    db: Session = Depends(get_session),
    token: str = Depends(OAuth2PasswordBearer(tokenUrl="/login"))
):
    try:
        # Decode token to get user data
        user_data = auth_handler.decode_access_token(token)
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    # Find user by email
    user_profile = db.query(UserProfile).filter(UserProfile.email == user_data['username']).first()

    if not user_profile:
        raise HTTPException(status_code=404, detail="User not found")

    # Log the current and updated profile data
    log_entry = LogUserProfile(
        action_name="update",
        user_id=user_profile.user_id,
        first_name=user_profile.first_name,
        to_first_name=profile_update.first_name,
        last_name=user_profile.last_name,
        to_last_name=profile_update.last_name,
        email=user_profile.email,
        to_email=user_profile.email,  
        contact_number=user_profile.contact_number,
        to_contact_number=profile_update.contact_number,
        role=user_profile.role
    )

    # Update the profile fields
    user_profile.first_name = profile_update.first_name
    user_profile.last_name = profile_update.last_name
    user_profile.contact_number = profile_update.contact_number

    # Commit the changes to the database and insert the log
    db.add(log_entry)
    db.commit()
    db.refresh(user_profile)

    return {
        "message": "Profile updated successfully",
        "first_name": user_profile.first_name,
        "last_name": user_profile.last_name,
        "email": user_profile.email,
        "contact_number": user_profile.contact_number
    }

