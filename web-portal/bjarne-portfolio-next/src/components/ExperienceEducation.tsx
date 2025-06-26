'use client';
import React from 'react';
import { Box, Typography, Card, Stack, useTheme, Avatar } from '@mui/material';
import SchoolIcon from '@mui/icons-material/School';
import WorkIcon from '@mui/icons-material/Work';
import VolunteerActivismIcon from '@mui/icons-material/VolunteerActivism';
import RadioIcon from '@mui/icons-material/Radio';
import FlightIcon from '@mui/icons-material/Flight';

const experience = [
  {
    title: 'IT-Berater für Systemimplementierung',
    company: 'MACH AG',
    date: 'März 2022 - August 2023',
    location: 'Lübeck, Deutschland',
    icon: <WorkIcon sx={{ color: '#b39ddb' }} />,
  },
  {
    title: 'Dualer Student Wirtschaftsinformatik',
    company: 'MACH AG',
    date: 'Oktober 2018 - März 2022',
    location: 'Lübeck, Deutschland',
    icon: <SchoolIcon sx={{ color: '#b39ddb' }} />,
  },
  {
    title: 'Ehrenamtliche Lernhilfe',
    company: 'Gemeinschaftsschule Mölln',
    date: 'September 2014 - Juli 2015',
    location: 'Mölln, Deutschland',
    icon: <VolunteerActivismIcon sx={{ color: '#b39ddb' }} />,
  },
  {
    title: 'Ehrenamtlicher Radiomoderator',
    company: 'Unite FM (ehemals GTA-Radio)',
    date: 'Dezember 2012 - März 2014',
    location: 'Remote (Deutschland)',
    icon: <RadioIcon sx={{ color: '#b39ddb' }} />,
  },
];

const education = [
  {
    title: 'M.Sc. Medieninformatik',
    company: 'Technische Hochschule Lübeck',
    date: 'September 2023 - März 2026 (Note ~1,4)',
    location: 'Schwerpunkte: Software, Data & AI + Interactive 3D (Game Dev)',
    icon: <SchoolIcon sx={{ color: '#b39ddb' }} />,
  },
  {
    title: 'Auslandssemester Irland',
    company: 'Griffith College Dublin',
    date: 'Oktober 2020 - Februar 2021 (Note 1,0, 5. Semester)',
    location: 'Dublin, Irland',
    icon: <FlightIcon sx={{ color: '#b39ddb' }} />,
  },
  {
    title: 'B.Sc. Wirtschaftsinformatik',
    company: 'NORDAKADEMIE Hochschule der Wirtschaft',
    date: 'Oktober 2018 - März 2022 (Note 2,0)',
    location: 'Wirtschaftsinformatik (Thesis: Potenziale der Gamification in betrieblichen Anwendungssystemen, Note: 1,3)',
    icon: <SchoolIcon sx={{ color: '#b39ddb' }} />,
  },
  {
    title: 'Abitur',
    company: 'Berufliches Gymnasium Mölln',
    date: 'August 2015 - Juni 2018',
    location: 'Leistungskurse: Volkswirtschaftslehre und Mathematik',
    icon: <SchoolIcon sx={{ color: '#b39ddb' }} />,
  },
];

const TimelineColumn = ({ items }: { items: typeof experience }) => {
  const theme = useTheme();
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

const ExperienceEducation: React.FC = () => {
  const theme = useTheme();
  return (
    <Box component="section" id="experience-education" sx={{ maxWidth: 1400, mx: 'auto', my: 8, px: 2, position: 'relative', zIndex: 1 }}>
      <Card sx={{ bgcolor: 'background.paper', borderRadius: 4, p: { xs: 2, md: 4 }, boxShadow: 3 }}>
        <Typography variant="h3" align="center" sx={{ fontWeight: 800, color: 'primary.main', mb: 4 }}>
          Erfahrung & Ausbildung
        </Typography>
        <Stack direction={{ xs: 'column', md: 'row' }} spacing={4}>
          {/* Erfahrung */}
          <Box flex={1}>
            <Typography variant="h4" sx={{ fontWeight: 700, mb: 2 }}>
              Erfahrung
            </Typography>
            <TimelineColumn items={experience} />
          </Box>
          {/* Ausbildung */}
          <Box flex={1}>
            <Typography variant="h4" sx={{ fontWeight: 700, mb: 2 }}>
              Ausbildung
            </Typography>
            <TimelineColumn items={education} />
          </Box>
        </Stack>
      </Card>
    </Box>
  );
};

export default ExperienceEducation; 