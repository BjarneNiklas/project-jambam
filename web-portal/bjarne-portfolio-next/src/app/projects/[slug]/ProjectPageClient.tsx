'use client';

import React, { useState, useCallback } from 'react';
import Image from 'next/image';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import LaunchIcon from '@mui/icons-material/Launch';
import GitHubIcon from '@mui/icons-material/GitHub';
import Footer from '@/components/Footer';
import { useLanguage } from '../../LanguageContext';
import { Box, Chip, IconButton, Modal, Button, Grid } from '@mui/material';
import { FaCogs, FaCode, FaGamepad, FaRobot, FaCube, FaSearch, FaBrain, FaShareAlt } from 'react-icons/fa';
import Snackbar from '@mui/material/Snackbar';
import Tooltip from '@mui/material/Tooltip';
import BubbleChartIcon from '@mui/icons-material/BubbleChart';
import ScienceIcon from '@mui/icons-material/Science'; // Added import
import HubIcon from '@mui/icons-material/Hub'; // Added import
import Grid4x4Icon from '@mui/icons-material/Grid4x4'; // Added import
import { BiCube } from 'react-icons/bi'; // Added import

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
}

interface ProjectPageClientProps {
  project: Project;
}

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
  // Add more icons as needed
};

// Define primary color (Teal, adjust as needed from theme)
const PRIMARY_COLOR = '#14b8a6'; // Teal shade from scrollbar
const PRIMARY_COLOR_LIGHT = '#2dd4bf';
const PRIMARY_COLOR_DARK = '#0f766e'; // A darker shade for hover or borders

// Hilfsfunktion für Icon-Rendering
function getTechIcon(tech: string) {
  const icon = techIcons[tech];
  if (!icon) return <FaCogs style={{ color: PRIMARY_COLOR_LIGHT, fontSize: '1.25rem', filter: 'drop-shadow(0 0 8px #14b8a6cc)' }} />;
  if (!icon.type) return icon;
  // MUI-Icons
  if (typeof icon.type === 'object' && 'muiName' in icon.type) {
    const baseStyle = {
      color: PRIMARY_COLOR_LIGHT,
      fontSize: '1.25rem',
      filter: 'drop-shadow(0 0 8px #14b8a6cc)'
    };
    let props: Record<string, any> = {};
    if (typeof icon.props === 'object' && icon.props !== null) props = icon.props;
    const style = props.style ? { ...props.style, ...baseStyle } : baseStyle;
    return React.createElement(icon.type, { ...props, style });
  }
  // React-Icons
  if (typeof icon.type === 'function' && !('muiName' in icon.type)) {
    const baseStyle = {
      color: PRIMARY_COLOR_LIGHT,
      fontSize: '1.25rem',
      filter: 'drop-shadow(0 0 8px #14b8a6cc)'
    };
    let props: Record<string, any> = {};
    if (typeof icon.props === 'object' && icon.props !== null) props = icon.props;
    const style = props.style ? { ...props.style, ...baseStyle } : baseStyle;
    return React.createElement(icon.type, { ...props, style });
  }
  // Fallback: rendere das Icon direkt
  return icon;
}

