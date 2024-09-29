from typing import List
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
    profile_data: CreatePetVacProfile,
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    # Fetch owner using the provided owner_name
    owner = db.query(UserProfile).filter(
        UserProfile.first_name + " " + UserProfile.last_name == profile_data.owner_name
    ).first()

    if not owner:
        raise HTTPException(status_code=404, detail="Owner not found")

    # Fetch pet using the provided pet_id
    pet = db.query(Pet).filter(Pet.pets_id == profile_data.pets_id, Pet.user_id == owner.user_id).first()

    if not pet:
        raise HTTPException(status_code=404, detail="Pet not found")

    # Create a new PetVacProfile instance
    new_profile = PetVacProfile(
        pets_id=profile_data.pets_id,
        pet_name=profile_data.pet_name,
        owner_name=profile_data.owner_name,
        dose=profile_data.dose,
        vac_name=profile_data.vac_name,
        startdatevac=profile_data.startdatevac,
        location=profile_data.location,
        remark=profile_data.remark,
        user_id=owner.user_id,
        note_by=username
    )

    db.add(new_profile)
    db.commit()
    db.refresh(new_profile)

    # Log the action
    log_entry = LogPetVacProfile(
        action_name="insert",
        action_by=username,
        action_datetime=datetime.now().replace(microsecond=0),
        vac_id=new_profile.vac_id,
        dose=new_profile.dose,
        vac_name=new_profile.vac_name,
        location=new_profile.location,
        remark=new_profile.remark,
        startdatevac=new_profile.startdatevac,
        pet_name=new_profile.pet_name,
        owner_name=new_profile.owner_name,
        user_id=new_profile.user_id,
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
        pets_id=new_profile.pets_id,  # Return pet_id in the response
        pet_name=new_profile.pet_name,
        owner_name=new_profile.owner_name,
        note_by=new_profile.note_by
    )


@router.get("/pet_vac_profile/{pets_id}", response_model=List[PetVacProfileResponse])
def get_pet_vac_profile(pets_id: int, db: Session = Depends(get_session)):
    profiles = db.query(PetVacProfile).filter(PetVacProfile.pets_id == pets_id).all()

    if not profiles:
        raise HTTPException(status_code=404, detail="Vaccine profiles not found")

    return [
        PetVacProfileResponse(
            status="success",
            vac_id=profile.vac_id,
            dose=profile.dose,
            vac_name=profile.vac_name,
            startdatevac=profile.startdatevac,
            location=profile.location,
            remark=profile.remark,
            pets_id=profile.pets_id,
            pet_name=profile.pet_name,
            owner_name=profile.owner_name,
            note_by=profile.note_by
        )
        for profile in profiles
    ]


@router.put("/pet_vac_profile/{pets_id}/{dose}", response_model=PetVacProfileResponse)
def update_pet_vac_profile(
    pets_id: int,
    dose: int,
    profile_data: UpdatePetVacProfile,
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    # Query the profile using both pets_id and dose
    profile = db.query(PetVacProfile).filter(
        PetVacProfile.pets_id == pets_id,
        PetVacProfile.dose == dose
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
        action_by=username,
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
        pets_id=profile.pets_id,
        pet_name=profile.pet_name,
        owner_name=profile.owner_name
    )


@router.delete("/pet_vac_profile/{pets_id}/{dose}", response_model=PetVacProfileResponse)
def delete_pet_vac_profile(
    pets_id: int,
    dose: int,
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    # Query the profile using both pets_id and dose
    profile = db.query(PetVacProfile).filter(
        PetVacProfile.pets_id == pets_id,
        PetVacProfile.dose == dose
    ).first()

    if not profile:
        raise HTTPException(status_code=404, detail="Vaccine profile not found")

    # Log the delete action
    log_entry = LogPetVacProfile(
        action_name="delete",
        action_by=username,
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
        pets_id=profile.pets_id,
        pet_name=profile.pet_name,
        owner_name=profile.owner_name,
        note_by=profile.note_by
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
            pets_id=profile.pets_id,
            pet_name=profile.pet_name,
            owner_name=profile.owner_name,
            note_by=profile.note_by
        ) for profile in profiles
    ]
