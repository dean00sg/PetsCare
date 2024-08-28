from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = "sqlite:///./test.db"  # ใช้ SQLite สำหรับการพัฒนา
    SECRET_KEY: str = "your-generated-secret-key"  # ใส่ค่า Secret Key ที่คุณคัดลอกมา

    class Config:
        env_file = ".env"

settings = Settings()
