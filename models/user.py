from pydantic import BaseModel, EmailStr
from typing import List, Optional
from models.pet import PetProfile

class UserProfile(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str

class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_number: Optional[str] = None

class UserWithPets(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    pets: List[PetProfile] = []  # เพิ่มข้อมูลสัตว์เลี้ยงของผู้ใช้