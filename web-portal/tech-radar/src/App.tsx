import React, { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import { AuthProvider } from './auth/AuthContext';
import ProtectedRoute from './auth/ProtectedRoute';
import AdminRoute from './auth/AdminRoute';
import { DarkModeProvider } from './contexts/DarkModeContext';
import { ThemeProvider } from './contexts/ThemeContext';
import Header from './components/layout/Header';
import Footer from './components/layout/Footer';
// import TechRadarPage from './pages/TechRadarPage';
// import LoginPage from './pages/LoginPage';
// import RegisterPage from './pages/RegisterPage';
// import SettingsPage from './pages/SettingsPage';
// import AdminPanel from './components/AdminPanel';
// import AboutPage from './pages/AboutPage';
// import FeedPage from './pages/FeedPage';
// import ProfilePage from './pages/ProfilePage';
import AuthCallback from './auth/AuthCallback'; // AuthCallback is small, can keep it eager
// import ProfileSetupPage from './pages/ProfileSetupPage';
import AuthWrapper from './auth/AuthWrapper'; // AuthWrapper is likely small, can keep it eager
// import HomePage from './pages/HomePage';
// import RoadmapPage from './pages/RoadmapPage';
// import TeamPage from './pages/TeamPage';
// import VisionMissionPage from './pages/VisionMissionPage';
// import FundingWorthinessPage from './pages/FundingWorthinessPage';
// import PrivacyPolicy from './pages/legal/PrivacyPolicy';
// import TermsOfService from './pages/legal/TermsOfService';
// import Impressum from './pages/legal/Impressum';
import ThemeBackground from './components/ThemeBackground';
import SkeletonLoader from './components/layout/SkeletonLoader'; // Import SkeletonLoader
import './App.css';

// Lazy load page components
const TechRadarPage = lazy(() => import('./pages/TechRadarPage'));
const LoginPage = lazy(() => import('./pages/LoginPage'));
const RegisterPage = lazy(() => import('./pages/RegisterPage'));
const SettingsPage = lazy(() => import('./pages/SettingsPage'));
const AdminPanel = lazy(() => import('./components/AdminPanel')); // AdminPanel is page-like
const AboutPage = lazy(() => import('./pages/AboutPage'));
const FeedPage = lazy(() => import('./pages/FeedPage'));
const ProfilePage = lazy(() => import('./pages/ProfilePage'));
const ProfileSetupPage = lazy(() => import('./pages/ProfileSetupPage'));
const HomePage = lazy(() => import('./pages/HomePage'));
const RoadmapPage = lazy(() => import('./pages/RoadmapPage'));
const TeamPage = lazy(() => import('./pages/TeamPage'));
const VisionMissionPage = lazy(() => import('./pages/VisionMissionPage'));
const FundingWorthinessPage = lazy(() => import('./pages/FundingWorthinessPage'));
const PrivacyPolicy = lazy(() => import('./pages/legal/PrivacyPolicy'));
const TermsOfService = lazy(() => import('./pages/legal/TermsOfService'));
const Impressum = lazy(() => import('./pages/legal/Impressum'));


// Placeholder pages for links that don't have content yet
const PlaceholderPage: React.FC<{ title: string }> = ({ title }) => (
  <div style={{ padding: '2rem', textAlign: 'center' }}>
    <h1>{title}</h1>
    <p>This page is under construction. Check back soon!</p>
    <Link to="/">Go to Homepage</Link>
  </div>
);

const GlobalPageSkeleton = () => (
  <div style={{ padding: '2rem' }}>
    <SkeletonLoader type="title" width="40%" style={{ marginBottom: '2rem' }} />
    <SkeletonLoader type="text" lines={1} width="80%" />
    <SkeletonLoader type="text" lines={1} width="90%" style={{ marginTop: '1rem' }} />
    <SkeletonLoader type="text" lines={1} width="70%" />
    <SkeletonLoader type="card" style={{ marginTop: '3rem', height: '200px' }} />
  </div>
);

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
                <Suspense fallback={<GlobalPageSkeleton />}>
                  <Routes>
                    <Route element={<AuthWrapper />}>
                      <Route path="/login" element={<LoginPage />} />
                      <Route path="/register" element={<RegisterPage />} />
                      <Route path="/profile-setup" element={<ProfileSetupPage />} />
                      <Route path="/about" element={<AboutPage />} />
                      <Route path="/feed" element={<FeedPage />} />
                      <Route path="/settings" element={<SettingsPage />} />
                      <Route path="/auth/callback" element={<AuthCallback />} />
                      <Route path="/roadmap" element={<RoadmapPage />} />
                      <Route path="/team" element={<TeamPage />} />
                      <Route path="/vision-mission" element={<VisionMissionPage />} />
                      <Route path="/funding-worthiness" element={<FundingWorthinessPage />} />

                      {/* Placeholder routes for footer links */}
                      <Route path="/careers" element={<PlaceholderPage title="Careers" />} />
                      <Route path="/contact" element={<PlaceholderPage title="Contact Us" />} />
                      <Route path="/impressum" element={<Impressum />} />
                      <Route path="/privacy-policy" element={<PrivacyPolicy />} />
                      <Route path="/terms-of-service" element={<TermsOfService />} />
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
                </Suspense>
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
