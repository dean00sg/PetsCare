from fastapi import FastAPI
from routers import pets_router
from routers import users_router
from routers import pets_vac_router
from routers import notehealth

app = FastAPI()

app.include_router(pets_router, prefix="/pets")
app.include_router(users_router, prefix="/users")
app.include_router(pets_vac_router, prefix="/pets_vac")
app.include_router(notehealth, prefix="/notehealth")
@app.get("/")
def root():

    return {"message": "Welcome to the Pet Care App"}
