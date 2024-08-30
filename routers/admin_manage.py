from datetime import date
from fastapi import APIRouter, HTTPException, Depends, Query, Path
from sqlalchemy.orm import Session
from sqlmodel import select
from models.notehealth import PetHealthRecord
from models.pet_vac import PetVacProfile
from models.user import PetsWithPetsVacsine, UserProfile, UserWithPets
from models.pet import Pet, PetProfile
from deps import get_session
from security import AuthHandler
from typing import List
from dateutil.relativedelta import relativedelta

router = APIRouter(tags=["Admin Checking"])
auth_handler = AuthHandler()  # Initialize your authentication handler

def calculate_age(birth_date: date) -> str:
    today = date.today()
    delta = relativedelta(today, birth_date)
    return f"{delta.years}y {delta.months}m {delta.days}d"

def verify_admin(firstname: str, password: str, session: Session) -> None:
    """Function to verify if the user is an admin with valid credentials."""
    # Fetch user by firstname
    admin_user = session.exec(select(UserProfile).where(UserProfile.first_name == firstname)).first()
    if not admin_user:
        raise HTTPException(status_code=404, detail="Admin user not found")
    
    # Verify the provided password
    if not auth_handler.verify_password(password, admin_user.password):
        raise HTTPException(
            status_code=401,
            detail="Invalid password. Access forbidden: Admins only"
        )

    # Check if the user has the admin role
    if admin_user.role != "admin":
        raise HTTPException(status_code=403, detail="Access forbidden: Admins only")

@router.get("/", response_model=List[UserProfile])
def get_users(
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    # Verify admin credentials
    verify_admin(firstname, password, session)
    
    try:
        users = session.exec(select(UserProfile)).all()
        return users
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/{user_id}", response_model=UserProfile)
def get_user(
    user_id: int = Path(..., description="User ID to retrieve user information"),
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    # Verify admin credentials
    verify_admin(firstname, password, session)
    
    db_user = session.get(UserProfile, user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

@router.get("/{user_id}/with_pets", response_model=UserWithPets)
def get_user_with_pets(
    user_id: int = Path(..., description="User ID to retrieve user and pet information"),
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    # Verify admin credentials
    verify_admin(firstname, password, session)
    
    try:
        # Lookup user by ID
        db_user = session.exec(select(UserProfile).where(UserProfile.user_id == user_id)).first()
        if db_user is None:
            raise HTTPException(status_code=404, detail="User not found")

        # Retrieve pets for the user
        pets = session.exec(select(Pet).where(Pet.user_id == user_id)).all()
        
        # Create PetProfile instances with calculated age
        pet_profiles = [
            PetProfile(
                id=pet.id,
                name=pet.name,
                type_pets=pet.type_pets,
                sex=pet.sex,
                breed=pet.breed,
                birth_date=pet.birth_date,
                age=calculate_age(pet.birth_date.date()),  # Calculate age
                weight=pet.weight,
                user_id=pet.user_id
            )
            for pet in pets
        ]

        # Create UserWithPets response
        user_with_pets = UserWithPets(
            user_id=db_user.user_id,
            first_name=db_user.first_name,
            last_name=db_user.last_name,
            email=db_user.email,
            contact_number=db_user.contact_number,
            pets=pet_profiles
        )
        
        return user_with_pets
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {str(e)}")


# แสดงรายการสัตว์เลี้ยงและข้อมูลวัคซีนและการแพ้ยา
@router.get("/{user_id}/with_pets_vacsine", response_model=PetsWithPetsVacsine)
def get_pets_with_vacsine(
    user_id: int,
    firstname: str = Query(..., description="First name of the user to authenticate"),
    password: str = Query(..., description="Password of the user to authenticate"),
    session: Session = Depends(get_session)
):
    # ตรวจสอบการยืนยันตัวตน
    user = session.exec(select(UserProfile).where(UserProfile.first_name == firstname)).first()
    
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    # ตรวจสอบความถูกต้องของรหัสผ่าน
    if not auth_handler.verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")
    
    # ตรวจสอบว่า user_id ตรงกับที่ได้รับจากการยืนยันตัวตนหรือไม่
    if user.user_id != user_id:
        raise HTTPException(status_code=403, detail="Unauthorized access to this user's pets")

    pets = session.exec(select(Pet).where(Pet.user_id == user_id)).all()

    if not pets:
        raise HTTPException(status_code=404, detail="No pets found for this user")

    # คำนวณอายุและสร้างรายการ PetProfile
    pet_profiles = []
    for pet in pets:
        age = calculate_age(pet.birth_date)
        pet_profiles.append(
            PetProfile(
                id=pet.id,
                name=pet.name,
                type_pets=pet.type_pets,
                sex=pet.sex,
                breed=pet.breed,
                birth_date=pet.birth_date,
                weight=pet.weight,
                user_id=pet.user_id,
                age=age  # เพิ่มอายุที่คำนวณไว้ในโปรไฟล์สัตว์เลี้ยง
            )
        )

    # ดึงข้อมูลวัคซีนและการแพ้ยาของสัตว์เลี้ยง
    pet_vac_profiles = session.exec(select(PetVacProfile).where(PetVacProfile.user_id == user_id)).all()

    pets_with_vacsine = PetsWithPetsVacsine(
        pets=pet_profiles,  # ข้อมูลสัตว์เลี้ยงพร้อมอายุ
        pet_vac_profiles=pet_vac_profiles  # ข้อมูลวัคซีนและการแพ้ยา
    )

    return pets_with_vacsine

@router.get("/notehealth/health", response_model=List[PetHealthRecord])
def get_all_health_records(
    firstname: str = Query(..., description="First name of the admin user to authenticate"),
    password: str = Query(..., description="Password of the admin user to authenticate"),
    session: Session = Depends(get_session)
):
    # Verify admin credentials
    verify_admin(firstname, password, session)

    try:
        # Query all pet health records
        health_records = session.exec(select(PetHealthRecord)).all()
        return health_records
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))