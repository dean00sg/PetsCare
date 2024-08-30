from datetime import datetime
from enum import Enum
from typing import Optional
from sqlmodel import SQLModel, Field

# Define Enum for Pet Types
class PetType(str, Enum):
    cat = "cat"
    dog = "dog"
    rabbit = "rabbit"
    fish = "fish"

# SQLModel Table for Pet Health Records
class PetHealthRecord(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    pet_type: Optional[PetType] = Field(default=None)
    age: Optional[str] = Field(default=None)  # Format "Xy Xm Xd"
    weight: Optional[float] = Field(default=None)
    notes: Optional[str] = Field(default=None)
    date: datetime = Field(default_factory=datetime.now)

# Pydantic Model for Creating Health Records
class CreateHealthRecord(SQLModel):
    pet_type: Optional[PetType] = Field(default=None)
    date: datetime
    weight: Optional[float] = Field(default=None)
    notes: Optional[str] = Field(default=None)
