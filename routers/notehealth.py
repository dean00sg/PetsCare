from fastapi import APIRouter, HTTPException
from models.pet import PetProfile, HealthRecord, CareSuggestion, CreatePetProfile
from datetime import datetime
from typing import List 

router = APIRouter(prefix="/notehealth", tags=["notehealth"])

pets_db: List[PetProfile] = []

@router.post("/notehealth/{pet_id}/health", response_model=HealthRecord)
def add_health_record(pet_id: int, record: HealthRecord):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    pet.health_records.append(record)
    return record

@router.get("/notehealth/{pet_id}/health", response_model=List[HealthRecord])
def get_health_records(pet_id: int):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    return pet.health_records

@router.put("/notehealth/{pet_id}/health/{record_id}", response_model=HealthRecord)
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

@router.delete("/notehealth/{pet_id}/health/{record_id}", response_model=HealthRecord)
def delete_health_record(pet_id: int, record_id: int):
    pet = next((p for p in pets_db if p.id == pet_id), None)
    if pet is None:
        raise HTTPException(status_code=404, detail="Pet not found")
    
    record = next((r for r in pet.health_records if r.id == record_id), None)
    if record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    
    pet.health_records = [r for r in pet.health_records if r.id != record_id]
    return record
