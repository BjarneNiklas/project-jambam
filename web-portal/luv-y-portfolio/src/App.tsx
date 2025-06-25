import React from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import './App.css';

// Placeholder Pages
const HomePage = () => (
  <div>
    <h1>Welcome to Luv Y's Portfolio</h1>
    <p>This is the main page. Content about me will go here.</p>
  </div>
);
const ProjectsPage = () => (
  <div>
    <h1>Projects</h1>
    <p>Showcase of projects will be listed here.</p>
    <ul>
      <li>Project 1 (Details to be added)</li>
      <li>Project 2 (Details to be added)</li>
    </ul>
  </div>
);
const ResumePage = () => (
  <div>
    <h1>CV / Resume</h1>
    <p>My professional experience and skills will be detailed here.</p>
    <p>A downloadable PDF might be linked here too.</p>
  </div>
);
const ContactPage = () => (
  <div>
    <h1>Contact Me</h1>
    <p>Contact information or a contact form will be here.</p>
    <p>Email: placeholder@example.com</p>
  </div>
);

function App() {
  return (
    <Router>
      <div>
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/projects">Projects</Link>
            </li>
            <li>
              <Link to="/resume">CV/Resume</Link>
            </li>
            <li>
              <Link to="/contact">Contact</Link>
            </li>
          </ul>
        </nav>
        <hr />
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/projects" element={<ProjectsPage />} />
          <Route path="/resume" element={<ResumePage />} />
          <Route path="/contact" element={<ContactPage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
