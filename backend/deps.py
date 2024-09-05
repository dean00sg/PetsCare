from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from fastapi import Request, HTTPException, Depends
from security import AuthHandler
from config import settings

engine = create_engine(settings.DATABASE_URL, echo=True)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def init_db():
    Base.metadata.create_all(bind=engine)

def get_session():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

auth_handler = AuthHandler()

def get_current_user_role(request: Request, session=Depends(get_session)) -> str:
    authorization: str = request.headers.get("Authorization")
    if not authorization:
        raise HTTPException(status_code=401, detail="Not authenticated")
    try:
        token_parts = authorization.split(" ")
        if len(token_parts) != 2:
            raise HTTPException(status_code=401, detail="Invalid authorization header")
        
        token = token_parts[1]
        role = auth_handler.get_current_user_role(token)
        if role not in ["admin", "userpets"]:
            raise HTTPException(status_code=403, detail="Invalid role")
        return role
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")
