'use client';
import React from 'react';
import { Box, Typography, Chip, Stack, Divider, Container, Card, CardContent, CardActions, Button, Paper } from '@mui/material';
import { FaStar, FaCheckCircle, FaGithub, FaExternalLinkAlt, FaMobileAlt, FaGamepad, FaBrain, FaChartLine, FaUsers, FaPlayCircle } from 'react-icons/fa';
import ChevronRightIcon from '@mui/icons-material/ChevronRight';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import Image from 'next/image';
import AVLogoProject from '../../public/av_logo.webp'; // Assuming same logo as header, can be different
import { useLanguage } from '../app/LanguageContext';
// import BlackForestAsylumPic from '../../public/black_forest_asylum.webp'; // If it exists
// import YLogoProject from '../../public/y_logo.webp'; // If it exists and is different from header

// Helper for chip colors
const chipColors: Array<'primary' | 'success' | 'warning' | 'error' | 'default' | 'secondary' | 'info'> = ['primary', 'success', 'warning', 'error'];

// Define the custom green color for the checkmark
const checkmarkColor = '#3DF58C';

const Projects: React.FC = () => {
  const { t } = useLanguage();

  const featuredProject = {
    title: 'AuraVention (MindFlow Engine)',
    description: t('projects.descriptions.auravention'),
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
      description: t('projects.descriptions.projectY'),
      tags: ['Flutter, Python, Rust'],
      slug: 'project-y',
      year: '2027',
      engines: ['Flutter', 'Python', 'Rust'],
      image: '/y_logo.webp',
      status: t('projects.status.inDevelopment'),
      detailUrl: '/projects/project-y',
    },
    {
      icon: <FaGamepad size={40} />, 
      title: 'Broxel Engine',
      description: t('projects.descriptions.broxelEngine'),
      tags: ['Bevy Engine'],
      slug: 'broxel-engine',
      year: '2027',
      engines: ['Bevy Engine'],
      status: t('projects.status.inDevelopment'),
      genres: ['ProcGen', 'Co-Creation'],
      detailUrl: '/projects/broxel-engine',
    },
    {
      icon: <FaGamepad size={40} />, 
      title: 'Black Forest Asylum', 
      description: t('projects.descriptions.blackForestAsylum'),
      tags: ['Unreal Engine'], 
      slug: 'black-forest-asylum',
      year: '2028',
      engines: ['Unreal Engine'],
      image: '/black_forest_asylum.webp',
      status: t('projects.status.planned'),
      genres: ['Psychological Horror', 'Exploration'],
      detailUrl: '/projects/black-forest-asylum',
    },
    {
      icon: <FaGamepad size={40} />, 
      title: 'Maze of Space', 
      description: t('projects.descriptions.mazeOfSpace'),
      tags: ['Godot'], 
      slug: 'maze-of-space',
      year: '2028',
      engines: ['Godot'],
      youtubeId: '9-YuMGMfzrQ',
      status: t('projects.status.prototype'),
      genres: ['Strategy', 'First-Person'],
      detailUrl: '/projects/maze-of-space',
    },
    {
      icon: <FaGamepad size={40} />, 
      title: 'Block Reversal', 
      description: t('projects.descriptions.blockReversal'),
      tags: ['Unity'], 
      slug: 'block-reversal',
      year: '2028',
      engines: ['Unity'],
      youtubeId: '6dGx8h18Bds',
      status: t('projects.status.published'),
      genres: ['Arcade', 'Action'],
      detailUrl: '/projects/block-reversal',
    },
    {
      icon: <FaGamepad size={40} />, 
      title: 'SLIME', 
      description: t('projects.descriptions.slime'),
      tags: ['Bevy Engine'], 
      slug: 'slime',
      year: '2029',
      engines: ['Bevy Engine'],
      youtubeId: 'HK8O6oQchKw',
      status: t('projects.status.cancelled'),
      genres: ['Survival', 'Physics'],
      detailUrl: '/projects/slime',
    },
  ];

  return (
    <Box component="section" id="projects" sx={{ py: 8, bgcolor: 'background.default' }}>
      <Container maxWidth="lg">
        <Box sx={{ textAlign: 'center', mb: 6 }}>
          <Typography variant="h3" component="h2" gutterBottom sx={{ fontWeight: 700 }}>
            {t('projects.title')}
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
              <Chip icon={<FaStar />} label={t('projects.mainProject')} color="primary" sx={{ mb: 2 }} />
              <Typography variant="h4" component="h3" gutterBottom sx={{ fontWeight: 700 }}>{featuredProject.title}</Typography>
              <Typography variant="body1" color="text.secondary" sx={{ mb: 3 }}>{featuredProject.description}</Typography>
              {/* Features as vertical list with green checkmarks and white text, no border or chip */}
              <Stack direction="column" spacing={2} my={2} alignItems="flex-start">
                <Box display="flex" alignItems="center" gap={1}>
                  <FaCheckCircle style={{ color: checkmarkColor, fontSize: 28 }} />
                  <Typography variant="h6" sx={{ color: '#fff', fontWeight: 500, fontSize: '1.1rem' }}>{t('projects.features.crossPlatform')}</Typography>
                </Box>
                <Box display="flex" alignItems="center" gap={1}>
                  <FaCheckCircle style={{ color: checkmarkColor, fontSize: 28 }} />
                  <Typography variant="h6" sx={{ color: '#fff', fontWeight: 500, fontSize: '1.1rem' }}>{t('projects.features.gameDesignAssistant')}</Typography>
                </Box>
                <Box display="flex" alignItems="center" gap={1}>
                  <FaCheckCircle style={{ color: checkmarkColor, fontSize: 28 }} />
                  <Typography variant="h6" sx={{ color: '#fff', fontWeight: 500, fontSize: '1.1rem' }}>{t('projects.features.aiContentGeneration')}</Typography>
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
              <Box sx={{
                width: { xs: 120, md: 180 },
                height: { xs: 120, md: 180 },
                borderRadius: 3,
                boxShadow: 4,
                bgcolor: 'background.default',
                border: '2px solid',
                borderColor: 'divider',
                mb: 2,
                overflow: 'hidden', // For next/image with borderRadius
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
              }}>
                <Image
                  src={AVLogoProject} // Use imported image
                  alt={featuredProject.title}
                  width={180} // Provide base width, will be scaled down by sx if container is smaller
                  height={180} // Provide base height
                  style={{
                    objectFit: 'contain',
                    maxWidth: '100%', // Ensure image scales down if container is smaller
                    height: 'auto',    // Maintain aspect ratio
                  }}
                />
              </Box>
              <Tooltip title={t('projects.learnMore')}>
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
                  p.status === t('projects.status.inDevelopment') ? 'secondary'
                  : p.status === t('projects.status.planned') ? 'warning'
                  : p.status === t('projects.status.prototype') ? 'success'
                  : p.status === t('projects.status.published') ? 'primary'
                  : p.status === t('projects.status.cancelled') ? 'error'
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
                    p.status === t('projects.status.inDevelopment') ? '#9b59b6' :
                    p.status === t('projects.status.planned') ? theme.palette.warning.main :
                    p.status === t('projects.status.prototype') ? theme.palette.success.main :
                    p.status === t('projects.status.published') ? theme.palette.primary.main :
                    p.status === t('projects.status.cancelled') ? theme.palette.error.main :
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
                      loading="lazy"
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
                {p.detailUrl && typeof p.detailUrl === 'string' && (
                  <Tooltip title={t('projects.learnMore')}>
                    <IconButton size="large" href={p.detailUrl}>
                      <ChevronRightIcon />
                    </IconButton>
                  </Tooltip>
                )}
              </CardActions>
            </Card>
          ))}
        </Box>

      </Container>
    </Box>
  );
};

export default Projects; 