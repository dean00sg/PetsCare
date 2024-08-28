from pydantic import BaseModel
from datetime import datetime
from enum import Enum
from typing import List, Optional


class PetVacProfile(BaseModel):
    pets_id: int
    user_id : int
    vacname: str
    stardatevac : datetime

class CreatePetVacProfile(BaseModel):
    pets_id: int
    user_id : int
    vacname: str
    stardatevac : datetime


class Petdrugallergy(BaseModel):
    pets_id: int
    user_id : int
    drugname: List[str]

class CreatePetdrugallergy(BaseModel):
    pets_id: int
    user_id : int
    drugname: List[str]