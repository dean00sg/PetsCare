from pydantic import BaseModel
from typing import List
from datetime import datetime
from .pet import PetType

class CareSuggestion(BaseModel):
    pet_type: PetType
    age_in_months: int
    suggestion: str
#test