from datetime import date, datetime
from typing import Optional
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String, Float, Date, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from deps import Base


class Notification(Base):
    __tablename__ = 'Notification'

    noti_id = Column(Integer, primary_key=True, index=True)
    header = Column(String,nullable=True)
    to_user = Column(String,nullable=True)
    user_name = Column(String,nullable=True)
    record_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0))
    start_noti =Column(DateTime, nullable=False)
    end_noti =Column(DateTime, nullable=False)
    file = Column(String,nullable=True)
    detail = Column(String,nullable=True)  
    status_show=Column(String, default="show")  
    create_by = Column(String,nullable=True)
    create_name = Column(String,nullable=True)

class LogNotification(Base):
    __tablename__ = 'log_notification'

    id = Column(Integer, primary_key=True, index=True)
    noti_id = Column(Integer,nullable=True)
    action_name = Column(String, nullable=False)
    login_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0)) 
    
    header = Column(String,nullable=True)
    to_user = Column(String,nullable=True)
    user_name = Column(String,nullable=True)
    record_datetime = Column(DateTime, default=lambda: datetime.now().replace(microsecond=0))
    start_noti =Column(DateTime, nullable=False)
    end_noti =Column(DateTime, nullable=False)
    file = Column(String,nullable=True)
    detail = Column(String,nullable=True)  
    create_by = Column(String,nullable=True)
    create_name = Column(String,nullable=True)

class CreateNotification(BaseModel):
    header: str
    to_user: str
    start_noti: datetime
    end_noti: datetime
    file: Optional[str] = None
    detail: Optional[str] = None


class NotificationUpdate(BaseModel):
    noti_id: int
    status_show: str

   
class NotificationResponse(BaseModel):
    noti_id: int
    header: Optional[str] = None
    to_user: Optional[str] = None
    user_name: Optional[str] = None 
    record_datetime: datetime
    start_noti: datetime
    end_noti: datetime
    file: Optional[str] = None
    detail: Optional[str] = None
    create_by: Optional[str] = None
    create_name: Optional[str] = None
    status_show: str