'use client';
import React from 'react';
import { Box, Typography, Chip, Stack, Divider, Container, Card, CardContent, CardActions, Button, Paper } from '@mui/material';
import { FaStar, FaCheckCircle, FaGithub, FaExternalLinkAlt, FaMobileAlt, FaGamepad, FaBrain, FaChartLine, FaUsers, FaPlayCircle } from 'react-icons/fa';
import ChevronRightIcon from '@mui/icons-material/ChevronRight';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';

// Helper for chip colors
const chipColors: Array<'primary' | 'success' | 'warning' | 'error' | 'default' | 'secondary' | 'info'> = ['primary', 'success', 'warning', 'error'];

// Define the custom green color for the checkmark
const checkmarkColor = '#3DF58C';

const featuredProject = {
  title: 'AuraVention (MindFlow Engine)',
  description: 'Entfalte deine Kreativität überall mit der "MindFlow Engine" – der revolutionären, mobilen und engine-agnostischen Entwicklungsumgebung für die nächste Generation von Spielen und KI-gestützten Inhalten. Das Projekt wird im Rahmen einer Masterthesis erforscht und entwickelt. KI-gestützte Plattform zur automatischen Generierung von Medieninhalten mit Fokus auf Innovation, Automatisierung und Co-Creation. Entwickle, designe und teile flexibel – unterstützt durch einen integrierten Asset-Store und moderne Team-Workflows. Auraventionen sind innovative, KI-gestützte Medien- und Spieleprojekte, die Kreativität, Technologie und Community auf neuartige Weise verbinden.',
  features: [
    'Cross-Platform',
    'Game Design Assistant',
    'AI Content Generation',
  ],
  tags: ['2026', 'Flutter, Python'],
  slug: 'auravention',
  year: '2026',
  engines: ['Flutter', 'Python'],
  image: '/av_logo.webp',
};

const otherProjects = [
  {
    icon: <img src="/y_logo.webp" alt="Project Y" style={{ width: 40, height: 40, borderRadius: 4 }} />, 
    title: 'Project Y', 
    description: 'Innovative Plattform für KI-gestützte Medienproduktion und Community-Building. Verbindet modernste Technologien mit Gamification und Teamwork für ein einzigartiges Nutzererlebnis.',
    tags: ['Flutter, Python, Rust'],
    slug: 'project-y',
    year: '2027',
    engines: ['Flutter', 'Python', 'Rust'],
    image: '/y_logo.webp',
    status: 'In Entwicklung',
  },
  {
    icon: <FaGamepad size={40} />, 
    title: 'Broxel Engine',
    description: 'Modulare Open-Source-Voxel-Engine (geplant 2027) für Next-Gen-Games und kreative Tools. Fokus auf prozedurale Welten, Modding, Cross-Platform-Support und Community-Integration. Basierend auf Bevy Engine.',
    tags: ['Bevy Engine'],
    slug: 'broxel-engine',
    year: '2027',
    engines: ['Bevy Engine'],
    status: 'In Entwicklung',
    genres: ['ProcGen', 'Co-Creation'],
  },
  {
    icon: <FaGamepad size={40} />, 
    title: 'Black Forest Asylum', 
    description: 'Atmosphärisches Horror-Adventure (2028) mit Fokus auf immersives Storytelling, Teamwork und Community-Events. Entwickelt in Unreal Engine für ein packendes Spielerlebnis.',
    tags: ['Unreal Engine'], 
    slug: 'black-forest-asylum',
    year: '2028',
    engines: ['Unreal Engine'],
    image: '/black_forest_asylum.webp',
    status: 'Geplant',
    genres: ['Psychological Horror', 'Exploration'],
  },
  {
    icon: <FaGamepad size={40} />, 
    title: 'Maze of Space', 
    description: 'Innovatives Maze-Game (2024, Prototyp in Unity) mit geplanter Erweiterung 2028: Neue Spielmodi, Multiplayer-Features und kreative Herausforderungen. Entwickelt in Godot.',
    tags: ['Godot'], 
    slug: 'maze-of-space',
    year: '2028',
    engines: ['Godot'],
    youtubeId: '9-YuMGMfzrQ',
    status: 'Fertiger Prototyp',
    genres: ['Strategy', 'First-Person'],
  },
  {
    icon: <FaGamepad size={40} />, 
    title: 'Block Reversal', 
    description: 'Casual-Game-Klassiker (2018, Prototyp in Unity) mit geplantem 3D-Nachfolger "Universal Blox" (2028): Neue Spielmodi, moderne Grafik, Multiplayer und Cross-Platform. Entwickelt in Unity und perspektivisch auf Broxel Engine.',
    tags: ['Unity'], 
    slug: 'block-reversal',
    year: '2028',
    engines: ['Unity'],
    youtubeId: '6dGx8h18Bds',
    status: 'Veröffentlicht (Google Play Store)',
    genres: ['Arcade', 'Action'],
  },
  {
    icon: <FaGamepad size={40} />, 
    title: 'SLIME', 
    description: 'Physikbasiertes Partyspiel (2017/2029, Prototyp in Unity): Steuere einen Schleim, sauge Items auf und meistere spaßige Herausforderungen. 2029 als Multiplayer-Partyspiel in Bevy Engine.',
    tags: ['Bevy Engine'], 
    slug: 'slime',
    year: '2029',
    engines: ['Bevy Engine'],
    youtubeId: 'HK8O6oQchKw',
    status: 'Abgebrochen',
    genres: ['Survival', 'Physics'],
  },
];

