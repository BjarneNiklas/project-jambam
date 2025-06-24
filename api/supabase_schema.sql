-- =================================================================
--  Project-Jambam Supabase Schema
--  Version: 1.1
--  Author: Bjarne, Gemini AI
--  Description: Full schema including tables, RLS, and functions.
-- =================================================================

-- -----------------------------------------------------------------
-- Section 1: Tables
-- -----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT DEFAULT 'user' CHECK (role IN ('user', 'moderator', 'admin', 'superadmin')),
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS organizations (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS organization_memberships (
    id SERIAL PRIMARY KEY,
    organization_id INTEGER REFERENCES organizations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    role TEXT DEFAULT 'member' CHECK (role IN ('member', 'admin', 'owner')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(organization_id, user_id)
);

CREATE TABLE IF NOT EXISTS license_types (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    allows_commercial_use BOOLEAN DEFAULT FALSE,
    allows_modification BOOLEAN DEFAULT FALSE,
    allows_redistribution BOOLEAN DEFAULT FALSE,
    requires_attribution BOOLEAN DEFAULT TRUE,
    max_users INTEGER,
    max_revenue DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assets (
    id SERIAL PRIMARY KEY,
    name TEXT DEFAULT 'Untitled Asset',
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    prompt TEXT,
    style TEXT,
    model_url TEXT NOT NULL,
    thumbnail_url TEXT,
    price DECIMAL(10,2) DEFAULT 0.0,
    is_for_sale BOOLEAN DEFAULT FALSE,
    max_quantity INTEGER,
    current_quantity_sold INTEGER DEFAULT 0,
    available_until TIMESTAMP WITH TIME ZONE,
    exclusive_to_organization_id INTEGER REFERENCES organizations(id),
    exclusivity_level TEXT DEFAULT 'public' CHECK (exclusivity_level IN ('public', 'organization', 'exclusive')),
    owner_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    remix_of_asset_id INTEGER REFERENCES assets(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS asset_licenses (
    id SERIAL PRIMARY KEY,
    asset_id INTEGER REFERENCES assets(id) ON DELETE CASCADE,
    license_type_id INTEGER REFERENCES license_types(id) ON DELETE CASCADE,
    price DECIMAL(10,2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS license_purchases (
    id SERIAL PRIMARY KEY,
    asset_license_id INTEGER REFERENCES asset_licenses(id) ON DELETE CASCADE,
    buyer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    purchase_price DECIMAL(10,2) NOT NULL,
    purchased_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    usage_count INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS asset_ownerships (
    id SERIAL PRIMARY KEY,
    asset_id INTEGER REFERENCES assets(id) ON DELETE CASCADE,
    buyer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    purchase_price DECIMAL(10,2) NOT NULL,
    purchased_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ratings (
    id SERIAL PRIMARY KEY,
    asset_id INTEGER REFERENCES assets(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    score INTEGER NOT NULL CHECK (score >= 1 AND score <= 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(asset_id, user_id)
);

CREATE TABLE IF NOT EXISTS tags (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS asset_tags (
    asset_id INTEGER REFERENCES assets(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (asset_id, tag_id)
);

CREATE TABLE IF NOT EXISTS community_themes (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    prompt TEXT NOT NULL,
    style TEXT,
    submitted_by UUID REFERENCES profiles(id) ON DELETE CASCADE,
    votes_count INTEGER DEFAULT 0,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS invite_codes (
  code TEXT PRIMARY KEY,
  is_used BOOLEAN DEFAULT FALSE,
  used_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  used_at TIMESTAMP WITH TIME ZONE
);

-- Admin Audit Log
CREATE TABLE IF NOT EXISTS admin_audit_log (
    id SERIAL PRIMARY KEY,
    admin_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    action TEXT NOT NULL,
    target_type TEXT NOT NULL,
    target_id TEXT,
    details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- -----------------------------------------------------------------
-- Section 2: Indexes
-- -----------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_assets_owner_id ON assets(owner_id);
CREATE INDEX IF NOT EXISTS idx_assets_is_public ON assets(is_public);
CREATE INDEX IF NOT EXISTS idx_assets_created_at ON assets(created_at);
CREATE INDEX IF NOT EXISTS idx_ratings_asset_id ON ratings(asset_id);
CREATE INDEX IF NOT EXISTS idx_asset_tags_asset_id ON asset_tags(asset_id);
CREATE INDEX IF NOT EXISTS idx_asset_tags_tag_id ON asset_tags(tag_id);

-- -----------------------------------------------------------------
-- Section 3: Functions and Triggers
-- -----------------------------------------------------------------

-- Function to handle user creation from auth.users
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username, email, role, is_verified)
  VALUES (
    NEW.id,
    -- Use the user's ID as a guaranteed unique username.
    -- The user can change this in their profile settings later.
    NEW.id::text,
    NEW.email,
    'user',
    TRUE
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to automatically create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- -----------------------------------------------------------------
-- Section 4: Row Level Security (RLS)
-- -----------------------------------------------------------------

-- Enable RLS on all relevant tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE organization_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_themes ENABLE ROW LEVEL SECURITY;
ALTER TABLE invite_codes ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
CREATE POLICY "Users can view their own profile" ON profiles
    FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
CREATE POLICY "Users can update their own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile" ON public.profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Superadmins have full access to profiles" ON profiles;
CREATE POLICY "Superadmins have full access to profiles" ON profiles
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role = 'superadmin'
    )
  );

-- RLS Policies for assets
DROP POLICY IF EXISTS "Public assets are viewable by everyone" ON assets;
CREATE POLICY "Public assets are viewable by everyone" ON assets
    FOR SELECT USING (is_public = true);

DROP POLICY IF EXISTS "Users can view their own assets" ON assets;
CREATE POLICY "Users can view their own assets" ON assets
    FOR SELECT USING (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Users can create assets" ON assets;
CREATE POLICY "Users can create assets" ON assets
    FOR INSERT WITH CHECK (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Users can update their own assets" ON assets;
CREATE POLICY "Users can update their own assets" ON assets
    FOR UPDATE USING (auth.uid() = owner_id);

-- RLS Policies for invite_codes
DROP POLICY IF EXISTS "Allow public read access to invite codes" ON invite_codes;
CREATE POLICY "Allow public read access to invite codes" ON invite_codes
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow users to update their own invite code" ON invite_codes;
CREATE POLICY "Allow users to update their own invite code" ON invite_codes
  FOR UPDATE USING (auth.uid() = used_by);

DROP POLICY IF EXISTS "Admins and Superadmins can manage all invite codes" ON invite_codes;
CREATE POLICY "Admins and Superadmins can manage all invite codes" ON invite_codes
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.role IN ('admin', 'superadmin')
    )
  );

-- -----------------------------------------------------------------
-- Section 5: Default Data
-- -----------------------------------------------------------------

INSERT INTO license_types (name, description, allows_commercial_use, allows_modification, allows_redistribution, requires_attribution, max_users, max_revenue) VALUES
('personal', 'Personal use only. No commercial usage allowed.', FALSE, FALSE, FALSE, TRUE, 1, NULL),
('commercial', 'Commercial use allowed. No redistribution.', TRUE, FALSE, FALSE, TRUE, 5, 10000.00),
('enterprise', 'Full commercial rights with modification and redistribution.', TRUE, TRUE, TRUE, FALSE, NULL, NULL)
ON CONFLICT (name) DO NOTHING; 