import React, { useState } from 'react';
import './RoadmapPage.css';

interface RoadmapItem {
  id: string;
  title: string;
  description: string;
  status: 'Planned' | 'In Progress' | 'Completed';
  date: string; // Can be a specific date or a quarter like "Q4 2024"
}

const sampleRoadmapData: RoadmapItem[] = [
  {
    id: '1',
    title: 'Launch Alpha Version',
    description: 'Initial release of the platform with core features for early adopters.',
    status: 'Completed',
    date: 'Q1 2024',
  },
  {
    id: '2',
    title: 'User Feedback Integration',
    description: 'Collect and integrate feedback from alpha users to improve features.',
    status: 'Completed',
    date: 'Q2 2024',
  },
  {
    id: '3',
    title: 'Develop Advanced AI Tools',
    description: 'Introduce new AI-powered tools for content generation and analysis.',
    status: 'In Progress',
    date: 'Q3 2024',
  },
  {
    id: '4',
    title: 'Community Forum Launch',
    description: 'Create a dedicated space for users to connect, share ideas, and get support.',
    status: 'In Progress',
    date: 'Q4 2024',
  },
  {
    id: '5',
    title: 'Public Beta Release',
    description: 'Wider public release with new features and improvements.',
    status: 'Planned',
    date: 'Q1 2025',
  },
  {
    id: '6',
    title: 'Mobile App Development',
    description: 'Begin development of native mobile applications for iOS and Android.',
    status: 'Planned',
    date: 'Q2 2025',
  },
];

const RoadmapPage: React.FC = () => {
  const [expandedItem, setExpandedItem] = useState<string | null>(null);

  const toggleItem = (id: string) => {
    if (expandedItem === id) {
      setExpandedItem(null);
    } else {
      setExpandedItem(id);
    }
  };

  return (
    <div className="roadmap-page">
      <header className="roadmap-header">
        <h1>Project Roadmap</h1>
        <p>Our journey and upcoming features. Click on an item to learn more.</p>
      </header>
      <main className="roadmap-content">
        <div className="roadmap-timeline">
          {sampleRoadmapData.map((item) => (
            <div key={item.id} className={`roadmap-item status-${item.status.toLowerCase().replace(' ', '-')}`}>
              <div className="roadmap-item-header" onClick={() => toggleItem(item.id)}>
                <div className="roadmap-item-date-status">
                  <span className="roadmap-item-date">{item.date}</span>
                  <span className={`roadmap-item-status-badge status-${item.status.toLowerCase().replace(' ', '-')}-badge`}>
                    {item.status}
                  </span>
                </div>
                <h3 className="roadmap-item-title">{item.title}</h3>
              </div>
              {expandedItem === item.id && (
                <div className="roadmap-item-description">
                  <p>{item.description}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      </main>
    </div>
  );
};

export default RoadmapPage;
