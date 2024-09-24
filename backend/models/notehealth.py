from datetime import datetime
from typing import Optional
from pydantic import BaseModel
from sqlmodel import SQLModel, Field
from sqlalchemy import Column, DateTime, Integer, String, Float, JSON
from sqlalchemy.orm import relationship
from deps import Base

# Model Health Record in SQLAlchemy
class HealthRecord(Base):
    __tablename__ = 'health_records'

    HR_id = Column(Integer, primary_key=True, index=True)
    pet_type = Column(String, nullable=True)
    age_years = Column(Integer, nullable=True)
    age_months = Column(Integer, nullable=True)
    age_days = Column(Integer, nullable=True)
    to_age_years = Column(Integer, nullable=True)
    to_age_months = Column(Integer, nullable=True)
    to_age_days = Column(Integer, nullable=True)
    weight_start_months = Column(Float, nullable=True)
    weight_end_months = Column(Float, nullable=True)
    record_date = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0))
    description = Column(JSON, nullable=True)


class LogHealthRecord(Base):
    __tablename__ = "log_healthrecords"

    id = Column(Integer, primary_key=True, index=True)
    action_name = Column(String, nullable=True)
    HR_id = Column(Integer, nullable=True)
    action_byname = Column(String, nullable=True)
    action_datetime = Column(DateTime, nullable=True, default=lambda: datetime.now().replace(microsecond=0))
    pet_type = Column(String, nullable=True)
    to_pet_type = Column(String, nullable=True)
    age_years = Column(Integer, nullable=True)
    to_age_years = Column(Integer, nullable=True)
    age_months = Column(Integer, nullable=True)
    to_age_months = Column(Integer, nullable=True)
    age_days = Column(Integer, nullable=True)
    to_age_days = Column(Integer, nullable=True)
    weight_start_months = Column(Float, nullable=True)
    to_weight_start_months = Column(Float, nullable=True)
    weight_end_months = Column(Float, nullable=True)
    to_weight_end_months = Column(Float, nullable=True)
    record_date = Column(DateTime, nullable=True)
    to_record_date = Column(DateTime, nullable=True)
    description = Column(String, nullable=True)
    to_description = Column(String, nullable=True)


# Pydantic models for input validation and response formatting
class Age(BaseModel):
    years: int
    months: int
    days: int

    def __str__(self) -> str:
        return f"{self.years}y {self.months}m {self.days}d"


class ToAge(BaseModel):
    years: int
    months: int
    days: int

    def __str__(self) -> str:
        return f"{self.years}y {self.months}m {self.days}d"


class CreateHealthRecord(BaseModel):
    pet_type: str
    age: Age
    to_age: ToAge
    weight_start_months: float
    weight_end_months: float
    description: Optional[str]

    class Config:
        orm_mode = True


class HealthRecordResponse(BaseModel):
    HR_id: int
    pet_type: str
    age: Age
    to_age: ToAge
    weight_start_months: float
    weight_end_months: float
    record_date: datetime
    description: Optional[str]

    class Config:
        orm_mode = True