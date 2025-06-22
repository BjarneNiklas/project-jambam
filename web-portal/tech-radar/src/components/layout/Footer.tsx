import React from 'react';
import './Footer.css';
import { FaYoutube, FaInstagram, FaGithub, FaTiktok, FaDiscord } from 'react-icons/fa';
import { FaXTwitter } from 'react-icons/fa6';

const Footer: React.FC = () => {
  return (
    <footer className="site-footer">
      <div className="footer-container">
        <div className="footer-content">
          <div className="footer-section">
            <h4>JamBam</h4>
            <p>&copy; 2025 Bjarne Niklas Luttermann. All Rights Reserved.</p>
            <p>A Next-Generation Interactive Media Ecosystem.</p>
          </div>
          <div className="footer-section">
            <h4>Quick Links</h4>
            <ul>
              <li><a href="/about">About Us</a></li>
              <li><a href="/feed">Feed</a></li>
              <li><a href="/careers">Careers</a></li>
              <li><a href="/contact">Contact</a></li>
              <li>
                <a 
                  href="https://www.auravention.com" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="footer-app-link"
                >
                  📱 JamBam App
                </a>
              </li>
            </ul>
          </div>
          <div className="footer-section">
            <h4>Follow Us</h4>
            <div className="social-icons">
              <a href="https://youtube.com" target="_blank" rel="noopener noreferrer" aria-label="YouTube"><FaYoutube /></a>
              <a href="https://instagram.com" target="_blank" rel="noopener noreferrer" aria-label="Instagram"><FaInstagram /></a>
              <a href="https://github.com/BjarneNiklas/project-jambam" target="_blank" rel="noopener noreferrer" aria-label="GitHub"><FaGithub /></a>
              <a href="https://twitter.com" target="_blank" rel="noopener noreferrer" aria-label="X"><FaXTwitter /></a>
              <a href="https://tiktok.com" target="_blank" rel="noopener noreferrer" aria-label="TikTok"><FaTiktok /></a>
              <a href="https://discord.com" target="_blank" rel="noopener noreferrer" aria-label="Discord"><FaDiscord /></a>
            </div>
          </div>
          <div className="footer-section">
            <h4>Legal</h4>
            <ul className="footer-links">
              <li><a href="/imprint">Imprint</a></li>
              <li><a href="/privacy">Privacy Policy</a></li>
              <li><a href="/terms">Terms of Service</a></li>
            </ul>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer; 