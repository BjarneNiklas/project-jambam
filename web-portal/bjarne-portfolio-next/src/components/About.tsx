'use client';
import React from 'react';
import { Box, Card, Typography, Button, Stack, Chip, useTheme } from '@mui/material';
import Image from 'next/image';
import ProfilePic from '../../public/bjarne_profile1.webp';
import cv from '../data/cv.json';
import { FaPlane, FaMusic, FaDumbbell, FaUsers, FaMagic, FaNewspaper, FaStar, FaRocket, FaEnvelope, FaLinkedin } from 'react-icons/fa';
import { useLanguage } from '../app/LanguageContext';

const iconMap: Record<string, React.ElementType> = {
  'Reisen': FaPlane,
  'EDM/Pop Musik': FaMusic,
  'Sport': FaDumbbell,
  'Freunde & Familie': FaUsers,
  'Generative KI': FaMagic,
  'Tech News': FaNewspaper,
};

const About: React.FC = () => {
  const theme = useTheme();
  const { t } = useLanguage();
  
  const interestsWithIcons = (cv.interests as string[]).map(label => ({
    icon: iconMap[label] || FaStar, // Use the component directly
    label
  }));

  const breakIndex = interestsWithIcons.findIndex(i => i.label === 'Generative KI');
  const firstLineInterests = breakIndex !== -1 ? interestsWithIcons.slice(0, breakIndex) : interestsWithIcons;
  const secondLineInterests = breakIndex !== -1 ? interestsWithIcons.slice(breakIndex) : [];

  return (
    <>
      <style jsx>{`
        @keyframes pulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.5; }
        }
        .typing-text {
          animation: pulse 1.5s infinite;
        }
      `}</style>
      <Box component="section" id="about" sx={{ maxWidth: 'md', mx: 'auto', my: 6, px: 2, position: 'relative', zIndex: 1 }}>
        <Card
          sx={{
            overflow: 'visible',
            bgcolor: 'background.paper',
            borderRadius: 4,
            p: { xs: 2, md: 4 },
            pt: { xs: 6, md: 8 },
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            textAlign: 'center',
            boxShadow: 3,
          }}
        >
          <Typography variant="h4" component="h2" gutterBottom sx={{ fontWeight: 700, color: 'primary.main' }}>
            Bjarne Niklas Luttermann
          </Typography>
          <Box sx={{
            width: 180,
            height: 180,
            mb: 2,
            border: `4px solid ${theme.palette.background.paper}`,
            boxShadow: 3,
            borderRadius: '50%',
            overflow: 'hidden', // Important for next/image with borderRadius
            display: 'flex', // Ensure the image is centered if it's smaller
            justifyContent: 'center',
            alignItems: 'center',
          }}>
            <Image
              src={ProfilePic}
              alt="Bjarne Niklas Luttermann"
              width={180}
              height={180}
              style={{
                objectFit: 'cover',
                objectPosition: 'center 45%',
              }}
              priority // Load this image eagerly as it's likely above the fold
            />
          </Box>
          <Typography sx={{ fontSize: { xs: '1.2rem', md: '2rem' }, color: '#fff', mb: 2, maxWidth: 600, mx: 'auto', lineHeight: 1.4, fontWeight: 500 }}>
            {t('hero.subtitle')}
          </Typography>
          <Box className="mb-4 h-8 flex justify-center items-center">
            <span style={{ fontSize: '1.125rem', color: '#9ca3af', marginRight: '0.5rem' }}>
              {t('hero.title').split(' ')[0]} {t('hero.title').split(' ')[1]}
            </span>
            <span className="typing-text" style={{ 
              fontSize: '1.125rem', 
              fontFamily: 'monospace', 
              color: '#2dd4bf', 
              borderRight: '2px solid #2dd4bf', 
              paddingRight: '2px'
            }}>
              {t('hero.title').split(' ').slice(2).join(' ')}
            </span>
          </Box>
          <Typography variant="body1" sx={{ mb: 3, bgcolor: 'action.hover', p: 2, borderRadius: 2 }}>
            {t('about.description')}
          </Typography>
          <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2} justifyContent="center" alignItems="center" sx={{ mb: 4 }}>
            <Button
              href="#projects"
              variant="contained"
              size="large"
              startIcon={<FaRocket />}
              sx={{ 
                fontWeight: 600,
                background: 'linear-gradient(90deg, #14b8a6 0%, #2dd4bf 100%)',
                '&:hover': {
                  background: 'linear-gradient(90deg, #0f766e 0%, #14b8a6 100%)',
                }
              }}
            >
              {t('projects.moreDetails')}
            </Button>
            <Button
              href="mailto:aurav.tech@gmail.com"
              variant="outlined"
              size="large"
              startIcon={<FaEnvelope />}
              sx={{ 
                fontWeight: 600,
                borderColor: '#2dd4bf',
                color: '#2dd4bf',
                '&:hover': {
                  backgroundColor: 'rgba(45, 212, 191, 0.1)',
                  borderColor: '#2dd4bf',
                }
              }}
            >
              {t('contact.email')}
            </Button>
            <Button
              href={cv.linkedin}
              target="_blank"
              rel="noopener"
              variant="contained"
              size="large"
              startIcon={<FaLinkedin />}
              sx={{ 
                fontWeight: 600,
                backgroundColor: '#0077b5',
                '&:hover': {
                  backgroundColor: '#005885',
                }
              }}
            >
              {t('contact.linkedin')}
            </Button>
          </Stack>
          <Typography variant="h5" component="h3" gutterBottom sx={{ fontWeight: 600 }}>
            {t('about.interests')}
          </Typography>
          <Stack direction="row" flexWrap="wrap" justifyContent="center" gap={1.5} sx={{ px: { xs: 0, sm: 2 } }}>
            {interestsWithIcons.map(Interest => (
              <Chip
                key={Interest.label}
                icon={Interest.icon ? <Interest.icon style={{ fontSize: '1.2rem' }} /> : undefined}
                label={Interest.label}
                variant="outlined"
                sx={{
                  p: 2,
                  fontSize: '1rem',
                  fontWeight: 500,
                  cursor: 'pointer',
                  borderColor: 'primary.main',
                  background: 'rgba(179,157,219,0.07)',
                  transition: 'all 0.2s',
                  '&:hover': {
                    transform: 'scale(1.05)',
                    bgcolor: 'primary.main',
                    color: 'primary.contrastText',
                    boxShadow: 3,
                  },
                }}
              />
            ))}
          </Stack>
        </Card>
      </Box>
    </>
  );
};

export default About; 