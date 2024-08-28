from datetime import datetime
from enum import Enum
from typing import Optional
from pydantic import BaseModel


class PetType(str, Enum):
    cat = "cat"
    dog = "dog"
    rabbit = "rabbit"
    fish = "fish"

class HealthRecord(BaseModel):
    id : int
    pet_type: Optional[PetType] = None
    age: Optional[int] = None
    weight: Optional[float] = None
    notes: Optional[str] = None

class CreateHealthRecord(BaseModel):
    pet_type: Optional[PetType] = None
    date: datetime
    weight: Optional[float] = None
    notes: Optional[str] = None

