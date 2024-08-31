from fastapi import FastAPI, APIRouter, HTTPException, Depends, Query
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session
from deps import get_session, get_current_user_role
from models.pet_vac import PetVacProfile
from security import AuthHandler

app = FastAPI()
router = APIRouter()
auth_handler = AuthHandler()

# Endpoint สำหรับการเข้าสู่ระบบ
@router.get("/login")
def login(firstname: str = Query(...), password: str = Query(...)):
    # จำลองข้อมูลผู้ใช้
    if firstname == "Pream" and password == "000000":
        token = auth_handler.create_access_token({"firstname": firstname, "role": "userpets"})
        return {"access_token": token, "token_type": "bearer"}
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

# Endpoint สำหรับการสร้างข้อมูลการฉีดวัคซีนของสัตว์เลี้ยง
@router.get("/pets_vac")
def create_pet_vac(pet_id: int = Query(...), user_id: int = Query(...), password: str = Query(...)):
    # ตรวจสอบรหัสผ่าน
    if password != "000000":
        raise HTTPException(status_code=401, detail="Invalid credentials")

    # จำลองข้อมูลการฉีดวัคซีน
    if pet_id == 1 and user_id == 1:
        return {"detail": "Pet vaccination record created"}
    else:
        raise HTTPException(status_code=404, detail="Pet or user not found")

app.include_router(router)

# Testing--------------------------------------------------------------------------------------------------------------------------

client = TestClient(app)

def test_create_pet_vac_success():
    token = auth_handler.create_access_token({"firstname": "Pream", "role": "userpets"})
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/pets_vac", params={"pet_id": 1, "user_id": 1, "password": "000000"}, headers=headers)
    assert response.status_code == 200
    assert response.json() == {"detail": "Pet vaccination record created"}

def test_create_pet_vac_failure():
    token = auth_handler.create_access_token({"firstname": "Pream", "role": "userpets"})
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/pets_vac", params={"pet_id": 1, "user_id": 1, "password": "123456"}, headers=headers)
    assert response.status_code == 401
    assert response.json() == {"detail": "Invalid credentials"}

    response = client.get("/pets_vac", params={"pet_id": 2, "user_id": 1, "password": "000000"}, headers=headers)
    assert response.status_code == 404
    assert response.json() == {"detail": "Pet or user not found"}

if __name__ == "__main__":
    test_create_pet_vac_success()
    test_create_pet_vac_failure()
