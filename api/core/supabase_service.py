from supabase import create_client, Client
from typing import Optional, Dict, Any
from .config import settings
import logging

logger = logging.getLogger(__name__)

class SupabaseService:
    def __init__(self):
        self.supabase: Client = create_client(
            settings.SUPABASE_URL, 
            settings.SUPABASE_KEY
        )
    
    async def create_user(self, email: str, password: str, username: str) -> Optional[Dict[str, Any]]:
        """Create a new user in Supabase Auth and Database."""
        try:
            # Create user in Supabase Auth
            auth_response = self.supabase.auth.sign_up({
                "email": email,
                "password": password
            })
            
            if auth_response.user:
                # Add additional user data to profiles table
                profile_data = {
                    "id": auth_response.user.id,
                    "username": username,
                    "email": email,
                    "role": "user",
                    "is_verified": False
                }
                
                profile_response = self.supabase.table("profiles").insert(profile_data).execute()
                
                return {
                    "user_id": auth_response.user.id,
                    "email": email,
                    "username": username
                }
            
        except Exception as e:
            logger.error(f"Error creating user: {e}")
            return None
    
    async def sign_in_user(self, email: str, password: str) -> Optional[Dict[str, Any]]:
        """Sign in user and return session data."""
        try:
            response = self.supabase.auth.sign_in_with_password({
                "email": email,
                "password": password
            })
            
            if response.user and response.session:
                # Get user profile data
                profile = self.supabase.table("profiles").select("*").eq("id", response.user.id).single().execute()
                
                return {
                    "user": response.user,
                    "session": response.session,
                    "profile": profile.data if profile.data else None
                }
            
        except Exception as e:
            logger.error(f"Error signing in user: {e}")
            return None
    
    async def get_user_profile(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Get user profile from database."""
        try:
            response = self.supabase.table("profiles").select("*").eq("id", user_id).single().execute()
            return response.data if response.data else None
        except Exception as e:
            logger.error(f"Error getting user profile: {e}")
            return None
    
    async def update_user_profile(self, user_id: str, data: Dict[str, Any]) -> bool:
        """Update user profile in database."""
        try:
            response = self.supabase.table("profiles").update(data).eq("id", user_id).execute()
            return bool(response.data)
        except Exception as e:
            logger.error(f"Error updating user profile: {e}")
            return False
    
    async def create_asset(self, asset_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Create a new asset in the database."""
        try:
            response = self.supabase.table("assets").insert(asset_data).execute()
            return response.data[0] if response.data else None
        except Exception as e:
            logger.error(f"Error creating asset: {e}")
            return None
    
    async def get_assets(self, limit: int = 20, offset: int = 0) -> list:
        """Get assets from database."""
        try:
            response = self.supabase.table("assets").select("*").range(offset, offset + limit - 1).execute()
            return response.data if response.data else []
        except Exception as e:
            logger.error(f"Error getting assets: {e}")
            return []

# Global instance
supabase_service = SupabaseService() 