from fastapi import APIRouter, HTTPException, Depends, Query
from sqlmodel import Session, select
from security import AuthHandler
from models.pet import Pet, PetProfile
from models.pet_vac import PetVacProfile, CreatePetVacProfile
from deps import get_session
from typing import List
from passlib.context import CryptContext

from models.user import UserProfile

router = APIRouter(tags=["Pets Vaccine"])
auth_handler = AuthHandler()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/", response_model=PetVacProfile)
def create_pet_vac(
    pet_vac: CreatePetVacProfile, 
    pet_name: str = Query(..., description="Name of the pet to vaccinate"),
    user_name: str = Query(..., description="First name of the user to authenticate"),
    password: str = Query(..., description="Password of the user to authenticate"),
    session: Session = Depends(get_session)
):
    # Verify user credentials using user_name
    user = session.exec(select(UserProfile).where(UserProfile.first_name == user_name)).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    if not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    # Verify pet ownership
    pet_profile = session.exec(select(Pet).where(Pet.name == pet_name, Pet.user_id == user.user_id)).first()
    if pet_profile is None:
        raise HTTPException(status_code=404, detail="Pet not found or does not belong to this user")

    # Create new pet vaccination profile
    new_pet_vac = PetVacProfile(
        pet_name=pet_profile.name,
        user_name=user.first_name,
        vacname=pet_vac.vacname,
        stardatevac=pet_vac.stardatevac,
        drugname=pet_vac.drugname
    )
    
    # Add to session and commit
    session.add(new_pet_vac)
    session.commit()
    session.refresh(new_pet_vac)
    return new_pet_vac

@router.get("/{pet_vac_id}", response_model=PetVacProfile)
def get_pet_vac(pet_vac_id: int, session: Session = Depends(get_session)):
    pet_vac = session.get(PetVacProfile, pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")
    return pet_vac

@router.put("/{pet_vac_id}", response_model=PetVacProfile)
def update_pet_vac(
    pet_vac_id: int, 
    pet_vac_update: CreatePetVacProfile, 
    password: str = Query(..., description="Password of the user to authenticate"),
    pet_name: str = Query(..., description="Name of the pet"),
    user_id: int = Query(..., description="ID of the user"),
    session: Session = Depends(get_session)
):
    pet_vac = session.get(PetVacProfile, pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")

    pet_profile = session.exec(select(Pet).where(Pet.name == pet_name)).first()
    if pet_profile is None or pet_profile.id != pet_vac.pets_id:
        raise HTTPException(status_code=403, detail="Pet ID does not match")

    user = session.get(UserProfile, user_id)
    if user is None or not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    for key, value in pet_vac_update.dict(exclude_unset=True).items():
        setattr(pet_vac, key, value)

    session.add(pet_vac)
    session.commit()
    session.refresh(pet_vac)
    return pet_vac

@router.delete("/{pet_vac_id}", response_model=dict)
def delete_pet_vac(
    pet_vac_id: int, 
    password: str = Query(..., description="Password of the user to authenticate"),
    pet_name: str = Query(..., description="Name of the pet"),
    user_id: int = Query(..., description="ID of the user"),
    session: Session = Depends(get_session)
):
    pet_vac = session.get(PetVacProfile, pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")

    pet_profile = session.exec(select(Pet).where(Pet.name == pet_name)).first()
    if pet_profile is None or pet_profile.id != pet_vac.pets_id:
        raise HTTPException(status_code=403, detail="Pet ID does not match")

    user = session.get(UserProfile, user_id)
    if user is None or not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    session.delete(pet_vac)
    session.commit()
    return {"message": "Deleted successfully"}
