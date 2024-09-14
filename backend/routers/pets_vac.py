from datetime import datetime
from typing import List
from fastapi import APIRouter, HTTPException, Depends, Query
from sqlalchemy.orm import Session
from models.pet import Pet
from models.pet_vac import PetVacProfile, LogPetVacProfile, CreatePetVacProfile, PetVacProfileResponse
from deps import get_current_user, get_session
from models.user import UserProfile

router = APIRouter(tags=["Pets Vaccine"])

def get_user_profile(username: str, session: Session) -> UserProfile:
    user_profile = session.query(UserProfile).filter(UserProfile.email == username).first()
    if user_profile is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user_profile


@router.post("/", response_model=PetVacProfileResponse)
def create_pet_vac(
    pet_vac: CreatePetVacProfile, 
    pet_name: str = Query(..., description="Name of the pet to vaccinate"),
    current_user: str = Depends(get_current_user), 
    session: Session = Depends(get_session)
):
    user_profile = get_user_profile(current_user, session)  

    pet_profile = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user_profile.user_id).first()
    if pet_profile is None:
        raise HTTPException(status_code=404, detail="Pet not found or does not belong to this user")

 
    startdatevac = pet_vac.startdatevac.replace(microsecond=0)

    new_pet_vac = PetVacProfile(
        pet_name=pet_profile.name,
        owner_name=user_profile.first_name,
        vac_name=pet_vac.vac_name,
        startdatevac=startdatevac,
        drugname=pet_vac.drugname,
        user_id=user_profile.user_id  
    )
    
    session.add(new_pet_vac)
    session.commit()
    session.refresh(new_pet_vac)

    log_entry = LogPetVacProfile(
        action_name="insert",
        action_datetime=datetime.now().replace(microsecond=0), 
        vac_id=new_pet_vac.vac_id,
        vac_name=new_pet_vac.vac_name,
        startdatevac=new_pet_vac.startdatevac,
        drugname=new_pet_vac.drugname,
        pet_name=new_pet_vac.pet_name,
        user_id=user_profile.user_id,  
        owner_name=user_profile.first_name
    )

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


@router.get("/{pet_name}/vaccines", response_model=List[PetVacProfileResponse])
def get_pet_vaccines(
    pet_name: str,
    current_user: str = Depends(get_current_user),  
    session: Session = Depends(get_session)
):
    user_profile = get_user_profile(current_user, session)  

    pet_profile = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user_profile.user_id).first()
    if pet_profile is None:
        raise HTTPException(status_code=404, detail="Pet not found or does not belong to this user")
    
    pet_vaccines = session.query(PetVacProfile).filter(PetVacProfile.pet_name == pet_profile.name).all()
    
    if not pet_vaccines:
        raise HTTPException(status_code=404, detail="No vaccination records found for this pet")
    
    return [
        PetVacProfileResponse(
            vac_id=vac.vac_id,
            vac_name=vac.vac_name,
            startdatevac=vac.startdatevac,
            drugname=vac.drugname,
            pet_name=vac.pet_name,
            owner_name=vac.owner_name,
            status="Fetched Success"
        ) for vac in pet_vaccines
    ]

@router.put("/{pet_name}", response_model=PetVacProfileResponse)
def update_pet_vac(
    pet_name: str, 
    pet_vac_update: CreatePetVacProfile, 
    current_user: str = Depends(get_current_user), 
    session: Session = Depends(get_session)
):
    user_profile = get_user_profile(current_user, session)  


    pet_vac = session.query(PetVacProfile).filter(
        PetVacProfile.pet_name == pet_name,
        PetVacProfile.user_id == user_profile.user_id
    ).first()

    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")


    pet_profile = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user_profile.user_id).first()
    if pet_profile is None:
        raise HTTPException(status_code=404, detail="Pet not found or does not belong to this user")

 
    startdatevac = pet_vac_update.startdatevac.replace(microsecond=0) if pet_vac_update.startdatevac else pet_vac.startdatevac

   
    log_entry = LogPetVacProfile(
        action_name="update",
        vac_id=pet_vac.vac_id,
        vac_name=pet_vac.vac_name,
        to_vac_name=pet_vac_update.vac_name,
        startdatevac=pet_vac.startdatevac,
        to_startdatevac=startdatevac,
        pet_name=pet_vac.pet_name,
        owner_name=pet_vac.owner_name,
        user_id=user_profile.user_id,
        drugname=pet_vac.drugname,
        to_drugname=pet_vac_update.drugname
    )

   
    for key, value in pet_vac_update.dict(exclude_unset=True).items():
        if key == "startdatevac":
            value = startdatevac
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


@router.delete("/", response_model=PetVacProfileResponse)
def delete_pet_vac(
    pet_name: str = Query(..., description="Name of the pet to delete vaccine record"),
    current_user: str = Depends(get_current_user), 
    session: Session = Depends(get_session)
):
    user_profile = get_user_profile(current_user, session) 

   
    pet_profile = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user_profile.user_id).first()
    if pet_profile is None:
        raise HTTPException(status_code=404, detail="Pet not found or does not belong to this user")

    
    pet_vac = session.query(PetVacProfile).filter(PetVacProfile.pet_name == pet_name, PetVacProfile.user_id == user_profile.user_id).first()
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine record not found")

    log_entry = LogPetVacProfile(
        action_name="delete",
        vac_id=pet_vac.vac_id,
        vac_name=pet_vac.vac_name,
        startdatevac=pet_vac.startdatevac,
        pet_name=pet_vac.pet_name,
        owner_name=pet_vac.owner_name,
        user_id=user_profile.user_id,
        drugname=pet_vac.drugname
    )

    session.delete(pet_vac)
    session.add(log_entry)
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
