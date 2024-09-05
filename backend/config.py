from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = 'postgresql://postgres:010203@localhost:5432/petscare_db'
    SECRET_KEY: str = "your-generated-secret-key"

    class Config:
        env_file = ".env" 

settings = Settings()
