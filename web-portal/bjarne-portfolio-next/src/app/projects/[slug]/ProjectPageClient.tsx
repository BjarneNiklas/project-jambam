'use client';

import React, { useState, useCallback } from 'react';
import Image from 'next/image';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import LaunchIcon from '@mui/icons-material/Launch';
import Footer from '@/components/Footer';
import { useLanguage } from '../../LanguageContext';
import { Box, Chip, IconButton, Modal, Typography, Fade, Stack, Paper, Button } from '@mui/material';
import { FaCogs, FaCode, FaGamepad, FaRobot, FaCube, FaSearch, FaBrain, FaShareAlt, FaCalendarAlt, FaTag, FaCheckCircle, FaMicrochip, FaPlayCircle } from 'react-icons/fa';
import Snackbar from '@mui/material/Snackbar';
import Tooltip from '@mui/material/Tooltip';
import BubbleChartIcon from '@mui/icons-material/BubbleChart';
import HubIcon from '@mui/icons-material/Hub';
import Grid4x4Icon from '@mui/icons-material/Grid4x4';
import SportsEsportsIcon from '@mui/icons-material/SportsEsports';
import { BiCube } from 'react-icons/bi';

interface Project {
  slug: string;
  name: string;
  shortDescription: string;
  longDescription: string;
  imageUrls?: string[];
  technologies: string[];
  url?: string;
  githubUrl?: string;
  year?: string;
  genres?: string[];
  status?: string;
  youtubeId?: string;
}

interface ProjectPageClientProps {
  project: Project;
}

// Premium Color Palette - Linear/Vercel inspired
const COLORS = {
  primary: '#14b8a6',
  primaryLight: '#2dd4bf',
  primaryDark: '#0f766e',
  background: '#0a0a0a',
  surface: '#18181b',
  surfaceLight: '#27272a',
  text: '#ffffff',
  textSecondary: '#a1a1aa',
  accent: '#8b5cf6',
  success: '#10b981',
  warning: '#f59e0b',
  error: '#ef4444',
  border: 'rgba(255, 255, 255, 0.1)',
  glow: 'rgba(20, 184, 166, 0.3)',
};

const techIcons: Record<string, React.ReactElement> = {
  'Unreal Engine': <FaGamepad />,
  'C++': <FaCode />,
  'Horror Design': <FaRobot />,
  'Voxel Graphics': <FaCube />,
  'Exploration': <FaSearch />,
  'Psychological Horror': <FaBrain />,
  'Bevy Engine': <BubbleChartIcon />,
  'SLIME': <BubbleChartIcon />,
  'Godot': <HubIcon />,
  'GDScript': <FaCode />,
  'Multiplayer': <FaShareAlt />,
  'Strategy': <FaBrain />,
  'Unity': <FaGamepad />,
  'C#': <FaCode />,
  '3D Graphics': <FaCube />,
  'Rust': <FaCode />,
  'ProcGen': <FaCogs />,
  'Modding': <FaCogs />,
  'Next.js': <FaCode />,
  'React': <FaCode />,
  'TypeScript': <FaCode />,
  'Node.js': <FaCode />,
  'MongoDB': <FaCogs />,
  'Tailwind CSS': <FaCogs />,
  'Vercel': <FaCogs />,
  'Flutter': <BubbleChartIcon />,
  'Python': <FaCode />,
  'AI': <FaRobot />,
  'Machine Learning': <FaBrain />,
  'Multi-Agent Systems': <FaRobot />,
  'Block Reversal': <Grid4x4Icon />,
};

// Sidebar-Icon-Map (wie in Sidebar.tsx, inkl. MUI-Icons und Images)
const projectMediaIcons: Record<string, React.ReactElement> = {
  'auravention': <Image src="/av_logo.webp" alt="AuraVention" width={180} height={180} style={{ borderRadius: 8, boxShadow: '0 0 40px #14b8a6' }} />,
  'broxel-engine': <BiCube size={180} style={{ color: '#14b8a6', filter: 'drop-shadow(0 0 40px #14b8a6)' }} />,
  'project-y': <Image src="/y_logo.webp" alt="Project Y" width={180} height={180} style={{ borderRadius: 8, boxShadow: '0 0 40px #14b8a6' }} />,
  'maze-of-space': <SportsEsportsIcon sx={{ fontSize: 180, color: '#14b8a6', filter: 'drop-shadow(0 0 40px #14b8a6)' }} />,
  'block-reversal': <Grid4x4Icon sx={{ fontSize: 180, color: '#8b5cf6', filter: 'drop-shadow(0 0 40px #8b5cf6)' }} />,
  'slime': <BubbleChartIcon sx={{ fontSize: 180, color: '#14b8a6', filter: 'drop-shadow(0 0 40px #14b8a6)' }} />,
};

