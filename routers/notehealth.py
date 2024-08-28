from datetime import datetime
from fastapi import APIRouter, HTTPException
from models.notehealth import HealthRecord, CreateHealthRecord
from typing import List
from dateutil.relativedelta import relativedelta

router = APIRouter(prefix="/notehealth", tags=["notehealth"])

notehealth_db: List[HealthRecord] = []

def calculate_age(date_of_birth: datetime, current_date: datetime) -> str:
    delta = relativedelta(current_date, date_of_birth)
    years = delta.years
    months = delta.months
    days = delta.days
    
    return f"{years}y {months}m {days}d"

@router.post("/notehealth/health", response_model=HealthRecord)
def create_health_record(health_record: CreateHealthRecord):
    new_id = len(notehealth_db) + 1  # Generate a new ID based on the current list size
    add_health_record = HealthRecord(id=new_id, **health_record.dict())  # Create a new HealthRecord instance

    # คำนวณอายุของสัตว์เลี้ยงในเดือนจากวันที่ใน HealthRecord
    current_date = datetime.now()
    health_record_date = health_record.date
    if health_record_date.tzinfo is not None:
        health_record_date = health_record_date.astimezone(tz=None).replace(tzinfo=None)

    age = calculate_age(health_record_date, current_date)
    add_health_record.age = age
    
    # เพิ่ม HealthRecord ลงในฐานข้อมูล
    notehealth_db.append(add_health_record)
    
    return add_health_record

@router.get("/notehealth/{id_health}/health", response_model=HealthRecord)
def get_health_record(id_health: int):
    health_record = next((p for p in notehealth_db if p.id == id_health), None)
    if health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    return health_record

@router.put("/notehealth/{id_health}/health", response_model=HealthRecord)
def update_health_record(id_health: int, record_update: CreateHealthRecord):
    new_health_record = next((p for p in notehealth_db if p.id == id_health), None)
    if new_health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    updated_data = record_update.dict(exclude_unset=True)

    for key, value in updated_data.items():
        if key != "date":
            setattr(new_health_record, key, value)
    
    # คำนวณอายุใหม่ถ้าฟิลด์วันที่ถูกอัปเดต
    if "date" in updated_data:
        current_date = datetime.now()
        health_record_date = record_update.date
        if health_record_date.tzinfo is not None:
            health_record_date = health_record_date.astimezone(tz=None).replace(tzinfo=None)
        
        age = calculate_age(health_record_date, current_date)
        new_health_record.age = age

    return new_health_record

@router.delete("/{id_health}/health", response_model=HealthRecord)
def delete_health_record(id_health: int):
    global notehealth_db
    delete_health_record = next((p for p in notehealth_db if p.id == id_health), None)
    if delete_health_record is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    notehealth_db = [record for record in notehealth_db if record.id != id_health]
    return delete_health_record

