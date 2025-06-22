import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    # Supabase Configuration
    SUPABASE_URL: str = os.getenv("SUPABASE_URL", "https://nnneohqytsemmwpufwtv.supabase.co")
    SUPABASE_KEY: str = os.getenv("SUPABASE_KEY", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ubmVvaHF5dHNlbW13cHVmd3R2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1OTU3NzEsImV4cCI6MjA2NjE3MTc3MX0.PnojgXWf9n34CNTRy2tWTQFjeUqUfH-WGjvh8ygS82A")
    
    # Database Configuration
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./jambam.db")
    
    # JWT Configuration
    SECRET_KEY: str = os.getenv("SECRET_KEY", "your-secret-key-here")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))
    
    # API Configuration
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "JambaM Avatar Factory"
    
    # CORS Configuration
    BACKEND_CORS_ORIGINS: list = [
        "http://localhost:3000",  # React dev server
        "http://localhost:3001",
        "https://your-frontend-domain.com"  # Production frontend
    ]

settings = Settings()

# Example for PostgreSQL: "postgresql://user:password@postgresserver/db" 