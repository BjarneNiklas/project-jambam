#!/usr/bin/env python3
"""
Fix Supabase RLS Policies Script
This script fixes the infinite recursion issue in the profiles table RLS policies.
"""

import os
import sys
from supabase import create_client, Client
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def get_supabase_client() -> Client:
    """Create and return Supabase client."""
    url = os.getenv('SUPABASE_URL')
    key = os.getenv('SUPABASE_SERVICE_ROLE_KEY')  # Use service role key for admin operations
    
    if not url or not key:
        print("❌ Error: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set in environment variables")
        sys.exit(1)
    
    return create_client(url, key)

def fix_rls_policies():
    """Fix the RLS policies that are causing infinite recursion."""
    supabase = get_supabase_client()
    
    print("🔧 Fixing Supabase RLS policies...")
    
    try:
        # Drop the problematic policies first
        print("📝 Dropping problematic policies...")
        
        # Drop the superadmin policy that causes infinite recursion
        supabase.rpc('exec_sql', {
            'sql': '''
            DROP POLICY IF EXISTS "Superadmins have full access to profiles" ON profiles;
            DROP POLICY IF EXISTS "Admins and Superadmins can manage all invite codes" ON invite_codes;
            '''
        })
        
        # Create the fixed policies
        print("📝 Creating fixed policies...")
        
        # Create is_admin_user function
        supabase.rpc('exec_sql', {
            'sql': '''
            CREATE OR REPLACE FUNCTION is_admin_user()
            RETURNS BOOLEAN AS $$
            BEGIN
              -- Check if user has admin role in JWT claims
              RETURN (auth.jwt() ->> 'role')::text = 'authenticated' AND
                     (auth.jwt() ->> 'app_metadata')::jsonb ->> 'role' IN ('admin', 'superadmin');
            END;
            $$ LANGUAGE plpgsql SECURITY DEFINER;
            '''
        })
        
        # Create fixed superadmin policy
        supabase.rpc('exec_sql', {
            'sql': '''
            CREATE POLICY "Superadmins have full access to profiles" ON profiles
              FOR ALL USING (
                (auth.jwt() ->> 'role')::text = 'authenticated' AND
                (auth.jwt() ->> 'app_metadata')::jsonb ->> 'role' = 'superadmin'
              );
            '''
        })
        
        # Create fixed admin policy for invite codes
        supabase.rpc('exec_sql', {
            'sql': '''
            CREATE POLICY "Admins and Superadmins can manage all invite codes" ON invite_codes
              FOR ALL USING (is_admin_user());
            '''
        })
        
        print("✅ RLS policies fixed successfully!")
        
    except Exception as e:
        print(f"❌ Error fixing RLS policies: {e}")
        return False
    
    return True

def test_profile_access():
    """Test if profile access works after the fix."""
    supabase = get_supabase_client()
    
    print("🧪 Testing profile access...")
    
    try:
        # Try to fetch a profile (this should work now)
        result = supabase.table('profiles').select('*').limit(1).execute()
        print("✅ Profile access test successful!")
        return True
    except Exception as e:
        print(f"❌ Profile access test failed: {e}")
        return False

def main():
    """Main function."""
    print("🚀 Starting Supabase RLS Policy Fix...")
    
    # Fix the policies
    if not fix_rls_policies():
        print("❌ Failed to fix RLS policies")
        sys.exit(1)
    
    # Test the fix
    if not test_profile_access():
        print("❌ Profile access test failed")
        sys.exit(1)
    
    print("🎉 All done! The infinite recursion issue should be resolved.")
    print("💡 You may need to restart your Flutter app to see the changes.")

if __name__ == "__main__":
    main() 