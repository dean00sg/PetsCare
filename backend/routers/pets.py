from datetime import date
from typing import List
from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session
from models.pet import Pet, PetCreate, PetResponse, PetUpdate
from deps import get_session
from dateutil.relativedelta import relativedelta

router = APIRouter(tags=["Pets"])

def calculate_age(birth_date: date) -> str:
    today = date.today()
    delta = relativedelta(today, birth_date)
    return f"{delta.years}y {delta.months}m {delta.days}d"

@router.post("/", response_model=PetResponse)
def create_pet(pet: PetCreate, session: Session = Depends(get_session)):
    db_pet = Pet(
        name=pet.name,
        type_pets=pet.type_pets,
        sex=pet.sex,
        breed=pet.breed,
        birth_date=pet.birth_date,
        weight=pet.weight
    )

    session.add(db_pet)
    session.commit()
    session.refresh(db_pet)

    return PetResponse(
        id=db_pet.id,
        name=db_pet.name,
        type_pets=db_pet.type_pets,
        sex=db_pet.sex,
        breed=db_pet.breed,
        birth_date=db_pet.birth_date,
        weight=db_pet.weight
    )

@router.get("/{pet_id}", response_model=PetResponse)
def get_pet(pet_id: int, session: Session = Depends(get_session)):
    pet = session.get(Pet, pet_id)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")

    return PetResponse(
        id=pet.id,
        name=pet.name,
        type_pets=pet.type_pets,
        sex=pet.sex,
        breed=pet.breed,
        birth_date=pet.birth_date,
        weight=pet.weight
    )
