'use client';
import React from 'react';
import { Box, Typography, Card, Stack, useTheme, Avatar } from '@mui/material';
import SchoolIcon from '@mui/icons-material/School';
import WorkIcon from '@mui/icons-material/Work';
import VolunteerActivismIcon from '@mui/icons-material/VolunteerActivism';
import RadioIcon from '@mui/icons-material/Radio';
import FlightIcon from '@mui/icons-material/Flight';
import { useLanguage } from '../app/LanguageContext';

const ExperienceEducation: React.FC = () => {
  const theme = useTheme();
  const { t } = useLanguage();

  const experience = [
    {
      title: t('experience.jobs.itConsultant'),
      company: t('experience.companies.machAG'),
      date: t('experience.dates.march2022August2023'),
      location: t('experience.locations.lubeck'),
      icon: <WorkIcon sx={{ color: '#b39ddb' }} />,
    },
    {
      title: t('experience.jobs.dualStudent'),
      company: t('experience.companies.machAG'),
      date: t('experience.dates.october2018March2022'),
      location: t('experience.locations.lubeck'),
      icon: <SchoolIcon sx={{ color: '#b39ddb' }} />,
    },
    {
      title: t('experience.jobs.volunteerTutor'),
      company: t('experience.companies.gemeinschaftsschuleMolln'),
      date: t('experience.dates.september2014July2015'),
      location: t('experience.locations.molln'),
      icon: <VolunteerActivismIcon sx={{ color: '#b39ddb' }} />,
    },
    {
      title: t('experience.jobs.radioModerator'),
      company: t('experience.companies.uniteFM'),
      date: t('experience.dates.december2012March2014'),
      location: t('experience.locations.remote'),
      icon: <RadioIcon sx={{ color: '#b39ddb' }} />,
    },
  ];

  const education = [
    {
      title: t('experience.educationItems.mscMedia'),
      company: t('experience.companies.thLubeck'),
      date: t('experience.dates.september2023March2026'),
      location: t('experience.details.focusSoftwareDataAI'),
      icon: <SchoolIcon sx={{ color: '#b39ddb' }} />,
    },
    {
      title: t('experience.educationItems.abroadSemester'),
      company: t('experience.companies.griffithCollege'),
      date: t('experience.dates.october2020February2021'),
      location: t('experience.locations.dublin'),
      icon: <FlightIcon sx={{ color: '#b39ddb' }} />,
    },
    {
      title: t('experience.educationItems.bscBusiness'),
      company: t('experience.companies.nordakademie'),
      date: t('experience.dates.october2018March2022'),
      location: t('experience.details.thesisGamification'),
      icon: <SchoolIcon sx={{ color: '#b39ddb' }} />,
    },
    {
      title: t('experience.educationItems.abitur'),
      company: t('experience.companies.beruflichesGymnasium'),
      date: t('experience.dates.august2015June2018'),
      location: t('experience.details.performanceCourses'),
      icon: <SchoolIcon sx={{ color: '#b39ddb' }} />,
    },
  ];

  const TimelineColumn = ({ items }: { items: typeof experience }) => {
    return (
      <Box flex={1} sx={{ position: 'relative', minHeight: 350 }}>
        <Stack spacing={4} sx={{ position: 'relative', zIndex: 1 }}>
          {items.map((item, i) => (
            <Box key={i} sx={{ position: 'relative', minHeight: 100, display: 'flex', justifyContent: 'center' }}>
              {/* Vertikale Linie mittig zur Card, jetzt in Primärfarbe */}
              {i < items.length - 1 && (
                <Box sx={{
                  position: 'absolute',
                  left: '50%',
                  top: '100%',
                  height: '80px',
                  width: 3,
                  bgcolor: theme.palette.primary.main,
                  zIndex: 0,
                  borderRadius: 2,
                  transform: 'translateX(-50%)',
                }} />
              )}
              {/* Card mit Icon rechts oben - Primärfarbe für Border und Avatar */}
              <Card sx={{
                p: 2.5,
                borderRadius: 3,
                bgcolor: 'background.default',
                border: `1.5px solid ${theme.palette.primary.main}`,
                boxShadow: 0,
                minWidth: 0,
                flex: 1,
                position: 'relative',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'flex-start',
                alignItems: 'flex-start',
              }}>
                <Box sx={{ position: 'absolute', top: 12, right: 20, zIndex: 2 }}>
                  <Avatar sx={{ bgcolor: theme.palette.primary.main, width: 40, height: 40, border: `3px solid ${theme.palette.primary.main}` }}>
                    {React.cloneElement(item.icon, { sx: { color: '#fff', fontSize: 28 } })}
                  </Avatar>
                </Box>
                <Typography variant="h6" sx={{ fontWeight: 700 }}>{item.title}</Typography>
                <Typography variant="subtitle1" sx={{ fontWeight: 600, color: 'primary.main', mb: 1 }}>{item.company}</Typography>
                <Typography variant="body2" color="text.secondary">{item.date}</Typography>
                <Typography variant="body2" color="text.secondary">{item.location}</Typography>
              </Card>
            </Box>
          ))}
        </Stack>
      </Box>
    );
  };
  
  return (
    <Box component="section" id="experience-education" sx={{ maxWidth: 1400, mx: 'auto', my: 8, px: 2, position: 'relative', zIndex: 1 }}>
      <Card sx={{ bgcolor: 'background.paper', borderRadius: 4, p: { xs: 2, md: 4 }, boxShadow: 3 }}>
        <Typography variant="h3" align="center" sx={{ fontWeight: 800, color: 'primary.main', mb: 4 }}>
          {t('experience.title')}
        </Typography>
        <Stack direction={{ xs: 'column', md: 'row' }} spacing={4}>
          {/* Erfahrung */}
          <Box flex={1}>
            <Typography variant="h4" sx={{ fontWeight: 700, mb: 2 }}>
              {t('experience.experience')}
            </Typography>
            <TimelineColumn items={experience} />
          </Box>
          {/* Ausbildung */}
          <Box flex={1}>
            <Typography variant="h4" sx={{ fontWeight: 700, mb: 2 }}>
              {t('experience.education')}
            </Typography>
            <TimelineColumn items={education} />
          </Box>
        </Stack>
      </Card>
    </Box>
  );
};

export default ExperienceEducation; 