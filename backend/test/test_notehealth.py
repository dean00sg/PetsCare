from fastapi import FastAPI, APIRouter, HTTPException, Depends, Query
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from deps import get_session, get_current_user_role
from security import AuthHandler

app = FastAPI()
router = APIRouter()
auth_handler = AuthHandler()

# Simulated in-memory note health data
note_health_data = [
    {
        "id": 1,
        "age": "1y 0m 0d",
        "notes": "High-Quality Food: Provide a balanced diet appropriate for your cat’s age and health.",
        "pet_type": "cat",
        "weight": 12,
        "date": "2023-08-30T18:28:44.664000"
    },
    {
        "id": 2,
        "age": "1y 0m 0d",
        "notes": "Balanced Diet: Feed a high-quality dog food suitable for your dog’s age, size, and activity level.",
        "pet_type": "dog",
        "weight": 12,
        "date": "2023-08-30T18:28:44.664000"
    }
]

@router.get("/login")
def login(firstname: str = Query(...), password: str = Query(...)):
    if firstname == "Dean" and password == "123456":
        token = auth_handler.create_access_token({"firstname": firstname, "role": "admin"})
        return {"access_token": token, "token_type": "bearer"}
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

@app.get("/notehealth/{note_id}")
def get_note_health(note_id: int, password: str = Query(...)):
    if password != "123456":
        raise HTTPException(status_code=401, detail="Unauthorized")
    for note in note_health_data:
        if note["id"] == note_id:
            return note
    raise HTTPException(status_code=404, detail="Note not found")

app.include_router(router)

# Testing--------------------------------------------------------------------------------------------------------------------------

client = TestClient(app)

def test_get_note_health_success():
    token = auth_handler.create_access_token({"firstname": "Dean", "role": "admin"})
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/notehealth/1", params={"password": "123456"}, headers=headers)
    assert response.status_code == 200
    assert response.json() == {
        "id": 1,
        "age": "1y 0m 0d",
        "notes": "High-Quality Food: Provide a balanced diet appropriate for your cat’s age and health.",
        "pet_type": "cat",
        "weight": 12,
        "date": "2023-08-30T18:28:44.664000"
    }

def test_get_note_health_failure():
    token = auth_handler.create_access_token({"firstname": "Dean", "role": "admin"})
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/notehealth/1", params={"password": "wrongpassword"}, headers=headers)
    assert response.status_code == 401
    assert response.json() == {"detail": "Unauthorized"}

    response = client.get("/notehealth/99", params={"password": "123456"}, headers=headers)
    assert response.status_code == 404
    assert response.json() == {"detail": "Note not found"}
    
if __name__ == "__main__":
    test_get_note_health_success()
    test_get_note_health_failure()
