from datetime import datetime
from typing import Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from deps import Base

class Pet(Base):
    __tablename__ = 'pets'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    type_pets = Column(String, nullable=False)
    sex = Column(String, nullable=False)
    breed = Column(String, nullable=False)
    birth_date = Column(DateTime, nullable=False)
    weight = Column(Float, nullable=False)

    # Relationships
    health_records = relationship("HealthRecord", back_populates="pet")

class HealthRecord(Base):
    __tablename__ = 'health_records'

    id = Column(Integer, primary_key=True, index=True)
    pet_id = Column(Integer, ForeignKey('pets.id'))
    record_date = Column(DateTime, nullable=False)
    description = Column(String, nullable=False)
    pet = relationship("Pet", back_populates="health_records")



class PetProfile(BaseModel):
    id: int
    name: str
    type_pets: str
    sex: str
    breed: str
    birth_date: datetime
    weight: float
 

class PetBase(BaseModel):
    name: str
    type_pets: str

class PetCreate(PetBase):
    sex: str
    breed: str
    birth_date: datetime
    weight: float
  

class PetResponse(PetBase):
    id: int
    sex: str
    breed: str
    birth_date: datetime
    weight: float
  

class PetUpdate(BaseModel):
    name: Optional[str] = None
    type_pets: Optional[str] = None
    sex: Optional[str] = None
    breed: Optional[str] = None
    birth_date: Optional[datetime] = None
    weight: Optional[float] = None
