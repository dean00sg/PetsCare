from datetime import datetime
from enum import Enum
from typing import Optional
from pydantic import BaseModel
from sqlmodel import SQLModel, Field
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, JSON, Float
from sqlalchemy.orm import relationship
from deps import Base

class HealthRecord(Base):
    __tablename__ = 'health_records'

    HR_id = Column(Integer, primary_key=True, index=True)
    pet_type = Column(String, nullable=False)
    age_years = Column(Integer, nullable=False)
    age_months = Column(Integer, nullable=False)
    age_days = Column(Integer, nullable=False)
    weight_start_months = Column(Float, nullable=False)
    weight_end_months = Column(Float, nullable=False)

    record_date = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0)) 
    description = Column(JSON, nullable=True)

class Age(BaseModel):
    years: int
    months: int
    days: int

    def str(self) -> str:
        return f"{self.years}y {self.months}m {self.days}d"



class CreateHealthRecord(BaseModel):
    pet_type: str
    age: Age
    weight_start_months: float
    weight_end_months: float
    description: Optional[str]

    class Config:
        orm_mode = True

class HealthRecordResponse(BaseModel):
    HR_id: int
    pet_type: str
    age: Age
    weight_start_months: float
    weight_end_months: float
    record_date: datetime
    description: Optional[str] 

    class Config:
        orm_mode = True