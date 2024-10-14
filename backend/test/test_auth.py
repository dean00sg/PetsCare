from fastapi import status
from fastapi.testclient import TestClient
from main import app  # อ้างอิงจากไฟล์หลักที่สร้าง FastAPI instance
from models.user import UserCreate, UpdateUser

client = TestClient(app)

# กรณีทดสอบการเข้าสู่ระบบ (Login)
def test_login_success():
    response = client.post("/authentication/login", data={"username": "preampreawping@gmail.com", "password": "123456"})
    assert response.status_code == status.HTTP_200_OK
    assert "access_token" in response.json()

def test_login_failure():
    response = client.post("/authentication/login", data={"username": "preampreawping@gmail.com", "password": "010203"})
    assert response.status_code == status.HTTP_401_UNAUTHORIZED
    assert response.json() == {"detail": "Incorrect username or password"}

# กรณีทดสอบการลงทะเบียน (Register)
def test_register_user():
    user_data = {
        "first_name": "John",
        "last_name": "Doe",
        "email": "john.doe@gmail.com",
        "contact_number": "1234567890",
        "password": "123456"
    }
    response = client.post("/authentication/register", json=user_data)
    assert response.status_code == status.HTTP_200_OK
    assert "email" in response.json()
    assert response.json()["email"] == user_data["email"]

# กรณีทดสอบการออกจากระบบ (Logout)
def test_logout_user():
    login_response = client.post("/authentication/login", data={"username": "john.doe@gmail.com", "password": "123456"})
    token = login_response.json()["access_token"]
    
    response = client.post("/authentication/logout", headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == status.HTTP_200_OK
    assert response.json() == {"message": "User logged out successfully"}

# กรณีทดสอบการอัปเดตผู้ใช้ (Update User)
def test_update_user():
    login_response = client.post("/authentication/login", data={"username": "john.doe@gmail.com", "password": "123456"})
    token = login_response.json()["access_token"]
    
    update_data = {
        "first_name": "Johnny",
        "last_name": "Doer",
        "email": "johnny.doer@gmail.com",
        "contact_number": "0987654321",
        "new_password": "010203"
    }
    response = client.put("/authentication/", json=update_data, headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == status.HTTP_200_OK
    assert response.json()["status"] == "User updated successfully"
    assert response.json()["first_name"] == update_data["first_name"]

# # กรณีทดสอบการลบผู้ใช้ (Delete User)
# def test_delete_user():
#     login_response = client.post("/authentication/login", data={"username": "johnny.doer@gmail.com", "password": "010203"})
#     token = login_response.json()["access_token"]
    
#     response = client.delete("/authentication/", headers={"Authorization": f"Bearer {token}"})
#     assert response.status_code == status.HTTP_200_OK
#     assert response.json()["status"] == "User deleted successfully"

if __name__ == "__main__":
    test_login_success()
    test_login_failure()
    test_register_user()
    test_logout_user()
    test_update_user()
