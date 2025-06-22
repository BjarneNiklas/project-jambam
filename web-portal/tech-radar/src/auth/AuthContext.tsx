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
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [isProfileComplete, setIsProfileComplete] = useState(false);

  const fetchProfile = useCallback(async (user: User) => {
    console.log('[AuthContext] fetchProfile: Starting for user ID:', user.id);
    if (!user) {
      console.warn('[AuthContext] fetchProfile: Called with no user.');
      setIsProfileComplete(false);
      return;
    };
    
    try {
      console.log('[AuthContext] fetchProfile: Attempting to select profile for user ID:', user.id);
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single();

      if (data) {
        setProfile(data);
        setIsProfileComplete(!!data.username);
        console.log('[AuthContext] fetchProfile: Profile found and set. Username:', data.username, 'isProfileComplete:', !!data.username);
      } else if (error && error.code === 'PGRST116') { // Profile not found, create it
        console.log('[AuthContext] fetchProfile: Profile not found (PGRST116), creating one for user ID:', user.id);
        const { data: newProfile, error: insertError } = await supabase
          .from('profiles')
          .insert({ id: user.id, email: user.email! })
          .select()
          .single();

        if (insertError) {
          console.error('[AuthContext] fetchProfile: Error creating profile:', insertError);
          setIsProfileComplete(false);
        } else {
          setProfile(newProfile);
          setIsProfileComplete(!!newProfile?.username); // Added optional chaining for safety
          console.log('[AuthContext] fetchProfile: New profile created. Username:', newProfile?.username, 'isProfileComplete:', !!newProfile?.username);
        }
      } else if (error) {
        console.error('[AuthContext] fetchProfile: Error fetching profile (other than PGRST116):', error);
        setIsProfileComplete(false);
      } else {
        // This case means no data and no error, which might imply profile doesn't exist but no PGRST116.
        // Or, it could be a non-standard error object.
        console.warn('[AuthContext] fetchProfile: No profile data and no specific error code. Assuming profile needs creation or investigation.');
        setIsProfileComplete(false); // Default to incomplete.
      }
    } catch (error) {
      console.error('[AuthContext] fetchProfile: Exception during profile fetch/creation:', error);
      setIsProfileComplete(false);
    }
    console.log('[AuthContext] fetchProfile: Finished for user ID:', user.id);
  }, []);

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
        setLoading(true); // Indicate loading state before async profile fetch
        console.log('[AuthContext] onAuthStateChange: Session and user found. setLoading(true). Calling fetchProfile.');
        await fetchProfile(session.user);
        console.log('[AuthContext] onAuthStateChange: fetchProfile completed.');
        setUser(session.user);
        setIsAuthenticated(true);
        console.log(`[AuthContext] onAuthStateChange: State updated: isAuthenticated: true, user set for ID: ${session.user.id}`);
      } else {
        console.log('[AuthContext] onAuthStateChange: No session or user. Resetting auth state.');
        setUser(null);
        setProfile(null);
        setIsAuthenticated(false);
        console.log('[AuthContext] onAuthStateChange: State updated: isAuthenticated: false, user/profile null.');
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
      // onAuthStateChange will handle setting state
    } catch (error) {
      console.error('Logout error:', error);
    }
  };

  const refreshProfile = async () => {
    if (user) {
        console.log("Refreshing profile for user:", user.id);
        await fetchProfile(user);
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
      refreshProfile
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