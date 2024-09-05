from fastapi import FastAPI
from routers import init_router
from deps import init_db, SessionLocal

app = FastAPI()
init_db() 
init_router(app)

@app.get("/")
def root():
    return {"message": "Welcome to the Pet Care App"}

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
