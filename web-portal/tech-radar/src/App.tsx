import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './auth/AuthContext';
import ProtectedRoute from './auth/ProtectedRoute';
import AdminRoute from './auth/AdminRoute';
import { DarkModeProvider } from './contexts/DarkModeContext';
import { ThemeProvider } from './contexts/ThemeContext';
import Header from './components/layout/Header';
import Footer from './components/layout/Footer';
import TechRadarPage from './pages/TechRadarPage';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import SettingsPage from './pages/SettingsPage';
import AdminPanel from './components/AdminPanel';
import AboutPage from './pages/AboutPage';
import FeedPage from './pages/FeedPage';
import ProfilePage from './pages/ProfilePage';
import AuthCallback from './auth/AuthCallback';
import ProfileSetupPage from './pages/ProfileSetupPage';
import AuthWrapper from './auth/AuthWrapper';
import HomePage from './pages/HomePage';
import RoadmapPage from './pages/RoadmapPage'; // Import RoadmapPage
import ContactPage from './pages/ContactPage'; // Import ContactPage
import ThemeBackground from './components/ThemeBackground';
import './App.css';

function App() {
  return (
    <DarkModeProvider>
      <ThemeProvider>
        <AuthProvider>
          <Router>
            <div className="App">
              <Header />
              <ThemeBackground />
              <main className="main-content">
                <Routes>
                  <Route element={<AuthWrapper />}>
                    <Route path="/login" element={<LoginPage />} />
                    <Route path="/register" element={<RegisterPage />} />
                    <Route path="/profile-setup" element={<ProfileSetupPage />} />
                    <Route path="/about" element={<AboutPage />} />
                    <Route path="/feed" element={<FeedPage />} />
                    <Route path="/settings" element={<SettingsPage />} />
                    <Route path="/auth/callback" element={<AuthCallback />} />
                    <Route path="/roadmap" element={<RoadmapPage />} /> {/* Add RoadmapPage route */}
                    <Route path="/contact" element={<ContactPage />} /> {/* Add ContactPage route */}
                    <Route element={<ProtectedRoute />}>
                      <Route path="/tech-radar" element={<TechRadarPage />} />
                      <Route path="/profile" element={<ProfilePage />} />
                      <Route element={<AdminRoute />}>
                        <Route path="/admin" element={<AdminPanel />} />
                      </Route>
                    </Route>
                    <Route path="/" element={<HomePage />} />
                  </Route>
                </Routes>
              </main>
              <Footer />
            </div>
          </Router>
        </AuthProvider>
      </ThemeProvider>
    </DarkModeProvider>
  );
}

export default App;
