from datetime import date, datetime
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from models.pet import Pet, PetCreate, PetLog, PetUpdate, PetResponse
from deps import get_current_user, get_session
from models.user import UserProfile
from dateutil.relativedelta import relativedelta

router = APIRouter(tags=["Pets"])

# def calculate_age(birth_date: date) -> str:
#     today = date.today()
#     delta = relativedelta(today, birth_date)
#     return f"{delta.years}y {delta.months}m {delta.days}d"

@router.post("/", response_model=PetResponse)
async def create_pet(
    pet: PetCreate, 
    session: Session = Depends(get_session),
    current_username: str = Depends(get_current_user)
):
    
    user = session.query(UserProfile).filter(UserProfile.email == current_username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    db_pet = Pet(
        name=pet.name,
        type_pets=pet.type_pets,
        sex=pet.sex,
        breed=pet.breed,
        birth_date=pet.birth_date,
        weight=pet.weight,
        owner_name=user.first_name,
        user_id=user.user_id  
    )

    session.add(db_pet)
    session.commit()
    session.refresh(db_pet)

  
    log_entry = PetLog(
        action_name="insert",
        action_datetime=datetime.now().replace(microsecond=0), 
        pets_id=db_pet.pets_id, 
        name=db_pet.name,
        birth_date=db_pet.birth_date,
        weight=db_pet.weight,
        user_id=db_pet.user_id,
        owner_name=db_pet.owner_name
    )

    session.add(log_entry)
    session.commit()

    return PetResponse(
        status="Success to add your pet is :",
        pets_id=db_pet.pets_id,
        name=db_pet.name,
        type_pets=db_pet.type_pets,
        sex=db_pet.sex,
        breed=db_pet.breed,
        birth_date=db_pet.birth_date,
        weight=db_pet.weight,
        user_id=db_pet.user_id,
        owner_name=db_pet.owner_name
    )


@router.get("/", response_model=list[PetResponse])
async def get_pets(
    session: Session = Depends(get_session),
    current_username: str = Depends(get_current_user)
):
    user = session.query(UserProfile).filter(UserProfile.email == current_username).first()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    pets = session.query(Pet).filter(Pet.user_id == user.user_id).all()

    if not pets:
        raise HTTPException(status_code=404, detail="No pets found for this user")

    return [
        PetResponse(
            status="Success",
            pets_id=pet.pets_id,
            name=pet.name,
            type_pets=pet.type_pets,
            sex=pet.sex,
            breed=pet.breed,
            birth_date=pet.birth_date,
            weight=pet.weight,
            user_id=pet.user_id,
            owner_name=f"{user.first_name} {user.last_name}"  # Owner's full name
        )
        for pet in pets
    ]


@router.put("/{pet_name}", response_model=PetResponse)
async def update_pet(
    pet_name: str, 
    pet_update: PetUpdate, 
    session: Session = Depends(get_session),
    current_username: str = Depends(get_current_user)
):
    user = session.query(UserProfile).filter(UserProfile.email == current_username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    pet = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user.user_id).first()
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")

    log_entry = PetLog(
        action_name="update",
        action_datetime=datetime.now().replace(microsecond=0), 
        pets_id=pet.pets_id,
        name=pet.name,
        to_name=pet_update.name if pet_update.name else pet.name,
        birth_date=pet.birth_date,
        to_birth_date=pet_update.birth_date if pet_update.birth_date else pet.birth_date,
        weight=pet.weight,
        to_weight=pet_update.weight if pet_update.weight else pet.weight,
        user_id=pet.user_id,
        owner_name=pet.owner_name
    )
    session.add(log_entry)
    session.commit() 

    if pet_update.name is not None:
        pet.name = pet_update.name
    if pet_update.birth_date is not None:
        pet.birth_date = pet_update.birth_date
    if pet_update.weight is not None:
        pet.weight = pet_update.weight

    session.commit() 
    session.refresh(pet)

    return PetResponse(
        status="Success to update your pet",
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


@router.delete("/{pet_name}")
async def delete_pet(
    pet_name: str, 
    session: Session = Depends(get_session),
    current_username: str = Depends(get_current_user)
):
    
    user = session.query(UserProfile).filter(UserProfile.email == current_username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")


    pet = session.query(Pet).filter(Pet.name == pet_name, Pet.user_id == user.user_id).first()
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")

    log_entry = PetLog(
        action_name="delete",
        action_datetime=datetime.now().replace(microsecond=0), 
        pets_id=pet.pets_id,
        name=pet.name,
        birth_date=pet.birth_date,
        weight=pet.weight,
        user_id=pet.user_id,
        owner_name=pet.owner_name
    )
    session.add(log_entry)
    session.commit()  

    session.delete(pet)  
    session.commit()

    return {"status": "Success", "detail": f"Pet '{pet_name}' has been deleted and logged in the system."}
