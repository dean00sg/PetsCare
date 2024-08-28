# routers/authen_user.py
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from security import AuthHandler
from models.user import UserProfile, UserCreate
from typing import List

router = APIRouter(prefix="/auth", tags=["auth"])

auth_handler = AuthHandler()
users_db: List[dict] = []  # List to store user data with hashed password

class Login(BaseModel):
    email: str
    password: str

@router.post("/register", response_model=UserProfile)
def register(user: UserCreate):
    try:
        hashed_password = auth_handler.get_password_hash(user.password)
        new_id = len(users_db) + 1
        new_user = UserProfile(
            user_id=new_id,
            first_name=user.first_name,
            last_name=user.last_name,
            email=user.email,
            contact_number=user.contact_number
        )
        users_db.append({
            **new_user.dict(),
            "password": hashed_password
        })
        return new_user
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/login")
def login(login: Login):
    try:
        user = next((u for u in users_db if u['email'] == login.email), None)
        if not user or not auth_handler.verify_password(login.password, user['password']):
            raise HTTPException(status_code=401, detail="Invalid credentials")

        access_token = auth_handler.create_access_token(data={"sub": login.email, "role": "userpets"})
        
        # Include user_id and name in the response
        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user_id": user['user_id'],
            "name": f"{user['first_name']} {user['last_name']}"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
