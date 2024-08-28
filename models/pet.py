from pydantic import BaseModel
from datetime import datetime
from enum import Enum
from typing import List, Optional

class PetType(str, Enum):
    cat = "cat"
    dog = "dog"
    rabbit = "rabbit"
    fish = "fish"

class HealthRecord(BaseModel):
    date: datetime
    weight: Optional[float] = None
    notes: Optional[str] = None

class PetProfile(BaseModel):
    id: int
    name: str
    pet_type: PetType
    sex : str
    breed: str
    birth_date: datetime
    weight: float
    health_records: List[HealthRecord] = []
    user_id: int  # อ้างถึงผู้ใช้เจ้าของสัตว์เลี้ยง
    
class CreatePetProfile(BaseModel):
    name: str
    pet_type: PetType
    sex : str
    breed: str
    birth_date: datetime
    weight: float
    health_records: List[HealthRecord] = []
    user_id: int  # อ้างถึงผู้ใช้เจ้าของสัตว์เลี้ยง

class CareSuggestion(BaseModel):
    age_in_months: int
    suggestion: str