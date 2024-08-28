from fastapi import APIRouter, HTTPException
from models.user import UserProfile, UserCreate, UserUpdate, UserWithPets
from models.pet import PetProfile
from typing import List

router = APIRouter()

users_db: List[UserProfile] = []
# [UserProfile(
#    user_id = 1,
#    first_name = "pppp",
#    last_name = "ssssss",
#    email = "preampreawping@gmail.com",
#    contact_number = "0935752425"
#  )]

pets_db: List[PetProfile] = [PetProfile(
  id = 1,
  name = "sunny",
  pet_type = "cat",
  sex = "female",
  breed = "pug",
  birth_date = "2024-05-28T08:42:18.608Z",
  weight = 5,
  health_records = [],
  user_id = 2 
)]

@router.post("/users", response_model=UserProfile)
def create_user(user: UserCreate):
    new_id = len(users_db) + 1
    new_user = UserProfile(user_id=new_id, **user.dict())
    users_db.append(new_user)
    return new_user

@router.get("/users/{user_id}", response_model=UserProfile)
def get_user(user_id: int):
    user = next((u for u in users_db if u.user_id == user_id), None)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    # ดึงข้อมูลสัตว์เลี้ยงที่สัมพันธ์กับ user_id
    user_pets = [pet for pet in pets_db if pet.user_id == user_id]

    print (pets_db)

    # สร้าง response ที่มีข้อมูลสัตว์เลี้ยงของผู้ใช้งาน
    return UserWithPets(
        user_id=user.user_id, 
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        pets=user_pets  
    )

@router.get("/{user_id}/pets", response_model=List[PetProfile])
def get_user_pets(user_id: int):
    user = next((u for u in users_db if u.user_id == user_id), None)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    user_pets = [pet for pet in pets_db if pet.user_id == user_id]
    return user_pets

@router.put("/users/{user_id}", response_model=UserProfile)
def update_user(user_id: int, user_update: UserUpdate):
    user = next((u for u in users_db if u.user_id == user_id), None)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    for key, value in user_update.dict(exclude_unset=True).items():
        setattr(user, key, value)
    
    return user

@router.delete("/users/{user_id}", response_model=UserProfile)
def delete_user(user_id: int):
    global users_db
    user = next((u for u in users_db if u.user_id == user_id), None)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    users_db = [u for u in users_db if u.user_id != user_id]
    return user
