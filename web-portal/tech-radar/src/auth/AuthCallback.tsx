import React, { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useAuth } from './AuthContext';

const AuthCallback: React.FC = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const { isAuthenticated, loading } = useAuth();
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    // Check for error parameters in URL
    const errorParam = searchParams.get('error');
    const errorDescription = searchParams.get('error_description');
    
    if (errorParam) {
      console.error('OAuth error:', errorParam, errorDescription);
      setError(errorDescription || 'OAuth-Anmeldung fehlgeschlagen');
      setTimeout(() => {
        navigate('/login?error=authentication_failed');
      }, 3000);
      return;
    }

    // We wait until the loading is false
    if (!loading) {
      if (isAuthenticated) {
        // If authenticated, redirect to the main app page
        navigate('/tech-radar');
      } else {
        // If not, there might have been an error during the process
        setError('Anmeldung konnte nicht abgeschlossen werden');
        setTimeout(() => {
          navigate('/login?error=authentication_failed');
        }, 3000);
      }
    }
  }, [isAuthenticated, loading, navigate, searchParams]);

  if (error) {
    return (
      <div className="auth-callback">
        <div className="error-container">
          <div className="error-icon">❌</div>
          <h2>Anmeldung fehlgeschlagen</h2>
          <p>{error}</p>
          <p>Du wirst zur Login-Seite weitergeleitet...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="auth-callback">
      <div className="loading-container">
        <div className="loading-spinner"></div>
        <p>Anmeldung wird verarbeitet...</p>
      </div>
    </div>
  );
};

export default AuthCallback; 