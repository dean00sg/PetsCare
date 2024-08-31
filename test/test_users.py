# from fastapi import FastAPI, APIRouter, HTTPException, Depends, Query
# from fastapi.testclient import TestClient
# from sqlalchemy.orm import Session
# from deps import get_session, get_current_user_role
# from models.user import UserProfile
# from security import AuthHandler

# app = FastAPI()
# router = APIRouter()
# auth_handler = AuthHandler()

# @router.get("/login")
# def login(firstname: str = Query(...), password: str = Query(...)):
#     # Replace with actual login logic
#     if firstname == "Dean" and password == "123456":
#         token = auth_handler.create_access_token({"firstname": firstname, "role": "admin"})
#         return {"access_token": token, "token_type": "bearer"}
#     else:
#         raise HTTPException(status_code=401, detail="Invalid credentials")

# app.include_router(router)

# # Testing--------------------------------------------------------------------------------------------------------------------------

# client = TestClient(app)

# def test_get_user_success():
#     token = auth_handler.create_access_token({"firstname": "Dean", "role": "admin"})
#     headers = {"Authorization": f"Bearer {token}"}
#     response = client.get("/users/Dean", params={"password": "123456"}, headers=headers)
#     assert response.status_code == 200
#     assert response.json()["firstname"] == "Dean"

# def test_get_user_failure():
#     token = auth_handler.create_access_token({"firstname": "Dean", "role": "admin"})
#     headers = {"Authorization": f"Bearer {token}"}
#     response = client.get("/users/Dean", params={"password": "000000"}, headers=headers)
#     assert response.status_code == 404
#     assert response.json() == {"detail": "User not found"}

# if __name__ == "__main__":
#     test_get_user_success()
#     test_get_user_failure()
