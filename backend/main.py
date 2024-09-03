from fastapi import FastAPI
from routers import init_router
from deps import init_db

app = FastAPI()

init_db()  # สร้างฐานข้อมูลเมื่อเริ่มต้นแอพพลิเคชัน
init_router(app)

@app.get("/")
def root():
    return {"message": "Welcome to the Pet Care App"}
