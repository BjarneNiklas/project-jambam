import React from 'react';
import { useTranslation } from 'react-i18next';
import './TeamPage.css'; // We'll create this CSS file next

interface TeamMember {
  id: string;
  nameKey: string; // Key for translation of name
  roleKey: string; // Key for translation of role
  bioKey: string; // Key for translation of bio
  image: string; // Path to image in /public or a URL
  linkedin?: string;
  github?: string;
  twitter?: string;
}

const teamMembers: TeamMember[] = [
  {
    id: 'bjarne',
    nameKey: 'team.bjarne.name',
    roleKey: 'team.bjarne.role',
    bioKey: 'team.bjarne.bio',
    image: '/assets/images/team/bjarne-luttermann.jpg', // Placeholder - replace with actual path
    linkedin: 'https://www.linkedin.com/in/bjarne-luttermann/',
    github: 'https://github.com/BjarneNiklas',
    twitter: 'https://twitter.com/auravention',
  },
  // Add more team members here once information is available
  // Example:
  // {
  //   id: 'jane_doe',
  //   nameKey: 'team.jane_doe.name',
  //   roleKey: 'team.jane_doe.role',
  //   bioKey: 'team.jane_doe.bio',
  //   image: '/assets/images/team/jane_doe.jpg',
  //   linkedin: 'https://linkedin.com/in/janedoe',
  //   github: 'https://github.com/janedoe',
  // },
];

const TeamPage: React.FC = () => {
  const { t } = useTranslation();

  return (
    <div className="team-page-container">
      <header className="team-page-header">
        <h1>{t('teamPage.title', 'Our Team')}</h1>
        <p>{t('teamPage.subtitle', 'Meet the passionate minds behind JamBam.')}</p>
      </header>

      <main className="team-members-grid">
        {teamMembers.map((member) => (
          <div key={member.id} className="team-member-card">
            <img src={member.image} alt={t(member.nameKey)} className="team-member-image" />
            <h2 className="team-member-name">{t(member.nameKey)}</h2>
            <h3 className="team-member-role">{t(member.roleKey)}</h3>
            <p className="team-member-bio">{t(member.bioKey)}</p>
            <div className="team-member-social-links">
              {member.linkedin && <a href={member.linkedin} target="_blank" rel="noopener noreferrer">LinkedIn</a>}
              {member.github && <a href={member.github} target="_blank" rel="noopener noreferrer">GitHub</a>}
              {member.twitter && <a href={member.twitter} target="_blank" rel="noopener noreferrer">Twitter/X</a>}
            </div>
          </div>
        ))}
      </main>

      {teamMembers.length === 0 && (
         <p className="team-empty-message">{t('teamPage.empty', 'Team member information will be updated soon.')}</p>
      )}

      <section className="team-culture-section">
        <h2>{t('teamPage.culture.title', 'Our Culture & Values')}</h2>
        <p>{t('teamPage.culture.description', 'At JamBam, we foster a culture of innovation, collaboration, and continuous learning. We believe in empowering creators and building an open, inclusive ecosystem.')}</p>
        {/* Add more details about culture or link to a values page if it exists */}
      </section>

      <section className="join-us-section">
        <h2>{t('teamPage.joinUs.title', 'Join Our Mission')}</h2>
        <p>{t('teamPage.joinUs.description', 'Interested in contributing to the future of interactive media? We are always looking for talented individuals to join our community and team.')}</p>
        {/* Link to a careers page or contact info */}
        <Link to="/contact" className="cta-button">{t('teamPage.joinUs.cta', 'Get in Touch')}</Link>
      </section>
    </div>
  );
};

export default TeamPage;
