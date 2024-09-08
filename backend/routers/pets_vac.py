from fastapi import APIRouter, HTTPException, Depends, Query
from sqlalchemy.orm import Session
from security import AuthHandler
from models.pet import Pet
from models.pet_vac import PetVacProfile, LogPetVacProfile, CreatePetVacProfile, PetVacProfileResponse
from deps import get_session
from passlib.context import CryptContext
from models.user import UserProfile

router = APIRouter(tags=["Pets Vaccine"])
auth_handler = AuthHandler()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/", response_model=PetVacProfileResponse)
def create_pet_vac(
    pet_vac: CreatePetVacProfile, 
    user_name: str = Query(..., description="First name of the user to authenticate"),
    password: str = Query(..., description="Password of the user to authenticate"),
    pet_name: str = Query(..., description="Name of the pet to vaccinate"),
    session: Session = Depends(get_session)
):
    # Verify user authentication
    user = session.query(UserProfile).filter(UserProfile.first_name == user_name).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    if not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    # Verify pet ownership
    pet_profile = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user.user_id).first()
    if pet_profile is None:
        raise HTTPException(status_code=404, detail="Pet not found or does not belong to this user")

    # Create the new pet vaccination record
    new_pet_vac = PetVacProfile(
        pet_name=pet_profile.name,
        owner_name=user.first_name,
        vac_name=pet_vac.vac_name,
        startdatevac=pet_vac.startdatevac,
        drugname=pet_vac.drugname,
        user_id=user.user_id
    )
    
    # Add to session and commit the new pet vaccination
    session.add(new_pet_vac)
    session.commit()
    session.refresh(new_pet_vac)  # Refresh to get the generated vac_id

    # Create a log entry for the pet vaccination
    log_entry = LogPetVacProfile(
        action_name="insert",
        vac_id=new_pet_vac.vac_id,
        vac_name=new_pet_vac.vac_name,
        startdatevac=new_pet_vac.startdatevac,
        pet_name=new_pet_vac.pet_name,
        owner_name=user.first_name,
        user_id=user.user_id,
        drugname=new_pet_vac.drugname
    )

    # Add the log entry and commit
    session.add(log_entry)
    session.commit()

    return PetVacProfileResponse(
        status="Created Success",
        vac_id=new_pet_vac.vac_id,
        vac_name=new_pet_vac.vac_name,
        startdatevac=new_pet_vac.startdatevac,
        drugname=new_pet_vac.drugname,
        pet_name=new_pet_vac.pet_name,
        owner_name=new_pet_vac.owner_name
    )



# Get vaccination profile by ID
@router.get("/{pet_vac_id}", response_model=PetVacProfileResponse)
def get_pet_vac(pet_vac_id: int, session: Session = Depends(get_session)):
    pet_vac = session.query(PetVacProfile).get(pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")
    return pet_vac

@router.put("/{pet_vac_id}", response_model=PetVacProfileResponse)
def update_pet_vac(
    pet_vac_id: int, 
    pet_vac_update: CreatePetVacProfile, 
    password: str = Query(..., description="Password of the user to authenticate"),
    pet_name: str = Query(..., description="Name of the pet"),
    user_name: str = Query(..., description="Name of the user"),
    session: Session = Depends(get_session)
):
    # Check if the pet vaccination profile exists
    pet_vac = session.query(PetVacProfile).get(pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")

    # Verify user credentials
    user = session.query(UserProfile).filter(UserProfile.first_name == user_name).first()
    if user is None or not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    # Verify pet ownership
    pet_profile = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user.user_id).first()
    if pet_profile is None:
        raise HTTPException(status_code=404, detail="Pet not found or does not belong to this user")

    # Ensure that the pet vaccination profile is associated with the right pet
    if pet_vac.pet_name != pet_name:
        raise HTTPException(status_code=403, detail="Pet name does not match")

    # Log the update in the vaccination profile
    log_entry = LogPetVacProfile(
        action_name="update",
        vac_id=pet_vac.vac_id,
        vac_name=pet_vac.vac_name,
        to_vac_name=pet_vac_update.vac_name,
        startdatevac=pet_vac.startdatevac,
        to_startdatevac=pet_vac_update.startdatevac,
        pet_name=pet_vac.pet_name,
        owner_name=pet_vac.owner_name,
        user_id=user.user_id,
        drugname=pet_vac.drugname,
        to_drugname=pet_vac_update.drugname
    )

    # Update the pet vaccination profile
    for key, value in pet_vac_update.dict(exclude_unset=True).items():
        setattr(pet_vac, key, value)

    session.add(pet_vac)
    session.add(log_entry)
    session.commit()
    session.refresh(pet_vac)
    
    return PetVacProfileResponse(
        status="Updated Success",
        vac_id=pet_vac.vac_id,
        vac_name=pet_vac.vac_name,
        startdatevac=pet_vac.startdatevac,
        drugname=pet_vac.drugname,
        pet_name=pet_vac.pet_name,
        owner_name=pet_vac.owner_name
    )


@router.delete("/{pet_vac_id}", response_model=PetVacProfileResponse)
def delete_pet_vac(
    pet_vac_id: int, 
    password: str = Query(..., description="Password of the user to authenticate"),
    pet_name: str = Query(..., description="Name of the pet"),
    user_name: str = Query(..., description="Name of the user"),
    session: Session = Depends(get_session)
):
    # Retrieve the pet vaccination profile
    pet_vac = session.query(PetVacProfile).get(pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")

    # Verify user credentials
    user = session.query(UserProfile).filter(UserProfile.first_name == user_name).first()
    if user is None or not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    # Verify if the pet belongs to the user
    pet_profile = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user.user_id).first()
    if pet_profile is None or pet_profile.name != pet_vac.pet_name:
        raise HTTPException(status_code=403, detail="Pet does not belong to this user")

    # Log the deletion of the pet vaccination profile
    log_entry = LogPetVacProfile(
        action_name="delete",
        vac_id=pet_vac.vac_id,
        vac_name=pet_vac.vac_name,
        startdatevac=pet_vac.startdatevac,
        pet_name=pet_vac.pet_name,
        owner_name=pet_vac.owner_name,
        user_id=user.user_id,
        drugname=pet_vac.drugname
    )

    # Delete the pet vaccination profile
    session.delete(pet_vac)
    session.add(log_entry)  # Add log entry to the session
    session.commit()

    return PetVacProfileResponse(
        status="Deleted Success",
        vac_id=pet_vac.vac_id,
        vac_name=pet_vac.vac_name,
        startdatevac=pet_vac.startdatevac,
        drugname=pet_vac.drugname,
        pet_name=pet_vac.pet_name,
        owner_name=pet_vac.owner_name
    )
