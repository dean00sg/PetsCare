# from sqlmodel import Field, SQLModel
# from typing import Optional
# from sqlalchemy import Enum
# from enum import Enum as PyEnum

# class Role(str, PyEnum):
#     admin = "admin"
#     userpets = "userpets"

# class User(SQLModel, table=True):
#     id: Optional[int] = Field(default=None, primary_key=True)
#     username: str = Field(unique=True)
#     hashed_password: str
#     role: Role
