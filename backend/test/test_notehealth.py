from fastapi import FastAPI, HTTPException, Depends
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from datetime import datetime
from models.notehealth import Age, ToAge, CreateHealthRecord, HealthRecordResponse, HealthRecord, LogHealthRecord
from deps import get_session, get_current_user, get_current_user_role
from routers.notehealth import router

app = FastAPI()
app.include_router(router, prefix="/notehealth")

client = TestClient(app)

# Override dependencies for testing
def override_get_current_user():
    return "test_user"

def override_get_current_user_role():
    return "admin"

app.dependency_overrides[get_current_user] = override_get_current_user
app.dependency_overrides[get_current_user_role] = override_get_current_user_role

# Test cases

def test_get_health_record_not_found():
    # Test retrieving a non-existing health record
    response = client.get("/notehealth/999/health")
    assert response.status_code == 404
    assert response.json() == {"detail": "Health record not found"}


# Existing test cases...
def test_create_health_record():
    test_record = {
        "header": "Healthy Dog",
        "pet_type": "Dog",
        "age": {"years": 2, "months": 5, "days": 20},
        "to_age": {"years": 3, "months": 0, "days": 0},
        "weight_start_months": 12.5,
        "weight_end_months": 14.0,
        "description": "Balanced diet for a growing dog."
    }
    response = client.post("/notehealth/", json=test_record)
    assert response.status_code == 200
    data = response.json()
    assert data["header"] == test_record["header"]
    assert data["pet_type"] == test_record["pet_type"]
    assert data["age"]["years"] == test_record["age"]["years"]
    assert data["to_age"]["years"] == test_record["to_age"]["years"]

def test_get_health_record():
    # Assuming a health record with HR_id = 1 exists for testing
    response = client.get("/notehealth/1/health")
    assert response.status_code == 200
    data = response.json()
    assert data["HR_id"] == 1

def test_get_all_health_records():
    response = client.get("/notehealth/all")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)

def test_update_health_record():
    # Assuming a health record with HR_id = 1 exists for testing
    updated_record = {
        "header": "Updated Healthy Dog",
        "pet_type": "dog",
        "age": {"years": 2, "months": 6, "days": 0},
        "to_age": {"years": 4, "months": 0, "days": 0},
        "weight_start_months": 13.0,
        "weight_end_months": 15.0,
        "description": "Updated balanced diet for a growing dog."
    }
    response = client.put("/notehealth/1/health", json=updated_record)
    assert response.status_code == 200
    data = response.json()
    assert data["header"] == updated_record["header"]
    assert data["age"]["months"] == updated_record["age"]["months"]

def test_update_health_record_not_found():
    # Test updating a non-existing health record
    updated_record = {
        "header": "Updated Healthy Dog",
        "pet_type": "dog",
        "age": {"years": 3, "months": 0, "days": 0},
        "to_age": {"years": 5, "months": 0, "days": 0},
        "weight_start_months": 14.0,
        "weight_end_months": 16.0,
        "description": "Updated balanced diet for an adult dog."
    }
    response = client.put("/notehealth/999/health", json=updated_record)
    assert response.status_code == 404
    assert response.json() == {"detail": "Health record not found"}

# Run tests
if __name__ == "__main__":
    test_create_health_record()

    test_get_health_record()
    test_get_health_record_not_found()  # New test
    test_get_all_health_records()

    test_update_health_record()
    test_update_health_record_not_found()