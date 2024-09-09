from datetime import datetime
from typing import Optional
from pydantic import BaseModel
from sqlalchemy import Column, DateTime, Integer, String, JSON, Float
from sqlalchemy.orm import Session
from fastapi import APIRouter, HTTPException, Depends, Query
from sqlalchemy.future import select
from models.notehealth import Age, HealthRecord as ModelHealthRecord, CreateHealthRecord, HealthRecordResponse
from models.user import UserProfile
from security import AuthHandler
from deps import get_session

router = APIRouter(tags=["Note Health"])

auth_handler = AuthHandler()

def verify_admin(firstname: str, password: str, session: Session) -> None:
    """Function to verify if the user is an admin with valid credentials."""
    stmt = select(UserProfile).where(UserProfile.first_name == firstname)
    result = session.execute(stmt).scalars().first()
    if not result:
        raise HTTPException(status_code=404, detail="Admin user not found")

    admin_user = result
    if not auth_handler.verify_password(password, admin_user.password):
        raise HTTPException(
            status_code=401,
            detail="Invalid password. Access forbidden: Admins only"
        )

    if admin_user.role != "admin":
        raise HTTPException(status_code=403, detail="Access forbidden: Admins only")

@router.post("/", response_model=HealthRecordResponse)
def create_health_record(
    health_record: CreateHealthRecord,
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(firstname, password, session)

    new_health_record = ModelHealthRecord(
        pet_type=health_record.pet_type,
        age_years=health_record.age.years,
        age_months=health_record.age.months,
        age_days=health_record.age.days,
        weight_start_months=health_record.weight_start_months,
        weight_end_months=health_record.weight_end_months,
        record_date=datetime.now().replace(microsecond=0),  # Set current local time without milliseconds
        description=health_record.description
    )
    session.add(new_health_record)
    session.commit()
    session.refresh(new_health_record)

    response = HealthRecordResponse(
        HR_id=new_health_record.HR_id,
        pet_type=new_health_record.pet_type,
        age=Age(
            years=new_health_record.age_years,
            months=new_health_record.age_months,
            days=new_health_record.age_days
        ),
        weight_start_months=new_health_record.weight_start_months,
        weight_end_months=new_health_record.weight_end_months,
        record_date=new_health_record.record_date,
        description=new_health_record.description
    )
    return response



@router.get("/{health_id}/health", response_model=HealthRecordResponse)
def get_health_record(
    health_id: int,
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(firstname, password, session)

    stmt = select(ModelHealthRecord).where(ModelHealthRecord.HR_id == health_id)
    result = session.execute(stmt).scalars().first()
    if result is None:
        raise HTTPException(status_code=404, detail="Health record not found")

    response = HealthRecordResponse(
        HR_id=result.HR_id,
        pet_type=result.pet_type,
        age=Age(
            years=result.age_years,
            months=result.age_months,
            days=result.age_days
        ),
        weight_start_months=result.weight_start_months,
        weight_end_months=result.weight_end_months,
        record_date=result.record_date.replace(microsecond=0),  # Remove milliseconds for response
        description=result.description
    )
    return response


@router.put("/{health_id}/health", response_model=HealthRecordResponse)
def update_health_record(
    health_id: int,
    record_update: CreateHealthRecord,
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(firstname, password, session)

    stmt = select(ModelHealthRecord).where(ModelHealthRecord.HR_id == health_id)
    result = session.execute(stmt).scalars().first()
    if result is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    health_record = result
    updated_data = record_update.dict(exclude_unset=True)
    
    # Handle the "age" field separately, as it needs to be decomposed
    if "age" in updated_data:
        age_data = updated_data.pop("age")
        updated_data["age_years"] = age_data["years"]
        updated_data["age_months"] = age_data["months"]
        updated_data["age_days"] = age_data["days"]
    
    # Set record_date to the current time when updating
    updated_data["record_date"] = datetime.now().replace(microsecond=0)

    for key, value in updated_data.items():
        setattr(health_record, key, value)

    session.add(health_record)
    session.commit()
    session.refresh(health_record)
    
    # Map to response model
    response = HealthRecordResponse(
        HR_id=health_record.HR_id,
        pet_type=health_record.pet_type,
        age=Age(
            years=health_record.age_years,
            months=health_record.age_months,
            days=health_record.age_days
        ),
        weight_start_months=health_record.weight_start_months,
        weight_end_months=health_record.weight_end_months,
        record_date=health_record.record_date,  # This now includes the updated time
        description=health_record.description
    )
    return response


@router.delete("/{health_id}/health", response_model=dict)
def delete_health_record(
    health_id: int,
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(firstname, password, session)

    stmt = select(ModelHealthRecord).where(ModelHealthRecord.HR_id == health_id)
    result = session.execute(stmt).scalars().first()
    if result is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    session.delete(result)
    session.commit()
    
    return {"message": "Health record deleted successfully"}