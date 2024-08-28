from fastapi import APIRouter, HTTPException
from models.pet import PetProfile, HealthRecord, CareSuggestion, CreatePetProfile
from datetime import datetime
from typing import List 

router = APIRouter(prefix="/pets", tags=["pets"])

# In-memory storage for demonstration
pets_db: List[PetProfile] = []

care_suggestions = [
    CareSuggestion(age_in_months=2, suggestion="Vaccination time! Make sure your pet is vaccinated."),
    CareSuggestion(age_in_months=6, suggestion="Your pet is growing fast! Time to start a balanced diet."),
    CareSuggestion(age_in_months=12, suggestion="Annual check-up! Keep an eye on weight and overall health."),
]

@router.post("/pets", response_model=PetProfile)
def create_pet(pet: CreatePetProfile):
    if pet.user_id <= 0:
        raise HTTPException(status_code=400, detail="Invalid user ID")

    new_id = len(pets_db) + 1
    new_pet = pet.copy(update={"id": new_id})
    pets_db.append(new_pet)
    return new_pet

@router.get("/pets/{pet_id}", response_model=PetProfile)
def get_pet_profile(pet_id: int):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    return pet

@router.put("/pets/{pet_id}", response_model=PetProfile)
def update_pet_profile(pet_id: int, pet_update: CreatePetProfile):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    updated_pet = pet.copy(update=pet_update.dict(exclude_unset=True))
    pets_db.remove(pet)
    pets_db.append(updated_pet)
    return updated_pet

@router.delete("/pets/{pet_id}", response_model=PetProfile)
def delete_pet_profile(pet_id: int):
    global pets_db
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    pets_db = [p for p in pets_db if p.id != pet_id]
    return pet

@router.get("/pets/{pet_id}/age")
def get_pet_age(pet_id: int):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    current_date = datetime.now()
    age_in_days = (current_date - pet.birth_date).days
    age_in_months = age_in_days // 30

    return {"pet_id": pet_id, "age_in_months": age_in_months, "age_in_days": age_in_days}

@router.get("/pets/{pet_id}/care")
def get_care_suggestions(pet_id: int):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    current_date = datetime.now()
    age_in_months = (current_date - pet.birth_date).days // 30

    applicable_suggestions = [s for s in care_suggestions if s.age_in_months <= age_in_months]
    return {"pet_id": pet_id, "suggestions": applicable_suggestions}

@router.post("/pets/{pet_id}/health", response_model=HealthRecord)
def add_health_record(pet_id: int, record: HealthRecord):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    pet.health_records.append(record)
    return record

@router.get("/pets/{pet_id}/health", response_model=List[HealthRecord])
def get_health_records(pet_id: int):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    return pet.health_records

@router.put("/pets/{pet_id}/health/{record_id}", response_model=HealthRecord)
def update_health_record(pet_id: int, record_id: int, record_update: HealthRecord):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    record = next((r for r in pet.health_records if r.id == record_id), None)
    if record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    updated_record = record.copy(update=record_update.dict(exclude_unset=True))
    pet.health_records = [updated_record if r.id == record_id else r for r in pet.health_records]
    return updated_record

@router.delete("/pets/{pet_id}/health/{record_id}", response_model=HealthRecord)
def delete_health_record(pet_id: int, record_id: int):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    record = next((r for r in pet.health_records if r.id == record_id), None)
    if record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    pet.health_records = [r for r in pet.health_records if r.id != record_id]
    return record
