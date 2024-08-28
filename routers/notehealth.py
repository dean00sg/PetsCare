from fastapi import APIRouter, HTTPException
from models.pet import HealthRecord, CreateHealthRecord
from typing import List

router = APIRouter(prefix="/notehealth", tags=["notehealth"])

notehealth_db: List[HealthRecord] = []

@router.post("/notehealth/health", response_model=HealthRecord)
def add_health_record(health_record: CreateHealthRecord):
    new_id = len(notehealth_db) + 1  # Generate a new ID based on the current list size
    new_health_record = HealthRecord(id=new_id, **health_record.dict())  # Create a new HealthRecord instance
    notehealth_db.append(new_health_record)  # Append the new record to the list
    return new_health_record

@router.get("/notehealth/{id_health}/health", response_model=HealthRecord)
def get_health_record(id_health: int):
    health_record = next((p for p in notehealth_db if p.id == id_health), None)
    if health_record is None:
        raise HTTPException(status_code=404, detail="Health record not found")
    return health_record




# @router.put("/notehealth/{pet_id}/health/{record_id}", response_model=HealthRecord)
# def update_health_record(pet_id: int, record_id: int, record_update: HealthRecord):
#     pet = next((p for p in pets_db if p.id == pet_id), None)
#     if pet is None:
#         raise HTTPException(status_code=404, detail="Pet not found")
    
#     record = next((r for r in pet.health_records if r.id == record_id), None)
#     if record is None:
#         raise HTTPException(status_code=404, detail="Health record not found")
    
#     updated_record = record.copy(update=record_update.dict(exclude_unset=True))
#     pet.health_records = [updated_record if r.id == record_id else r for r in pet.health_records]
#     return updated_record

# @router.delete("/notehealth/{pet_id}/health/{record_id}", response_model=HealthRecord)
# def delete_health_record(pet_id: int, record_id: int):
#     pet = next((p for p in pets_db if p.id == pet_id), None)
#     if pet is None:
#         raise HTTPException(status_code=404, detail="Pet not found")
    
#     record = next((r for r in pet.health_records if r.id == record_id), None)
#     if record is None:
#         raise HTTPException(status_code=404, detail="Health record not found")
    
#     pet.health_records = [r for r in pet.health_records if r.id != record_id]
#     return record
