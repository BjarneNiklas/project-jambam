import React from 'react';
import { useTranslation } from 'react-i18next';
import { 
  IconButton, 
  Tooltip, 
  Fade, 
  Grow,
  Box 
} from '@mui/material';

// German Flag SVG Component
const GermanFlag: React.FC<{ size?: number }> = ({ size = 28 }) => (
  <svg width={size} height={size * 0.6} viewBox="0 0 5 3" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect width="5" height="3" fill="#FFCE00"/>
    <rect width="5" height="2" fill="#DD0000"/>
    <rect width="5" height="1" fill="#000000"/>
  </svg>
);

// UK Flag (Union Jack) SVG Component
const UKFlag: React.FC<{ size?: number }> = ({ size = 28 }) => (
    <svg width={size} height={size * 0.6} viewBox="0 0 60 36" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="60" height="36" fill="#012169"/>
        <path d="M0,0 L60,36 M60,0 L0,36" stroke="#FFFFFF" strokeWidth="6"/>
        <path d="M0,0 L60,36 M60,0 L0,36" stroke="#C8102E" strokeWidth="4" strokeDasharray="30 30" transform="translate(5, -5)"/>
        <path d="M30,0 V36 M0,18 H60" stroke="#FFFFFF" strokeWidth="10"/>
        <path d="M30,0 V36 M0,18 H60" stroke="#C8102E" strokeWidth="6"/>
    </svg>
);

const LanguageSwitcher: React.FC = () => {
  const { i18n } = useTranslation();

  const toggleLanguage = () => {
    const newLang = i18n.language === 'de' ? 'en' : 'de';
    i18n.changeLanguage(newLang);
  };

  const getTooltipText = (lang: string) => {
    return lang === 'de' ? 'Switch to English' : 'Wechseln zu Deutsch';
  };

  return (
    <Fade in timeout={800}>
      <Box>
        <Tooltip 
          title={getTooltipText(i18n.language)} 
          arrow
          placement="bottom"
        >
          <IconButton
            onClick={toggleLanguage}
            sx={{
              width: 48,
              height: 48,
              background: 'rgba(255, 255, 255, 0.1)',
              border: '1px solid rgba(255, 255, 255, 0.2)',
              backdropFilter: 'blur(10px)',
              color: 'white',
              fontSize: '1.5rem',
              transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
              '&:hover': {
                background: 'rgba(255, 255, 255, 0.2)',
                borderColor: 'rgba(255, 255, 255, 0.3)',
                transform: 'scale(1.1) rotate(5deg)',
                boxShadow: '0 8px 25px rgba(0, 0, 0, 0.3)',
              },
              '&:active': {
                transform: 'scale(0.95)',
              },
            }}
          >
            <Grow in timeout={300}>
              <Box component="span" sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                {i18n.language === 'de' ? <GermanFlag /> : <UKFlag />}
              </Box>
            </Grow>
          </IconButton>
        </Tooltip>
      </Box>
    </Fade>
  );
};

export default LanguageSwitcher; 