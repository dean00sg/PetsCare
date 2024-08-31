from fastapi import FastAPI, APIRouter, Query, HTTPException
from fastapi.testclient import TestClient
from pydantic import BaseModel
from typing import Dict, Optional
from datetime import datetime, timedelta, timezone
from jose import JWTError, jwt
from passlib.context import CryptContext
from config import settings
from security import AuthHandler


app = FastAPI()
auth_handler = AuthHandler()

router = APIRouter()

@router.get("/login")
def login(email: str = Query(...), password: str = Query(...)):
    # Replace with actual login logic
    if email == "Dean.sg@gmail.com" and password == "123456":
        token = auth_handler.create_access_token({"email": email, "role": "admin"})
        return {"access_token": token, "token_type": "bearer"}
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

app.include_router(router)

# Testing--------------------------------------------------------------------------------------------------------------------------

client = TestClient(app)

def test_login_success():
    response = client.get("/login", params={"email": "Dean.sg@gmail.com", "password": "123456"})
    assert response.status_code == 200
    assert "access_token" in response.json()

def test_login_failure():
    response = client.get("/login", params={"email": "Dean.sg@gmail.com", "password": "000000"})
    assert response.status_code == 401
    assert response.json() == {"detail": "Invalid credentials"}

if __name__ == "__main__":
    test_login_success()
    test_login_failure()
