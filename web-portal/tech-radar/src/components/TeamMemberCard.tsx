import React from 'react';
import './TeamMemberCard.css';

interface TeamMemberCardProps {
  name: string;
  role: string;
  avatarUrl: string; // URL to the avatar image
  portfolioUrl?: string; // Optional portfolio URL
}

const TeamMemberCard: React.FC<TeamMemberCardProps> = ({ name, role, avatarUrl, portfolioUrl }) => {
  return (
    <div className="team-member-card">
      <div className="avatar-container">
        <img src={avatarUrl} alt={`Avatar of ${name}`} className="avatar-image" />
      </div>
      <h3 className="member-name">{name}</h3>
      <p className="member-role">{role}</p>
      {portfolioUrl && (
        <a 
          href={portfolioUrl} 
          target="_blank" 
          rel="noopener noreferrer" 
          className="portfolio-link"
          aria-label={`Visit ${name}'s portfolio`}
        >
          <span className="portfolio-icon">🌐</span>
        </a>
      )}
    </div>
  );
};

export default TeamMemberCard; 