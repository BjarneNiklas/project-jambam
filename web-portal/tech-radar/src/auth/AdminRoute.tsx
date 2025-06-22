import React from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from './AuthContext';

const AdminRoute: React.FC = () => {
  const { isAuthenticated, profile, loading } = useAuth();

  if (loading) {
    return <div>Lade...</div>;
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  if (!profile || !['admin', 'moderator', 'superadmin'].includes(profile.role)) {
    return <Navigate to="/" replace />;
  }

  return <Outlet />;
};

export default AdminRoute; 