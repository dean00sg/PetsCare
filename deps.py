from sqlmodel import create_engine, SQLModel, Session
from config import settings
from fastapi import Request, HTTPException, Depends
from security import AuthHandler

engine = create_engine(settings.DATABASE_URL, echo=True)

def init_db():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session

auth_handler = AuthHandler()

def get_current_user_role(request: Request, session: Session = Depends(get_session)) -> str:
    authorization: str = request.headers.get("Authorization")
    if not authorization:
        raise HTTPException(status_code=401, detail="Not authenticated")
    try:
        token = authorization.split(" ")[1]  # Remove "Bearer" prefix
        role = auth_handler.get_current_user_role(token)
        if role not in ["admin", "userpets"]:
            raise HTTPException(status_code=403, detail="Invalid role")
        return role
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")
