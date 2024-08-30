from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel
from sqlalchemy import JSON, Column
from sqlmodel import SQLModel, Field, Relationship

class PetVacProfile(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    pets_id: int
    user_id: int
    vacname: str
    stardatevac: datetime #วันที่เริ่มฉีดวัคซีน
    drugname: Optional[List[str]] = Field(sa_column=Column(JSON)) 

class CreatePetVacProfile(BaseModel):
    vacname: str
    stardatevac: datetime
    drugname: Optional[List[str]]