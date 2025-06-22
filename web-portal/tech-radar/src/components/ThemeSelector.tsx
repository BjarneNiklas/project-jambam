import React from 'react';
import { useTranslation } from 'react-i18next';
import { useTheme } from '../contexts/ThemeContext';
import './ThemeSelector.css';

const ThemeSelector: React.FC = () => {
  const { t } = useTranslation();
  const { currentTheme, changeTheme } = useTheme();

  console.log('ThemeSelector currentTheme:', currentTheme);

  const themes: { value: string; label: string; icon: string; description: string }[] = [
    {
      value: 'none',
      label: t('themes.none.title'),
      icon: '🚫',
      description: t('themes.none.description')
    },
    {
      value: 'bubbles',
      label: t('themes.bubbles.title'),
      icon: '🫧',
      description: t('themes.bubbles.description')
    },
    {
      value: 'balloons',
      label: t('themes.balloons.title'),
      icon: '🎈',
      description: t('themes.balloons.description')
    },
    {
      value: 'butterflies',
      label: t('themes.butterflies.title'),
      icon: '🦋',
      description: t('themes.butterflies.description')
    },
    {
      value: 'stars',
      label: t('themes.stars.title'),
      icon: '⭐',
      description: t('themes.stars.description')
    },
    {
      value: 'fireflies',
      label: t('themes.fireflies.title'),
      icon: '🪲',
      description: t('themes.fireflies.description')
    }
  ];

  return (
    <div className="settings-card theme-selector">
      <div className="theme-selector-header">
        <h3>{t('themes.title')}</h3>
        <p>{t('themes.subtitle')}</p>
      </div>
      
      <div className="theme-grid">
        {themes.map((theme) => (
          <button
            key={theme.value}
            className={`theme-option ${currentTheme === theme.value ? 'active' : ''}`}
            onClick={() => changeTheme(theme.value as 'none' | 'bubbles' | 'balloons' | 'butterflies' | 'stars' | 'fireflies')}
            title={theme.description}
          >
            <div className="theme-icon">{theme.icon}</div>
            <div className="theme-info">
              <span className="theme-label">{theme.label}</span>
              <span className="theme-description">{theme.description}</span>
            </div>
            {currentTheme === theme.value && (
              <div className="theme-check">✓</div>
            )}
          </button>
        ))}
      </div>
    </div>
  );
};

export default ThemeSelector; 