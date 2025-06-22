import React, { useState, useEffect } from 'react';
import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useAuth } from './AuthContext';
import ConfidentialGate from '../components/ConfidentialGate'; // Import the gate

const ProtectedRoute: React.FC = () => {
  const {
    isAuthenticated,
    currentUserHasValidatedInvite,
    hasSessionPassedGate,
    loading: authLoading // Auth context loading state
  } = useAuth();
  const location = useLocation();

  // This local state helps manage the gate visibility after successful validation within the session
  // but before a potential re-render triggered by context changes (e.g. profile update).
  const [gatePassedThisRender, setGatePassedThisRender] = useState(false);

  // Determine if the gate should be shown
  const needsToPassGate = isAuthenticated && !currentUserHasValidatedInvite && !hasSessionPassedGate && !gatePassedThisRender;

  useEffect(() => {
    // If the user has a validated invite or session pass from context, ensure gatePassedThisRender is also true.
    // This handles cases where the context updates while the component is mounted.
    if (currentUserHasValidatedInvite || hasSessionPassedGate) {
      setGatePassedThisRender(true);
    }
    // If user logs out or conditions change, reset gatePassedThisRender if it was true
    // This is implicitly handled as hasSessionPassedGate would be false on logout.
    // And if they no longer need to pass the gate, we don't need to force it closed here.
  }, [currentUserHasValidatedInvite, hasSessionPassedGate]);


  if (authLoading) {
    // Optional: Show a loading spinner or a blank page while auth state is being determined.
    // This prevents flashing the login page or gate momentarily.
    return (
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
            {/* You can use a proper spinner component here */}
            Loading authentication...
        </div>
    );
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  if (needsToPassGate) {
    return (
      <ConfidentialGate
        onSuccess={() => {
          // When the gate is passed successfully (either by shared pass or new invite code):
          // 1. If it was a shared password, `hasSessionPassedGate` in context is now true.
          // 2. If it was an invite code, `currentUserHasValidatedInvite` in context will become true after profile refresh.
          // Setting local state `gatePassedThisRender` ensures immediate UI update.
          setGatePassedThisRender(true);
        }}
      />
    );
  }

  // If authenticated and (already validated invite OR passed gate in session OR just passed gate now)
  return <Outlet />;
};

export default ProtectedRoute; 