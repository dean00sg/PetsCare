from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from models.history_rec import HistoryRec, CreateHistoryRec, HistoryRecResponse
from models.user import UserProfile
from deps import get_current_user, get_current_user_role, get_session

router = APIRouter(tags=["History Records"])

@router.post("/history_rec/", response_model=HistoryRecResponse)
def create_history_record(
    record_data: CreateHistoryRec,
    db: Session = Depends(get_session),
    role: str = Depends(get_current_user_role),
    username: str = Depends(get_current_user)
):
    # Check if owner exists
    owner = db.query(UserProfile).filter(
        (UserProfile.first_name + " " + UserProfile.last_name) == record_data.owner_name
    ).first()

    if not owner:
        raise HTTPException(status_code=404, detail="Owner not found")

    # Fetch the user profile for the note_by
    user_profile = db.query(UserProfile).filter(UserProfile.email == username).first()

    if not user_profile:
        raise HTTPException(status_code=404, detail="User profile not found")

    # Create new history record
    new_record = HistoryRec(
        header=record_data.header,
        record_datetime=datetime.now().replace(microsecond=0),
        Symptoms=record_data.Symptoms,
        Diagnose=record_data.Diagnose,
        Remark=record_data.Remark,  # Optional
        pet_name=record_data.pet_name,
        owner_name=record_data.owner_name,
        user_id=owner.user_id,
        note_by=username,  # Set the current user's username
        note_name=f"{user_profile.first_name} {user_profile.last_name}"  # Full name of the user
    )

    db.add(new_record)
    db.commit()
    db.refresh(new_record)

    return HistoryRecResponse(
        hr_id=new_record.hr_id,
        header=new_record.header,
        record_datetime=new_record.record_datetime,
        Symptoms=new_record.Symptoms,
        Diagnose=new_record.Diagnose,
        Remark=new_record.Remark,
        pet_name=new_record.pet_name,
        owner_name=new_record.owner_name,
        note_by=new_record.note_by,
        note_name=new_record.note_name
    )

@router.get("/history_rec/get_all", response_model=list[HistoryRecResponse])
def get_all_history_records(
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    records = db.query(HistoryRec).all()

    if not records:
        raise HTTPException(status_code=404, detail="No history records found")

    return [
        HistoryRecResponse(
            hr_id=record.hr_id,
            header=record.header,
            record_datetime=record.record_datetime,
            Symptoms=record.Symptoms,
            Diagnose=record.Diagnose,
            Remark=record.Remark,
            pet_name=record.pet_name,
            owner_name=record.owner_name,
            note_by=record.note_by
        )
        for record in records
    ]

@router.get("/history_rec/{pet_name}", response_model=list[HistoryRecResponse])
def get_history_records_by_pet_name(
    pets_name: str,
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    records = db.query(HistoryRec).filter(HistoryRec.pet_name ==pets_name).all()

    if not records:
        raise HTTPException(status_code=404, detail="No history records found for the given pet")

    return [
        HistoryRecResponse(
            hr_id=record.hr_id,
            header=record.header,
            record_datetime=record.record_datetime,
            Symptoms=record.Symptoms,
            Diagnose=record.Diagnose,
            Remark=record.Remark,
            pet_name=record.pet_name,
            owner_name=record.owner_name,
            note_by=record.note_by,
            note_name=record.note_name
        )
        for record in records
    ]



@router.delete("/history_rec/{pet_name}/{header}", response_model=HistoryRecResponse)
def delete_history_record(
    pet_name: str,
    header: str,
    db: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    record = db.query(HistoryRec).filter(
        HistoryRec.pet_name == pet_name,
        HistoryRec.header == header
    ).first()

    if not record:
        raise HTTPException(status_code=404, detail="History record not found")

    db.delete(record)
    db.commit()

    return HistoryRecResponse(
        hr_id=record.hr_id,
        header=record.header,
        record_datetime=record.record_datetime,
        Symptoms=record.Symptoms,
        Diagnose=record.Diagnose,
        Remark=record.Remark,
        pet_name=record.pet_name,
        owner_name=record.owner_name,
        note_by=record.note_by
    )