export default function ProjectPageClient({ project }: ProjectPageClientProps) {
  const { t } = useLanguage();
  let demoProject = { ...project };
  if (demoProject.slug === 'maze-of-space') {
    demoProject.year = demoProject.year || '2024';
    demoProject.genres = demoProject.genres || ['Maze', 'Strategy', 'First-Person'];
  }
  if (demoProject.slug === 'block-reversal') {
    demoProject.year = demoProject.year || '2028';
    demoProject.genres = demoProject.genres || ['Casual', 'Puzzle'];
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
    // Ensure specific tags are present if not already
    if (demoProject.slug === 'black-forest-asylum') { // Example: add specific tags only for BFA
        if (!arr.includes('Exploration')) arr.push('Exploration');
        if (!arr.includes('Psychological Horror')) arr.push('Psychological Horror');
    }
    return arr;
  })();

  // Fallback-Icon-Logik (wird jetzt direkt in der Hero-Sektion behandelt)
  // const fallbackIcon = project.slug === 'slime' ? <BubbleChartIcon sx={{ fontSize: 120, color: PRIMARY_COLOR, filter: 'drop-shadow(0 0 32px #14b8a6cc)' }} /> : <FaCogs size={120} color={PRIMARY_COLOR} style={{ filter: 'drop-shadow(0 0 32px #14b8a6cc)' }} />;

  // 2. Fallback-Icon robust: Bild muss ein nicht-leerer String sein
  const hasValidImage = projectImages.length > 0 && typeof projectImages[0] === 'string' && projectImages[0].trim() !== '';

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
    <div className="min-h-screen flex flex-col bg-[#0a0a0a]">
      <div className="flex flex-1 w-full">
        <div className="hidden md:block" style={{ width: 220, flexShrink: 0 }} /> {/* Sidebar spacer */}
        <div className="w-full px-8 md:px-24 lg:px-40 xl:px-64">
          <main className="flex-1 max-w-5xl mx-auto my-24 md:my-40 bg-gradient-to-br from-[#18181b] to-[#23232a] rounded-3xl shadow-2xl p-16 md:p-32 border border-[#2a2a30] min-h-[70vh] flex flex-col relative items-center">
            {/* Share Button - Positioned for visibility */}
            <div className="absolute top-6 right-6 md:top-8 md:right-8 z-10">
              <Tooltip title={t('projects.shareTooltip') || 'Share Page'} arrow>
                <IconButton
                  onClick={handleShare}
                  size="medium"
                  sx={{
                    bgcolor: 'rgba(30,30,40,0.7)',
                    color: 'white',
                    '&:hover': { bgcolor: PRIMARY_COLOR, color: 'white' },
                    transition: 'all 0.2s ease-in-out',
                    width: { xs: 36, md: 40 },
                    height: { xs: 36, md: 40 }
                  }}
                >
                  <FaShareAlt size={18} />
                </IconButton>
              </Tooltip>
            </div>

            {/* Hero Section: Image or Fallback Icon */}
            <div className="w-full mb-8 md:mb-12 relative overflow-hidden rounded-2xl shadow-xl border border-[#2a2a30] bg-[#101013] flex items-center justify-center" style={{ minHeight: '300px', maxHeight: '500px' }}>
              {hasValidImage ? (
                <Image
                  src={projectImages[0]}
                  alt={`${demoProject.name} Hero Image`}
                  width={1200}
                  height={600}
                  style={{ objectFit: 'cover', width: '100%', height: '100%' }}
                  className="transition-transform duration-500 ease-in-out hover:scale-105"
                />
              ) : (
                <div className="flex flex-col items-center justify-center p-8 text-center">
                  {/* Fallback Icon mit Glow und Animation */}
                  {demoProject.slug === 'slime' && <BubbleChartIcon style={{ fontSize: 'clamp(100px, 15vw, 180px)', color: PRIMARY_COLOR, filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {demoProject.slug === 'broxel-engine' && <BiCube size={180} color={PRIMARY_COLOR} style={{ filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {demoProject.slug === 'black-forest-asylum' && <ScienceIcon style={{ fontSize: 'clamp(100px, 15vw, 180px)', color: PRIMARY_COLOR, filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {demoProject.slug === 'maze-of-space' && <HubIcon style={{ fontSize: 'clamp(100px, 15vw, 180px)', color: PRIMARY_COLOR, filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {demoProject.slug === 'block-reversal' && <Grid4x4Icon style={{ fontSize: 'clamp(100px, 15vw, 180px)', color: PRIMARY_COLOR, filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {demoProject.slug === 'auravention' && <Image src="/av_logo.webp" alt="AuraVention" width={180} height={180} style={{ filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {demoProject.slug === 'project-y' && <Image src="/y_logo.webp" alt="Project Y" width={180} height={180} style={{ filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {demoProject.slug === 'aurax-media-platform' && <FaCogs size={180} color={PRIMARY_COLOR} style={{ filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {demoProject.slug === 'portfolio-website' && <FaCogs size={180} color={PRIMARY_COLOR} style={{ filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />}
                  {/* Generic Fallback */}
                  {!['slime', 'broxel-engine', 'black-forest-asylum', 'maze-of-space', 'block-reversal', 'auravention', 'project-y', 'aurax-media-platform', 'portfolio-website'].includes(demoProject.slug) && (
                    <FaCogs size={180} color={PRIMARY_COLOR} style={{ filter: 'drop-shadow(0 0 40px #14b8a6cc)', animation: 'pulse 2s infinite ease-in-out' }} />
                  )}
                  <span className="mt-6 text-xl font-bold text-gray-400 tracking-wide uppercase drop-shadow-lg">{t('projects.noImageFallback') || 'Kein Bild vorhanden'}</span>
                </div>
              )}
            </div>

            <h1 className="text-3xl sm:text-4xl md:text-5xl font-extrabold text-white tracking-tight drop-shadow-lg mb-3 mt-4 md:mt-2 text-center w-full">{demoProject.name}</h1>

            <div className="flex flex-wrap gap-x-14 gap-y-8 items-center justify-center mb-14 mt-6 w-full">
              {demoProject.year && (
                <Chip
                  label={demoProject.year}
                  sx={{
                    bgcolor: PRIMARY_COLOR_DARK, // Using a darker shade of primary for year
                    color: '#fff',
                    fontWeight: 700,
                    fontSize: { xs: '0.9rem', md: '1rem' },
                    px: 1.5, py: 0.5,
                    borderRadius: 2,
                    boxShadow: 1
                  }}
                />
              )}
              {demoProject.genres && demoProject.genres.map((genre) => (
                <Chip
                  key={genre}
                  label={genre}
                  sx={{
                    bgcolor: '#2c2c34', // Slightly different background for genres
                    color: PRIMARY_COLOR_LIGHT, // Lighter primary for text
                    fontWeight: 600,
                    fontSize: { xs: '0.85rem', md: '0.95rem' },
                    px: 1.5, py: 0.5,
                    borderRadius: 2,
                    border: `1px solid ${PRIMARY_COLOR_DARK}`
                  }}
                />
              ))}
            </div>

            {/* Image Gallery */}
            {projectImages.length > 1 && ( // Only show gallery if more than one image
              <>
                <div className="mb-4 mt-4 w-full flex justify-center">
                  <span className="text-sm font-semibold text-gray-400 tracking-wide uppercase">{t('projects.conceptImagesLabel') || 'Concept Images'}</span>
                </div>
                <Box display="grid" gridTemplateColumns={{ xs: '1fr', sm: '1fr 1fr', md: '1fr 1fr 1fr' }} gap={{ xs: 2, md: 3 }} className="w-full max-w-4xl mb-10 md:mb-12">
                  {projectImages.slice(1).map((src, idx) => ( // Skip the first image as it's used in hero
                    <Box key={src} className="cursor-pointer group" sx={{
                      width: '100%',
                      paddingTop: '66.66%', // 3:2 Aspect Ratio (height / width * 100)
                      position: 'relative',
                      borderRadius: 3,
                      overflow: 'hidden',
                      background: 'rgba(30,30,40,0.7)',
                      boxShadow: '0 8px 32px rgba(20,184,166,0.18)',
                      transition: 'transform 0.3s, box-shadow 0.3s',
                      '&:hover': {
                        transform: 'translateY(-4px)',
                        boxShadow: `0 12px 40px rgba(20,184,166,0.25)`,
                      }
                    }} onClick={() => openLightbox(idx + 1)}>
                      <Image
                        src={src}
                        alt={`${demoProject.name} Screenshot ${idx + 2}`} // Adjust alt text
                        fill
                        style={{
                          objectFit: 'cover',
                          transition: 'transform 0.3s',
                        }}
                        className="group-hover:scale-105"
                      />
                    </Box>
                  ))}
                </Box>
              </>
            )}

            <Modal open={lightboxIdx !== null} onClose={closeLightbox} sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 2000, backdropFilter: 'blur(5px)' }}>
              <Box sx={{ position: 'relative', outline: 'none', maxWidth: '90vw', maxHeight: '90vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                {lightboxIdx !== null && projectImages.length > 0 && (
                  <div style={{ position: 'absolute', top: 12, left: 18, color: '#fff', fontWeight: 600, fontSize: '1rem', background: 'rgba(0,0,0,0.6)', borderRadius: 8, padding: '4px 12px', zIndex: 20 }}>
                    {t('projects.image')} {lightboxIdx + 1}/{projectImages.length}
                  </div>
                )}
                <IconButton onClick={prevImg} sx={{ position: 'absolute', left: { xs: 8, md: 16 }, top: '50%', transform: 'translateY(-50%)', zIndex: 10, bgcolor: 'rgba(0,0,0,0.5)', color: 'white', '&:hover': { bgcolor: PRIMARY_COLOR } }}>
                  <ArrowBackIcon fontSize="medium" />
                </IconButton>
                {lightboxIdx !== null && projectImages.length > 0 && (
                  <Image
                    src={projectImages[lightboxIdx]}
                    alt={`${demoProject.name} Screenshot ${lightboxIdx + 1}`}
                    width={1000} // Larger base for better quality
                    height={700}
                    style={{ objectFit: 'contain', borderRadius: 12, background: '#101013', maxHeight: '85vh', maxWidth: '85vw', boxShadow: '0 8px 32px rgba(0,0,0,0.4)' }}
                  />
                )}
                <IconButton onClick={nextImg} sx={{ position: 'absolute', right: { xs: 8, md: 16 }, top: '50%', transform: 'translateY(-50%)', zIndex: 10, bgcolor: 'rgba(0,0,0,0.5)', color: 'white', '&:hover': { bgcolor: PRIMARY_COLOR } }}>
                  <ArrowBackIcon fontSize="medium" sx={{ transform: 'scaleX(-1)' }} />
                </IconButton>
              </Box>
            </Modal>

            <h2 className="text-xl sm:text-2xl font-bold mb-3 text-white mt-12 md:mt-16 text-center w-full" style={{ letterSpacing: 0.2 }}> {t('projects.descriptionLabel') || 'Project Description'} </h2>
            <p className="text-base md:text-lg text-gray-300 mb-12 leading-relaxed max-w-3xl mx-auto text-center px-2" style={{ lineHeight: 1.8, fontWeight: 500, fontSize: '1.13rem', letterSpacing: 0.1 }}> {demoProject.longDescription} </p>

            <h2 className="text-xl sm:text-2xl font-bold mb-4 text-white mt-12 md:mt-16 text-center w-full" style={{ letterSpacing: 0.2 }}>{t('projects.tagsLabel') || 'Technologies & Tags'}</h2>
            <div className="flex flex-wrap gap-10 md:gap-14 mb-24 justify-center w-full max-w-3xl mx-auto px-2">
              {techs.map((tech) => (
                <Chip
                  key={tech}
                  icon={getTechIcon(tech)}
                  label={tech}
                  sx={{
                    bgcolor: 'rgba(20, 184, 166, 0.18)',
                    color: '#fff',
                    fontWeight: 700,
                    fontSize: { xs: '1.02rem', md: '1.09rem' },
                    px: 2.2,
                    py: 1.1,
                    borderRadius: '16px',
                    border: `1.5px solid ${PRIMARY_COLOR_LIGHT}`,
                    boxShadow: '0 2px 16px 0 rgba(20,184,166,0.10)',
                    letterSpacing: 0.13,
                    transition: 'all 0.25s',
                    '& .MuiChip-icon': { transition: 'transform 0.2s', fontSize: '1.25rem' },
                    '&:hover': {
                      bgcolor: 'rgba(20, 184, 166, 0.32)',
                      boxShadow: `0 0 18px 2px rgba(20, 184, 166, 0.22)`,
                      transform: 'translateY(-2px) scale(1.06)',
                      color: '#fff',
                      '& .MuiChip-icon': {
                        transform: 'scale(1.18)',
                        color: '#fff',
                      }
                    }
                  }}
                />
              ))}
            </div>
          </main>
        </div>
        <div className="hidden md:block flex-1" /> {/* Sidebar spacer */}
      </div>
      <Footer />
      <Snackbar
        open={snackbarOpen}
        autoHideDuration={2500}
        onClose={() => setSnackbarOpen(false)}
        message={snackbarMsg}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        sx={{
            '& .MuiSnackbarContent-root': {
                backgroundColor: PRIMARY_COLOR,
                color: 'white',
                fontWeight: 'medium',
                borderRadius: '8px',
                boxShadow: 3,
            }
        }}
      />
    </div>
  );
}