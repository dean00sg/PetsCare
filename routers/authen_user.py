from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlmodel import Session, select, update, delete
from security import AuthHandler
from models.user import UserProfile, UserCreate, UserUpdate ,DeleteResponse
from deps import get_session

router = APIRouter( tags=["Authentication"])

auth_handler = AuthHandler()

class Login(BaseModel):
    email: str
    password: str

@router.post("/register", response_model=UserProfile)
def register_user(user: UserCreate, session: Session = Depends(get_session)):
    hashed_password = auth_handler.get_password_hash(user.password)
    db_user = UserProfile(
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        password=hashed_password
    )
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    return db_user

@router.post("/login")
def login(login: Login, session: Session = Depends(get_session)):
    try:
        user = session.exec(select(UserProfile).where(UserProfile.email == login.email)).first()
        if not user or not auth_handler.verify_password(login.password, user.password):
            raise HTTPException(status_code=401, detail="Invalid credentials")

        access_token = auth_handler.create_access_token(data={"sub": login.email, "role": "userpets"})
        
        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user_id": user.user_id,
            "name": f"{user.first_name} {user.last_name}"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/users/{user_id}", response_model=UserProfile)
def get_user(user_id: int, session: Session = Depends(get_session)):
    user = session.exec(select(UserProfile).where(UserProfile.user_id == user_id)).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.put("/users/{user_id}", response_model=UserProfile)
def update_user(user_id: int, user_update: UserUpdate, password: str, session: Session = Depends(get_session)):
    db_user = session.exec(select(UserProfile).where(UserProfile.user_id == user_id)).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if not auth_handler.verify_password(password, db_user.password):
        raise HTTPException(status_code=403, detail="Invalid password")

    db_user.first_name = user_update.first_name or db_user.first_name
    db_user.last_name = user_update.last_name or db_user.last_name
    db_user.email = user_update.email or db_user.email
    db_user.contact_number = user_update.contact_number or db_user.contact_number
    
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    return db_user

@router.delete("/users/{user_id}", response_model=DeleteResponse)
def delete_user(user_id: int, password: str, session: Session = Depends(get_session)):
    db_user = session.exec(select(UserProfile).where(UserProfile.user_id == user_id)).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if not auth_handler.verify_password(password, db_user.password):
        raise HTTPException(status_code=403, detail="Invalid password")

    session.exec(delete(UserProfile).where(UserProfile.user_id == user_id))
    session.commit()
    
    return {
        "message": "Delete Account Success",
        "user_id": db_user.user_id,
        "name": f"{db_user.first_name} {db_user.last_name}"
    }