export default function ProjectPageClient({ project }: ProjectPageClientProps) {
  const { t, lang } = useLanguage();
  const slug = project.slug;
  const name = t(`projects.details.${slug}.name`) || project.name;
  const shortDescription = t(`projects.details.${slug}.shortDescription`) || project.shortDescription;
  const longDescription = t(`projects.details.${slug}.longDescription`) || project.longDescription;
  const demoProject = { ...project };
  
  if (demoProject.slug === 'maze-of-space') {
    demoProject.year = demoProject.year || '2024';
    demoProject.genres = demoProject.genres || ['Maze', 'Strategy', 'First-Person'];
  }
  if (demoProject.slug === 'block-reversal') {
    demoProject.year = demoProject.year || '2028';
    demoProject.genres = demoProject.genres || ['Casual', 'Puzzle'];
  }
  if (demoProject.slug === 'slime') {
    demoProject.year = demoProject.year || '2029';
    demoProject.genres = demoProject.genres || ['Survival', 'Physics', 'Party Game'];
  }
  
  const projectImages = demoProject.imageUrls && demoProject.imageUrls.length > 0 ? demoProject.imageUrls : [];
  const [lightboxIdx, setLightboxIdx] = useState<number|null>(null);
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMsg, setSnackbarMsg] = useState('');
  const [showVideo, setShowVideo] = useState(false);

  const openLightbox = (idx: number) => setLightboxIdx(idx);
  const closeLightbox = () => setLightboxIdx(null);
  const nextImg = useCallback(() => setLightboxIdx(i => (i !== null ? (i + 1) % projectImages.length : null)), [projectImages.length]);
  const prevImg = useCallback(() => setLightboxIdx(i => (i !== null ? (i - 1 + projectImages.length) % projectImages.length : null)), [projectImages.length]);

  const handleShare = async () => {
    const shareUrl = window.location.href;
    if (navigator.share) {
      try {
        await navigator.share({ title: demoProject.name, url: shareUrl });
        setSnackbarMsg(t('projects.sharedSuccess') || 'Page shared!');
      } catch {
        setSnackbarMsg(t('projects.sharedCancelled') || 'Sharing cancelled.');
      }
    } else {
      await navigator.clipboard.writeText(shareUrl);
      setSnackbarMsg(t('projects.linkCopied') || 'Link copied!');
    }
    setSnackbarOpen(true);
  };

  const techs = (() => {
    const arr = demoProject.technologies.filter(t => t !== 'Blueprints');
    if (demoProject.slug === 'black-forest-asylum') {
        if (!arr.includes('Exploration')) arr.push('Exploration');
        if (!arr.includes('Psychological Horror')) arr.push('Psychological Horror');
    }
    return arr;
  })();

  // Individuelle Quickfacts je nach Projekt
  const quickfacts = (() => {
    switch (slug) {
      case 'black-forest-asylum':
        return {
          engine: 'Unreal Engine',
          genre: 'Horror',
          status: 'Planned',
          year: '2028'
        };
      case 'maze-of-space':
        return {
          engine: 'Godot',
          genre: 'Strategy',
          status: 'Prototype',
          year: '2024'
        };
      case 'block-reversal':
        return {
          engine: 'Unity',
          genre: 'Casual',
          status: 'Released',
          year: '2018'
        };
      case 'slime':
        return {
          engine: 'Bevy Engine',
          genre: 'Physics',
          status: 'Prototype',
          year: '2017/2029'
        };
      case 'broxel-engine':
        return {
          engine: 'Bevy Engine',
          genre: 'Voxel',
          status: 'Planned',
          year: '2027'
        };
      case 'project-y':
        return {
          engine: 'Flutter',
          genre: 'Social/AI',
          status: 'Prototype',
          year: '-'
        };
      case 'aurax-media-platform':
        return {
          engine: 'Next.js',
          genre: 'Media Platform',
          status: 'Released',
          year: '-'
        };
      case 'portfolio-website':
        return {
          engine: 'Next.js',
          genre: 'Portfolio',
          status: 'Released',
          year: '-'
        };
      case 'auravention':
        return {
          engine: 'Flutter',
          genre: 'KI/Engine',
          status: 'Prototype',
          year: '2023'
        };
      default:
        return {
          engine: demoProject.technologies && demoProject.technologies.length > 0 ? demoProject.technologies[0] : '-',
          genre: demoProject.genres && demoProject.genres.length > 0 ? demoProject.genres[0] : '-',
          status: demoProject.status || '-',
          year: demoProject.year || '-'
        };
    }
  })();

  React.useEffect(() => {
    if (lightboxIdx !== null) {
      const handler = (e: KeyboardEvent) => {
        if (e.key === 'Escape') closeLightbox();
        if (e.key === 'ArrowRight') nextImg();
        if (e.key === 'ArrowLeft') prevImg();
      };
      window.addEventListener('keydown', handler);
      return () => window.removeEventListener('keydown', handler);
    }
  }, [lightboxIdx, nextImg, prevImg]);

  // Robust image path logic
  let mainImage = '/placeholder_generic.svg';
  if (projectImages[0] && projectImages[0].trim() !== '') {
    if (projectImages[0].startsWith('/images/projects/')) {
      mainImage = '/' + projectImages[0].split('/').pop();
    } else {
      mainImage = projectImages[0];
    }
  } else if (slug === 'black-forest-asylum') {
    mainImage = '/bfa1.webp';
  }

  // Add support for YouTube video if available
  const youtubeId = project.youtubeId || demoProject.youtubeId;

  // Tag/Chip-Logik: Sammle alle relevanten Tags, unique, sinnvoll sortiert
  const allTags = Array.from(new Set([
    quickfacts.engine,
    quickfacts.genre,
    quickfacts.status,
    quickfacts.year,
    ...techs
  ].filter(Boolean)));

  return (
    <div className="min-h-screen flex flex-col" style={{ backgroundColor: COLORS.background }}>
      <div className="flex flex-1 w-full">
        <div className="hidden md:block" style={{ width: 220, flexShrink: 0 }} />
        
        {/* Premium Container with Maximal White Space */}
        <div className="w-full" style={{ padding: '0 48px' }}>
          <main className="flex-1 max-w-7xl mx-auto my-0 bg-transparent rounded-3xl shadow-none border-none min-h-[70vh] flex flex-col relative items-center" style={{ padding: '48px 32px' }}>
            {/* Breadcrumbs and Back Button */}
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 3, width: '100%' }}>
              <Button href="/" startIcon={<ArrowBackIcon />} sx={{ color: '#14b8a6', fontWeight: 700, textTransform: 'none', fontSize: 18, mr: 2 }}>
                Zurück
              </Button>
              <Typography sx={{ color: '#a1a1aa', fontWeight: 500, fontSize: 16 }}>
                <span style={{ cursor: 'pointer', color: '#14b8a6' }} onClick={() => window.location.href = '/'}>Home</span>
                <span style={{ margin: '0 8px' }}>/</span>
                <span style={{ cursor: 'pointer', color: '#14b8a6' }} onClick={() => window.location.href = '/projects'}>Projekte</span>
                <span style={{ margin: '0 8px' }}>/</span>
                <span style={{ color: '#fff', fontWeight: 700 }}>{name}</span>
              </Typography>
            </Box>
            {/* Modern Shop-like Hero Section */}
            <Box sx={{ 
              display: 'grid', 
              gridTemplateColumns: { xs: '1fr', md: 'minmax(320px,400px) 1fr' }, 
              gap: 1.2, 
              alignItems: 'center', 
              mb: 6, 
              mt: 2 
            }}>
              {/* Image Column */}
              <Box sx={{ display: 'flex', justifyContent: { xs: 'center', md: 'flex-start' }, alignItems: 'center', position: 'relative' }}>
                <Box sx={{
                  width: { xs: 240, sm: 320, md: 400 },
                  height: { xs: 240, sm: 320, md: 400 },
                  position: 'relative',
                  zIndex: 2,
                  mt: { xs: 1, md: 0 },
                  mb: { xs: 1, md: 0 },
                  borderRadius: 4,
                  overflow: 'hidden',
                  boxShadow: '0 8px 48px rgba(20,184,166,0.18)',
                  background: '#000',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}>
                  {youtubeId ? (
                    showVideo ? (
                      <Box sx={{ position: 'relative', width: '100%', height: '100%' }}>
                        <iframe
                          src={`https://www.youtube.com/embed/${youtubeId}?autoplay=1`}
                          title={name}
                          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                          allowFullScreen
                          style={{
                            border: 0,
                            width: '100%',
                            height: '100%',
                            aspectRatio: '16/9',
                            borderRadius: 4,
                            background: '#000',
                            display: 'block',
                          }}
                        />
                      </Box>
                    ) : (
                      <Box sx={{ position: 'relative', width: '100%', height: '100%', cursor: 'pointer' }} onClick={() => setShowVideo(true)}>
                        <Image
                          src={`https://img.youtube.com/vi/${youtubeId}/hqdefault.jpg`}
                          alt={name}
                          fill
                          style={{ objectFit: 'cover', borderRadius: 4, filter: 'brightness(0.85)' }}
                          sizes="(max-width: 600px) 100vw, 400px"
                          priority
                        />
                        <Box sx={{
                          position: 'absolute',
                          top: '50%',
                          left: '50%',
                          transform: 'translate(-50%, -50%)',
                          zIndex: 2,
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                        }}>
                          <FaPlayCircle style={{ fontSize: 80, color: '#fff', filter: 'drop-shadow(0 4px 24px #000)' }} />
                        </Box>
                      </Box>
                    )
                  ) : (
                    slug === 'black-forest-asylum' ? (
                      <Image
                        src={mainImage}
                        alt={name}
                        fill
                        style={{ objectFit: 'cover', borderRadius: 4 }}
                        sizes="(max-width: 600px) 100vw, 400px"
                        priority
                      />
                    ) : (
                      projectMediaIcons[slug] || <FaGamepad size={180} color="#14b8a6" style={{ filter: 'drop-shadow(0 0 40px #14b8a6)' }} />
                    )
                  )}
                </Box>
              </Box>
              {/* Content Column */}
              <Box>
                <Paper elevation={0} sx={{
                  background: 'none',
                  borderRadius: 0,
                  p: { xs: 1, md: 3 },
                  boxShadow: 'none',
                  position: 'relative',
                  zIndex: 3,
                  mt: { xs: -8, md: 0 },
                }}>
                  {/* Title */}
                  <Typography variant="h2" sx={{
                    fontWeight: 900,
                    fontSize: { xs: 36, md: 56 },
                    mb: 1.2,
                    letterSpacing: 2,
                    background: 'linear-gradient(90deg, #14b8a6 0%, #0d9488 100%)',
                    backgroundClip: 'text',
                    WebkitBackgroundClip: 'text',
                    WebkitTextFillColor: 'transparent',
                    textShadow: '0 8px 48px rgba(20,184,166,0.3)',
                    lineHeight: 1.1,
                  }}>{name}</Typography>
                  {/* Alle Tags/Chips (unique, gesammelt, sinnvoll sortiert) */}
                  <Stack direction="row" spacing={0.7} sx={{ mb: 1.2, flexWrap: 'wrap' }}>
                    {allTags.map((tag) => (
                    <Chip 
                        key={tag}
                        label={tag}
                        size="medium"
                      sx={{ 
                          background: 'linear-gradient(135deg, rgba(20,184,166,0.15) 0%, rgba(20,184,166,0.25) 100%)',
                        color: COLORS.text, 
                          fontWeight: 500,
                          fontSize: '1rem',
                          px: 2,
                          py: 1,
                          borderRadius: '12px',
                          border: `1px solid rgba(20,184,166,0.3)`,
                        backdropFilter: 'blur(10px)',
                          mb: 1,
                          mr: 1,
                        '&:hover': {
                            background: 'linear-gradient(135deg, rgba(20,184,166,0.25) 0%, rgba(20,184,166,0.35) 100%)',
                            borderColor: 'rgba(20,184,166,0.6)',
                          transform: 'scale(1.05)',
                        }
                      }} 
                    />
                    ))}
                  </Stack>
                  {/* Description */}
                  <Typography variant="h6" sx={{
                    color: COLORS.textSecondary,
                    fontWeight: 500,
                    fontSize: { xs: 18, md: 22 },
                    mb: 1.2,
                    lineHeight: 1.4,
                  }}>{shortDescription}</Typography>
                  {/* Meta Badges */}
                  <Stack direction="row" spacing={1.2} sx={{ mb: 1.2, flexWrap: 'wrap' }}>
                    <Chip icon={<FaMicrochip />} label={quickfacts.engine} sx={{ bgcolor: '#14b8a6', color: '#fff', fontWeight: 700, fontSize: 16 }} />
                    <Chip icon={<FaTag />} label={quickfacts.genre} sx={{ bgcolor: '#0d9488', color: '#fff', fontWeight: 700, fontSize: 16 }} />
                    <Chip icon={<FaCheckCircle />} label={quickfacts.status} sx={{ bgcolor: '#27272a', color: '#14b8a6', fontWeight: 700, fontSize: 16 }} />
                    <Chip icon={<FaCalendarAlt />} label={quickfacts.year} sx={{ bgcolor: '#18181b', color: '#14b8a6', fontWeight: 700, fontSize: 16 }} />
                  </Stack>
                  {/* CTA and Share Buttons */}
                  <Stack direction="row" spacing={1.2} sx={{ mb: 1.2 }}>
                    {youtubeId && !showVideo && (
                      <Button variant="outlined" color="primary" size="large" onClick={() => setShowVideo(true)} sx={{ fontWeight: 700, fontSize: 18, borderRadius: 3, px: 3, borderColor: '#14b8a6', color: '#14b8a6', display: 'flex', alignItems: 'center', gap: 1 }}>
                        <FaPlayCircle style={{ marginRight: 8, fontSize: 20 }} />
                        {lang === 'de' ? 'Video abspielen' : 'Show Video'}
                      </Button>
                    )}
                    <Button variant="outlined" color="primary" size="large" href={demoProject.url && demoProject.url !== '#' ? demoProject.url : (lang === 'de' ? '/de#projects' : '/en#projects')} target="_blank" sx={{ fontWeight: 700, fontSize: 18, borderRadius: 3, px: 3, borderColor: '#14b8a6', color: '#14b8a6', display: 'flex', alignItems: 'center', gap: 1 }}>
                      <LaunchIcon style={{ marginRight: 8, fontSize: 20 }} />
                      {lang === 'de' ? 'Zur Webseite' : 'Visit Website'}
                    </Button>
              {demoProject.url && demoProject.url !== '#' && (
                      <Button variant="contained" color="primary" size="large" href={demoProject.url} target="_blank" sx={{ fontWeight: 700, fontSize: 18, borderRadius: 3, px: 4, boxShadow: '0 8px 32px rgba(20,184,166,0.3)' }}>Mehr erfahren</Button>
                    )}
                    <Button variant="outlined" color="primary" size="large" onClick={handleShare} sx={{ fontWeight: 700, fontSize: 18, borderRadius: 3, px: 4, borderColor: '#14b8a6', color: '#14b8a6', display: 'flex', alignItems: 'center', gap: 1 }}>
                      <FaShareAlt style={{ marginRight: 8, fontSize: 20 }} />
                      Teilen
                    </Button>
              </Stack>
            </Paper>
              </Box>
            </Box>

            {/* Premium Feature Highlights */}
            <Box sx={{ mb: 8 }}>
              <Typography variant="h4" sx={{ 
                textAlign: 'center', 
                mb: 6, 
                fontWeight: 700, 
                color: COLORS.text,
                letterSpacing: 1
              }}>
                Key Features
              </Typography>
              <Stack direction={{ xs: 'column', md: 'row' }} spacing={4}>
                {(() => {
                  // Project-specific key features
                  const features = (() => {
                    switch (slug) {
                      case 'black-forest-asylum':
                        return [
                          { icon: <FaBrain />, title: 'Psychological Horror', desc: 'Deep psychological terror elements' },
                          { icon: <FaSearch />, title: 'Atmospheric Exploration', desc: 'Immersive environmental storytelling' },
                          { icon: <FaGamepad />, title: 'Community Events', desc: 'Collaborative horror experiences' }
                        ];
                      case 'maze-of-space':
                        return [
                          { icon: <Grid4x4Icon />, title: 'Strategic Maze', desc: 'Complex puzzle-solving mechanics' },
                          { icon: <FaShareAlt />, title: 'Multiplayer', desc: 'Competitive maze challenges' },
                          { icon: <FaBrain />, title: 'First-Person', desc: 'Immersive 3D navigation' }
                        ];
                      case 'block-reversal':
                        return [
                          { icon: <Grid4x4Icon />, title: 'Block Mechanics', desc: 'Innovative block manipulation' },
                          { icon: <FaGamepad />, title: 'Casual Gameplay', desc: 'Accessible puzzle design' },
                          { icon: <FaCube />, title: '3D Evolution', desc: 'Modern 3D graphics planned' }
                        ];
                      case 'slime':
                        return [
                          { icon: <BubbleChartIcon />, title: 'Physics Engine', desc: 'Realistic slime physics' },
                          { icon: <FaShareAlt />, title: 'Party Game', desc: 'Multiplayer fun mechanics' },
                          { icon: <FaCogs />, title: 'Item Collection', desc: 'Strategic item absorption' }
                        ];
                      case 'broxel-engine':
                        return [
                          { icon: <BiCube />, title: 'Voxel Graphics', desc: 'Advanced voxel rendering' },
                          { icon: <FaCogs />, title: 'Procedural Generation', desc: 'Dynamic world creation' },
                          { icon: <FaCogs />, title: 'Modding Support', desc: 'Extensive modding tools' }
                        ];
                      case 'auravention':
                        return [
                          { icon: <FaRobot />, title: 'AI Engine', desc: 'Multi-agent AI systems' },
                          { icon: <FaBrain />, title: 'Creative AI', desc: 'AI-powered content generation' },
                          { icon: <FaShareAlt />, title: 'Collaboration', desc: 'Team-based creative workflows' }
                        ];
                      case 'project-y':
                        return [
                          { icon: <FaRobot />, title: 'Social AI', desc: 'AI-enhanced social features' },
                          { icon: <FaShareAlt />, title: 'Community', desc: 'Collaborative creative space' },
                          { icon: <FaBrain />, title: 'Gamification', desc: 'Engaging reward systems' }
                        ];
                      default:
                        return [
                  { icon: <FaGamepad />, title: 'Advanced AI', desc: 'Sophisticated AI behavior patterns' },
                  { icon: <FaSearch />, title: 'Exploration', desc: 'Non-linear exploration mechanics' },
                  { icon: <FaBrain />, title: 'Psychology', desc: 'Psychological horror elements' }
                        ];
                    }
                  })();
                  
                  return features.map((feature, idx) => (
                  <Box key={idx} sx={{ flex: 1 }}>
                    <Paper elevation={0} sx={{
                      background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.1) 0%, rgba(20, 184, 166, 0.05) 100%)',
                      border: `1px solid ${COLORS.border}`,
                      borderRadius: 3,
                      p: 4,
                      height: '100%',
                      transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                      backdropFilter: 'blur(10px)',
                      '&:hover': {
                        transform: 'translateY(-8px)',
                        boxShadow: '0 20px 40px rgba(20, 184, 166, 0.2)',
                        borderColor: COLORS.primary
                      }
                    }}>
                      <Box sx={{ textAlign: 'center' }}>
                        <Box sx={{ 
                          display: 'inline-flex', 
                          alignItems: 'center', 
                          justifyContent: 'center',
                          width: 64,
                          height: 64,
                          borderRadius: '50%',
                          bgcolor: COLORS.primary,
                          mb: 3,
                          transition: 'all 0.3s ease',
                          '&:hover': {
                            transform: 'scale(1.1)',
                            boxShadow: '0 0 20px rgba(20, 184, 166, 0.5)'
                          }
                        }}>
                          {React.cloneElement(feature.icon, { 
                            style: { fontSize: 32, color: COLORS.text } 
                          })}
                        </Box>
                        <Typography variant="h6" sx={{ 
                          fontWeight: 600, 
                          color: COLORS.text, 
                          mb: 2 
                        }}>
                          {feature.title}
                        </Typography>
                        <Typography variant="body2" sx={{ 
                          color: COLORS.textSecondary,
                          lineHeight: 1.6
                        }}>
                          {feature.desc}
                        </Typography>
                      </Box>
                    </Paper>
                  </Box>
                  ));
                })()}
              </Stack>
            </Box>

            {/* Video Section below Key Features */}
            {youtubeId && (
              <Box sx={{ width: '100%', maxWidth: 800, mx: 'auto', my: 6, borderRadius: 4, overflow: 'hidden', boxShadow: '0 8px 48px rgba(20,184,166,0.18)' }}>
                <iframe
                  src={`https://www.youtube.com/embed/${youtubeId}`}
                  title={name}
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowFullScreen
                  style={{
                    border: 0,
                    width: '100%',
                    height: 'min(45vw, 450px)',
                    aspectRatio: '16/9',
                    borderRadius: 4,
                    background: '#000',
                    display: 'block',
                  }}
                />
              </Box>
            )}

            {/* Premium Project Info Chips */}
            <Stack direction="row" flexWrap="wrap" justifyContent="center" gap={4} sx={{ mb: 10, mt: 8 }}>
              
              {/* Premium Genre Chips */}
              {demoProject.genres && demoProject.genres.map((genre) => (
                <Chip 
                  key={genre} 
                  label={genre} 
                  sx={{ 
                    background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.15) 0%, rgba(20, 184, 166, 0.25) 100%)',
                    color: COLORS.text, 
                    fontWeight: 600, 
                    fontSize: '1.1rem', 
                    px: 6, 
                    py: 2, 
                    borderRadius: '24px',
                    border: `2px solid rgba(20, 184, 166, 0.4)`,
                    boxShadow: '0 8px 32px rgba(20, 184, 166, 0.2)',
                    letterSpacing: 0.3,
                    transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
                    backdropFilter: 'blur(10px)',
                    '&:hover': {
                      background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.25) 0%, rgba(20, 184, 166, 0.35) 100%)',
                      borderColor: 'rgba(20, 184, 166, 0.8)',
                      boxShadow: '0 12px 48px rgba(20, 184, 166, 0.3)',
                      transform: 'translateY(-4px) scale(1.08)',
                      color: COLORS.text,
                    }
                  }} 
                />
              ))}
              
              {/* Premium Technology Chips */}
              {techs.map((tech) => (
                <Tooltip title={tech} key={tech} arrow>
                  <Chip
                    label={tech}
                    sx={{
                      background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.15) 0%, rgba(20, 184, 166, 0.25) 100%)',
                      color: COLORS.text,
                      fontWeight: 600,
                      fontSize: '1.1rem',
                      px: 6,
                      py: 2,
                      borderRadius: '24px',
                      border: `2px solid rgba(20, 184, 166, 0.4)`,
                      boxShadow: '0 8px 32px rgba(20, 184, 166, 0.2)',
                      letterSpacing: 0.3,
                      transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
                      backdropFilter: 'blur(10px)',
                      '&:hover': {
                        background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.25) 0%, rgba(20, 184, 166, 0.35) 100%)',
                        borderColor: 'rgba(20, 184, 166, 0.8)',
                        boxShadow: '0 12px 48px rgba(20, 184, 166, 0.3)',
                        transform: 'translateY(-4px) scale(1.08)',
                        color: COLORS.text,
                      }
                    }}
                  />
                </Tooltip>
              ))}
            </Stack>

            {/* Premium Image Gallery */}
            {projectImages.length > 1 && (
              <Fade in timeout={800}>
                <div className="w-full mb-16">
                  <div className="mb-8 w-full flex justify-center">
                    <span className="text-sm font-semibold text-gray-400 tracking-widest uppercase animate-fade-in-up" style={{ letterSpacing: 2 }}>
                      {t('projects.conceptImagesLabel') || 'Concept Images'}
                    </span>
                  </div>
                  <Box display="grid" gridTemplateColumns={{ xs: '1fr', sm: '1fr 1fr', md: '1fr 1fr 1fr' }} gap={{ xs: 4, md: 6 }} className="w-full max-w-6xl mb-16 animate-fade-in-up">
                    {projectImages.slice(1).map((src, idx) => (
                      <Box key={src} className="cursor-pointer group" sx={{ 
                        width: '100%', 
                        paddingTop: '66.66%', 
                        position: 'relative', 
                        borderRadius: 4, 
                        overflow: 'hidden', 
                        background: COLORS.surface, 
                        boxShadow: '0 16px 64px rgba(0,0,0,0.3)', 
                        transition: 'all 0.5s cubic-bezier(0.4, 0, 0.2, 1)', 
                        border: `1px solid ${COLORS.border}`,
                        '&:hover': { 
                          transform: 'translateY(-8px) scale(1.02)', 
                          boxShadow: `0 24px 80px rgba(20, 184, 166, 0.3)` 
                        } 
                      }} onClick={() => openLightbox(idx + 1)}>
                        <Image src={src} alt={`${demoProject.name} Screenshot ${idx + 2}`} fill style={{ objectFit: 'cover', transition: 'transform 0.5s' }} className="group-hover:scale-110" />
                      </Box>
                    ))}
                  </Box>
                </div>
              </Fade>
            )}

            {/* Premium Lightbox Modal */}
            <Modal open={lightboxIdx !== null} onClose={closeLightbox} sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 2000, backdropFilter: 'blur(20px)' }}>
              <Box sx={{ position: 'relative', outline: 'none', maxWidth: '95vw', maxHeight: '95vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                {lightboxIdx !== null && projectImages.length > 0 && (
                  <div style={{ position: 'absolute', top: 16, left: 24, color: COLORS.text, fontWeight: 600, fontSize: '1.1rem', background: 'rgba(0,0,0,0.8)', borderRadius: 12, padding: '8px 16px', zIndex: 20, backdropFilter: 'blur(10px)' }}>
                    {(lang === 'de' ? 'Bild' : 'Image')} {lightboxIdx + 1}/{projectImages.length}
                  </div>
                )}
                {/* X zum Schließen oben rechts */}
                <IconButton onClick={closeLightbox} sx={{ position: 'absolute', top: 12, right: 12, zIndex: 30, bgcolor: 'rgba(0,0,0,0.7)', color: 'white', fontSize: 32, '&:hover': { bgcolor: COLORS.primary, color: 'white', transform: 'scale(1.15)' } }}>
                  <span style={{ fontSize: 36, fontWeight: 900, lineHeight: 1 }}>×</span>
                </IconButton>
                <IconButton onClick={prevImg} sx={{ position: 'absolute', left: { xs: 16, md: 32 }, top: '50%', transform: 'translateY(-50%)', zIndex: 10, bgcolor: 'rgba(0,0,0,0.8)', color: 'white', backdropFilter: 'blur(10px)', '&:hover': { bgcolor: COLORS.primary } }}>
                  <ArrowBackIcon fontSize="large" />
                </IconButton>
                {lightboxIdx !== null && projectImages.length > 0 && (
                  <Image src={projectImages[lightboxIdx]} alt={`${demoProject.name} Screenshot ${lightboxIdx + 1}`} width={1200} height={800} style={{ objectFit: 'contain', borderRadius: 16, background: COLORS.surface, maxHeight: '90vh', maxWidth: '90vw', boxShadow: '0 32px 128px rgba(0,0,0,0.6)' }} />
                )}
                <IconButton onClick={nextImg} sx={{ position: 'absolute', right: { xs: 16, md: 32 }, top: '50%', transform: 'translateY(-50%)', zIndex: 10, bgcolor: 'rgba(0,0,0,0.8)', color: 'white', backdropFilter: 'blur(10px)', '&:hover': { bgcolor: COLORS.primary } }}>
                  <ArrowBackIcon fontSize="large" sx={{ transform: 'scaleX(-1)' }} />
                </IconButton>
              </Box>
            </Modal>

            {/* Premium Project Description */}
            <div className="w-full max-w-5xl mx-auto mb-16">
              <h2 className="text-3xl md:text-4xl font-black text-white mb-8 text-center" style={{ letterSpacing: 1 }}>
                About the Project
              </h2>
              <Typography variant="body1" sx={{ 
                color: COLORS.textSecondary, 
                fontSize: '1.25rem', 
                mb: 8, 
                whiteSpace: 'pre-line', 
                textAlign: 'center', 
                lineHeight: 1.8, 
                maxWidth: 1000, 
                mx: 'auto', 
                fontWeight: 400, 
                letterSpacing: 0.2 
              }}>
                {longDescription}
              </Typography>
            </div>
          </main>
        </div>
        <div className="hidden md:block flex-1" />
      </div>
      <Footer />
      <Snackbar
        open={snackbarOpen}
        autoHideDuration={3000}
        onClose={() => setSnackbarOpen(false)}
        message={snackbarMsg}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        sx={{
            '& .MuiSnackbarContent-root': {
                backgroundColor: COLORS.primary,
                color: COLORS.text,
                fontWeight: 'medium',
                borderRadius: '12px',
                boxShadow: '0 16px 64px rgba(20, 184, 166, 0.3)',
                backdropFilter: 'blur(10px)'
            }
        }}
      />
      <style jsx global>{`
        @keyframes pulse {
          0% { filter: brightness(1) drop-shadow(0 0 0 rgba(20, 184, 166, 0.4)); }
          50% { filter: brightness(1.2) drop-shadow(0 0 48px rgba(20, 184, 166, 0.6)); }
          100% { filter: brightness(1) drop-shadow(0 0 0 rgba(20, 184, 166, 0.4)); }
        }
        .animate-fade-in-up {
          animation: fadeInUp 1s cubic-bezier(.4,1.2,.6,1) both;
        }
        .animate-fade-in-up-slow {
          animation: fadeInUp 1.6s cubic-bezier(.4,1.2,.6,1) both;
        }
        @keyframes fadeInUp {
          0% { opacity: 0; transform: translateY(48px); }
          100% { opacity: 1; transform: translateY(0); }
        }
        .shadow-3xl {
          box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }
      `}</style>
    </div>
  );
}