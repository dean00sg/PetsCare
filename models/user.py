# models/user.py
from pydantic import BaseModel, EmailStr
from typing import List, Optional
from models.pet import PetProfile

class UserProfile(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    # ลบ password ออกจาก UserProfile

class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    password: str  # เพิ่มฟิลด์รหัสผ่าน

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_number: Optional[str] = None
    password: Optional[str] = None  # เพิ่มฟิลด์รหัสผ่านเพื่อการอัปเดต

class UserWithPets(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    pets: List[PetProfile] = []
