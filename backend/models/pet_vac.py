from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field
from sqlalchemy import JSON, Column, Float, ForeignKey
from sqlalchemy import Column, DateTime, Integer, String
from sqlalchemy.orm import relationship
from models.pet import PetProfile
from deps import Base


class PetVacProfile(Base):
    __tablename__ = 'PetVacProfile'

    vac_id = Column(Integer, primary_key=True, index=True)
    vac_name = Column(String, nullable=False)
    startdatevac = Column(DateTime, nullable=False)
    drugname = Column(JSON, nullable=True)
    pet_name = Column(String, nullable=False)  
    owner_name = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('Userprofiles.user_id'), nullable=False)
    
    # Relationship to UserProfile
    # owner = relationship("UserProfile", back_populates="pets")
    # pet_name = relationship("Pet", back_populates="name")

class LogPetVacProfile(Base):
    __tablename__ = 'log_PetVacProfile'

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    action_name = Column(String, nullable=False)
    action_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0))
    vac_id =  Column(Integer, nullable=False)
    vac_name = Column(String, nullable=False)
    to_vac_name = Column(String, nullable=True)
    startdatevac = Column(DateTime, nullable=False)
    to_startdatevac = Column(DateTime, nullable=True)
    drugname = Column(JSON, nullable=True)
    to_drugname = Column(JSON, nullable=True)
    pet_name = Column(String, nullable=False)
    user_id = Column(Integer, nullable=False)
    owner_name = Column(String, nullable=False)
   
    # Relationship to UserProfile
    # owner = relationship("UserProfile", back_populates="pets")



class PetVacProfileResponse(BaseModel):
    status:str
    vac_id: int
    vac_name: str
    startdatevac: datetime
    drugname: Optional[List[str]]
    pet_name: str
    owner_name: str

    class Config:
        orm_mode = True

class CreatePetVacProfile(BaseModel):
    vac_name: str
    startdatevac: datetime
    drugname: Optional[List[str]]
    

    class Config:
        orm_mode = True