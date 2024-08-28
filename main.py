from fastapi import FastAPI
from routers import pets_router
from routers import users_router
from routers import pets_vac_router

app = FastAPI()

app.include_router(pets_router, prefix="/api/pets")
app.include_router(users_router, prefix="/api/users")
app.include_router(pets_vac_router, prefix="/api/pets_vac")
@app.get("/")
def root():

    return {"message": "Welcome to the Pet Care App"}
