from fastapi import APIRouter, HTTPException, Depends, Query, Body
from sqlalchemy.orm import Session
from security import AuthHandler
from models.user import UserCreate, UpdateUser, UpdateUserResponse, UserProfile, UserWithPets, DeleteResponse
from deps import get_session

router = APIRouter(tags=["Authentication"])

auth_handler = AuthHandler()


@router.post("/register", response_model=UserWithPets)
def register_user(user: UserCreate, session: Session = Depends(get_session)):
    role = user.role or "userpets"  # Default role if not provided
    if role not in ["admin", "userpets"]:
        raise HTTPException(status_code=400, detail="Invalid role")

    hashed_password = auth_handler.get_password_hash(user.password)
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
    return db_user


@router.post("/login")
def login(
    email: str = Query(..., description="Email of the user for login"),
    password: str = Query(..., description="Password of the user for login"),
    session: Session = Depends(get_session)
):
    user = session.query(UserProfile).filter(UserProfile.email == email).first()
    if not user or not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    access_token = auth_handler.create_access_token(data={"username": user.email, "role": user.role})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user_id": user.user_id,
        "name": f"{user.first_name} {user.last_name}",
        "role": user.role
    }


@router.get("/", response_model=UserWithPets)
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

    # Update user information
    if update_data.new_password:
        user.password = auth_handler.get_password_hash(update_data.new_password)
    if update_data.first_name:
        user.first_name = update_data.first_name
    if update_data.last_name:
        user.last_name = update_data.last_name
    if update_data.email:
        user.email = update_data.email
    if update_data.contact_number:
        user.contact_number = update_data.contact_number

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

    delete_response = DeleteResponse(
        status="User deleted successfully",
        id=user.user_id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        contact_number=user.contact_number,
        role=user.role
    )

    session.delete(user)
    session.commit()
    
    return delete_response