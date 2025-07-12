-- Fix Supabase RLS Policies
-- Run this in your Supabase SQL Editor to fix the infinite recursion issue

-- Step 1: Drop the problematic policies
DROP POLICY IF EXISTS "Superadmins have full access to profiles" ON profiles;
DROP POLICY IF EXISTS "Admins and Superadmins can manage all invite codes" ON invite_codes;

-- Step 2: Create the is_admin_user function
CREATE OR REPLACE FUNCTION is_admin_user()
RETURNS BOOLEAN AS $$
BEGIN
  -- Check if user has admin role in JWT claims
  RETURN (auth.jwt() ->> 'role')::text = 'authenticated' AND
         (auth.jwt() ->> 'app_metadata')::jsonb ->> 'role' IN ('admin', 'superadmin');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 3: Create the fixed superadmin policy for profiles
CREATE POLICY "Superadmins have full access to profiles" ON profiles
  FOR ALL USING (
    (auth.jwt() ->> 'role')::text = 'authenticated' AND
    (auth.jwt() ->> 'app_metadata')::jsonb ->> 'role' = 'superadmin'
  );

-- Step 4: Create the fixed admin policy for invite codes
CREATE POLICY "Admins and Superadmins can manage all invite codes" ON invite_codes
  FOR ALL USING (is_admin_user());

-- Step 5: Test the fix by trying to select from profiles
-- This should work without infinite recursion
SELECT COUNT(*) FROM profiles LIMIT 1; 