from fastapi import APIRouter, HTTPException
from models.pet_vac import PetVacProfile,CreatePetVacProfile,Petdrugallergy
from datetime import datetime
from typing import List

router = APIRouter(tags=["petsVacsine"])
pets_vac_db: List[PetVacProfile] = []



@router.post("/pet_vac", response_model=PetVacProfile)
def create_pet_vac(pet_vac: CreatePetVacProfile):
    if pet_vac.user_id and pet_vac.pets_id <= 0:
        raise HTTPException(status_code=400, detail="Invalid user ID")

    new_id = len(pets_vac_db) + 1
    new_pet = pet_vac.copy(update={"id": new_id})
    pets_vac_db.append(new_pet)
    return new_pet

@router.get("/pets_vac/{pet_id}", response_model=PetVacProfile)
def get_pet_vac(pet_id: int):
    pet = next((p for p in pets_vac_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    return pet

#---------------------------------------------------------------------------------------------------------------------

@router.post("/pet_vac_drug", response_model=Petdrugallergy)
def create_pet_drug(pet_vac: Petdrugallergy):
    if pet_vac.user_id and pet_vac.pets_id <= 0:
        raise HTTPException(status_code=400, detail="Invalid user ID")

    new_id = len(pets_vac_db) + 1
    new_pet = pet_vac.copy(update={"id": new_id})
    pets_vac_db.append(new_pet)
    return new_pet


@router.get("/pets_vac_drug/{pet_id}", response_model=Petdrugallergy)
def get_pet_drug(pet_id: int):
    pet = next((p for p in pets_vac_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    return pet
