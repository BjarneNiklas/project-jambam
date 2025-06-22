import React, { createContext, useContext, useState, ReactNode, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import type { User } from '@supabase/supabase-js';
import type { Profile } from '../lib/supabase';

interface AuthContextType {
  isAuthenticated: boolean;
  isProfileComplete: boolean;
  user: User | null;
  profile: Profile | null;
  login: (email: string, password: string) => Promise<{ success: boolean; error?: string }>;
  loginWithGoogle: () => Promise<boolean>;
  loginWithDiscord: () => Promise<boolean>;
  loginWithGitHub: () => Promise<boolean>;
  register: (email: string, password: string) => Promise<{ success: boolean; error?: string }>;
  logout: () => Promise<void>;
  loading: boolean;
  refreshProfile: () => Promise<void>;
  // New additions for confidential gate
  currentUserHasValidatedInvite: boolean;
  hasSessionPassedGate: boolean;
  validateSharedPassword: (password: string) => Promise<boolean>;
  validateInviteCodeForGate: (inviteCode: string) => Promise<boolean>;
  clearSessionGatePass: () => void; // To reset session pass on logout or timeout
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [isProfileComplete, setIsProfileComplete] = useState(false);
  // New states for confidential gate
  const [currentUserHasValidatedInvite, setCurrentUserHasValidatedInvite] = useState(false);
  const [hasSessionPassedGate, setHasSessionPassedGate] = useState(false);


  const fetchProfile = useCallback(async (user: User) => {
    if (!user) {
      setIsProfileComplete(false);
      setCurrentUserHasValidatedInvite(false); // Reset on no user
      return;
    };
    
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*, has_validated_invite_code') // Ensure new field is selected
        .eq('id', user.id)
        .single();

      if (data) {
        setProfile(data);
        setIsProfileComplete(!!data.username);
        // Set invite status from profile
        setCurrentUserHasValidatedInvite(data.has_validated_invite_code || false);
        console.log('Profile fetched:', data);
      } else if (error && error.code === 'PGRST116') { // Profile not found, create it
        console.log('Profile not found for user, creating one...');
        const { data: newProfile, error: insertError } = await supabase
          .from('profiles')
          .insert({
            id: user.id,
            email: user.email!,
            has_validated_invite_code: false // Default for new profile
          })
          .select('*, has_validated_invite_code')
          .single();

        if (insertError) {
          console.error('Error creating profile:', insertError);
          setIsProfileComplete(false);
          setCurrentUserHasValidatedInvite(false);
        } else {
          setProfile(newProfile);
          setIsProfileComplete(!!newProfile.username);
          setCurrentUserHasValidatedInvite(newProfile.has_validated_invite_code || false);
          console.log('New profile created:', newProfile);
        }
      } else if (error) {
        console.error('Error fetching profile:', error);
        setIsProfileComplete(false);
        setCurrentUserHasValidatedInvite(false);
      }
    } catch (error) {
      console.error('Exception while fetching profile:', error);
      setIsProfileComplete(false);
      setCurrentUserHasValidatedInvite(false);
    }
  }, []);

  useEffect(() => {
    setLoading(true);
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (_event, session) => {
      if (session?.user) {
        await fetchProfile(session.user); // This will now also update currentUserHasValidatedInvite
        setUser(session.user);
        setIsAuthenticated(true);
      } else {
        setUser(null);
        setProfile(null);
        setIsAuthenticated(false);
        setCurrentUserHasValidatedInvite(false); // Reset on logout
        setHasSessionPassedGate(false); // Reset session gate pass on logout
      }
      setLoading(false);
    });

    return () => {
      subscription.unsubscribe();
    };
  }, [fetchProfile]);

  const login = async (email: string, password: string): Promise<{ success: boolean; error?: string }> => {
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        console.error('Login error:', error.message);
        return { success: false, error: error.message };
      }

      return { success: true }; // onAuthStateChange will handle the rest
    } catch (error) {
      console.error('Login error:', error);
      return { success: false, error: error instanceof Error ? error.message : 'An error occurred' };
    }
  };

  const loginWithProvider = async (provider: 'google' | 'discord' | 'github'): Promise<boolean> => {
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider,
        options: {
          redirectTo: `${window.location.origin}/auth/callback`
        }
      });

      if (error) {
        console.error(`${provider} login error:`, error.message);
        return false;
      }

      return true;
    } catch (error) {
      console.error(`${provider} login error:`, error);
      return false;
    }
  };

  const loginWithGoogle = () => loginWithProvider('google');
  const loginWithDiscord = () => loginWithProvider('discord');
  const loginWithGitHub = () => loginWithProvider('github');

  const register = async (email: string, password: string): Promise<{ success: boolean; error?: string }> => {
    try {
      console.log('=== REGISTRATION START (v3 - Email/Pass Only) ===');
      console.log('Attempting registration for:', { email, passwordLength: password.length });
      
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          emailRedirectTo: `${window.location.origin}/auth/callback`
        },
      });

      if (error) {
        console.error('Registration auth error:', error.message);
        if (error.message.includes('already registered')) {
          return { success: false, error: 'Diese E-Mail-Adresse ist bereits registriert.' };
        }
        if (error.message.includes('fetch')) {
          return { success: false, error: 'Verbindungsproblem. Bitte versuchen Sie es erneut.' };
        }
        return { success: false, error: `Authentifizierungsfehler: ${error.message}` };
      }

      if (!data.user) {
        console.error('No user object returned from signUp.');
        return { success: false, error: 'Benutzer konnte nicht erstellt werden.' };
      }

      console.log('User created in auth successfully:', data.user.id);
      
      if (data.session) {
        console.log('User is immediately signed in');
        return { success: true };
      } else {
        console.log('Email confirmation required');
        return { success: true, error: 'Fast geschafft! Bitte bestätigen Sie Ihre E-Mail-Adresse.' };
      }

    } catch (error) {
      console.error('Registration exception:', error);
      return { success: false, error: 'Ein unerwarteter Fehler ist aufgetreten.' };
    } finally {
      console.log('=== REGISTRATION END (v3) ===');
    }
  };

  const logout = async () => {
    try {
      await supabase.auth.signOut();
      // onAuthStateChange will handle setting state (including resetting gate statuses)
    } catch (error) {
      console.error('Logout error:', error);
    }
  };

  const refreshProfile = async () => {
    if (user) {
        console.log("Refreshing profile for user:", user.id);
        await fetchProfile(user); // This will update invite status too
    }
  };

  const clearSessionGatePass = () => {
    setHasSessionPassedGate(false);
  };

  const validateSharedPassword = async (password: string): Promise<boolean> => {
    if (!profile) { // Should not happen if user is logged in
      console.error("validateSharedPassword: No profile found for logged-in user.");
      return false;
    }
    try {
      // In a real scenario, the key 'shared_content_password' should be configurable
      // And ideally, this check happens in an Edge Function for better security
      const { data, error } = await supabase
        .from('app_config')
        .select('value')
        .eq('key', 'shared_content_password')
        .single();

      if (error) {
        console.error('Error fetching shared password:', error);
        return false;
      }

      if (data && data.value === password) {
        setHasSessionPassedGate(true);
        return true;
      }
      return false;
    } catch (e) {
      console.error('Exception validating shared password:', e);
      return false;
    }
  };

  const validateInviteCodeForGate = async (inviteCode: string): Promise<boolean> => {
    if (!user || !profile) {
      console.error("validateInviteCodeForGate: User or profile not available.");
      return false;
    }

    try {
      // 1. Check if the code is valid and unused
      const { data: codeData, error: codeError } = await supabase
        .from('invite_codes')
        .select('*')
        .eq('code', inviteCode)
        .eq('is_used', false)
        .single();

      if (codeError || !codeData) {
        console.error('Error fetching invite code or code is invalid/used:', codeError);
        return false;
      }

      // 2. Mark invite code as used
      const { error: updateCodeError } = await supabase
        .from('invite_codes')
        .update({
          is_used: true,
          used_by: user.id,
          used_at: new Date().toISOString()
        })
        .eq('code', inviteCode);

      if (updateCodeError) {
        console.error('Error marking invite code as used:', updateCodeError);
        // Potentially roll back or handle this error more gracefully
        return false;
      }

      // 3. Update user's profile
      const { error: updateProfileError } = await supabase
        .from('profiles')
        .update({ has_validated_invite_code: true })
        .eq('id', user.id);

      if (updateProfileError) {
        console.error('Error updating profile for invite code:', updateProfileError);
        // Potentially roll back invite code usage or handle error
        return false;
      }

      // 4. Refresh profile to update context state
      await refreshProfile();
      return true;

    } catch (e) {
      console.error('Exception validating invite code for gate:', e);
      return false;
    }
  };

  return (
    <AuthContext.Provider value={{ 
      isAuthenticated, 
      isProfileComplete,
      user, 
      profile,
      login, 
      loginWithGoogle,
      loginWithDiscord,
      loginWithGitHub,
      register, 
      logout, 
      loading,
      refreshProfile,
      // New additions
      currentUserHasValidatedInvite,
      hasSessionPassedGate,
      validateSharedPassword,
      validateInviteCodeForGate,
      clearSessionGatePass
    }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}; 