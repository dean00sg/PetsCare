from fastapi import FastAPI
from .pets import router as pets_router
from .admin_manage import router as admin_manage_router
from .pets_vac import router as pets_vac_router
from .notehealth import router as notehealth_router
from .authen_user import router as auth_router
from .feedpost import router as feed_router
from .profile import router as profile_router

def init_router(app: FastAPI):
    app.include_router(auth_router, prefix="/authentication")
    app.include_router(admin_manage_router, prefix="/admin_manage")
    app.include_router(pets_router, prefix="/pets")
    app.include_router(pets_vac_router, prefix="/pets_vac")
    app.include_router(notehealth_router, prefix="/notehealth")
    app.include_router(feed_router, prefix="/feedpost")
    app.include_router(profile_router, prefix="/profile")
