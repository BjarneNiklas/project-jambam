import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
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
import RoadmapPage from './pages/RoadmapPage';
import TeamPage from './pages/TeamPage'; // Import TeamPage
import VisionMissionPage from './pages/VisionMissionPage'; // Import VisionMissionPage
import FundingWorthinessPage from './pages/FundingWorthinessPage'; // Import FundingWorthinessPage
import ThemeBackground from './components/ThemeBackground';
import './App.css';

// Placeholder pages for links that don't have content yet
const PlaceholderPage: React.FC<{ title: string }> = ({ title }) => (
  <div style={{ padding: '2rem', textAlign: 'center' }}>
    <h1>{title}</h1>
    <p>This page is under construction. Check back soon!</p>
    <Link to="/">Go to Homepage</Link>
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
                    <Route path="/team" element={<TeamPage />} /> {/* Add TeamPage route */}
                    <Route path="/vision-mission" element={<VisionMissionPage />} /> {/* Add VisionMissionPage route */}
                    <Route path="/funding-worthiness" element={<FundingWorthinessPage />} /> {/* Add FundingWorthinessPage route */}

                    {/* Placeholder routes for footer links */}
                    <Route path="/careers" element={<PlaceholderPage title="Careers" />} />
                    <Route path="/contact" element={<PlaceholderPage title="Contact Us" />} />
                    <Route path="/imprint" element={<PlaceholderPage title="Imprint" />} />
                    <Route path="/privacy" element={<PlaceholderPage title="Privacy Policy" />} />
                    <Route path="/terms" element={<PlaceholderPage title="Terms of Service" />} />
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
