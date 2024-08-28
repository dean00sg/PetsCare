from fastapi import FastAPI
from routers import init_router

app = FastAPI()

init_router(app)

@app.get("/")
def root():
    return {"message": "Welcome to the Pet Care App"}
