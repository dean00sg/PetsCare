from fastapi import status, HTTPException
from fastapi.testclient import TestClient
from main import app  # Assuming the main FastAPI app includes the router for pets
from sqlalchemy.orm import Session
from security import AuthHandler

client = TestClient(app)
auth_handler = AuthHandler()

def get_auth_header(email: str, password: str, role: str = "user"):
    login_response = client.post("/authentication/login", data={"username": email, "password": password})
    if login_response.status_code != status.HTTP_200_OK:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Login failed")
    
    token = login_response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}

def setup_pet():
    headers = get_auth_header("pream@gmail.com", password="010203")
    pet_name = "TestPet"
    response = client.post("/pets/", json={
        "name": pet_name,
        "type_pets": "Dog",
        "sex": "male",
        "breed": "Beagle",
        "birth_date": "2021-02-15",
        "weight": 10.0
    }, headers=headers)
    return response.json()["pets_id"], pet_name

def test_create_pet():
    headers = get_auth_header("pream@gmail.com", password="010203")
    response = client.post("/pets/", json={
        "name": "Milo",
        "type_pets": "Dog",
        "sex": "male",
        "breed": "Beagle",
        "birth_date": "2021-02-15",
        "weight": 10.0
    }, headers=headers)
    assert response.status_code == 200
    assert response.json()["name"] == "Milo"

def test_get_pets():
    headers = get_auth_header("pream@gmail.com", password="010203")
    response = client.get("/pets/", headers=headers)
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_pet_by_id():
    pet_id, pet_name = setup_pet()
    headers = get_auth_header("pream@gmail.com", password="010203")
    response = client.get(f"/pets/byid?pet_id={pet_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()["pets_id"] == pet_id

def test_get_all_pets_admin():
    headers = get_auth_header("Dean.sg@gmail.com", password="123456", role="admin")
    response = client.get("/pets/all-pets-admin", headers=headers)
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_update_pet():
    pet_id, _ = setup_pet()
    headers = get_auth_header("pream@gmail.com", password="010203")
    response = client.put(f"/pets/{pet_id}", json={
        "name": "Max",
        "birth_date": "2024-10-14",
        "weight": 12.0
    }, headers=headers)
    assert response.status_code == 200
    assert response.json()["name"] == "Max"

def test_delete_pet():
    _, pet_name = setup_pet()
    headers = get_auth_header("pream@gmail.com", password="010203")
    response = client.delete(f"/pets/{pet_name}", headers=headers)
    assert response.status_code == 200
    assert response.json()["detail"] == f"Pet '{pet_name}' has been deleted and logged in the system."

# Run all tests
if __name__ == "__main__":
    test_create_pet()
    test_get_pets()
    test_get_pet_by_id()
    test_get_all_pets_admin()
    test_update_pet()
    test_delete_pet()
