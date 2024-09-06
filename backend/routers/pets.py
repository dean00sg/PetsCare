from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session
from models.pet import Pet, PetCreate, PetUpdate, PetResponse
from deps import get_session
from datetime import date
from dateutil.relativedelta import relativedelta
from models.user import UserProfile
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
        weight=pet.weight,
        user_id=pet.user_id
    )

    session.add(db_pet)
    session.commit()
    session.refresh(db_pet)

    return PetResponse(
        pets_id=db_pet. pets_id,
        name=db_pet.name,
        type_pets=db_pet.type_pets,
        sex=db_pet.sex,
        breed=db_pet.breed,
        birth_date=db_pet.birth_date,
        weight=db_pet.weight,
        user_id=db_pet.user_id
        
    )

@router.get("/{pets_id}", response_model=PetResponse)
def get_pet(pets_id: int, session: Session = Depends(get_session)):
    # Fetch the pet and its owner by using a join
    pet = session.query(Pet).join(UserProfile).filter(Pet.pets_id == pets_id).first()

    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")

    # Get the owner's name from the related UserProfile
    owner = session.query(UserProfile).filter(UserProfile.user_id == pet.user_id).first()

    return PetResponse(
        pets_id=pet.pets_id,
        name=pet.name,
        type_pets=pet.type_pets,
        sex=pet.sex,
        breed=pet.breed,
        birth_date=pet.birth_date,
        weight=pet.weight,
        user_id=pet.user_id,
        owner_name=f"{owner.first_name} {owner.last_name}"  # Display the owner's full name
    )

@router.put("/{pets_id}", response_model=PetResponse)
def update_pet(pets_id: int, pet_update: PetUpdate, session: Session = Depends(get_session)):
    pet = session.get(Pet, pets_id)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")

    if pet_update.name is not None:
        pet.name = pet_update.name
    if pet_update.type_pets is not None:
        pet.type_pets = pet_update.type_pets
    if pet_update.sex is not None:
        pet.sex = pet_update.sex
    if pet_update.breed is not None:
        pet.breed = pet_update.breed
    if pet_update.birth_date is not None:
        pet.birth_date = pet_update.birth_date
    if pet_update.weight is not None:
        pet.weight = pet_update.weight

    session.add(pet)
    session.commit()
    session.refresh(pet)

    return PetResponse(
        pets_id=pet.pets_id,
        name=pet.name,
        type_pets=pet.type_pets,
        sex=pet.sex,
        breed=pet.breed,
        birth_date=pet.birth_date,
        weight=pet.weight,
        user_id=pet.user_id  # Include user_id in the response
    )

@router.delete("/{pets_id}", response_model=PetResponse)
def delete_pet(pets_id: int, session: Session = Depends(get_session)):
    pet = session.get(Pet, pets_id)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")

    session.delete(pet)
    session.commit()

    return PetResponse(
        pets_id=pet.pets_id,
        name=pet.name,
        type_pets=pet.type_pets,
        sex=pet.sex,
        breed=pet.breed,
        birth_date=pet.birth_date,
        weight=pet.weight,
        user_id=pet.user_id  # Include user_id in the response
    )
