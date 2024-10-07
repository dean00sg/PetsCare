from typing import List
from fastapi import APIRouter, HTTPException, Depends, status
from sqlalchemy.orm import Session
from datetime import datetime
from models.user import UserProfile
from deps import get_session, get_current_user
from models.notification import Notification, CreateNotification, LogNotification, NotificationResponse, NotificationUpdate

router = APIRouter(tags=["Notification"])


@router.post("/", response_model=CreateNotification)
def create_notification(
    notification: CreateNotification,
    session: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
  
    creator = session.query(UserProfile).filter(UserProfile.email == username).first()
    if not creator:
        raise HTTPException(status_code=404, detail="Creator not found")
    
    to_user_profile = session.query(UserProfile).filter(UserProfile.email == notification.to_user).first()
    if not to_user_profile:
        raise HTTPException(status_code=404, detail="Recipient (to_user) not found")
   
    db_notification = Notification(
        **notification.dict(),
        record_datetime=datetime.now().replace(microsecond=0),
        create_by=username,
        create_name=f"{creator.first_name} {creator.last_name}", 
        user_name=f"{to_user_profile.first_name} {to_user_profile.last_name}" 
    )
    session.add(db_notification)
    session.commit()
    session.refresh(db_notification)

    # Log the creation action
    log_entry = LogNotification(
        noti_id=db_notification.noti_id,
        action_name="insert",
        login_datetime=datetime.now().replace(microsecond=0),
        header=db_notification.header,
        to_user=db_notification.to_user,
        user_name=f"{to_user_profile.first_name} {to_user_profile.last_name}",  # First and last name of the recipient (to_user)
        record_datetime=db_notification.record_datetime,
        start_noti=db_notification.start_noti,
        end_noti=db_notification.end_noti,
        file=db_notification.file,
        detail=db_notification.detail,
        create_by=username,
        create_name=f"{creator.first_name} {creator.last_name}"
    )
    session.add(log_entry)
    session.commit()

    return db_notification


@router.get("/", response_model=List[NotificationResponse])
def get_all_notifications(
    session: Session = Depends(get_session),
    username: str = Depends(get_current_user) 
):
   
    db_notifications = session.query(Notification).filter(Notification.to_user == username).all()

    if not db_notifications:
        raise HTTPException(status_code=404, detail="No Notifications found for the current user")

    return db_notifications

@router.put("/", response_model=NotificationResponse)
def update_notification(
    notification_update: NotificationUpdate,
    session: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    # Retrieve notification ID from the request body
    notification_id = notification_update.noti_id

    # Query the database for the notification
    db_notification = session.query(Notification).filter(Notification.noti_id == notification_id).first()

    if db_notification is None:
        raise HTTPException(status_code=404, detail="Notification not found")

    # Update only the status_show field
    db_notification.status_show = notification_update.status_show

    session.commit()
    session.refresh(db_notification)

    # Log the update action
    log_entry = LogNotification(
        noti_id=db_notification.noti_id,
        action_name="update",
        login_datetime=datetime.now().replace(microsecond=0),
        header=db_notification.header,
        to_user=db_notification.to_user,
        record_datetime=db_notification.record_datetime,
        start_noti=db_notification.start_noti,
        end_noti=db_notification.end_noti,
        file=db_notification.file,
        detail=db_notification.detail,
        create_by=username
    )
    session.add(log_entry)
    session.commit()

    return db_notification


@router.delete("/{notification_id}", status_code=status.HTTP_200_OK)
def delete_notification(
    notification_id: int,
    session: Session = Depends(get_session),
    username: str = Depends(get_current_user)
):
    db_notification = session.query(Notification).filter(Notification.noti_id == notification_id).first()

    if db_notification is None:
        raise HTTPException(status_code=404, detail="Notification not found")

  
    log_entry = LogNotification(
        noti_id=db_notification.noti_id,
        action_name="delete",
        login_datetime=datetime.now().replace(microsecond=0),
        header=db_notification.header,
        to_user=db_notification.to_user,
        record_datetime=db_notification.record_datetime,
        start_noti=db_notification.start_noti,
        end_noti=db_notification.end_noti,
        file=db_notification.file,
        detail=db_notification.detail,
        create_by=username
    )
    session.add(log_entry)
    session.commit()

    session.delete(db_notification)
    session.commit()

    return {"status": "success", "detail": "Notification deleted successfully"}
