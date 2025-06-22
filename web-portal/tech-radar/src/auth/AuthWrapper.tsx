import React from 'react';
import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useAuth } from './AuthContext';

const AuthWrapper = () => {
    const { isAuthenticated, isProfileComplete, loading } = useAuth();
    const location = useLocation();

    if (loading) {
        return <div>Wird geladen...</div>; // Oder einen schöneren Spinner
    }

    // Authenticated but incomplete profile
    if (isAuthenticated && !isProfileComplete) {
        // If not already on setup page, redirect there
        if (location.pathname !== '/profile-setup') {
            return <Navigate to="/profile-setup" replace />;
        }
    }

    // Authenticated and complete profile
    if (isAuthenticated && isProfileComplete) {
        // If trying to access login, register, or setup page, redirect to main app
        if (['/login', '/register', '/profile-setup'].includes(location.pathname)) {
            return <Navigate to="/tech-radar" replace />;
        }
    }
    
    // Unauthenticated user trying to access a protected page (including profile-setup)
    // This is a bit redundant with ProtectedRoute, but provides an extra layer of security
    // and handles the /profile-setup case cleanly.
    if (!isAuthenticated && location.pathname === '/profile-setup') {
        return <Navigate to="/login" replace />;
    }

    // In all other cases, render the requested route.
    return <Outlet />;
};

export default AuthWrapper; 