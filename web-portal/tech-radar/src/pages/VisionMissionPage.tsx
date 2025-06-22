import React from 'react';
import { useTranslation } from 'react-i18next';
import './VisionMissionPage.css'; // We'll create this CSS file next
import { Link } from 'react-router-dom';

const VisionMissionPage: React.FC = () => {
  const { t } = useTranslation();

  return (
    <div className="vision-mission-container">
      <header className="vision-mission-header">
        <h1>{t('visionMissionPage.mainTitle', 'Our Vision & Mission')}</h1>
        <p className="subtitle">{t('visionMissionPage.mainSubtitle', 'Shaping the future of interactive co-creation and democratizing game development.')}</p>
      </header>

      <section className="vision-section card-style">
        <div className="card-icon">💡</div>
        <h2>{t('visionMissionPage.vision.title', 'Our Vision: A Universe of Creators')}</h2>
        <p>{t('visionMissionPage.vision.p1', 'We envision a vibrant, interconnected global ecosystem where creators of all backgrounds and skill levels can effortlessly bring their digital visions to life. Project JamBam aims to dismantle barriers to entry, fostering a world where imagination is the only limit.')}</p>
        <p>{t('visionMissionPage.vision.p2', 'Our platform will be the nexus for the next generation of interactive content – from indie games and immersive XR experiences to educational simulations and collaborative art projects. We see a future powered by collective creativity, where AI and human ingenuity merge to unlock unprecedented possibilities.')}</p>
      </section>

      <section className="mission-section card-style">
        <div className="card-icon">🎯</div>
        <h2>{t('visionMissionPage.mission.title', 'Our Mission: Democratizing & Accelerating Creation')}</h2>
        <p>{t('visionMissionPage.mission.p1', 'Project JamBam is dedicated to democratizing and accelerating the development of interactive 3D applications and games. We are building an AI-powered co-creation platform, akin to a "GitHub Copilot for the 3D world," with a profound emphasis on community, open standards, and collaborative development – especially for dynamic events like game jams.')}</p>
        <p>{t('visionMissionPage.mission.p2', 'Our core objectives include:')}</p>
        <ul>
          <li>{t('visionMissionPage.mission.obj1', 'Empowering individual creators and small teams with powerful, intuitive AI tools.')}</li>
          <li>{t('visionMissionPage.mission.obj2', 'Fostering a collaborative environment through open APIs, shared resources, and community-driven projects.')}</li>
          <li>{t('visionMissionPage.mission.obj3', 'Streamlining the development pipeline from ideation to multi-engine deployment.')}</li>
          <li>{t('visionMissionPage.mission.obj4', 'Championing interoperability and open standards to ensure freedom and flexibility for creators.')}</li>
          <li>{t('visionMissionPage.mission.obj5', 'Cultivating a learning ecosystem where users can grow their skills and share knowledge.')}</li>
        </ul>
      </section>

      <section className="usp-section card-style">
        <div className="card-icon">⭐</div>
        <h2>{t('visionMissionPage.usp.title', 'Our Unique Selling Proposition (USP)')}</h2>
        <p>{t('visionMissionPage.usp.intro', 'JamBam distinguishes itself through a unique combination of features and philosophical approach:')}</p>
        <ul>
          <li><strong>{t('visionMissionPage.usp.item1.title', 'AI-Powered Co-Creation Core:')}</strong> {t('visionMissionPage.usp.item1.desc', 'Deeply integrated AI not just as a feature, but as a fundamental part of the creative workflow, from ideation and asset generation (3D models, textures, audio, narratives) to world-building and even code assistance.')}</li>
          <li><strong>{t('visionMissionPage.usp.item2.title', 'Community-Centric Development & Governance:')}</strong> {t('visionMissionPage.usp.item2.desc', 'A platform that is not only for the community but actively shaped by it through transparent feedback mechanisms, contribution pathways, and potential for decentralized governance models.')}</li>
          <li><strong>{t('visionMissionPage.usp.item3.title', 'Radical Interoperability & Multi-Engine Support:')}</strong> {t('visionMissionPage.usp.item3.desc', 'Our Engine Adapter Framework is designed to break down walled gardens, allowing creators to seamlessly work with and transition between various popular game engines (Unity, Unreal, Godot, Bevy, etc.) while leveraging JamBam’s core services.')}</li>
          <li><strong>{t('visionMissionPage.usp.item4.title', 'Focus on Rapid Prototyping & Jam Culture:')}</strong> {t('visionMissionPage.usp.item4.desc', 'Tools and workflows optimized for speed and iteration, making it ideal for game jams, hackathons, and agile development cycles. Our "Jam Kits" concept embodies this.')}</li>
          <li><strong>{t('visionMissionPage.usp.item5.title', 'Ethical AI & Creator Empowerment:')}</strong> {t('visionMissionPage.usp.item5.desc', 'Commitment to responsible AI development, ensuring creators maintain ownership and control, and exploring fair compensation models for AI training data and co-created assets.')}</li>
        </ul>
      </section>

      <section className="cta-section">
        <h2>{t('visionMissionPage.cta.title', 'Ready to Build the Future With Us?')}</h2>
        <p>{t('visionMissionPage.cta.subtitle', 'Explore our project further, join our community, or see how we are putting these ideas into practice.')}</p>
        <div className="cta-buttons">
          <Link to="/roadmap" className="cta-button primary">{t('visionMissionPage.cta.roadmap', 'View Our Roadmap')}</Link>
          <Link to="/team" className="cta-button secondary">{t('visionMissionPage.cta.team', 'Meet the Team')}</Link>
          {/* <Link to="/community" className="cta-button secondary">{t('visionMissionPage.cta.community', 'Join Community')}</Link> */}
        </div>
      </section>

    </div>
  );
};

export default VisionMissionPage;
