import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./jambam.db")
# Example for PostgreSQL: "postgresql://user:password@postgresserver/db" 