from datetime import datetime
from enum import Enum
from typing import Optional
from pydantic import BaseModel
from sqlmodel import SQLModel, Field

class PetType(str, Enum):
    cat = "cat"
    dog = "dog"
    rabbit = "rabbit"
    fish = "fish"

class PetHealthRecord(SQLModel, table=True):
    #__tablename__ = 'health_records'
    id: Optional[int] = Field(default=None, primary_key=True)
    pet_type: Optional[PetType] = None
    age: Optional[str] = None  #format "Xy Xm Xd"
    weight: Optional[float] = None
    notes: Optional[str] = None
    date: datetime = Field(default=datetime.now())

class CreateHealthRecord(SQLModel):
    pet_type: Optional[PetType] = None
    date: datetime
    weight: Optional[float] = None
    notes: Optional[str] = None