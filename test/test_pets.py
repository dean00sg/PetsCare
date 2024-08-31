from fastapi import FastAPI, APIRouter, HTTPException, Depends, Query
from fastapi.testclient import TestClient
from security import AuthHandler

app = FastAPI()
router = APIRouter()
auth_handler = AuthHandler()

# Simulated in-memory pet data
pets = {
    1: {
        "name": "Buddy",
        "type_pets": "dog",
        "sex": "male",
        "breed": "Labrador",
        "birth_date": "2020-01-01T00:00:00",
        "weight": 30.5,
        "user_id": 1
    }
}

@router.get("/login")
def login(firstname: str = Query(...), password: str = Query(...)):
    if firstname == "Pream" and password == "000000":
        token = auth_handler.create_access_token({"firstname": firstname, "role": "userpets"})
        return {"access_token": token, "token_type": "bearer"}
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

@app.get("/pets/{pet_id}")
def get_pet(pet_id: int, password: str = Query(...)):
    if pet_id in pets:
        return pets[pet_id]
    else:
        raise HTTPException(status_code=404, detail="Pet not found")

app.include_router(router)

# Testing--------------------------------------------------------------------------------------------------------------------------

client = TestClient(app)

def test_get_pet_success():
    token = auth_handler.create_access_token({"firstname": "Pream", "role": "userpets"})
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/pets/1", params={"password": "000000"}, headers=headers)
    assert response.status_code == 200
    assert response.json() == {
        "name": "Buddy",
        "type_pets": "dog",
        "sex": "male",
        "breed": "Labrador",
        "birth_date": "2020-01-01T00:00:00",
        "weight": 30.5,
        "user_id": 1
    }

def test_get_pet_failure():
    token = auth_handler.create_access_token({"firstname": "Pream", "role": "userpets"})
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/pets/99", params={"password": "000000"}, headers=headers)
    assert response.status_code == 404
    assert response.json() == {"detail": "Pet not found"}

if __name__ == "__main__":
    test_get_pet_success()
    test_get_pet_failure()
