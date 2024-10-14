from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = 'postgresql://postgres:postgres@34.124.181.238:5432/petcare_db'
    SECRET_KEY: str = "254fg4r845FESF5A87wewa5rg51h5s4a51g51e4a8t5g"

    class Config:
        env_file = ".env" 

settings = Settings()
