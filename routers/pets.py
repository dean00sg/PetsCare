from datetime import date
from typing import List
from fastapi import APIRouter, HTTPException, Depends
from fastapi.responses import JSONResponse
from sqlmodel import Session, select
from models.pet import Pet, PetCreate, PetResponse, PetUpdate
from models.user import UserProfile
from deps import get_session
from dateutil.relativedelta import relativedelta

router = APIRouter(tags=["Pets"])

def calculate_age(birth_date: date) -> str:
    today = date.today()
    delta = relativedelta(today, birth_date)
    return f"{delta.years}y {delta.months}m {delta.days}d"

@router.post("/", response_model=Pet)
def create_pet(pet: PetCreate, session: Session = Depends(get_session)):
    try:
        # Ensure user exists
        user = session.get(UserProfile, pet.user_id)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

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
        return db_pet
    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {str(e)}")

@router.get("/{pet_id}", response_model=PetResponse)
def get_pet(pet_id: int, user_id: int, session: Session = Depends(get_session)):
    try:
        # Retrieve the pet
        pet = session.get(Pet, pet_id)
        if pet is None:
            raise HTTPException(status_code=404, detail="Pet not found")

        # Verify that the pet belongs to the user
        if pet.user_id != user_id:
            raise HTTPException(status_code=403, detail="Not authorized to access this pet")
        
        pet_age = calculate_age(pet.birth_date.date())
        
        return PetResponse(
            id=pet.id,
            name=pet.name,
            type_pets=pet.type_pets,
            sex=pet.sex,
            breed=pet.breed,
            birth_date=pet.birth_date,
            age=pet_age,
            weight=pet.weight,
            user_id=pet.user_id
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {str(e)}")

@router.get("/user/{user_id}", response_model=List[PetResponse])
def get_pets_by_user(user_id: int, session: Session = Depends(get_session)):
    try:
        # Lookup user by ID
        user = session.get(UserProfile, user_id)
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")

        # Retrieve pets for the user
        pets = session.exec(select(Pet).where(Pet.user_id == user_id)).all()
        if not pets:
            raise HTTPException(status_code=404, detail="No pets found for this user")
        
        pet_responses = [
            PetResponse(
                id=pet.id,
                name=pet.name,
                type_pets=pet.type_pets,
                sex=pet.sex,
                breed=pet.breed,
                birth_date=pet.birth_date,
                age=calculate_age(pet.birth_date.date()),  # Ensure birth_date is a date object
                weight=pet.weight,
                user_id=pet.user_id
            )
            for pet in pets
        ]

        return pet_responses
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {str(e)}")

@router.put("/{pet_id}", response_model=Pet)
def update_pet(pet_id: int, pet_update: PetUpdate, user_id: int, session: Session = Depends(get_session)):
    try:
        # Retrieve the pet
        pet = session.get(Pet, pet_id)
        if pet is None:
            raise HTTPException(status_code=404, detail="Pet not found")
        
        # Ensure the user_id matches
        if pet.user_id != user_id:
            raise HTTPException(status_code=403, detail="Not authorized to update this pet")
        
        # Update pet fields
        for key, value in pet_update.dict(exclude_unset=True).items():
            setattr(pet, key, value)

        session.add(pet)
        session.commit()
        session.refresh(pet)

        # Custom response with success message
        return JSONResponse(
            status_code=200,
            content={
                "message": "Pet updated successfully",
                "pet_id": pet.id,
                "user_id": user_id
            }
        )
    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {str(e)}")
    
@router.delete("/{pet_id}", response_model=Pet)
def delete_pet(pet_id: int, user_id: int, session: Session = Depends(get_session)):
    try:
        # Retrieve the pet
        pet = session.get(Pet, pet_id)
        if pet is None:
            raise HTTPException(status_code=404, detail="Pet not found")
        
        # Ensure the user_id matches
        if pet.user_id != user_id:
            raise HTTPException(status_code=403, detail="Not authorized to delete this pet")

        session.delete(pet)
        session.commit()

        # Custom response with success message
        return JSONResponse(
            status_code=200,
            content={
                "message": "Pet deleted successfully",
                "pet_id": pet.id,
                "user_id": user_id
            }
        )
    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {str(e)}")
