import React from 'react';
import { useTranslation } from 'react-i18next';
import './FundingWorthinessPage.css'; // We'll create this CSS file next
import { Link } from 'react-router-dom';

const FundingWorthinessPage: React.FC = () => {
  const { t } = useTranslation();

  return (
    <div className="funding-worthiness-container">
      <header className="funding-worthiness-header">
        <h1>{t('fundingPage.mainTitle', 'Why JamBam Deserves Funding')}</h1>
        <p className="subtitle">{t('fundingPage.mainSubtitle', 'Our commitment to innovation, community, and a sustainable digital future makes JamBam a prime candidate for support.')}</p>
      </header>

      <section className="argument-card">
        <div className="argument-icon">🚀</div>
        <h2>{t('fundingPage.innovation.title', 'Technological Innovation & Novelty')}</h2>
        <p>{t('fundingPage.innovation.p1', 'JamBam is not just another game development tool; it’s a paradigm shift. Our core innovation lies in the deep integration of AI as a co-creative partner throughout the entire development lifecycle – from AI-driven ideation and "Jam Kit" generation to intelligent asset creation (3D models, textures, audio, narratives) and automated workflow assistance.')}</p>
        <p>{t('fundingPage.innovation.p2', 'The Engine Adapter Framework represents a significant technical advancement, promoting radical interoperability between major game engines. This addresses a critical pain point for developers, reducing vendor lock-in and fostering a more open ecosystem.')}</p>
        <p>{t('fundingPage.innovation.p3', 'Our approach to hybrid voxel technology (Broxel Engine) and the forward-looking LUVY Engine concept for XR also showcase our commitment to pushing the boundaries of real-time interactive experiences.')}</p>
      </section>

      <section className="argument-card">
        <div className="argument-icon">📈</div>
        <h2>{t('fundingPage.marketPotential.title', 'Significant Market Potential & Scalability')}</h2>
        <p>{t('fundingPage.marketPotential.p1', 'The global game development market, along with the creator economy and the emerging metaverse, represents a multi-billion dollar industry. JamBam is strategically positioned to capture a significant share by targeting a broad spectrum of users: from indie developers and hobbyists to educational institutions and professional studios seeking to accelerate prototyping and innovation.')}</p>
        <p>{t('fundingPage.marketPotential.p2', 'Our platform’s scalability is inherent in its community-driven model and its focus on user-generated content and AI tools. As the community grows, so does the value and capability of the platform. Monetization strategies include premium AI features, a marketplace for assets and "Jam Kits," enterprise solutions, and educational partnerships.')}</p>
      </section>

      <section className="argument-card">
        <div className="argument-icon">🌍</div>
        <h2>{t('fundingPage.societalImpact.title', 'Societal & Economic Impact')}</h2>
        <p>{t('fundingPage.societalImpact.p1', 'JamBam aims to democratize access to game development and interactive content creation, empowering a new generation of creators, particularly from underrepresented groups. This fosters digital literacy, STEM skills, and entrepreneurial opportunities.')}</p>
        <p>{t('fundingPage.societalImpact.p2', 'By promoting open standards and collaboration, we contribute to a healthier, more competitive digital ecosystem in Europe and beyond. Our focus on game jams and rapid prototyping can stimulate local innovation hubs and creative industries.')}</p>
        <p>{t('fundingPage.societalImpact.p3', 'The platform also has applications in education (Studi.OS, AI Quiz & E-Learning), cultural heritage (AURAX photogrammetry), and community building (Home Café Connect), demonstrating a broad positive impact.')}</p>
      </section>

      <section className="argument-card">
        <div className="argument-icon">👥</div>
        <h2>{t('fundingPage.teamExcellence.title', 'Strong Founding Team & Vision')}</h2>
        <p>{t('fundingPage.teamExcellence.p1', 'Led by Bjarne Luttermann, Project JamBam benefits from a visionary founder with a deep understanding of AI, game development, and community dynamics. The (growing) team combines technical expertise with a passion for innovation and a clear, ambitious roadmap.')}</p>
        <p>{t('fundingPage.teamExcellence.p2', 'Our commitment to an agile, iterative development process, coupled with a strong emphasis on user feedback, ensures that JamBam will evolve to meet the real-world needs of its community.')} (Reference: <Link to="/team">{t('fundingPage.teamExcellence.teamLink', 'Meet the Team')}</Link>)</p>
      </section>

      <section className="argument-card">
        <div className="argument-icon">🌱</div>
        <h2>{t('fundingPage.sustainability.title', 'Sustainability & Long-Term Viability')}</h2>
        <p>{t('fundingPage.sustainability.p1', 'JamBam’s business model is designed for long-term sustainability. A multi-faceted approach including freemium access, a marketplace, premium features for power users/teams, and B2B services (e.g., custom engine adapters, educational licenses) creates diverse revenue streams.')}</p>
        <p>{t('fundingPage.sustainability.p2', 'The open and community-driven aspects also contribute to sustainability by fostering a loyal user base, encouraging third-party development on the platform, and reducing reliance on purely internal content generation.')}</p>
      </section>

      <section className="funding-ask-section">
        <h2>{t('fundingPage.fundingAsk.title', 'Our Funding Goals')}</h2>
        <p>{t('fundingPage.fundingAsk.p1', 'Support for Project JamBam will directly accelerate the development of our core platform, expand our AI capabilities, grow our community outreach programs, and help us establish key industry partnerships.')}</p>
        <p>{t('fundingPage.fundingAsk.p2', 'We are seeking funding to achieve key milestones, including [mention 1-2 key milestones, e.g., "launching the full Engine Adapter Framework" or "releasing the JamBam AI Studio public beta"]. This will position JamBam as a leader in the next generation of co-creative technologies.')}</p>
        <div className="cta-buttons">
           <Link to="/contact" className="cta-button primary">{t('fundingPage.fundingAsk.contact', 'Discuss Funding Opportunities')}</Link>
           <Link to="/roadmap" className="cta-button secondary">{t('fundingPage.fundingAsk.roadmap', 'View Detailed Roadmap')}</Link>
        </div>
      </section>

    </div>
  );
};

export default FundingWorthinessPage;
