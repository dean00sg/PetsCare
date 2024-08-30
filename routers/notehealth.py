from datetime import datetime
from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session, select
from models.notehealth import PetHealthRecord, CreateHealthRecord
from typing import List
from dateutil.relativedelta import relativedelta
from deps import get_session

router = APIRouter(tags=["Note Health"])


def calculate_age(date_of_birth: datetime, current_date: datetime) -> str:
    delta = relativedelta(current_date, date_of_birth)
    years = delta.years
    months = delta.months
    days = delta.days
    
    return f"{years}y {months}m {days}d"

@router.post("/notehealth/health", response_model=PetHealthRecord)
def create_health_record(health_record: CreateHealthRecord, session: Session = Depends(get_session)):
    
    #คำนวณอายุของสัตว์เลี้ยงในเดือนจากวันที่ใน HealthRecord
    current_date = datetime.now()
    health_record_date = health_record.date
    if health_record_date.tzinfo is not None:
        health_record_date = health_record_date.astimezone(tz=None).replace(tzinfo=None)

    age = calculate_age(health_record_date, current_date)
    
    #สร้าง HealthRecord ใหม่
    new_health_record = PetHealthRecord(age=age, **health_record.dict(exclude_unset=True))
    
    #เพิ่ม HealthRecord ลงในฐานข้อมูลจริง
    session.add(new_health_record)
    session.commit()
    session.refresh(new_health_record)
    
    return new_health_record

@router.get("/notehealth/{id_health}/health", response_model=PetHealthRecord)
def get_health_record(health_id: int, session: Session = Depends(get_session)):
    health_record = session.get(PetHealthRecord, health_id)
    if health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    return health_record

@router.put("/notehealth/{id_health}/health", response_model=PetHealthRecord)
def update_health_record(health_id: int, record_update: CreateHealthRecord, session: Session = Depends(get_session)):
    health_record = session.get(PetHealthRecord, health_id)
    if health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    updated_data = record_update.dict(exclude_unset=True)

    for key, value in updated_data.items():
        setattr(health_record, key, value)
    
    # คำนวณอายุใหม่ถ้าฟิลด์วันที่ถูกอัปเดต
    if "date" in updated_data:
        current_date = datetime.now()
        health_record_date = record_update.date
        if health_record_date.tzinfo is not None:
            health_record_date = health_record_date.astimezone(tz=None).replace(tzinfo=None)
        
        age = calculate_age(health_record_date, current_date)
        health_record.age = age

    session.add(health_record)
    session.commit()
    session.refresh(health_record)
    
    return health_record

@router.delete("/notehealth/{id_health}/health", response_model=dict)
def delete_health_record(health_id: int, session: Session = Depends(get_session)):
    health_record = session.get(PetHealthRecord, health_id)
    if health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    session.delete(health_record)
    session.commit()
    return {"message": "deleted successfully"}
