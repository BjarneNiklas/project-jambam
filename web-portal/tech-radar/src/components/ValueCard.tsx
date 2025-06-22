import React from 'react';
import './ValueCard.css';

interface ValueCardProps {
  icon: string; // For simplicity, we'll pass icon character or a placeholder
  title: string;
  description: string;
}

const ValueCard: React.FC<ValueCardProps> = ({ icon, title, description }) => {
  return (
    <div className="value-card">
      <div className="value-icon">{icon}</div>
      <h3 className="value-title">{title}</h3>
      <p className="value-description">{description}</p>
    </div>
  );
};

export default ValueCard; 