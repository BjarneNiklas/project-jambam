'use client';
import React from 'react';
import { Box, Card, Typography, Button, Avatar, Stack, Chip, useTheme, Icon } from '@mui/material';
import cv from '../data/cv.json';

const iconMap: Record<string, string> = {
  'Reisen': 'fa-solid fa-plane',
  'EDM/Pop Musik': 'fa-solid fa-music',
  'Sport': 'fa-solid fa-dumbbell',
  'Freunde & Familie': 'fa-solid fa-users',
  'Generative KI': 'fa-solid fa-wand-magic-sparkles',
  'Tech News': 'fa-solid fa-newspaper',
};

const About: React.FC = () => {
  const theme = useTheme();
  const interestsWithIcons = (cv.interests as string[]).map(label => ({
    icon: iconMap[label] || 'fa-solid fa-star',
    label
  }));

  return (
    <Box component="section" id="about" sx={{ maxWidth: 'md', mx: 'auto', my: 6, px: 2, position: 'relative', zIndex: 1 }}>
      <Card
        sx={{
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
        <Avatar
          src="/bjarne_profile1.webp"
          alt="Bjarne Niklas Luttermann"
          sx={{
            width: 120,
            height: 120,
            mt: -13,
            mb: 2,
            border: `4px solid ${theme.palette.background.paper}`,
            boxShadow: 3,
          }}
        />
        <Typography variant="h4" component="h2" gutterBottom sx={{ fontWeight: 700, color: 'primary.main' }}>
          Über Mich
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, bgcolor: 'action.hover', p: 2, borderRadius: 2 }}>
          {cv.about}
        </Typography>
        <Button
          href={cv.linkedin}
          target="_blank"
          rel="noopener"
          variant="contained"
          size="large"
          startIcon={<i className="fab fa-linkedin" />}
          sx={{ mb: 4, fontWeight: 600 }}
        >
          LinkedIn Profil
        </Button>
        <Stack direction="row" flexWrap="wrap" justifyContent="center" gap={2} mb={4}>
          {(cv.facts as {label: string, value: string}[]).map(f => (
            <Box key={f.label} sx={{ bgcolor: 'action.hover', p: 2, borderRadius: 2, minWidth: 90 }}>
              <Typography variant="h5" component="div" sx={{ fontWeight: 'bold', color: 'primary.main' }}>{f.value}</Typography>
              <Typography variant="body2" color="text.secondary">{f.label}</Typography>
            </Box>
          ))}
        </Stack>
        <Typography variant="h5" component="h3" gutterBottom sx={{ fontWeight: 600 }}>
          Interessen & Hobbys
        </Typography>
        <Stack direction="row" flexWrap="wrap" justifyContent="center" gap={1.5}>
          {interestsWithIcons.map(i => (
            <Chip
              key={i.label}
              icon={<Icon className={`${i.icon} fa-fw`} />}
              label={i.label}
              variant="outlined"
              sx={{ p: 2, fontSize: '1rem' }}
            />
          ))}
        </Stack>
      </Card>
    </Box>
  );
};

export default About; 