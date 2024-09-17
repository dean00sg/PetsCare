from datetime import datetime
from fastapi import APIRouter, HTTPException, Depends, Body,status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError
from pydantic import BaseModel
from sqlalchemy.orm import Session
from security import AuthHandler, Token
from models.user import LogUserLogin, LogUserProfile, UpdateUser, UserCreate, UserUpdate, UpdateUserResponse, UserProfile, UserWithPets, DeleteResponse, UserAuthen
from deps import get_session, get_current_user
from sqlalchemy.exc import IntegrityError

router = APIRouter(tags=["Authentication"])

auth_handler = AuthHandler()

@router.post("/register", response_model=UserAuthen)
async def register_user(user: UserCreate, session: Session = Depends(get_session)):
    role = user.role or "userpets"  
    if role not in ["admin", "userpets"]:
        raise HTTPException(status_code=400, detail="Invalid role")

    hashed_password = auth_handler.get_password_hash(user.password)
    
    db_user = UserProfile(
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        password=hashed_password,
        role=user.role
    )
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    
    log_entry = LogUserProfile(
        action_name="insert",
        action_datetime=datetime.now(),
        user_id=db_user.user_id,
        first_name=db_user.first_name,
        last_name=db_user.last_name,
        email=db_user.email,
        contact_number=db_user.contact_number,
        password=db_user.password,
        role=db_user.role
    )
    
    session.add(log_entry)
    session.commit()

    return db_user


@router.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_session)):

    user = db.query(UserProfile).filter(UserProfile.email == form_data.username).first()

    if not user or not auth_handler.verify_password(form_data.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    

    token = auth_handler.create_access_token(data={"username": user.email, "role": user.role})
    
   
    log_entry = LogUserLogin(
        action_name="Login",
        login_datetime=datetime.now().replace(microsecond=0),
        user_id=user.user_id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        access_token=token,  
        role=user.role
    )
    
    db.add(log_entry)
    db.commit()

    return {"access_token": token, "token_type": "bearer"}





@router.post("/logout")
async def logout(
    token: str = Depends(OAuth2PasswordBearer(tokenUrl="/login")),  
    db: Session = Depends(get_session)  
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = auth_handler.decode_access_token(token)
        username: str = payload.get("username")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = db.query(UserProfile).filter(UserProfile.email == username).first()
    if user is None:
        raise credentials_exception

    log_entry = LogUserLogin(
        action_name="Logout", 
        login_datetime=datetime.now().replace(microsecond=0),  
        user_id=user.user_id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        access_token="N/A",  
        role=user.role
    )

    try:
     
        db.add(log_entry)
        db.commit()

    except IntegrityError:
        db.rollback()  
  
        new_log_entry = LogUserLogin(
            action_name="Logout",
            login_datetime=datetime.now().replace(microsecond=0),  
            user_id=user.user_id,
            first_name=user.first_name,
            last_name=user.last_name,
            email=user.email,
            contact_number=user.contact_number,
            access_token="N/A",  
            role=user.role
        )
        db.add(new_log_entry)
        db.commit()
    
    return {"message": "User logged out successfully"}






@router.put("/", response_model=UpdateUserResponse)
async def update_user(
    update_data: UpdateUser = Body(...),
    session: Session = Depends(get_session),
    current_user_email: str = Depends(get_current_user)
):
    user = session.query(UserProfile).filter(UserProfile.email == current_user_email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    log_entry = LogUserProfile(
        action_name="update",
        action_datetime=datetime.now(),
        user_id=user.user_id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        password=user.password,
        role=user.role
    )

    if update_data.new_password:
        user.password = auth_handler.get_password_hash(update_data.new_password)
        log_entry.to_password = user.password
    if update_data.first_name:
        log_entry.to_first_name = update_data.first_name
        user.first_name = update_data.first_name
    if update_data.last_name:
        log_entry.to_last_name = update_data.last_name
        user.last_name = update_data.last_name
    if update_data.email:
        log_entry.to_email = update_data.email
        user.email = update_data.email
    if update_data.contact_number:
        log_entry.to_contact_number = update_data.contact_number
        user.contact_number = update_data.contact_number

    session.add(log_entry)
    session.add(user)
    session.commit()
    session.refresh(user)

    return UpdateUserResponse(
        status="User updated successfully",
        user_id=user.user_id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        role=user.role
    )


@router.delete("/", response_model=DeleteResponse)
async def delete_user(
    session: Session = Depends(get_session),
    current_user_email: str = Depends(get_current_user)
):
    user = session.query(UserProfile).filter(UserProfile.email == current_user_email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    log_entry = LogUserProfile(
        action_name="delete",
        action_datetime=datetime.now(),
        user_id=user.user_id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        password=user.password,
        role=user.role
    )

    delete_response = DeleteResponse(
        status="User deleted successfully",
        id=user.user_id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        role=user.role
    )

    session.add(log_entry)
    session.delete(user)
    session.commit()
    
    return delete_response
