from fastapi import APIRouter, HTTPException, Depends
from sqlmodel import Session, select
from models.pet import Pet, PetProfile
from models.pet_vac import PetVacProfile, CreatePetVacProfile
from deps import get_session
from typing import List
from passlib.context import CryptContext

from models.user import UserProfile

router = APIRouter(tags=["Pets Vacsine"])

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

#ประวัติวัคซีนและประวัติการแพ้ยาของสัตว์เลี้ยง

@router.post("/pet_vac", response_model=PetVacProfile)
def create_pet_vac(pet_vac: CreatePetVacProfile, pet_id: int, password: str, session: Session = Depends(get_session)):
    
    # ตรวจสอบว่ามี pet_id และ password ที่ถูกต้อง
    pet_profile = session.exec(select(Pet).where(Pet.id == pet_id)).first()
    
    if pet_profile is None:
        raise HTTPException(status_code=404, detail="Pet not found")

    user = session.get(UserProfile, pet_profile.user_id)
    if user is None or not pwd_context.verify(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    # ใช้ pets_id และ user_id จาก Pet
    new_pet_vac = PetVacProfile(
        pets_id=pet_profile.id,  # ใช้ id ของสัตว์เลี้ยงจาก Pet
        user_id=pet_profile.user_id,
        vacname=pet_vac.vacname,
        stardatevac=pet_vac.stardatevac,
        drugname=pet_vac.drugname
    )
    session.add(new_pet_vac)
    session.commit()
    session.refresh(new_pet_vac)
    return new_pet_vac


@router.get("/pets_vac/{pet_vac_id}", response_model=PetVacProfile)
def get_pet_vac(pet_vac_id: int, session: Session = Depends(get_session)):
    pet_vac = session.get(PetVacProfile, pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")
    return pet_vac


@router.get("/pets_vac", response_model=List[PetVacProfile])
def get_all_pet_vacs(session: Session = Depends(get_session)):
    pet_vacs = session.exec(select(PetVacProfile)).all()
    return pet_vacs


@router.put("/pets_vac/{pet_vac_id}", response_model=PetVacProfile)
def update_pet_vac(pet_vac_id: int, pet_vac_update: CreatePetVacProfile, password: str, pet_id: int, session: Session = Depends(get_session)):
    pet_vac = session.get(PetVacProfile, pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")

    if pet_vac.pets_id != pet_id:
        raise HTTPException(status_code=403, detail="Pet ID does not match")

    user = session.get(UserProfile, pet_vac.user_id)
    if user is None or not pwd_context.verify(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    for key, value in pet_vac_update.dict(exclude_unset=True).items():
        setattr(pet_vac, key, value)

    session.add(pet_vac)
    session.commit()
    session.refresh(pet_vac)
    return pet_vac

@router.delete("/pets_vac/{pet_vac_id}", response_model=dict)
def delete_pet_vac(pet_vac_id: int, password: str, pet_id: int, session: Session = Depends(get_session)):
    pet_vac = session.get(PetVacProfile, pet_vac_id)
    if pet_vac is None:
        raise HTTPException(status_code=404, detail="Pet vaccine profile not found")

    if pet_vac.pets_id != pet_id:
        raise HTTPException(status_code=403, detail="Pet ID does not match")

    user = session.get(UserProfile, pet_vac.user_id)
    if user is None or not pwd_context.verify(password, user.password):
        raise HTTPException(status_code=401, detail="Invalid password")

    session.delete(pet_vac)
    session.commit()
    return {"message": "deleted successfully"}