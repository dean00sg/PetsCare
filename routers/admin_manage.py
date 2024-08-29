from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from sqlmodel import select
from models.user import UserProfile, UserWithPets
from models.pet import Pet
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

# GET /users/{user_id}/with_pets
@router.get("/{user_id}/with_pets", response_model=UserWithPets)
def get_user_with_pets(user_id: int, session: Session = Depends(get_session)):
    user = session.exec(select(UserProfile).where(UserProfile.user_id == user_id)).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    pets = session.exec(select(Pet).where(Pet.user_id == user_id)).all()
    user_with_pets = UserWithPets(
        user_id=user.user_id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        pets=pets  # or use PetProfile if needed
    )

    return user_with_pets
