from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from routers import init_router
from deps import init_db, SessionLocal

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust to your frontend URL if it's hosted somewhere
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
init_db() 
init_router(app)

@app.get("/")
def root():
    return {"message": "Welcome to the Pet Care App"}

# ฟังก์ชัน get_db สำหรับใช้ใน dependencies
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
