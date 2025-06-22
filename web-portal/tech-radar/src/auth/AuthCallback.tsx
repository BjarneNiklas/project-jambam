import React, { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useAuth } from './AuthContext';

const AuthCallback: React.FC = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { isAuthenticated, loading, user } = useAuth(); // Added user for logging
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string>('Anmeldung wird verarbeitet...');

  useEffect(() => {
    console.log('[AuthCallback] useEffect triggered. Current state: isAuthenticated:', isAuthenticated, 'loading:', loading, 'User ID:', user?.id);
    console.log('[AuthCallback] Search params:', searchParams.toString());

    // Check for error parameters in URL first
    const errorParam = searchParams.get('error');
    const errorCode = searchParams.get('error_code');
    const errorDescription = searchParams.get('error_description');
    
    if (errorParam || errorCode || errorDescription) {
      const fullError = `OAuth error: ${errorParam || 'N/A'}, Code: ${errorCode || 'N/A'}, Desc: ${errorDescription || 'N/A'}`;
      console.error(`[AuthCallback] ${fullError}`);
      setError(errorDescription || 'OAuth-Anmeldung fehlgeschlagen. Details im Log.');
      setMessage(`Fehler: ${errorDescription || 'OAuth-Anmeldung fehlgeschlagen.'}`);
      setTimeout(() => {
        navigate('/login?error=oauth_failed');
      }, 5000);
      return;
    }

    console.log('[AuthCallback] About to check loading state. Current loading:', loading);
    // We wait until the loading is false
    if (!loading) {
      console.log('[AuthCallback] Loading is false. Checking isAuthenticated. Current isAuthenticated:', isAuthenticated);
      if (isAuthenticated) {
        console.log('[AuthCallback] User is authenticated. Navigating to /tech-radar.');
        setMessage('Erfolgreich angemeldet! Weiterleitung...');
        // Ensure navigation happens after message update if desired, though usually not critical
        setTimeout(() => navigate('/tech-radar'), 100);
      } else {
        console.warn('[AuthCallback] Loading is false, but user is NOT authenticated. This might be an issue.');
        setError('Anmeldung konnte nicht abgeschlossen werden. Bitte versuchen Sie es erneut oder kontaktieren Sie den Support.');
        setMessage('Anmeldung fehlgeschlagen. Du wirst zur Login-Seite weitergeleitet...');
        setTimeout(() => {
          navigate('/login?error=callback_auth_failed');
        }, 5000);
      }
    } else {
      console.log('[AuthCallback] Still loading. Waiting for loading to become false.');
      setMessage('Anmeldung wird überprüft und abgeschlossen...');
    }
  }, [isAuthenticated, loading, navigate, searchParams, user]);

  if (error) {
    return (
      <div className="auth-callback">
        <div className="error-container">
          <div className="error-icon">❌</div>
          <h2>Anmeldung fehlgeschlagen</h2>
          <p>{error}</p> {/* This will display the error state */}
          <p>{message}</p> {/* This will display the message state */}
        </div>
      </div>
    );
  }

  return (
    <div className="auth-callback">
      <div className="loading-container">
        <div className="loading-spinner"></div>
        <p>{message}</p> {/* Display dynamic message here as well */}
      </div>
    </div>
  );
};

export default AuthCallback; 