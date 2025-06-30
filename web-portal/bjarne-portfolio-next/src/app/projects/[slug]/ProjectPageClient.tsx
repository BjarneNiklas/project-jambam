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
  'Psychological Horror': <FaBrain />
  // Add more icons as needed
};

// Define primary color (Teal, adjust as needed from theme)
const PRIMARY_COLOR = '#14b8a6'; // Teal shade from scrollbar
const PRIMARY_COLOR_LIGHT = '#2dd4bf';
const PRIMARY_COLOR_DARK = '#0f766e'; // A darker shade for hover or borders

export default function ProjectPageClient({ project }: ProjectPageClientProps) {
  const { t } = useLanguage();
  const projectImages = project.imageUrls && project.imageUrls.length > 0 ? project.imageUrls : [];
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
        await navigator.share({ title: project.name, url: shareUrl });
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
    const arr = project.technologies.filter(t => t !== 'Blueprints');
    // Ensure specific tags are present if not already
    if (project.slug === 'black-forest-asylum') { // Example: add specific tags only for BFA
        if (!arr.includes('Exploration')) arr.push('Exploration');
        if (!arr.includes('Psychological Horror')) arr.push('Psychological Horror');
    }
    return arr;
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
    <div className="min-h-screen flex flex-col bg-[#0a0a0a]">
      <div className="flex flex-1 w-full">
        <div className="hidden md:block" style={{ width: 220, flexShrink: 0 }} /> {/* Sidebar spacer */}
        <main className="flex-1 max-w-5xl mx-auto my-8 md:my-12 bg-gradient-to-br from-[#18181b] to-[#23232a] rounded-3xl shadow-2xl p-6 md:p-10 border border-[#2a2a30] min-h-[70vh] flex flex-col relative items-center">

          <div className="absolute top-6 right-6 md:top-8 md:right-8">
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

          <h1 className="text-3xl sm:text-4xl md:text-5xl font-extrabold text-white tracking-tight drop-shadow-lg mb-3 mt-4 md:mt-2 text-center w-full">{project.name}</h1>

          <div className="flex flex-wrap gap-x-4 gap-y-2 items-center justify-center mb-6 mt-1 w-full">
            {project.year && (
              <Chip
                label={project.year}
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
            {project.genres && project.genres.map((genre) => (
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

          {projectImages.length > 0 && (
            <div className="mb-4 mt-4 w-full flex justify-center">
              <span className="text-sm font-semibold text-gray-400 tracking-wide uppercase">{t('projects.conceptImagesLabel') || 'Concept Images'}</span>
            </div>
          )}

          {/* Image Gallery: Responsive layout */}
          {projectImages.length > 0 && (
            <div className="w-full flex justify-center mb-10 md:mb-12">
              {/* On mobile: Stack vertically. On md and up: Scroll horizontally */}
              <div className="grid grid-cols-1 md:flex md:flex-row md:flex-nowrap gap-4 md:gap-6 md:overflow-x-auto md:px-2 py-2 w-full md:max-w-3xl lg:max-w-4xl items-center justify-items-center"
                style={{
                  // scrollbarColor: `${PRIMARY_COLOR} #23232a`, // For Firefox
                  // scrollbarWidth: 'thin', // For Firefox
                }}
              >
                {projectImages.map((src, idx) => (
                  <div
                    key={src}
                    className="flex-shrink-0 w-full max-w-xs md:w-auto cursor-pointer group" // Added group for hover effects
                    style={{
                      // Mobile: images take more width, Desktop: fixed size
                      width: '100%', // Default full width for stacked mobile
                      maxWidth: '300px', // Max width for mobile images
                      '@media (min-width: 768px)': { // md breakpoint
                        width: 200, // Desktop width
                        height: 200, // Desktop height
                        marginRight: idx !== projectImages.length - 1 ? '1.5rem' : 0, // Desktop margin
                        maxWidth: 'none',
                      },
                      height: 200, // Common height
                      borderRadius: 16, // Rounded corners
                      overflow: 'hidden', // Clip image to rounded corners
                      background: 'rgba(30,30,40,0.6)', // Placeholder background
                      boxShadow: '0 6px 12px rgba(0,0,0,0.3)',
                      transition: 'transform 0.3s ease, box-shadow 0.3s ease',
                    }}
                    onClick={() => openLightbox(idx)}
                    // Apply Tailwind classes for responsive sizing where possible
                    // Overriding with style prop for fine-tuning and media queries not easily done in Tailwind JIT for dynamic elements
                  >
                    <Image
                      src={src}
                      alt={`${project.name} Screenshot ${idx + 1}`}
                      width={250} // Base width for Next/Image optimization
                      height={250} // Base height
                      style={{
                        objectFit: 'cover',
                        width: '100%',
                        height: '100%',
                        transition: 'transform 0.3s ease',
                      }}
                      className="group-hover:scale-105" // Scale image on hover
                    />
                  </div>
                ))}
              </div>
            </div>
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
                  alt={`${project.name} Screenshot ${lightboxIdx + 1}`}
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

          <h2 className="text-xl sm:text-2xl font-bold mb-3 text-white mt-8 md:mt-10 text-center w-full">{t('projects.descriptionLabel') || 'Project Description'}</h2>
          <p className="text-base md:text-lg text-gray-300 mb-10 md:mb-12 leading-relaxed max-w-3xl mx-auto text-center px-2" style={{ lineHeight: 1.75 }}>
            {project.longDescription}
          </p>

          {/* Call to Action Buttons */}
          {(project.url || project.githubUrl) && (
            <Box sx={{ my: 4, width: '100%', display: 'flex', justifyContent: 'center', gap: 2, flexWrap: 'wrap' }}>
              {project.url && (
                <Button
                  variant="contained"
                  href={project.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  startIcon={<LaunchIcon />}
                  sx={{
                    bgcolor: PRIMARY_COLOR,
                    color: 'white',
                    fontWeight: 600,
                    fontSize: { xs: '0.85rem', md: '0.95rem' },
                    px: { xs: 2, md: 3 }, py: { xs: 1, md: 1.5 },
                    '&:hover': { bgcolor: PRIMARY_COLOR_DARK },
                    borderRadius: 2,
                    boxShadow: 2,
                  }}
                >
                  {t('projects.liveProject') || 'View Live Project'}
                </Button>
              )}
              {project.githubUrl && (
                <Button
                  variant="outlined"
                  href={project.githubUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  startIcon={<GitHubIcon />}
                  sx={{
                    borderColor: PRIMARY_COLOR,
                    color: PRIMARY_COLOR_LIGHT,
                    fontWeight: 600,
                    fontSize: { xs: '0.85rem', md: '0.95rem' },
                    px: { xs: 2, md: 3 }, py: { xs: 1, md: 1.5 },
                    '&:hover': {
                      borderColor: PRIMARY_COLOR_LIGHT,
                      bgcolor: 'rgba(20, 184, 166, 0.1)', // Primary color with low opacity
                      color: PRIMARY_COLOR_LIGHT
                    },
                    borderRadius: 2,
                    boxShadow: 1,
                  }}
                >
                  {t('projects.githubRepo') || 'View on GitHub'}
                </Button>
              )}
            </Box>
          )}

          <h2 className="text-xl sm:text-2xl font-bold mb-4 text-white mt-8 md:mt-10 text-center w-full">{t('projects.tagsLabel') || 'Technologies & Tags'}</h2>
          <div className="flex flex-wrap gap-2 md:gap-3 mb-8 justify-center w-full max-w-3xl mx-auto px-2">
            {techs.map((tech) => (
              <Chip
                key={tech}
                icon={techIcons[tech] ? React.cloneElement(techIcons[tech], { style: { color: PRIMARY_COLOR_LIGHT, fontSize: '1.1rem', transition: 'transform 0.2s' } }) : <FaCogs style={{ color: PRIMARY_COLOR_LIGHT, fontSize: '1.1rem' }} />}
                label={tech}
                sx={{ 
                  bgcolor: 'rgba(20, 184, 166, 0.15)', // Primary color with low opacity
                  color: '#e0e0e0', // Lighter text color for contrast
                  fontWeight: 600, 
                  fontSize: { xs: '0.85rem', md: '0.9rem' },
                  px: 1.5, 
                  py: 0.5,
                  borderRadius: '12px', // Softer border radius
                  border: `1px solid ${PRIMARY_COLOR_DARK}`,
                  boxShadow: '0 0 0 0 transparent',
                  transition: 'all 0.25s ease-in-out',
                  '& .MuiChip-icon': { transition: 'transform 0.2s' }, // Ensure icon transition is applied
                  '&:hover': { 
                    bgcolor: 'rgba(20, 184, 166, 0.25)',
                    boxShadow: `0 0 10px 2px rgba(20, 184, 166, 0.3)`, // Softer glow effect
                    transform: 'translateY(-2px) scale(1.03)',
                    color: '#fff',
                    '& .MuiChip-icon': {
                        transform: 'scale(1.12)',
                        color: '#fff', // Icon color change on hover
                     }
                  }
                }}
              />
            ))}
          </div>
        </main>
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