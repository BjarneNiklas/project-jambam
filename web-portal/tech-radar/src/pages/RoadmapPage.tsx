import React, { useState } from 'react';
import './RoadmapPage.css';

interface RoadmapItem {
  id: string;
  title: string;
  description: string;
  status: 'Planned' | 'In Progress' | 'Completed' | 'Thesis Focus';
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
  // Master Thesis Items
  {
    id: 'thesis-0',
    title: 'Master Thesis: Define Core User Workflow (Prototype)',
    description: 'The app enables AI-assisted generation of Game Jam ideas ("Jam Seeds"), collaborative refinement with community feedback and AI suggestions, leading to game idea inspiration and initial 3D asset descriptions. This end-to-end process is the core of the prototype.',
    status: 'Thesis Focus',
    date: 'Thesis Planning',
  },
  {
    id: 'thesis-1',
    title: 'Master Thesis: In-Depth Literature Research & Analysis',
    description: 'Analyze existing ideation methods for AI automation in Game Jams. Research game design trends and AI creativity tools. Identify and analyze metadata/tags from sources like Steam/itch.io for game concept inspiration and classification.',
    status: 'Thesis Focus',
    date: 'Thesis Research Phase',
  },
  {
    id: 'thesis-m1',
    title: 'Master Thesis M1: Design & Concept for "Jam Seed" Generation AI',
    description: 'Define interfaces to MediaThemeAgent & ResearchAgent. Design data model for "Jam Seeds". Create initial prompt strategies for AI ideation.',
    status: 'Planned',
    date: 'Thesis Milestone 1',
  },
  {
    id: 'thesis-m2',
    title: 'Master Thesis M2: Develop Collaborative Refinement Platform (UI/UX Base)',
    description: 'Implement basic web/app (Flutter) UI for displaying and editing Jam Seeds. Basic manual adjustment features.',
    status: 'Planned',
    date: 'Thesis Milestone 2',
  },
  {
    id: 'thesis-m3',
    title: 'Master Thesis M3: Implement Basic Community Feedback System',
    description: 'Simple system for commenting and rating Jam Seeds. Store feedback linked to Jam Seeds.',
    status: 'Planned',
    date: 'Thesis Milestone 3',
  },
  {
    id: 'thesis-m4',
    title: 'Master Thesis M4: Integrate Multi-Agent AI Suggestions',
    description: 'Connect to multi-agent system for iterative Jam Seed optimization based on manual/community feedback. Integrate PromptOptimizer & CriticAgent suggestions.',
    status: 'Planned',
    date: 'Thesis Milestone 4',
  },
  {
    id: 'thesis-m5',
    title: 'Master Thesis M5: Develop Spielideen & Asset Description Module',
    description: 'Logic for generating concrete game ideas from refined Jam Seeds. System for deriving initial 3D asset descriptions (linking to AssetAgent logic).',
    status: 'Planned',
    date: 'Thesis Milestone 5',
  },
  {
    id: 'thesis-m6',
    title: 'Master Thesis M6: Prototype End-to-End Workflow Implementation & Testing',
    description: 'Connect all modules into a testable prototype mapping the core user workflow. Conduct internal tests and iterations.',
    status: 'Planned',
    date: 'Thesis Milestone 6',
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
