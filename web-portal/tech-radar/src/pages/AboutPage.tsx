import React from 'react';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom'; // Import Link
import './AboutPage.css'; // Ensure this CSS file is created and styled

const AboutPage: React.FC = () => {
  const { t } = useTranslation();

  const coreValues = [
    { titleKey: 'about.values.innovation.title', descriptionKey: 'about.values.innovation.description', icon: '💡' },
    { titleKey: 'about.values.community.title', descriptionKey: 'about.values.community.description', icon: '👥' },
    { titleKey: 'about.values.quality.title', descriptionKey: 'about.values.quality.description', icon: '⭐' },
    { titleKey: 'about.values.collaboration.title', descriptionKey: 'about.values.collaboration.description', icon: '🤝' },
    { titleKey: 'about.values.openness.title', descriptionKey: 'about.values.openness.description', icon: '🌍' },
    { titleKey: 'about.values.sustainability.title', descriptionKey: 'about.values.sustainability.description', icon: '🌱' },
  ];

  return (
    <div className="about-page-container">
      <header className="about-header">
        <h1>{t('about.title', 'About Us')}</h1>
        <p className="subtitle">{t('about.subtitle', 'Driving the Future of Interactive Co-Creation')}</p>
      </header>

      <section className="about-section mission-vision-summary">
        <div className="summary-card">
          <h2>{t('about.summary.title', 'Our Essence')}</h2>
          <p>{t('about.summary.p1', "Project JamBam is at the forefront of revolutionizing how interactive 3D applications and games are made. We're building an AI-powered co-creation platform designed to democratize development, foster community, and accelerate innovation.")}</p>
          <p>{t('about.summary.p2', "Our vision is a global ecosystem where creativity flourishes, unhindered by technical barriers. We're committed to open standards, interoperability, and empowering creators of all levels.")}</p>
          <div className="summary-links">
            <Link to="/vision-mission" className="cta-button-outline">
              {t('about.summary.readMoreVision', 'Read Full Vision & Mission')}
            </Link>
            <Link to="/team" className="cta-button-outline">
              {t('about.summary.meetTeam', 'Meet Our Team')}
            </Link>
          </div>
        </div>
      </section>

      <section className="about-section problem-solution">
        <h2>{t('about.problemSolution.title', 'The Challenge & Our Approach')}</h2>
        <div className="problem-card">
          <h3>{t('about.problemSolution.problemTitle', 'The Challenge: Barriers in Game Development')}</h3>
          <p>{t('about.problemSolution.problemDesc', 'Traditional game development is often complex, time-consuming, and resource-intensive, creating high barriers to entry, especially for indie developers, small teams, and those participating in time-constrained events like game jams. Siloed engine ecosystems can also limit flexibility and collaboration.')}</p>
        </div>
        <div className="solution-card">
          <h3>{t('about.problemSolution.solutionTitle', 'Our Solution: AI-Powered Co-Creation & Interoperability')}</h3>
          <p>{t('about.problemSolution.solutionDesc', "JamBam tackles these challenges by providing AI tools that streamline ideation, asset generation, and workflow automation. Our unique Engine Adapter Framework promotes interoperability, allowing creators to leverage JamBam's strengths across various game engines. This approach significantly lowers barriers, speeds up development, and fosters a more open, collaborative environment.")}</p>
        </div>
      </section>

      <section className="about-section values-section">
        <h2>{t('about.values.title', 'Our Core Values')}</h2>
        <div className="values-grid">
          {coreValues.map((value, index) => (
            <div key={index} className="value-card">
              <span className="value-icon">{value.icon}</span>
              <h3>{t(value.titleKey)}</h3>
              <p>{t(value.descriptionKey)}</p>
            </div>
          ))}
        </div>
      </section>

       <section className="about-section cta-section-about">
        <h2>{t('about.cta.title', 'Join the Revolution')}</h2>
        <p>{t('about.cta.subtitle', "Whether you're a developer, artist, student, or enthusiast, there's a place for you in the JamBam ecosystem. Explore our technology, contribute to our community, or consider supporting our mission.")}</p>
        <div className="cta-buttons-about">
          <Link to="/roadmap" className="cta-button primary">{t('about.cta.roadmap', 'View Our Roadmap')}</Link>
          <Link to="/funding-worthiness" className="cta-button secondary">{t('about.cta.supportUs', 'Why Support JamBam?')}</Link>
          {/* <Link to="/community" className="cta-button secondary">{t('about.cta.community', 'Join Our Community')}</Link> */}
        </div>
      </section>
    </div>
  );
};

export default AboutPage;