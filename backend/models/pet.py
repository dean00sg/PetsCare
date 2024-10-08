from datetime import date, datetime
from typing import Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String, Float, Date, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from deps import Base


class Pet(Base):
    __tablename__ = 'Pets'

    pets_id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    type_pets = Column(String, nullable=False)
    sex = Column(String, nullable=False)
    breed = Column(String, nullable=False)
    birth_date = Column(Date, nullable=False)  
    weight = Column(Float, nullable=False)

    user_id = Column(Integer, ForeignKey('Userprofiles.user_id'), nullable=False)
    owner_name = Column(String, nullable=False)

  
    owner = relationship("UserProfile", back_populates="pets")


class PetLog(Base):
    __tablename__ = 'log_Petsprofile'

    id = Column(Integer, primary_key=True, index=True)
    action_name = Column(String, nullable=False)
    action_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0))
    pets_id = Column(Integer, nullable=False)

    name = Column(String, nullable=False)
    to_name = Column(String, nullable=True)
    birth_date = Column(Date, nullable=False)
    to_birth_date = Column(Date, nullable=True)
    weight = Column(Float, nullable=False)
    to_weight = Column(Float, nullable=True)
    user_id = Column(Integer, ForeignKey('Userprofiles.user_id'), nullable=False)
    owner_name = Column(String, nullable=False)



class PetProfile(BaseModel):
    pets_id: int
    name: str
    type_pets: str
    sex: str
    breed: str
    birth_date: date
    weight: float
    user_id: int
    owner_name: str
    class Config:
        orm_mode = True 


class PetBase(BaseModel):
    name: str
    type_pets: str
    class Config:
        orm_mode = True 


class PetCreate(PetBase):
    sex: str
    breed: str
    birth_date: date
    weight: float
    class Config:
        orm_mode = True 


class PetResponse(BaseModel):
    status: str
    pets_id: int
    name: str
    type_pets: str
    sex: str
    breed: str
    birth_date: date
    weight: float
    user_id: int
    owner_name: str
    class Config:
        orm_mode = True 

class PetUpdate(BaseModel):
    name: Optional[str] = None
    birth_date: Optional[date] = None
    weight: Optional[float] = None
    class Config:
        orm_mode = True 
