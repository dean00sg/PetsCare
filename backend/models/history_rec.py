from datetime import date, datetime
from typing import Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String, Float, Date, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from deps import Base


class HistoryRec(Base):
    __tablename__ = 'HistoryRec'

    hr_id = Column(Integer, primary_key=True, index=True)
    header = Column(String,nullable=True)
    record_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0))
    Symptoms = Column(String,nullable=True)
    Diagnose =Column(String, nullable=False)
    Remark = Column(String,nullable=True)
    pet_name = Column(String, nullable=False)  
    owner_name = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('Userprofiles.user_id'), nullable=False)

    note_by = Column(String,nullable=True)
    note_name = Column(String,nullable=True)


class CreateHistoryRec(BaseModel):
    header: str
    Symptoms : str
    Diagnose : str
    Remark : str
    pet_name: str
    owner_name: str

class HistoryRecResponse(BaseModel):
    hr_id: int
    header: str
    record_datetime :datetime
    Symptoms : str
    Diagnose : str
    Remark : str
    pet_name: str
    owner_name: str
    note_by:str