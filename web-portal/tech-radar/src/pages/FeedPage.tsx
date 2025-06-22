import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import './FeedPage.css';

const FeedPage: React.FC = () => {
  const { t } = useTranslation();
  const [selectedCategories, setSelectedCategories] = useState<string[]>(['All']);

  const handleFilterClick = (category: string) => {
    if (category === 'All') {
      setSelectedCategories(['All']);
      return;
    }

    // Copy the current state and remove 'All' if it's present
    let newSelection = selectedCategories.filter(c => c !== 'All');

    if (newSelection.includes(category)) {
      // If the category is already selected, remove it
      newSelection = newSelection.filter(c => c !== category);
    } else {
      // Otherwise, add it
      newSelection.push(category);
    }

    // If no categories are selected, default back to 'All'
    if (newSelection.length === 0) {
      setSelectedCategories(['All']);
    } else {
      setSelectedCategories(newSelection);
    }
  };

  const categories = ['All', 'News', 'Insights', 'Community'];

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
            {category}
          </button>
        ))}
      </div>

      <div className="feed-content-stream">
        <p>Content for: {selectedCategories.join(', ')}</p>
      </div>
    </div>
  );
};

export default FeedPage; 