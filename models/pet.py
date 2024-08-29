from datetime import date, datetime
from pydantic import BaseModel
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List

class PetBase(SQLModel):
    name: str
    type_pets: str

class PetProfile(SQLModel):
    id: int
    name: str
    type_pets: str
    sex: str
    breed: str
    birth_date: datetime
    weight: float

class Pet(SQLModel, table=True):
    id: int = Field(default=None, primary_key=True)
    name: str
    type_pets: str
    sex: str
    breed: str
    birth_date: datetime
    weight: float
    user_id: int = Field(default=None, foreign_key="userprofile.user_id")
    health_records: List["HealthRecord"] = Relationship(back_populates="pet")
    owner: Optional["UserProfile"] = Relationship(back_populates="pets")

class PetCreate(PetBase):
    name: str
    type_pets: str
    sex: str
    breed: str
    birth_date: datetime
    weight: float
    user_id: int

class PetUpdate(BaseModel):
    name: Optional[str] = None
    type_pets: Optional[str] = None
    sex: Optional[str] = None
    breed: Optional[str] = None
    birth_date: Optional[date] = None
    weight: Optional[float] = None

class HealthRecord(SQLModel, table=True):
    id: int = Field(default=None, primary_key=True)
    pet_id: int = Field(default=None, foreign_key="pet.id")
    record_date: datetime
    description: str
    pet: Optional[Pet] = Relationship(back_populates="health_records")
