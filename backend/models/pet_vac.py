from datetime import date, datetime
from typing import Optional, List
from pydantic import BaseModel, Field
from sqlalchemy import JSON, Column, Date, Float, ForeignKey
from sqlalchemy import Column, DateTime, Integer, String
from sqlalchemy.orm import relationship
from models.pet import PetProfile
from deps import Base


class PetVacProfile(Base):
    __tablename__ = 'PetVacProfile'

    vac_id = Column(Integer, primary_key=True, index=True)
    note_by=Column(String, nullable=False)
    dose = Column(Integer, nullable=False)
    vac_name = Column(String, nullable=False)
    startdatevac = Column(Date, nullable=False)
    location = Column(String, nullable=False)
    remark = Column(String, nullable=False)
    pets_id = Column(Integer, ForeignKey('Pets.pets_id'), nullable=False) 
    pet_name = Column(String, nullable=False)  
    owner_name = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('Userprofiles.user_id'), nullable=False)

    


class LogPetVacProfile(Base):
    __tablename__ = 'log_PetVacProfile'

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    action_name = Column(String, nullable=False)
    action_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0))
    action_by=Column(String, nullable=False)
    
    vac_id =  Column(Integer, nullable=False)
    dose = Column(Integer, nullable=False)
    to_dose = Column(Integer, nullable=True)

    vac_name = Column(String, nullable=False)
    to_vac_name = Column(String, nullable=True)

    location = Column(String, nullable=False)
    to_location = Column(String, nullable=True)

    remark = Column(String, nullable=False)
    to_remark = Column(String, nullable=True)

    startdatevac = Column(Date,nullable=False)
    to_startdatevac = Column(Date,nullable=True)

    pet_name = Column(String, nullable=False)
    user_id = Column(Integer, nullable=False)
    owner_name = Column(String, nullable=False)
   

class PetVacProfileResponse(BaseModel):
    status:str
    vac_id: int
    dose: int
    vac_name: str
    startdatevac: date
    location: str
    remark: str
    pets_id: int
    pet_name: str
    owner_name: str
    note_by:str


    class Config:
        orm_mode = True

class CreatePetVacProfile(BaseModel):
    owner_name: str
    pet_name: str
    pets_id: int
    dose: int
    vac_name: str
    startdatevac: date
    location: str
    remark: str


    class Config:
        orm_mode = True

class UpdatePetVacProfile(BaseModel):
    dose: Optional[int] = None
    vac_name: Optional[str] = None
    startdatevac: Optional[date] = None
    location: Optional[str] = None
    remark: Optional[str] = None

    class Config:
        orm_mode = True