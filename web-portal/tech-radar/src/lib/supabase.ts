import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || 'https://nnneohqytsemmwpufwtv.supabase.co'
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ubmVvaHF5dHNlbW13cHVmd3R2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA1OTU3NzEsImV4cCI6MjA2NjE3MTc3MX0.PnojgXWf9n34CNTRy2tWTQFjeUqUfH-WGjvh8ygS82A'

console.log('Supabase URL:', supabaseUrl);

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  }
})

// Database types for TypeScript
export interface Profile {
  id: string
  username: string
  email: string
  role: 'user' | 'moderator' | 'admin' | 'superadmin'
  is_verified: boolean
  is_active: boolean
  created_at: string
  updated_at: string
  last_login?: string
  has_validated_invite_code?: boolean // Added for invite gate logic
}

export interface Asset {
  id: number
  name: string
  description?: string
  is_public: boolean
  prompt?: string
  style?: string
  model_url: string
  thumbnail_url?: string
  price: number
  is_for_sale: boolean
  owner_id: string
  created_at: string
  updated_at: string
}

export interface CommunityTheme {
  id: number
  title: string
  description?: string
  prompt: string
  style?: string
  submitted_by: string
  votes_count: number
  is_approved: boolean
  created_at: string
} 