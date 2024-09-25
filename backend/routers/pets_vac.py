from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from models.pet_vac import PetVacProfile, CreatePetVacProfile, PetVacProfileResponse, LogPetVacProfile, UpdatePetVacProfile
from models.user import UserProfile
from models.pet import Pet
from deps import get_current_user, get_current_user_role, get_session
from datetime import datetime

router = APIRouter(tags=["Pets Vaccine"])


@router.post("/pet_vac_profile/", response_model=PetVacProfileResponse)
def create_pet_vac_profile(
    pet_name: str,
    owner_name: str,
    profile_data: CreatePetVacProfile,
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    owner = db.query(UserProfile).filter(UserProfile.first_name + " " + UserProfile.last_name == owner_name).first()

    if not owner:
        raise HTTPException(status_code=404, detail="Owner not found")

    pet = db.query(Pet).filter(Pet.name == pet_name, Pet.user_id == owner.user_id).first()

    if not pet:
        raise HTTPException(status_code=404, detail="Pet not found")

    new_profile = PetVacProfile(
        pet_name=pet_name,
        owner_name=owner_name,
        dose=profile_data.dose,
        vac_name=profile_data.vac_name,
        startdatevac=profile_data.startdatevac,
        location=profile_data.location,
        remark=profile_data.remark,
        user_id=owner.user_id
    )

    db.add(new_profile)
    db.commit()
    db.refresh(new_profile)

    log_entry = LogPetVacProfile(
        action_name="insert",
        action_by=username,  # Added action_by here
        action_datetime=datetime.now().replace(microsecond=0),
        vac_id=new_profile.vac_id,
        dose=new_profile.dose,
        vac_name=new_profile.vac_name,
        location=new_profile.location,
        remark=new_profile.remark,
        startdatevac=new_profile.startdatevac,
        pet_name=new_profile.pet_name,
        owner_name=new_profile.owner_name,
        user_id=new_profile.user_id
    )

    db.add(log_entry)
    db.commit()

    return PetVacProfileResponse(
        status="success",
        vac_id=new_profile.vac_id,
        dose=new_profile.dose,
        vac_name=new_profile.vac_name,
        startdatevac=new_profile.startdatevac,
        location=new_profile.location,
        remark=new_profile.remark,
        pet_name=new_profile.pet_name,
        owner_name=new_profile.owner_name
    )



@router.get("/pet_vac_profile/{pet_name}", response_model=PetVacProfileResponse)
def get_pet_vac_profile(pet_name: str, db: Session = Depends(get_session)):
    profile = db.query(PetVacProfile).filter(PetVacProfile.pet_name == pet_name).first()

    if not profile:
        raise HTTPException(status_code=404, detail="Vaccine profile not found")

    return PetVacProfileResponse(
        status="success",
        vac_id=profile.vac_id,
        dose=profile.dose,
        vac_name=profile.vac_name,
        startdatevac=profile.startdatevac,
        location=profile.location,
        remark=profile.remark,
        pet_name=profile.pet_name,
        owner_name=profile.owner_name
    )


@router.put("/pet_vac_profile/{pet_name}/{dose}", response_model=PetVacProfileResponse)
def update_pet_vac_profile(
    pet_name: str,
    dose: str,  # Add dose as a path parameter
    profile_data: UpdatePetVacProfile,
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)  # Get the username of the current user
):
    # Query the profile using both pet_name and dose
    profile = db.query(PetVacProfile).filter(
        PetVacProfile.pet_name == pet_name,
        PetVacProfile.dose == dose  # Filter by dose
    ).first()

    if not profile:
        raise HTTPException(status_code=404, detail="Vaccine profile not found")

    # Store old profile data for logging
    old_profile = {
        "dose": profile.dose,
        "vac_name": profile.vac_name,
        "location": profile.location,
        "remark": profile.remark,
        "startdatevac": profile.startdatevac
    }

    # Update profile with new data if provided
    if profile_data.dose is not None:
        profile.dose = profile_data.dose
    if profile_data.vac_name is not None:
        profile.vac_name = profile_data.vac_name
    if profile_data.startdatevac is not None:
        profile.startdatevac = profile_data.startdatevac
    if profile_data.location is not None:
        profile.location = profile_data.location
    if profile_data.remark is not None:
        profile.remark = profile_data.remark

    db.commit()
    db.refresh(profile)

    # Log the update
    log_entry = LogPetVacProfile(
        action_name="update",
        action_by=username,  # Added action_by here
        action_datetime=datetime.now().replace(microsecond=0),
        vac_id=profile.vac_id,
        dose=old_profile["dose"],
        vac_name=old_profile["vac_name"],
        location=old_profile["location"],
        remark=old_profile["remark"],
        startdatevac=old_profile["startdatevac"],
        to_dose=profile.dose,
        to_vac_name=profile.vac_name,
        to_location=profile.location,
        to_remark=profile.remark,
        to_startdatevac=profile.startdatevac,
        pet_name=profile.pet_name,
        owner_name=profile.owner_name,
        user_id=profile.user_id
    )

    db.add(log_entry)
    db.commit()

    return PetVacProfileResponse(
        status="success",
        vac_id=profile.vac_id,
        dose=profile.dose,
        vac_name=profile.vac_name,
        startdatevac=profile.startdatevac,
        location=profile.location,
        remark=profile.remark,
        pet_name=profile.pet_name,
        owner_name=profile.owner_name
    )



@router.delete("/pet_vac_profile/{pet_name}", response_model=PetVacProfileResponse)
def delete_pet_vac_profile(
    pet_name: str,
    dose: str,  # Add dose as a parameter
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)  # Get the username of the current user
):
    # Query the profile using both pet_name and dose
    profile = db.query(PetVacProfile).filter(
        PetVacProfile.pet_name == pet_name,
        PetVacProfile.dose == dose  # Filter by dose
    ).first()

    if not profile:
        raise HTTPException(status_code=404, detail="Vaccine profile not found")

    # Log the delete action
    log_entry = LogPetVacProfile(
        action_name="delete",
        action_by=username,  # Added action_by here
        action_datetime=datetime.now().replace(microsecond=0),
        vac_id=profile.vac_id,
        dose=profile.dose,
        vac_name=profile.vac_name,
        location=profile.location,
        remark=profile.remark,
        startdatevac=profile.startdatevac,
        pet_name=profile.pet_name,
        owner_name=profile.owner_name,
        user_id=profile.user_id
    )

    db.add(log_entry)
    db.delete(profile)
    db.commit()

    return PetVacProfileResponse(
        status="success",
        vac_id=profile.vac_id,
        dose=profile.dose,
        vac_name=profile.vac_name,
        startdatevac=profile.startdatevac,
        location=profile.location,
        remark=profile.remark,
        pet_name=profile.pet_name,
        owner_name=profile.owner_name
    )



@router.get("/get_all", response_model=list[PetVacProfileResponse])
async def get_all_pet_vac_profiles(
    db: Session = Depends(get_session),
    current_user_role: str = Depends(get_current_user_role)
):
    profiles = db.query(PetVacProfile).all()  # Retrieve all profiles

    if not profiles:
        raise HTTPException(status_code=404, detail="No vaccine profiles found")

    return [
        PetVacProfileResponse(
            status="success",
            vac_id=profile.vac_id,
            dose=profile.dose,
            vac_name=profile.vac_name,
            startdatevac=profile.startdatevac,
            location=profile.location,
            remark=profile.remark,
            pet_name=profile.pet_name,
            owner_name=profile.owner_name
        )
        for profile in profiles
    ]
