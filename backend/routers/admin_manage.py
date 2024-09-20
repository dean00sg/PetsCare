from datetime import date
from fastapi import APIRouter, HTTPException, Depends, Path
from sqlalchemy.orm import Session
from models.notehealth import CreateHealthRecord, HealthRecord
from models.pet_vac import PetVacProfile
from models.user import GetUserProfile, UserProfile, UserWithPets
from models.pet import Pet, PetProfile
from deps import get_session, get_current_user_role
from typing import List
from dateutil.relativedelta import relativedelta

router = APIRouter(tags=["Admin Checking"])

def calculate_age(birth_date: date) -> str:
    today = date.today()
    delta = relativedelta(today, birth_date)
    return f"{delta.years}y {delta.months}m {delta.days}d"

@router.get("/", response_model=List[GetUserProfile])
async def get_users(
    session: Session = Depends(get_session),
    role: str = Depends(get_current_user_role)  
):
   
    users = session.query(UserProfile).all()
    return users

@router.get("/{user_id}", response_model=GetUserProfile)
async def get_user(
    user_id: int = Path(..., description="User ID to retrieve user information"),
    session: Session = Depends(get_session),
    role: str = Depends(get_current_user_role)  # Ensure the current user is an admin
):
    db_user = session.query(UserProfile).get(user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    return GetUserProfile(
        user_id=db_user.user_id,
        first_name=db_user.first_name,
        last_name=db_user.last_name,
        email=db_user.email,
        contact_number=db_user.contact_number,
        role=db_user.role
    )

@router.get("/{user_id}/with_pets", response_model=UserWithPets)
async def get_user_with_pets(
    user_id: int = Path(..., description="User ID to retrieve user and pet information"),
    session: Session = Depends(get_session),
    role: str = Depends(get_current_user_role)  # Ensure the current user is an admin
):
    db_user = session.query(UserProfile).filter(UserProfile.user_id == user_id).first()
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")

    pets = session.query(Pet).filter(Pet.user_id == user_id).all()
    pet_profiles = [
        PetProfile(
            pets_id=pet.pets_id,
            name=pet.name,
            type_pets=pet.type_pets,
            sex=pet.sex,
            breed=pet.breed,
            birth_date=pet.birth_date,
            weight=pet.weight,
            user_id=pet.user_id,
            owner_name=pet.owner_name
        )
        for pet in pets
    ]
   
    return UserWithPets(
        user_id=db_user.user_id,
        first_name=db_user.first_name,
        last_name=db_user.last_name,
        email=db_user.email,
        contact_number=db_user.contact_number,
        pets=pet_profiles
    )


# Assuming you want to uncomment and update the endpoint for getting pets with vaccine records
# @router.get("/{pet_id}/with_pets_vacsine", response_model=PetsWithPetsVacsine)
# def get_pets_with_vacsine(
#     pet_id: int = Path(..., description="Pet ID to retrieve pet and vaccination information"),
#     session: Session = Depends(get_session),
#     username: str = Depends(get_current_user)  # Get the current user's username from the token
# ):
#     user = session.query(UserProfile).filter(UserProfile.first_name == username).first()
    
#     if user is None:
#         raise HTTPException(status_code=404, detail="User not found")
    
#     pet = session.query(Pet).filter(Pet.id == pet_id, Pet.user_id == user.user_id).first()
    
#     if pet is None:
#         raise HTTPException(status_code=403, detail="Unauthorized access to this pet")

#     pet_profile = PetProfile(
#         id=pet.id,
#         name=pet.name,
#         type_pets=pet.type_pets,
#         sex=pet.sex,
#         breed=pet.breed,
#         birth_date=pet.birth_date,
#         weight=pet.weight,
#         user_id=pet.user_id,
#         age=calculate_age(pet.birth_date.date())
#     )
#     pet_vac_profiles = session.query(PetVacProfile).filter(PetVacProfile.pet_name == pet.name).all()

#     if not pet_vac_profiles:
#         raise HTTPException(status_code=404, detail="No vaccination records found for this pet")

#     pets_with_vacsine = PetsWithPetsVacsine(
#         pets=[pet_profile],
#         pet_vac_profiles=pet_vac_profiles
#     )

#     return pets_with_vacsine

# Endpoint to get all health records
# @router.get("/notehealth/health", response_model=List[HealthRecord])
# def get_all_health_records(
#     session: Session = Depends(get_session),
#     username: str = Depends(get_current_user)  # Get the current user's username from the token
# ):
#     verify_admin(username, session)

#     health_records = session.query(HealthRecord).all()
#     return health_records
