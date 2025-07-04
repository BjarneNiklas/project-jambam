'use client';

import React, { useState, useCallback } from 'react';
import Image from 'next/image';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import LaunchIcon from '@mui/icons-material/Launch';
import Footer from '@/components/Footer';
import { useLanguage } from '../../LanguageContext';
import { Box, Chip, IconButton, Modal, Typography, Fade, Stack, Paper, Grid } from '@mui/material';
import { FaCogs, FaCode, FaGamepad, FaRobot, FaCube, FaSearch, FaBrain, FaShareAlt, FaExternalLinkAlt } from 'react-icons/fa';
import Snackbar from '@mui/material/Snackbar';
import Tooltip from '@mui/material/Tooltip';
import BubbleChartIcon from '@mui/icons-material/BubbleChart';
import ScienceIcon from '@mui/icons-material/Science';
import HubIcon from '@mui/icons-material/Hub';
import Grid4x4Icon from '@mui/icons-material/Grid4x4';
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

// Premium Project Fallback Icons
const getProjectFallbackIcon = (slug: string): React.ReactElement => {
  const iconSize = 240; // Vergrößert für bessere Sichtbarkeit
  const iconStyle = {
    filter: 'drop-shadow(0 0 40px rgba(20, 184, 166, 0.4))',
    animation: 'pulse 3s infinite ease-in-out'
  };

  switch (slug) {
    case 'auravention':
      return (
        <Image 
          src="/av_logo.webp" 
          alt="AuraVention" 
          width={iconSize} 
          height={iconSize} 
          style={{ ...iconStyle, borderRadius: 12 }}
        />
      );
    case 'project-y':
      return (
        <Image 
          src="/y_logo.webp" 
          alt="Project Y" 
          width={iconSize} 
          height={iconSize} 
          style={{ ...iconStyle, borderRadius: 12 }}
        />
      );
    case 'broxel-engine':
      return <BiCube size={iconSize} color={COLORS.primary} style={iconStyle} />;
    case 'black-forest-asylum':
      return <FaGamepad size={iconSize} color={COLORS.primary} style={iconStyle} />;
    case 'maze-of-space':
      return <Grid4x4Icon sx={{ fontSize: iconSize, color: COLORS.primary, ...iconStyle }} />;
    case 'block-reversal':
      return <Grid4x4Icon sx={{ fontSize: iconSize, color: COLORS.accent, ...iconStyle }} />;
    case 'slime':
      return <BubbleChartIcon sx={{ fontSize: iconSize, color: COLORS.primary, ...iconStyle }} />;
    case 'bubblez-interest-minigame':
      return <BubbleChartIcon sx={{ fontSize: iconSize, color: COLORS.success, ...iconStyle }} />;
    case 'home-cafe-module':
      return <HubIcon sx={{ fontSize: iconSize, color: COLORS.warning, ...iconStyle }} />;
    case 'mall-orca':
      return <FaGamepad size={iconSize} color={COLORS.accent} style={iconStyle} />;
    default:
      return <FaCogs size={iconSize} color={COLORS.primary} style={iconStyle} />;
  }
};

