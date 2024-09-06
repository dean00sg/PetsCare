from pydantic import BaseModel, EmailStr
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from deps import Base
from typing import List, Optional

class UserProfile(Base):
    __tablename__ = 'Userprofiles'

    user_id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    contact_number = Column(String, nullable=False)
    password = Column(String, nullable=False)
    role = Column(String, default="userpets")  # Default to "userpets" if not provided
    
    # Relationship to Pet model
    pets = relationship("Pet", back_populates="owner")


# Pydantic schemas for UserProfile
class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    password: str
    role: Optional[str] = "userpets"  # Default to "userpets" if not provided

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_number: Optional[str] = None
    password: Optional[str] = None
    role: Optional[str] = None  # Allow role updates if specified

class UserWithPets(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    # pets: List['PetProfile'] = []  # Forward reference for PetProfile

    class Config:
        orm_mode = True  # Allows working with SQLAlchemy models directly

class DeleteResponse(BaseModel):
    status: str
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
    email: EmailStr
    contact_number: Optional[str] = None
    new_password: Optional[str] = None

class UpdateUserResponse(BaseModel):
    status: str
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    role: str

    class Config:
        orm_mode = True  # Allows working with SQLAlchemy models directly