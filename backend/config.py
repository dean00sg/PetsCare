from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = 'postgresql://petscare:5SmuudKzz2itnxshOD4wm15YXCgmCmjo@dpg-cs6klet6l47c73fh2nh0-a.oregon-postgres.render.com/petscare'
    SECRET_KEY: str = "254fg4r845FESF5A87wewa5rg51h5s4a51g51e4a8t5g"

    class Config:
        env_file = ".env" 

settings = Settings()
