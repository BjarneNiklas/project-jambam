import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import UpdateCard from '../components/UpdateCard'; // Import UpdateCard
import './FeedPage.css';

// Define a type for individual update items
interface UpdateItem {
  id: string;
  title: string;
  date: string;
  content: string;
  category: string;
}

// Sample data for updates
const sampleUpdates: UpdateItem[] = [
  {
    id: '1',
    title: 'New Feature: Enhanced User Profiles',
    date: '2023-10-26',
    content: 'We are excited to announce the launch of enhanced user profiles, allowing for more customization and better community interaction.',
    category: 'News',
  },
  {
    id: '2',
    title: 'Community Spotlight: Amazing Creations',
    date: '2023-10-24',
    content: 'Check out some of the incredible work being shared by our talented community members this week!',
    category: 'Community',
  },
  {
    id: '3',
    title: 'Platform Maintenance Scheduled',
    date: '2023-10-22',
    content: 'There will be a scheduled maintenance on October 28th from 2 AM to 4 AM UTC to improve platform stability.',
    category: 'News',
  },
  {
    id: '4',
    title: 'Deep Dive: The Future of AI in Content Generation',
    date: '2023-10-20',
    content: 'Our latest blog post explores the evolving role of artificial intelligence and its potential impact on content creation workflows.',
    category: 'Insights',
  },
  {
    id: '5',
    title: 'Join Our Weekly Q&A Session!',
    date: '2023-10-18',
    content: 'Have questions? Join our team for a live Q&A session every Friday at 3 PM UTC on our Discord server.',
    category: 'Community',
  }
];

const FeedPage: React.FC = () => {
  const { t } = useTranslation();
  const [selectedCategories, setSelectedCategories] = useState<string[]>(['All']);

  const handleFilterClick = (category: string) => {
    if (category === 'All') {
      setSelectedCategories(['All']);
      return;
    }

    let newSelection = selectedCategories.filter(c => c !== 'All');

    if (newSelection.includes(category)) {
      newSelection = newSelection.filter(c => c !== category);
    } else {
      newSelection.push(category);
    }

    if (newSelection.length === 0) {
      setSelectedCategories(['All']);
    } else {
      setSelectedCategories(newSelection);
    }
  };

  const categories = ['All', 'News', 'Insights', 'Community'];

  const filteredUpdates = selectedCategories.includes('All')
    ? sampleUpdates
    : sampleUpdates.filter(update => selectedCategories.includes(update.category));

  return (
    <div className="feed-page">
      <header className="feed-header">
        <h1>{t('feed.title')}</h1>
        <p>{t('feed.subtitle')}</p>
      </header>
      
      <div className="feed-filters">
        {categories.map(category => (
          <button
            key={category}
            className={`filter-chip ${selectedCategories.includes(category) ? 'active' : ''}`}
            onClick={() => handleFilterClick(category)}
          >
            {t(`feed.categories.${category.toLowerCase()}`)}
          </button>
        ))}
      </div>

      <div className="feed-content-stream">
        {filteredUpdates.length > 0 ? (
          filteredUpdates.map(update => (
            <UpdateCard
              key={update.id}
              title={update.title}
              date={update.date}
              content={update.content}
              category={t(`feed.categories.${update.category.toLowerCase()}`)} // Translate category in UpdateCard
            />
          ))
        ) : (
          <p>{t('feed.noUpdatesFound')}</p> // Message when no updates match filters
        )}
      </div>
    </div>
  );
};

export default FeedPage;
            title={update.title}
            date={update.date}
            content={update.content}
            category={update.category}
          />
        ))}
      </div>
    </div>
  );
};

export default FeedPage; 