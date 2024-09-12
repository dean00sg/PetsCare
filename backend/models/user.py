from datetime import datetime
from pydantic import BaseModel, EmailStr, Field
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from models.pet import PetProfile
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
    role = Column(String, default="userpets")  
    
    # Relationship to Pet model
    pets = relationship("Pet", back_populates="owner")


class UserLogin(Base):
    __tablename__ = 'UserLogin'

    login_id = Column(Integer, primary_key=True, index=True)
    login_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0)) 
    user_id = Column(Integer, ForeignKey('Userprofiles.user_id'), nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    contact_number = Column(String, nullable=False)
    access_token = Column(String, nullable=False)
    role = Column(String, nullable=False)


class LogUserLogin(Base):
    __tablename__ = 'log_UserLogin'

    id = Column(Integer, primary_key=True, index=True)
    action_name = Column(String, nullable=False)
    login_id = Column(Integer, nullable=False)
    login_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0)) 
    user_id = Column(Integer, ForeignKey('Userprofiles.user_id'), nullable=False)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    contact_number = Column(String, nullable=False)
    access_token = Column(String, nullable=False)
    role = Column(String, nullable=False)


class LogUserProfile(Base):
    __tablename__ = 'log_Userprofiles'

    id = Column(Integer, primary_key=True, index=True)
    action_name = Column(String, nullable=False)
    action_datetime = Column(DateTime, default=datetime.now()) 
    user_id = Column(Integer, nullable=False)

    first_name = Column(String, nullable=False)
    to_first_name = Column(String, nullable=True)

    last_name = Column(String, nullable=False)
    to_last_name = Column(String, nullable=True)

    email = Column(String, nullable=False)
    to_email = Column(String, nullable=True)

    contact_number = Column(String, nullable=False)
    to_contact_number = Column(String, nullable=True)

    password = Column(String, nullable=False)
    to_password = Column(String, nullable=True)

    role = Column(String, default="userpets")
   


class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    password: str
    role: str = Field(default="userpets")

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_number: Optional[str] = None
    password: Optional[str] = None
    role: Optional[str] = None  

class UserWithPets(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    pets: List['PetProfile'] = []  

    class Config:
        orm_mode = True  

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
        orm_mode = True 


class GetUserProfile(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    role: str

    class Config:
        orm_mode = True 
        

class UserAuthen(BaseModel):
    user_id: int
    first_name: str
    last_name: str
    email: EmailStr
    contact_number: str
    
    class Config:
        orm_mode = True  