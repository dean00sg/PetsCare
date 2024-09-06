from datetime import date, datetime
from typing import Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from deps import Base
from .user import UpdateUser

class Pet(Base):
    __tablename__ = 'pets'

    pets_id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    type_pets = Column(String, nullable=False)
    sex = Column(String, nullable=False)
    breed = Column(String, nullable=False)
    birth_date = Column(DateTime, nullable=False)
    weight = Column(Float, nullable=False)

    # Foreign key to link the pet to the user
    user_id = Column(Integer, ForeignKey('Userprofiles.user_id'), nullable=False)

    # Relationship to UserProfile
    owner = relationship("UserProfile", back_populates="pets")
# class HealthRecord(Base):
#     __tablename__ = 'health_records'

#     id = Column(Integer, primary_key=True, index=True)
#     pet_id = Column(Integer, ForeignKey('pets.pets_id'))
#     record_date = Column(DateTime, nullable=False)
#     description = Column(String, nullable=False)
#     pet = relationship("Pet", back_populates="health_records")



class PetProfile(BaseModel):
    pets_id: int
    name: str
    type_pets: str
    sex: str
    breed: str
    birth_date: datetime
    weight: float
    user_id:int

class PetBase(BaseModel):
    name: str
    type_pets: str

class PetCreate(PetBase):
    sex: str
    breed: str
    birth_date: datetime
    weight: float
    user_id:int
  

class PetResponse(BaseModel):
    pets_id: int
    name: str
    type_pets: str
    sex: str
    breed: str
    birth_date: date
    weight: float
    user_id: int
    owner_name: str 
  

class PetUpdate(BaseModel):
    name: Optional[str] = None
    type_pets: Optional[str] = None
    sex: Optional[str] = None
    breed: Optional[str] = None
    birth_date: Optional[datetime] = None
    weight: Optional[float] = None

