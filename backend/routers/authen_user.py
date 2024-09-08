from datetime import datetime
from fastapi import APIRouter, HTTPException, Depends, Query, Body
from sqlalchemy.orm import Session
from security import AuthHandler
from models.user import LogUserProfile, UpdateUser, UserCreate, UserUpdate, UpdateUserResponse, UserProfile, UserWithPets, DeleteResponse,UserAuthen
from deps import get_session

router = APIRouter(tags=["Authentication"])

auth_handler = AuthHandler()


@router.post("/register", response_model=UserAuthen)
def register_user(user: UserCreate, session: Session = Depends(get_session)):
    role = user.role or "userpets"  # Default role if not provided
    if role not in ["admin", "userpets"]:
        raise HTTPException(status_code=400, detail="Invalid role")

    hashed_password = auth_handler.get_password_hash(user.password)
    
    # Create new user
    db_user = UserProfile(
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        password=hashed_password,
        role=role
    )
    
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    
    # Log the creation of the new user
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


# @router.post("/login")
# def login(
#     email: str = Query(..., description="Email of the user for login"),
#     password: str = Query(..., description="Password of the user for login"),
#     session: Session = Depends(get_session)
# ):
#     user = session.query(UserProfile).filter(UserProfile.email == email).first()
#     if not user or not auth_handler.verify_password(password, user.password):
#         raise HTTPException(status_code=401, detail="Invalid credentials")

#     access_token = auth_handler.create_access_token(data={"username": user.email, "role": user.role})
    
#     return {
#         "access_token": access_token,
#         "token_type": "bearer",
#         "user_id": user.user_id,
#         "name": f"{user.first_name} {user.last_name}",
#         "role": user.role
#     }


@router.get("/", response_model=UserAuthen)
def get_user(
    firstname: str = Query(..., description="First name"),
    password: str = Query(..., description="Password of the user"),
    session: Session = Depends(get_session)
):
    user = session.query(UserProfile).filter(UserProfile.first_name == firstname).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Verify password of the requester
    if not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials. Incorrect password provided.")
    
    return user


@router.put("/", response_model=UpdateUserResponse)
def update_user(
    firstname: str = Query(..., description="First name"),
    password: str = Query(..., description="Password of the user"),
    update_data: UpdateUser = Body(...),
    session: Session = Depends(get_session)
):
    user = session.query(UserProfile).filter(UserProfile.first_name == firstname).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Verify password of the requester
    if not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials. Incorrect password provided.")

    # Log the old values
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

    # Update user information
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
def delete_user(
    firstname: str = Query(..., description="First name of the user"),
    password: str = Query(..., description="Password of the user"),
    session: Session = Depends(get_session)
):
    user = session.query(UserProfile).filter(UserProfile.first_name == firstname).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Verify password of the requester
    if not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials. Incorrect password provided.")

    # Log deletion
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
