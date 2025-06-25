'use client';
import React from 'react';
import { Box, Typography, Chip, Stack, Divider, Container, Card, CardContent, CardActions, Button, Paper } from '@mui/material';
import { FaStar, FaCheckCircle, FaGithub, FaExternalLinkAlt, FaMobileAlt, FaGamepad, FaBrain, FaChartLine, FaUsers, FaPlayCircle } from 'react-icons/fa';

const featuredProject = {
  title: 'Aurax - Next-Gen Media Platform',
  description: 'Eine revolutionäre, interaktive Medienplattform für den europäischen Markt. Kombiniert Gamification, Community Building und moderne Technologien für eine einzigartige Nutzererfahrung.',
  features: [
    'Flutter Cross-Platform App',
    'Unity Game Integration',
    'AI-Powered Content Generation',
    'Secure Authentication System',
  ],
  tags: ['Flutter', 'Unity', 'Python', 'React', 'Node.js']
};

const otherProjects = [
  { icon: <FaMobileAlt size={40} />, title: 'Flutter Portfolio App', description: 'Cross-platform Portfolio App mit modernem UI/UX Design und interaktiven Animationen.', tags: ['Flutter', 'Dart'] },
  { icon: <FaGamepad size={40} />, title: 'Unity VR Experience', description: 'Immersive VR-Erfahrung mit interaktiven 3D-Elementen und haptischem Feedback.', tags: ['Unity', 'C#'] },
  { icon: <FaBrain size={40} />, title: 'AI Content Generator', description: 'KI-gestützte Plattform zur automatischen Generierung von Medieninhalten.', tags: ['Python', 'TensorFlow'] },
  { icon: <FaChartLine size={40} />, title: 'Analytics Dashboard', description: 'Echtzeit-Dashboard für Datenanalyse und Performance-Monitoring.', tags: ['React', 'Node.js'] },
  { icon: <FaUsers size={40} />, title: 'Community Platform', description: 'Plattform für Community-Building, Wettbewerbe und Teamwork.', tags: ['React', 'Node.js'] },
];

const Projects: React.FC = () => {
  return (
    <Box component="section" id="projects" sx={{ py: 8, bgcolor: 'background.default' }}>
      <Container maxWidth="lg">
        <Box sx={{ textAlign: 'center', mb: 6 }}>
          <Typography variant="h3" component="h2" gutterBottom sx={{ fontWeight: 700 }}>
            Projekte & Arbeiten
          </Typography>
          <Divider sx={{ width: 80, height: 4, mx: 'auto', bgcolor: 'primary.main', borderRadius: 2 }} />
        </Box>

        {/* Featured Project */}
        <Paper elevation={4} sx={{ p: 4, borderRadius: 4, mb: 8, bgcolor: 'background.paper' }}>
          <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', md: '1fr 1fr' }, gap: 4, alignItems: 'center' }}>
            <Box>
              <Chip icon={<FaStar />} label="Hauptprojekt" color="primary" sx={{ mb: 2 }} />
              <Typography variant="h4" component="h3" gutterBottom sx={{ fontWeight: 700 }}>{featuredProject.title}</Typography>
              <Typography variant="body1" color="text.secondary" sx={{ mb: 3 }}>{featuredProject.description}</Typography>
              <Stack spacing={1} mb={3}>
                {featuredProject.features.map(feat => (
                  <Stack direction="row" alignItems="center" spacing={1} key={feat}>
                    <FaCheckCircle color="success" />
                    <Typography variant="body2">{feat}</Typography>
                  </Stack>
                ))}
              </Stack>
              <Stack direction="row" flexWrap="wrap" gap={1} mb={3}>
                {featuredProject.tags.map(tag => <Chip key={tag} label={tag} variant="outlined" />)}
              </Stack>
              <Stack direction="row" spacing={2}>
                <Button variant="contained" startIcon={<FaExternalLinkAlt />}>Live Demo</Button>
                <Button variant="outlined" startIcon={<FaGithub />}>Source Code</Button>
              </Stack>
            </Box>
            <Box sx={{
              aspectRatio: '16 / 9',
              bgcolor: 'action.hover',
              borderRadius: 2,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: 'text.disabled'
            }}>
              <FaPlayCircle size={60} />
            </Box>
          </Box>
        </Paper>

        {/* Other Projects */}
        <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', sm: '1fr 1fr', md: '1fr 1fr 1fr' }, gap: 4 }}>
          {otherProjects.map(p => (
            <Card key={p.title} sx={{ height: '100%', display: 'flex', flexDirection: 'column', transition: '0.3s', '&:hover': { transform: 'scale(1.03)', boxShadow: 6 } }}>
              <CardContent sx={{ flexGrow: 1 }}>
                <Box sx={{ color: 'primary.main', mb: 2 }}>{p.icon}</Box>
                <Typography variant="h6" component="h4" gutterBottom sx={{ fontWeight: 600 }}>{p.title}</Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>{p.description}</Typography>
                <Stack direction="row" flexWrap="wrap" gap={1}>
                  {p.tags.map(tag => <Chip key={tag} label={tag} size="small" />)}
                </Stack>
              </CardContent>
              <CardActions>
                <Button size="small">Demo</Button>
                <Button size="small" variant="outlined">Code</Button>
              </CardActions>
            </Card>
          ))}
        </Box>

      </Container>
    </Box>
  );
};

export default Projects; 