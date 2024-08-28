from fastapi import FastAPI
from .pets import router as pets_router
from .users import router as users_router
from .pets_vac import router as pets_vac_router
from .notehealth import router as notehealth



def init_router(app: FastAPI):
    app.include_router(pets_router, prefix="/pets")
    app.include_router(users_router, prefix="/users")
    app.include_router(pets_vac_router, prefix="/pet_vac")
    app.include_router(notehealth, prefix="/notehealth")