// Premium Icon Rendering
function getTechIcon(tech: string) {
  const icon = techIcons[tech];
  if (!icon) return <FaCogs style={{ color: COLORS.primaryLight, fontSize: '1.3rem', filter: 'drop-shadow(0 0 8px rgba(20, 184, 166, 0.4))' }} />;
  if (!icon.type) return icon;
  const iconType = icon.type as unknown;
  
  if (typeof iconType === 'object' && iconType !== null && 'muiName' in iconType) {
    const baseStyle = {
      color: COLORS.primaryLight,
      fontSize: '1.3rem',
      filter: 'drop-shadow(0 0 8px rgba(20, 184, 166, 0.4))'
    };
    let props = {};
    if (typeof icon.props === 'object' && icon.props !== null) props = icon.props as Record<string, unknown>;
    const style = (props as { style?: unknown }).style ? { ...(props as { style?: object }).style, ...baseStyle } : baseStyle;
    return React.createElement(iconType as React.ComponentType<Record<string, unknown>>, { ...(props as object), style });
  }
  
  if (typeof iconType === 'function' && !('muiName' in iconType)) {
    const baseStyle = {
      color: COLORS.primaryLight,
      fontSize: '1.3rem',
      filter: 'drop-shadow(0 0 8px rgba(20, 184, 166, 0.4))'
    };
    let props = {};
    if (typeof icon.props === 'object' && icon.props !== null) props = icon.props as Record<string, unknown>;
    const style = (props as { style?: unknown }).style ? { ...(props as { style?: object }).style, ...baseStyle } : baseStyle;
    return React.createElement(iconType as React.ComponentType<Record<string, unknown>>, { ...(props as object), style });
  }
  
  return icon;
}

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

  const hasValidImage = projectImages.length > 0 && typeof projectImages[0] === 'string' && projectImages[0].trim() !== '';

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

  return (
    <div className="min-h-screen flex flex-col" style={{ backgroundColor: COLORS.background }}>
      <div className="flex flex-1 w-full">
        <div className="hidden md:block" style={{ width: 220, flexShrink: 0 }} />
        
        {/* Premium Container with Maximal White Space */}
        <div className="w-full" style={{ padding: '0 48px' }}>
          <main className="flex-1 max-w-7xl mx-auto my-0 bg-transparent rounded-3xl shadow-none border-none min-h-[70vh] flex flex-col relative items-center" style={{ padding: '48px 32px' }}>
            
            {/* Premium Hero Section */}
            <div className="relative w-full h-[45vh] md:h-[60vh] flex items-end justify-center overflow-hidden rounded-3xl shadow-2xl border border-gray-800 mb-12" style={{ background: COLORS.background }}>
              {/* Kein Hintergrundbild mehr, nur dunkler Hintergrund */}
              <div className="flex flex-col items-center justify-center w-full h-full">
                {getProjectFallbackIcon(slug)}
              </div>
              {/* Premium Animated Headline */}
              <div className="absolute bottom-12 left-1/2 -translate-x-1/2 w-full px-8 flex flex-col items-center">
                <h1 className="text-5xl md:text-7xl font-black text-white tracking-tight drop-shadow-2xl animate-fade-in-up text-center" style={{ letterSpacing: 2, textShadow: '0 8px 48px rgba(20, 184, 166, 0.6)' }}>
                  {name}
                </h1>
                <p className="text-xl md:text-2xl text-gray-300 font-medium mt-4 animate-fade-in-up-slow text-center max-w-4xl" style={{ textShadow: '0 4px 24px rgba(20, 184, 166, 0.4)', lineHeight: 1.4 }}>
                  {shortDescription}
                </p>
                {/* Professional Year Badge - Game Shop Style */}
                {demoProject.year && (
                  <div className="mt-6">
                    <Chip 
                      label={demoProject.year} 
                      sx={{ 
                        background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.9) 0%, rgba(20, 184, 166, 0.7) 100%)',
                        color: COLORS.text, 
                        fontWeight: 700, 
                        fontSize: '1.2rem', 
                        px: 4, 
                        py: 1.5, 
                        borderRadius: '16px',
                        border: `2px solid rgba(20, 184, 166, 0.8)`,
                        boxShadow: '0 8px 32px rgba(20, 184, 166, 0.4)',
                        letterSpacing: 0.5,
                        textTransform: 'uppercase',
                        backdropFilter: 'blur(10px)',
                        '&:hover': {
                          background: 'linear-gradient(135deg, rgba(20, 184, 166, 1) 0%, rgba(20, 184, 166, 0.8) 100%)',
                          boxShadow: '0 12px 48px rgba(20, 184, 166, 0.6)',
                          transform: 'scale(1.05)',
                        }
                      }} 
                    />
                  </div>
                )}
              </div>
              
              {/* Premium Back Button */}
              <Tooltip title="Back to Projects" arrow>
                <IconButton 
                  onClick={() => window.history.back()} 
                  sx={{ 
                    position: 'absolute', 
                    top: 32, 
                    left: 32, 
                    bgcolor: 'rgba(20, 184, 166, 0.15)', 
                    color: COLORS.text,
                    border: `1px solid ${COLORS.border}`,
                    backdropFilter: 'blur(10px)',
                    '&:hover': { 
                      bgcolor: 'rgba(20, 184, 166, 0.25)',
                      transform: 'scale(1.05)',
                      boxShadow: '0 8px 32px rgba(20, 184, 166, 0.3)'
                    },
                    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)'
                  }}
                >
                  <ArrowBackIcon fontSize="large" />
                </IconButton>
              </Tooltip>
              
              {/* Premium Status Badge */}
              {demoProject.status && (
                <Chip 
                  label={demoProject.status} 
                  sx={{ 
                    position: 'absolute', 
                    top: 32, 
                    right: 32, 
                    bgcolor: COLORS.primary, 
                    color: COLORS.text, 
                    fontWeight: 700, 
                    fontSize: '1rem', 
                    px: 3, 
                    py: 1.5, 
                    borderRadius: 3, 
                    boxShadow: '0 8px 32px rgba(20, 184, 166, 0.3)',
                    textTransform: 'uppercase', 
                    letterSpacing: 0.3,
                    border: `1px solid ${COLORS.primaryLight}`,
                    backdropFilter: 'blur(10px)'
                  }} 
                />
              )}
            </div>

            {/* Premium Call-to-Action Buttons */}
            <div className="flex flex-wrap gap-6 justify-center mb-12 mt-8">
              {demoProject.url && demoProject.url !== '#' && (
                <Tooltip title="View Live Demo" arrow>
                  <a href={demoProject.url} target="_blank" rel="noopener" className="no-underline">
                    <button className="bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white font-bold py-4 px-8 rounded-2xl text-lg shadow-xl transition-all duration-300 flex items-center gap-3 animate-fade-in-up hover:scale-105 hover:shadow-2xl">
                      <LaunchIcon /> Live Demo
                    </button>
                  </a>
                </Tooltip>
              )}
              {demoProject.githubUrl && demoProject.githubUrl !== '#' && (
                <Tooltip title="View Source Code" arrow>
                  <a href={demoProject.githubUrl} target="_blank" rel="noopener" className="no-underline">
                    <button className="bg-gradient-to-r from-gray-700 to-gray-800 hover:from-gray-600 hover:to-gray-700 text-white font-bold py-4 px-8 rounded-2xl text-lg shadow-xl transition-all duration-300 flex items-center gap-3 animate-fade-in-up hover:scale-105 hover:shadow-2xl">
                      <FaCode /> Source Code
                    </button>
                  </a>
                </Tooltip>
              )}
            </div>

            {/* Premium Quickfacts Bar */}
            <Paper elevation={0} sx={{ 
              background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.1) 0%, rgba(20, 184, 166, 0.05) 100%)',
              border: `1px solid ${COLORS.border}`,
              borderRadius: 4,
              p: 4,
              mb: 8,
              backdropFilter: 'blur(10px)'
            }}>
              <Stack direction={{ xs: 'column', md: 'row' }} spacing={4} alignItems="center" justifyContent="space-around">
                {/* Engine */}
                <Box sx={{ textAlign: 'center' }}>
                  <Typography variant="caption" color="text.secondary" sx={{ textTransform: 'uppercase', letterSpacing: 1 }}>
                    {lang === 'de' ? 'Engine' : 'Engine'}
                  </Typography>
                  <Typography variant="h6" sx={{ fontWeight: 600, color: COLORS.text }}>
                    {quickfacts.engine}
                  </Typography>
                </Box>
                {/* Genre */}
                <Box sx={{ textAlign: 'center' }}>
                  <Typography variant="caption" color="text.secondary" sx={{ textTransform: 'uppercase', letterSpacing: 1 }}>
                    {lang === 'de' ? 'Genre' : 'Genre'}
                  </Typography>
                  <Typography variant="h6" sx={{ fontWeight: 600, color: COLORS.text }}>
                    {quickfacts.genre}
                  </Typography>
                </Box>
                {/* Status */}
                <Box sx={{ textAlign: 'center' }}>
                  <Typography variant="caption" color="text.secondary" sx={{ textTransform: 'uppercase', letterSpacing: 1 }}>
                    {lang === 'de' ? 'Status' : 'Status'}
                  </Typography>
                  <Typography variant="h6" sx={{ fontWeight: 600, color: COLORS.text }}>
                    {quickfacts.status}
                  </Typography>
                </Box>
                {/* Jahr */}
                <Box sx={{ textAlign: 'center' }}>
                  <Typography variant="caption" color="text.secondary" sx={{ textTransform: 'uppercase', letterSpacing: 1 }}>
                    {lang === 'de' ? 'Jahr' : 'Year'}
                  </Typography>
                  <Typography variant="h6" sx={{ fontWeight: 600, color: COLORS.text }}>
                    {quickfacts.year}
                  </Typography>
                </Box>
              </Stack>
            </Paper>

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
                {[
                  { icon: <FaGamepad />, title: 'Advanced AI', desc: 'Sophisticated AI behavior patterns' },
                  { icon: <FaSearch />, title: 'Exploration', desc: 'Non-linear exploration mechanics' },
                  { icon: <FaBrain />, title: 'Psychology', desc: 'Psychological horror elements' }
                ].map((feature, idx) => (
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
                ))}
              </Stack>
            </Box>

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