from datetime import datetime
from fastapi import APIRouter, HTTPException, Depends, Query
from sqlmodel import Session, select
from models.notehealth import PetHealthRecord, CreateHealthRecord
from models.user import UserProfile
from deps import get_session
from security import AuthHandler
from typing import List
from dateutil.relativedelta import relativedelta

router = APIRouter(tags=["Note Health"])

auth_handler = AuthHandler()

def calculate_age(date_of_birth: datetime, current_date: datetime) -> str:
    delta = relativedelta(current_date, date_of_birth)
    years = delta.years
    months = delta.months
    days = delta.days
    
    return f"{years}y {months}m {days}d"

def verify_admin(firstname: str, password: str, session: Session) -> None:
    """Function to verify if the user is an admin with valid credentials."""
    admin_user = session.exec(select(UserProfile).where(UserProfile.first_name == firstname)).first()
    if not admin_user:
        raise HTTPException(status_code=404, detail="Admin user not found")
    
    if not auth_handler.verify_password(password, admin_user.password):
        raise HTTPException(
            status_code=401,
            detail="Invalid password. Access forbidden: Admins only"
        )

    if admin_user.role != "admin":
        raise HTTPException(status_code=403, detail="Access forbidden: Admins only")

@router.post("/notehealth/health", response_model=PetHealthRecord)
def create_health_record(
    health_record: CreateHealthRecord,
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(firstname, password, session)

    current_date = datetime.now()
    health_record_date = health_record.date
    if health_record_date.tzinfo is not None:
        health_record_date = health_record_date.astimezone(tz=None).replace(tzinfo=None)

    age = calculate_age(health_record_date, current_date)
    
    new_health_record = PetHealthRecord(age=age, **health_record.dict(exclude_unset=True))
    session.add(new_health_record)
    session.commit()
    session.refresh(new_health_record)
    
    return new_health_record

@router.get("/notehealth/{health_id}/health", response_model=PetHealthRecord)
def get_health_record(
    health_id: int,
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(firstname, password, session)

    health_record = session.get(PetHealthRecord, health_id)
    if health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    return health_record

@router.put("/notehealth/{health_id}/health", response_model=PetHealthRecord)
def update_health_record(
    health_id: int,
    record_update: CreateHealthRecord,
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(firstname, password, session)

    health_record = session.get(PetHealthRecord, health_id)
    if health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    updated_data = record_update.dict(exclude_unset=True)
    for key, value in updated_data.items():
        setattr(health_record, key, value)
    
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

@router.delete("/notehealth/{health_id}/health", response_model=dict)
def delete_health_record(
    health_id: int,
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    verify_admin(firstname, password, session)

    health_record = session.get(PetHealthRecord, health_id)
    if health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    session.delete(health_record)
    session.commit()
    return {"message": "deleted successfully"}
