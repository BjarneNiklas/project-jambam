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


  const fetchProfile = useCallback(async (currentUser: User) => {
    console.log('[AuthContext] fetchProfile: Starting for user ID:', currentUser.id);
    if (!currentUser) {
      console.warn('[AuthContext] fetchProfile: Called with no user.');
      setIsProfileComplete(false);
      setCurrentUserHasValidatedInvite(false); // Reset on no user
      return;
    };
    
    try {
      console.log('[AuthContext] fetchProfile: Attempting to select profile for user ID:', user.id);
      const { data, error } = await supabase
        .from('profiles')
        .select('*, has_validated_invite_code') // Ensure new field is selected
        .eq('id', user.id)
        .single();

      if (data) {
        setProfile(data);
        setIsProfileComplete(!!data.username);
        setCurrentUserHasValidatedInvite(data.has_validated_invite_code || false);
        console.log('Profile fetched:', data);
      } else if (error && error.code === 'PGRST116') {
        console.log('[AuthContext] fetchProfile: Profile not found (PGRST116), creating one for user ID:', user.id);
        const { data: newProfile, error: insertError } = await supabase
          .from('profiles')
          .insert({
            id: user.id,
            email: user.email!,
            has_validated_invite_code: false
          })
          .select('*, has_validated_invite_code')
          .single();

        if (insertError) {
          console.error('[AuthContext] fetchProfile: Error creating profile:', insertError);
          setIsProfileComplete(false);
          setCurrentUserHasValidatedInvite(false);
        } else {
          setProfile(newProfile);
          setIsProfileComplete(!!newProfile.username);
          setCurrentUserHasValidatedInvite(newProfile.has_validated_invite_code || false);
          console.log('New profile created:', newProfile);
        }
      } else if (error) {
        console.error('[AuthContext] fetchProfile: Error fetching profile (other than PGRST116):', error);
        setIsProfileComplete(false);
        setCurrentUserHasValidatedInvite(false);
      }
    } catch (error) {
      console.error('[AuthContext] fetchProfile: Exception during profile fetch/creation:', error);
      setIsProfileComplete(false);
      setCurrentUserHasValidatedInvite(false);
    }
    console.log('[AuthContext] fetchProfile: Finished for user ID:', user.id);
  }, []); // fetchProfile depends on supabase, but supabase client instance is stable.

  useEffect(() => {
    console.log('[AuthContext] useEffect: Setting up onAuthStateChange listener.');

    // Initial check for session to set initial loading state correctly.
    (async () => {
      console.log('[AuthContext] useEffect: Performing initial getSession check.');
      const { data: { session: initialSession } } = await supabase.auth.getSession();
      console.log('[AuthContext] useEffect: Initial session present:', !!initialSession);
      if (!initialSession?.user) {
        setIsAuthenticated(false);
        setUser(null);
        setProfile(null);
        setLoading(false);
        console.log('[AuthContext] useEffect: Initial getSession check - no active session. loading: false, isAuthenticated: false.');
      } else {
        // If there IS an initial session, onAuthStateChange will likely fire with INITIAL_SESSION
        // and handle it, including fetchProfile and setting loading states.
        // Set loading true here, anticipating that event or direct processing if onAuthStateChange is quick.
        setLoading(true);
        console.log('[AuthContext] useEffect: Initial getSession check - active session found. Expecting onAuthStateChange. loading: true.');
        // Optionally, you could even call the main logic here for the initial session,
        // but onAuthStateChange with INITIAL_SESSION should also cover it.
        // Forcing it here might lead to double processing if not careful.
        // Let's rely on onAuthStateChange to be the single source of truth for session processing.
      }
    })();

    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (_event, session) => {
      console.log(`[AuthContext] onAuthStateChange: Event received: ${_event}. Session present: ${!!session}. User ID: ${session?.user?.id || 'N/A'}`);
      // console.log(`[AuthContext] onAuthStateChange: Current state before this event: isAuthenticated: ${isAuthenticated}, loading: ${loading}`); // This shows state from previous render

      if (session?.user) {
        await fetchProfile(session.user); // This will now also update currentUserHasValidatedInvite
        setUser(session.user);
        setIsAuthenticated(true);
        console.log(`[AuthContext] onAuthStateChange: State updated: isAuthenticated: true, user set for ID: ${session.user.id}`);
      } else {
        console.log('[AuthContext] onAuthStateChange: No session or user. Resetting auth state.');
        setUser(null);
        setProfile(null);
        setIsAuthenticated(false);
        setCurrentUserHasValidatedInvite(false); // Reset on logout
        setHasSessionPassedGate(false); // Reset session gate pass on logout
      }
      setLoading(false);
      const finalAuthStatus = session?.user ? true : false;
      console.log(`[AuthContext] onAuthStateChange: Processing finished for event ${_event}. setLoading(false). Effective isAuthenticated for this event: ${finalAuthStatus}`);
    });

    return () => {
      console.log('[AuthContext] useEffect: Cleaning up onAuthStateChange listener.');
      subscription.unsubscribe();
    };
  }, [fetchProfile]);

  const login = useCallback(async (email: string, password: string): Promise<{ success: boolean; error?: string }> => {
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        console.error('Login error:', error.message);
        return { success: false, error: error.message };
      }
      return { success: true };
    } catch (error) {
      console.error('Login error:', error);
      return { success: false, error: error instanceof Error ? error.message : 'An error occurred' };
    }
  }, []);

  const loginWithProvider = useCallback(async (provider: 'google' | 'discord' | 'github'): Promise<boolean> => {
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
  }, []);

  const loginWithGoogle = useCallback(() => loginWithProvider('google'), [loginWithProvider]);
  const loginWithDiscord = useCallback(() => loginWithProvider('discord'), [loginWithProvider]);
  const loginWithGitHub = useCallback(() => loginWithProvider('github'), [loginWithProvider]);

  const register = useCallback(async (email: string, password: string): Promise<{ success: boolean; error?: string }> => {
    try {
      console.log('=== REGISTRATION START (v3 - Email/Pass Only) ===');
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
      
      if (data.session) {
        return { success: true };
      } else {
        return { success: true, error: 'Fast geschafft! Bitte bestätigen Sie Ihre E-Mail-Adresse.' };
      }
    } catch (error) {
      console.error('Registration exception:', error);
      return { success: false, error: 'Ein unerwarteter Fehler ist aufgetreten.' };
    } finally {
      console.log('=== REGISTRATION END (v3) ===');
    }
  }, []);

  const logout = useCallback(async () => {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      console.error('Logout error:', error);
    }
  }, []);

  const refreshProfileCb = useCallback(async () => {
    if (user) {
        console.log("Refreshing profile for user:", user.id);
        await fetchProfile(user);
    }
  }, [user, fetchProfile]);

  const clearSessionGatePass = useCallback(() => {
    setHasSessionPassedGate(false);
  }, []);

  const validateSharedPassword = useCallback(async (password: string): Promise<boolean> => {
    if (!profile) {
      console.error("validateSharedPassword: No profile found for logged-in user.");
      return false;
    }
    try {
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
  }, [profile]);

  const validateInviteCodeForGate = useCallback(async (inviteCode: string): Promise<boolean> => {
    if (!user || !profile) {
      console.error("validateInviteCodeForGate: User or profile not available.");
      return false;
    }
    try {
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
        return false;
      }

      const { error: updateProfileError } = await supabase
        .from('profiles')
        .update({ has_validated_invite_code: true })
        .eq('id', user.id);

      if (updateProfileError) {
        console.error('Error updating profile for invite code:', updateProfileError);
        return false;
      }
      await refreshProfileCb(); // Use the callback version
      return true;
    } catch (e) {
      console.error('Exception validating invite code for gate:', e);
      return false;
    }
  }, [user, profile, refreshProfileCb]);

  const contextValue = React.useMemo(() => ({
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
    refreshProfile: refreshProfileCb,
    currentUserHasValidatedInvite,
    hasSessionPassedGate,
    validateSharedPassword,
    validateInviteCodeForGate,
    clearSessionGatePass
  }), [
    isAuthenticated, isProfileComplete, user, profile, login, loginWithGoogle, loginWithDiscord, loginWithGitHub,
    register, logout, loading, refreshProfileCb, currentUserHasValidatedInvite, hasSessionPassedGate,
    validateSharedPassword, validateInviteCodeForGate, clearSessionGatePass
  ]);

  return (
    <AuthContext.Provider value={contextValue}>
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