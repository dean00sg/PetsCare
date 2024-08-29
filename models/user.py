from pydantic import BaseModel, EmailStr
from sqlmodel import SQLModel, Field, Relationship
from typing import List, Optional
from models.pet import Pet, PetProfile  # Import PetProfile if needed

class UserProfile(SQLModel, table=True):
    user_id: Optional[int] = Field(default=None, primary_key=True)
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    password: str  # Store hashed passwords

    # Relationship to Pet model
    pets: List[Pet] = Relationship(back_populates="owner")

class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    password: str  # Store plaintext password for creation; hash it before storing

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_number: Optional[str] = None
    password: Optional[str] = None  # Allow password updates

class UserWithPets(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    pets: List[PetProfile] = []  # Use PetProfile if necessary

class DeleteResponse(BaseModel):
    message: str
    user_id: int
    name: str
