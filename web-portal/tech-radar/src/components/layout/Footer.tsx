import React from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import './Footer.css';
import { FaYoutube, FaInstagram, FaGithub, FaTiktok, FaDiscord, FaReddit, FaLinkedin } from 'react-icons/fa';
import { FaXTwitter } from 'react-icons/fa6';
import LogoHexSpark from '../LogoHexSpark'; // Assuming this is your logo component

const Footer: React.FC = () => {
  const { t } = useTranslation();
  const currentYear = new Date().getFullYear();

  // Define social media links (replace with actual project links)
  const socialLinks = [
    { name: 'YouTube', icon: <FaYoutube />, url: 'https://youtube.com/@auravention' },
    { name: 'Instagram', icon: <FaInstagram />, url: 'https://instagram.com/auravention' },
    { name: 'GitHub', icon: <FaGithub />, url: 'https://github.com/BjarneNiklas/project-jambam' },
    { name: 'X', icon: <FaXTwitter />, url: 'https://x.com/auravention' },
    { name: 'TikTok', icon: <FaTiktok />, url: 'https://tiktok.com/@auravention' },
    { name: 'Discord', icon: <FaDiscord />, url: 'https://discord.gg/invite/auravention-community-1005913120254283878' },
    { name: 'Reddit', icon: <FaReddit />, url: 'https://reddit.com/r/auravention' },
    { name: 'LinkedIn', icon: <FaLinkedin />, url: 'https://linkedin.com/company/auravention' }
  ];

  // Define quick links (ensure these routes exist or create placeholder pages)
  const quickLinks = [
    { to: '/about', text: t('footer.quickLinks.about', 'About Us') },
    { to: '/feed', text: t('footer.quickLinks.feed', 'Feed') },
    { to: '/roadmap', text: t('footer.quickLinks.roadmap', 'Roadmap') },
    // { to: '/careers', text: t('footer.quickLinks.careers', 'Careers') }, // Uncomment when page exists
    // { to: '/contact', text: t('footer.quickLinks.contact', 'Contact') }, // Uncomment when page exists
  ];

  // Define legal links (ensure these routes exist or create placeholder pages)
  const legalLinks = [
    { to: '/imprint', text: t('footer.legal.imprint', 'Imprint') },
    { to: '/privacy', text: t('footer.legal.privacy', 'Privacy Policy') },
    { to: '/terms', text: t('footer.legal.terms', 'Terms of Service') },
  ];

  return (
    <footer className="site-footer">
      <div className="footer-container">
        <div className="footer-main">
          <div className="footer-section footer-branding">
            <Link to="/" className="footer-logo-link">
              <LogoHexSpark />
              <h4 className="footer-site-title">JamBam</h4>
            </Link>
            <p className="footer-tagline">{t('footer.tagline', 'A Next-Generation Interactive Media Ecosystem.')}</p>
            <p className="footer-copyright">&copy; {currentYear} Bjarne Niklas Luttermann. {t('footer.rights', 'All Rights Reserved.')}</p>
          </div>

          <div className="footer-section footer-links-group">
            <h4>{t('footer.quickLinks.title', 'Quick Links')}</h4>
            <ul>
              {quickLinks.map(link => (
                <li key={link.to}><Link to={link.to}>{link.text}</Link></li>
              ))}
               <li>
                <a
                  href="https://www.auravention.com" // Replace with actual app link
                  target="_blank"
                  rel="noopener noreferrer"
                  className="footer-app-link"
                >
                  📱 {t('footer.jambamApp', 'JamBam App')}
                </a>
              </li>
            </ul>
          </div>

          <div className="footer-section footer-links-group">
            <h4>{t('footer.legal.title', 'Legal')}</h4>
            <ul>
              {legalLinks.map(link => (
                <li key={link.to}><Link to={link.to}>{link.text}</Link></li>
              ))}
            </ul>
          </div>

          <div className="footer-section footer-social">
            <h4>{t('footer.followUs.title', 'Follow Us')}</h4>
            <div className="social-icons">
              {socialLinks.map(social => (
                <a key={social.name} href={social.url} target="_blank" rel="noopener noreferrer" aria-label={social.name} title={social.name}>
                  {social.icon}
                </a>
              ))}
            </div>
          </div>
        </div>

        <div className="footer-bottom">
          <p>{t('footer.bottomText', 'JamBam is a project by Bjarne Niklas Luttermann, striving to innovate the digital media landscape.')}</p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;