const Projects: React.FC = () => {
  return (
    <Box component="section" id="projects" sx={{ py: 8, bgcolor: 'background.default' }}>
      <Container maxWidth="lg">
        <Box sx={{ textAlign: 'center', mb: 6 }}>
          <Typography variant="h3" component="h2" gutterBottom sx={{ fontWeight: 700 }}>
            Projekte
          </Typography>
          <Divider sx={{ width: 80, height: 4, mx: 'auto', bgcolor: 'primary.main', borderRadius: 2 }} />
        </Box>

        {/* Featured Project */}
        <Paper elevation={4} sx={{ p: { xs: 2, md: 4 }, borderRadius: 4, mb: 8, bgcolor: 'background.paper', boxShadow: 6 }}>
          <Box sx={{
            display: 'flex',
            flexDirection: { xs: 'column', md: 'row' },
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: { xs: 4, md: 6 },
            minHeight: { md: 260 },
          }}>
            <Box flex={1} sx={{ minWidth: 0 }}>
              <Chip icon={<FaStar />} label="Hauptprojekt" color="primary" sx={{ mb: 2 }} />
              <Typography variant="h4" component="h3" gutterBottom sx={{ fontWeight: 700 }}>{featuredProject.title}</Typography>
              <Typography variant="body1" color="text.secondary" sx={{ mb: 3 }}>{featuredProject.description}</Typography>
              {/* Features as vertical list with green checkmarks and white text, no border or chip */}
              <Stack direction="column" spacing={2} my={2} alignItems="flex-start">
                <Box display="flex" alignItems="center" gap={1}>
                  <FaCheckCircle style={{ color: checkmarkColor, fontSize: 28 }} />
                  <Typography variant="h6" sx={{ color: '#fff', fontWeight: 500, fontSize: '1.1rem' }}>Cross-Platform</Typography>
                </Box>
                <Box display="flex" alignItems="center" gap={1}>
                  <FaCheckCircle style={{ color: checkmarkColor, fontSize: 28 }} />
                  <Typography variant="h6" sx={{ color: '#fff', fontWeight: 500, fontSize: '1.1rem' }}>Game Design Assistant</Typography>
                </Box>
                <Box display="flex" alignItems="center" gap={1}>
                  <FaCheckCircle style={{ color: checkmarkColor, fontSize: 28 }} />
                  <Typography variant="h6" sx={{ color: '#fff', fontWeight: 500, fontSize: '1.1rem' }}>AI Content Generation</Typography>
                </Box>
              </Stack>
              {/* Chips for year and engines below features */}
              <Stack direction="row" flexWrap="wrap" gap={1} mb={2}>
                {[featuredProject.year, ...featuredProject.engines].map((label, idx) => (
                  <Chip key={label} label={label} color={chipColors[idx % chipColors.length]} sx={{ fontWeight: 600, fontSize: '1rem', color: '#fff' }} />
                ))}
              </Stack>
            </Box>
            <Box flexShrink={0} p={2} display="flex" flexDirection="column" alignItems="center">
              <Box
                component="img"
                src={featuredProject.image}
                alt={featuredProject.title}
                sx={{
                  width: { xs: 120, md: 180 },
                  height: { xs: 120, md: 180 },
                  objectFit: 'contain',
                  borderRadius: 3,
                  boxShadow: 4,
                  bgcolor: 'background.default',
                  border: '2px solid',
                  borderColor: 'divider',
                  mb: 2,
                }}
              />
              <Tooltip title="Mehr erfahren">
                <IconButton size="large" href={`/projects/${featuredProject.slug}`} sx={{ transition: 'all 0.2s', '&:hover': { color: 'primary.main', transform: 'translateX(4px) scale(1.15)' } }}>
                  <ChevronRightIcon fontSize="large" />
                </IconButton>
              </Tooltip>
            </Box>
          </Box>
        </Paper>

        {/* Other Projects */}
        <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', sm: '1fr 1fr', md: '1fr 1fr 1fr' }, gap: 4 }}>
          {otherProjects.map(p => (
            <Card
              key={p.title}
              sx={{ height: '100%', display: 'flex', flexDirection: 'column', transition: '0.3s', position: 'relative', '&:hover': { transform: 'scale(1.03)', boxShadow: 6 } }}
            >
              <Chip
                label={p.status}
                color={
                  p.status === 'In Entwicklung' ? 'secondary'
                  : p.status === 'Geplant' ? 'warning'
                  : p.status === 'Fertiger Prototyp' ? 'success'
                  : p.status === 'Veröffentlicht (Google Play Store)' ? 'primary'
                  : p.status === 'Abgebrochen' ? 'error'
                  : 'secondary'
                }
                size="small"
                sx={{
                  position: 'absolute',
                  top: 12,
                  right: 12,
                  zIndex: 2,
                  fontWeight: 600,
                  fontSize: '0.95rem',
                  letterSpacing: 0.2,
                  color: '#fff',
                  backgroundColor: (theme) =>
                    p.status === 'In Entwicklung' ? '#9b59b6' :
                    p.status === 'Geplant' ? theme.palette.warning.main :
                    p.status === 'Fertiger Prototyp' ? theme.palette.success.main :
                    p.status === 'Veröffentlicht (Google Play Store)' ? theme.palette.primary.main :
                    p.status === 'Abgebrochen' ? theme.palette.error.main :
                    theme.palette.grey[800],
                }}
              />
              <CardContent sx={{ flexGrow: 1 }}>
                <Box sx={{ color: 'primary.main', mb: 2 }}>{p.icon}</Box>
                {p.youtubeId && (
                  <Box sx={{ mb: 2, borderRadius: 2, overflow: 'hidden', aspectRatio: '16/9', bgcolor: 'grey.900', boxShadow: 2 }}>
                    <iframe
                      width="100%"
                      height="180"
                      src={`https://www.youtube.com/embed/${p.youtubeId}`}
                      title={p.title}
                      frameBorder="0"
                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                      allowFullScreen
                      style={{ display: 'block', width: '100%', height: '100%' }}
                    />
                  </Box>
                )}
                <Typography
                  variant="h6"
                  sx={{
                    fontWeight: 700,
                    color: 'primary.main',
                    textDecoration: 'none',
                    transition: 'color 0.2s',
                    '&:hover': {
                      color: 'secondary.main',
                      textDecoration: 'none',
                    },
                    mb: 1,
                    display: 'block',
                  }}
                >
                  {p.title}
                </Typography>
                <Typography
                  variant="body2"
                  color="text.secondary"
                  sx={{
                    mb: 2,
                    textDecoration: 'none',
                    '& a': {
                      color: 'inherit',
                      textDecoration: 'none',
                      '&:hover': { textDecoration: 'underline' },
                    },
                  }}
                  component="div"
                >
                  {p.description}
                </Typography>
                <Stack direction="row" flexWrap="wrap" gap={1}>
                  {[p.year, ...p.engines, ...(p.genres || [])].map((label, idx) => (
                    <Chip key={label} label={label} color={chipColors[idx % chipColors.length]} sx={{ color: '#fff' }} />
                  ))}
                </Stack>
              </CardContent>
              <CardActions sx={{ justifyContent: 'flex-end' }}>
                <Tooltip title="Mehr erfahren">
                  <IconButton size="large" href={`/projects/${p.slug}`}>
                    <ChevronRightIcon />
                  </IconButton>
                </Tooltip>
              </CardActions>
            </Card>
          ))}
        </Box>

      </Container>
    </Box>
  );
};

export default Projects; 