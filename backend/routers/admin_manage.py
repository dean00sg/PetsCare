from datetime import date
from fastapi import APIRouter, HTTPException, Depends, Query, Path
from sqlalchemy.orm import Session
from sqlmodel import select
from models.notehealth import PetHealthRecord
from models.pet_vac import PetVacProfile
from models.user import GetUserProfile, UserProfile, UserWithPets
from models.pet import Pet, PetProfile
from deps import get_session
from security import AuthHandler
from typing import List
from dateutil.relativedelta import relativedelta

router = APIRouter(tags=["Admin Checking"])
auth_handler = AuthHandler()  # Initialize your authentication handler

def calculate_age(birth_date: date) -> str:
    today = date.today()
    delta = relativedelta(today, birth_date)
    return f"{delta.years}y {delta.months}m {delta.days}d"

def verify_admin(firstname: str, password: str, session: Session) -> None:
    """Function to verify if the user is an admin with valid credentials."""
    # Use session.query for SQLAlchemy
    admin_user = session.query(UserProfile).filter(UserProfile.first_name == firstname).first()

    if not admin_user:
        raise HTTPException(status_code=404, detail="Admin user not found")

    if not auth_handler.verify_password(password, admin_user.password):
        raise HTTPException(status_code=401, detail="Invalid password. Access forbidden: Admins only")

    if admin_user.role != "admin":
        raise HTTPException(status_code=403, detail="Access forbidden: Admins only")

# Endpoint to get all users
@router.get("/", response_model=List[GetUserProfile])
def get_users(
    first_name: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(first_name, password, session)
    
    users = session.query(UserProfile).all()
    return users

@router.get("/{user_id}", response_model=GetUserProfile)
def get_user(
    user_id: int = Path(..., description="User ID to retrieve user information"),
    first_name: str = Query(..., description="Admin user first name for authentication"),
    password: str = Query(..., description="Admin user password for authentication"),
    session: Session = Depends(get_session)
):
    verify_admin(first_name, password, session)
    
    db_user = session.query(UserProfile).get(user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Directly create an instance of GetUserProfile from db_user
    user_profile = GetUserProfile(
        user_id=db_user.user_id,
        first_name=db_user.first_name,
        last_name=db_user.last_name,
        email=db_user.email,
        contact_number=db_user.contact_number,
        role=db_user.role
    )
    
    return user_profile


# Endpoint to get a user along with their pets
@router.get("/{user_id}/with_pets", response_model=UserWithPets)
def get_user_with_pets(
    user_id: int = Path(..., description="User ID to retrieve user and pet information"),
    first_name: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(first_name, password, session)
    
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
   
    user_with_pets = UserWithPets(
        user_id=db_user.user_id,
        first_name=db_user.first_name,
        last_name=db_user.last_name,
        email=db_user.email,
        contact_number=db_user.contact_number,
        pets=pet_profiles
    )
    
    return user_with_pets

#-----------------------------------------------------------------------------------------------------------------------
# @router.get("/{pet_id}/with_pets_vacsine", response_model=PetsWithPetsVacsine)
# def get_pets_with_vacsine(
#     pet_id: int = Path(..., description="Pet ID to retrieve user and pet information"),
#     firstname: str = Query(..., description="First name of the user to authenticate"),
#     password: str = Query(..., description="Password of the user to authenticate"),
#     session: Session = Depends(get_session)
# ):
#     user = session.exec(select(UserProfile).where(UserProfile.first_name == firstname)).first()
    
#     if user is None:
#         raise HTTPException(status_code=404, detail="User not found")
    
#     if not auth_handler.verify_password(password, user.password):
#         raise HTTPException(status_code=401, detail="Invalid password")
    
#     pet = session.exec(select(Pet).where(Pet.id == pet_id, Pet.user_id == UserProfile.user_id)).first()
    
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
#     petname = session.exec(select(Pet.name).where(Pet.id == pet_id)).first()
#     pet_vac_profiles = session.exec(select(PetVacProfile).where(PetVacProfile.pet_name == petname)).all()

#     if not pet_vac_profiles:
#         raise HTTPException(status_code=404, detail="No vaccination records found for this pet")

#     pets_with_vacsine = PetsWithPetsVacsine(
#         pets=[pet_profile],
#         pet_vac_profiles=pet_vac_profiles
#     )

#     return pets_with_vacsine




# @router.get("/notehealth/health", response_model=List[PetHealthRecord])
# def get_all_health_records(
#     firstname: str = Query(..., description="First name of the admin user to authenticate"),
#     password: str = Query(..., description="Password of the admin user to authenticate"),
#     session: Session = Depends(get_session)
# ):
#     verify_admin(firstname, password, session)

#     health_records = session.exec(select(PetHealthRecord)).all()
#     return health_records

