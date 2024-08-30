from pydantic import BaseModel, EmailStr
from sqlmodel import SQLModel, Field, Relationship
from typing import List, Optional
<<<<<<< HEAD
from models.pet import Pet, PetProfile  
from models.pet_vac import PetVacProfile
=======
from models.pet import Pet, PetProfile
>>>>>>> 610fa1a6679729c87e07bb30e12a8de6bf193857

class UserProfile(SQLModel, table=True):
    user_id: Optional[int] = Field(default=None, primary_key=True)
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
<<<<<<< HEAD
    password: str  
=======
    password: str
    role: str = Field(default="userpets")  # Default to "userpets" if not provided
>>>>>>> 610fa1a6679729c87e07bb30e12a8de6bf193857

    # Relationship to Pet model
    pets: List[Pet] = Relationship(back_populates="owner")

class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
<<<<<<< HEAD
    password: str 
=======
    password: str
    role: Optional[str] = "userpets"  # Default to "userpets" if not provided
>>>>>>> 610fa1a6679729c87e07bb30e12a8de6bf193857

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_number: Optional[str] = None
<<<<<<< HEAD
    password: Optional[str] = None  
=======
    password: Optional[str] = None
    role: Optional[str] = None  # Allow role updates if specified
>>>>>>> 610fa1a6679729c87e07bb30e12a8de6bf193857

class UserWithPets(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    pets: List[PetProfile] = []  

class DeleteResponse(BaseModel):
    status : str
    id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    role: str

class Login(BaseModel):
    email: str
    password: str

class UpdateUser(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email:EmailStr
    contact_number: Optional[str] = None
    new_password: Optional[str] = None

class UpdateUserResponse(BaseModel):
    status: str
    user_id: int
<<<<<<< HEAD
    name: str

class PetsWithPetsVacsine(BaseModel):
    pets: List[PetProfile] = []  # ข้อมูลสัตว์เลี้ยง
    pet_vac_profiles: List[PetVacProfile] #รายการข้อมูลวัคซีนและการแพ้ยาของสัตว์เลี้ยง
=======
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    role: str
>>>>>>> 610fa1a6679729c87e07bb30e12a8de6bf193857
