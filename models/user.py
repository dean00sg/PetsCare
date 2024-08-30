from pydantic import BaseModel, EmailStr
from sqlmodel import SQLModel, Field, Relationship
from typing import List, Optional
from models.pet import Pet, PetProfile  
from models.pet_vac import PetVacProfile

class UserProfile(SQLModel, table=True):
    user_id: Optional[int] = Field(default=None, primary_key=True)
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    password: str  

    # Relationship to Pet model
    pets: List[Pet] = Relationship(back_populates="owner")

class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    password: str 

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_number: Optional[str] = None
    password: Optional[str] = None  

class UserWithPets(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    pets: List[PetProfile] = []  

class DeleteResponse(BaseModel):
    message: str
    user_id: int
    name: str

class PetsWithPetsVacsine(BaseModel):
    pets: List[PetProfile] = []  # ข้อมูลสัตว์เลี้ยง
    pet_vac_profiles: List[PetVacProfile] #รายการข้อมูลวัคซีนและการแพ้ยาของสัตว์เลี้ยง