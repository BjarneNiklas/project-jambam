import React from 'react';
import './UpdateCard.css';

interface UpdateCardProps {
  title: string;
  date: string;
  content: string;
  category: string;
}

const UpdateCard: React.FC<UpdateCardProps> = ({ title, date, content, category }) => {
  return (
    <div className="update-card">
      <div className="update-card-header">
        <h3>{title}</h3>
        <span className="update-card-category">{category}</span>
      </div>
      <p className="update-card-date">{date}</p>
      <p className="update-card-content">{content}</p>
    </div>
  );
};

export default UpdateCard;
