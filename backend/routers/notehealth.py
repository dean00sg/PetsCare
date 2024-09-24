from datetime import datetime
from typing import List
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.future import select
from sqlmodel import Session
from models.notehealth import Age, HealthRecord as ModelHealthRecord, CreateHealthRecord, HealthRecordResponse, LogHealthRecord, ToAge
from deps import get_current_user, get_current_user_role, get_session

router = APIRouter(tags=["Note Health"])

@router.post("/", response_model=HealthRecordResponse)
def create_health_record(
    health_record: CreateHealthRecord,
    session: Session = Depends(get_session),
    username: str = Depends(get_current_user),
    role: str = Depends(get_current_user_role)
):
    # Create new health record
    new_health_record = ModelHealthRecord(
        pet_type=health_record.pet_type,
        age_years=health_record.age.years,
        age_months=health_record.age.months,
        age_days=health_record.age.days,
        to_age_years=health_record.to_age.years,
        to_age_months=health_record.to_age.months,
        to_age_days=health_record.to_age.days,
        weight_start_months=health_record.weight_start_months,
        weight_end_months=health_record.weight_end_months,
        record_date=datetime.now().replace(microsecond=0),
        description=health_record.description
    )
    
    session.add(new_health_record)
    session.commit()
    session.refresh(new_health_record)

    # Create log entry
    log_entry = LogHealthRecord(
        action_name="insert",
        HR_id=new_health_record.HR_id,
        action_byname=username,
        action_datetime=datetime.now().replace(microsecond=0),
        pet_type=new_health_record.pet_type,
        to_pet_type=None,
        age_years=new_health_record.age_years,
        to_age_years=None,
        age_months=new_health_record.age_months,
        to_age_months=None,
        age_days=new_health_record.age_days,
        to_age_days=None,
        weight_start_months=new_health_record.weight_start_months,
        to_weight_start_months=None,
        weight_end_months=new_health_record.weight_end_months,
        to_weight_end_months=None,
        record_date=new_health_record.record_date,
        to_record_date=None,
        description=new_health_record.description,
        to_description=None
    )
    
    session.add(log_entry)
    session.commit()

    return HealthRecordResponse(
        HR_id=new_health_record.HR_id,
        pet_type=new_health_record.pet_type,
        age=Age(
            years=new_health_record.age_years,
            months=new_health_record.age_months,
            days=new_health_record.age_days
        ),
        to_age=ToAge(
            years=new_health_record.to_age_years,
            months=new_health_record.to_age_months,
            days=new_health_record.to_age_days
        ),
        weight_start_months=new_health_record.weight_start_months,
        weight_end_months=new_health_record.weight_end_months,
        record_date=new_health_record.record_date,
        description=new_health_record.description
    )


@router.get("/{health_id}/health", response_model=HealthRecordResponse)
def get_health_record(
    health_id: int,
    session: Session = Depends(get_session),
    role: str = Depends(get_current_user_role)
):
    stmt = select(ModelHealthRecord).where(ModelHealthRecord.HR_id == health_id)
    result = session.execute(stmt).scalars().first()
    
    if result is None:
        raise HTTPException(status_code=404, detail="Health record not found")

    return HealthRecordResponse(
        HR_id=result.HR_id,
        pet_type=result.pet_type,
        age=Age(
            years=result.age_years,
            months=result.age_months,
            days=result.age_days
        ),
        to_age=ToAge(
            years=result.to_age_years,
            months=result.to_age_months,
            days=result.to_age_days
        ),
        weight_start_months=result.weight_start_months,
        weight_end_months=result.weight_end_months,
        record_date=result.record_date.replace(microsecond=0),
        description=result.description
    )


@router.get("/all", response_model=List[HealthRecordResponse])
def get_all_health_records(
    session: Session = Depends(get_session),
    role: str = Depends(get_current_user_role)
):
    # ดึงข้อมูลทั้งหมดจากตาราง health_records
    stmt = select(ModelHealthRecord)
    result = session.execute(stmt).scalars().all()

    if not result:
        raise HTTPException(status_code=404, detail="No health records found")
    
    # Return ข้อมูลทั้งหมดในรูปแบบของ HealthRecordResponse
    return [
        HealthRecordResponse(
            HR_id=record.HR_id,
            pet_type=record.pet_type,
            age=Age(
                years=record.age_years,
                months=record.age_months,
                days=record.age_days
            ),
            to_age=ToAge(
                years=record.to_age_years,
                months=record.to_age_months,
                days=record.to_age_days
            ),
            weight_start_months=record.weight_start_months,
            weight_end_months=record.weight_end_months,
            record_date=record.record_date,
            description=record.description
        )
        for record in result
    ]


@router.put("/{health_id}/health", response_model=HealthRecordResponse)
def update_health_record(
    health_id: int,
    record_update: CreateHealthRecord,
    session: Session = Depends(get_session),
    username: str = Depends(get_current_user),
    role: str = Depends(get_current_user_role)
):
    stmt = select(ModelHealthRecord).where(ModelHealthRecord.HR_id == health_id)
    result = session.execute(stmt).scalars().first()
    
    if result is None:
        raise HTTPException(status_code=404, detail="Health record not found")

    old_health_record = result
    updated_data = record_update.dict(exclude_unset=True)
    
    # Extract age data if present
    age_data = updated_data.pop("age", None)
    if age_data:
        updated_data["age_years"] = age_data.get("years")
        updated_data["age_months"] = age_data.get("months")
        updated_data["age_days"] = age_data.get("days")

    to_age_data = updated_data.pop("to_age", None)
    if to_age_data:
        updated_data["to_age_years"] = to_age_data.get("years")
        updated_data["to_age_months"] = to_age_data.get("months")
        updated_data["to_age_days"] = to_age_data.get("days")

    updated_data["record_date"] = datetime.now().replace(microsecond=0)

    for key, value in updated_data.items():
        setattr(old_health_record, key, value)

    session.add(old_health_record)
    session.commit()
    session.refresh(old_health_record)

    # Create log entry
    log_entry = LogHealthRecord(
        action_name="update",
        HR_id=old_health_record.HR_id,
        action_byname=username,
        action_datetime=datetime.now().replace(microsecond=0),
        pet_type=old_health_record.pet_type,
        to_pet_type=None,
        age_years=old_health_record.age_years,
        to_age_years=updated_data.get("to_age_years"),
        age_months=old_health_record.age_months,
        to_age_months=updated_data.get("to_age_months"),
        age_days=old_health_record.age_days,
        to_age_days=updated_data.get("to_age_days"),
        weight_start_months=old_health_record.weight_start_months,
        to_weight_start_months=None,
        weight_end_months=old_health_record.weight_end_months,
        to_weight_end_months=None,
        record_date=old_health_record.record_date,
        to_record_date=None,
        description=old_health_record.description,
        to_description=None
    )
    
    session.add(log_entry)
    session.commit()

    return HealthRecordResponse(
        HR_id=old_health_record.HR_id,
        pet_type=old_health_record.pet_type,
        age=Age(
            years=old_health_record.age_years,
            months=old_health_record.age_months,
            days=old_health_record.age_days
        ),
        to_age=ToAge(
            years=old_health_record.to_age_years,
            months=old_health_record.to_age_months,
            days=old_health_record.to_age_days
        ),
        weight_start_months=old_health_record.weight_start_months,
        weight_end_months=old_health_record.weight_end_months,
        record_date=old_health_record.record_date.replace(microsecond=0),
        description=old_health_record.description
    )