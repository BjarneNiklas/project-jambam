'use client';

import React, { useState, useCallback } from 'react';
import Image from 'next/image';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import Footer from '@/components/Footer';
import { useLanguage } from '../../LanguageContext';
import { Box, Chip, IconButton, Modal } from '@mui/material';
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
};

export default function ProjectPageClient({ project }: ProjectPageClientProps) {
  const { t } = useLanguage();
  const projectImages = project.imageUrls && project.imageUrls.length > 0 ? project.imageUrls : [];
  const [lightboxIdx, setLightboxIdx] = useState<number|null>(null);
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMsg, setSnackbarMsg] = useState('');

  // Lightbox-Handler
  const openLightbox = (idx: number) => setLightboxIdx(idx);
  const closeLightbox = () => setLightboxIdx(null);
  const nextImg = useCallback(() => setLightboxIdx(i => (i !== null ? (i + 1) % projectImages.length : null)), [projectImages.length]);
  const prevImg = useCallback(() => setLightboxIdx(i => (i !== null ? (i - 1 + projectImages.length) % projectImages.length : null)), [projectImages.length]);

  // Share handler
  const handleShare = async () => {
    const shareUrl = window.location.href;
    if (navigator.share) {
      try {
        await navigator.share({ title: project.name, url: shareUrl });
        setSnackbarMsg('Seite geteilt!');
      } catch {
        setSnackbarMsg('Teilen abgebrochen.');
      }
    } else {
      await navigator.clipboard.writeText(shareUrl);
      setSnackbarMsg('Link kopiert!');
    }
    setSnackbarOpen(true);
  };

  const techs = (() => {
    const arr = project.technologies.filter(t => t !== 'Blueprints');
    if (!arr.includes('Exploration')) arr.push('Exploration');
    if (!arr.includes('Psychological Horror')) arr.push('Psychological Horror');
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
        <div className="hidden md:block" style={{ width: 220, flexShrink: 0 }} />
        <main className="flex-1 max-w-5xl mx-auto my-12 bg-gradient-to-br from-[#18181b] to-[#23232a] rounded-3xl shadow-2xl p-6 md:p-12 border border-[#23232a] min-h-[70vh] flex flex-col relative items-center">
          {/* Share-Button klein, top right, mit Tooltip */}
          <div className="absolute top-8 right-8">
            <Tooltip title={t('projects.shareTooltip') || 'Seite teilen'} arrow>
              <IconButton onClick={handleShare} size="medium" sx={{ bgcolor: 'rgba(30,30,40,0.7)', color: 'white', '&:hover': { bgcolor: 'primary.main', color: 'white' }, transition: 'all 0.2s', width: 38, height: 38 }}>
                <FaShareAlt size={20} />
              </IconButton>
            </Tooltip>
          </div>

          {/* Titel */}
          <h1 className="text-4xl md:text-5xl font-extrabold text-white tracking-tight drop-shadow-lg mb-2 mt-2 text-center w-full">{project.name}</h1>

          {/* Jahr & Genre in einer Zeile, mittig */}
          <div className="flex flex-row gap-4 items-center justify-center mb-6 mt-2 w-full">
            <Chip
              label={project.year ? project.year : '2028'}
              sx={{ bgcolor: '#a78bfa', color: '#fff', fontWeight: 700, fontSize: '1.1rem', px: 2, py: 0.5, borderRadius: 2, boxShadow: 2 }}
            />
            {project.genres && project.genres.map((genre) => (
              <Chip
                key={genre}
                label={genre}
                sx={{ bgcolor: '#23232a', color: '#a78bfa', fontWeight: 600, fontSize: '1rem', px: 2, py: 0.5, borderRadius: 2, border: '1px solid #a78bfa' }}
              />
            ))}
          </div>

          {/* Konzeptbilder-Label dezent, kleiner, mit Abstand */}
          {projectImages.length > 0 && (
            <div className="mb-6 mt-2 w-full flex justify-center">
              <span className="text-base font-semibold text-gray-300 tracking-wide">{t('projects.conceptImagesLabel')}</span>
            </div>
          )}

          {/* Galerie - Top Niveau: Immer nebeneinander, echtes Karussell, niemals untereinander */}
          {projectImages.length > 0 && (
            <div className="w-full flex justify-center">
              <div
                className="flex flex-row flex-nowrap items-center mb-14 overflow-x-auto px-2"
                style={{
                  maxWidth: 1200,
                  whiteSpace: 'nowrap',
                  scrollbarColor: '#a78bfa #23232a',
                  scrollbarWidth: 'thin',
                }}
              >
                {projectImages.map((src, idx) => (
                  <div
                    key={src}
                    className="flex-shrink-0"
                    style={{
                      width: 220,
                      height: 220,
                      borderRadius: 18,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      background: 'rgba(30,30,40,0.7)',
                      marginRight: idx !== projectImages.length - 1 ? '3rem' : 0
                    }}
                    onClick={() => openLightbox(idx)}
                  >
                    <Image
                      src={src}
                      alt={`${project.name} Screenshot ${idx + 1}`}
                      width={220}
                      height={220}
                      style={{ objectFit: 'cover', width: '100%', height: '100%', borderRadius: 18, boxShadow: '0 4px 24px 0 #18181b55' }}
                      className="rounded-2xl border border-[#23232a] cursor-pointer transition-transform duration-200 hover:scale-105"
                    />
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Lightbox Modal mit Nummerierung */}
          <Modal open={lightboxIdx !== null} onClose={closeLightbox} sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 2000 }}>
            <Box sx={{ position: 'relative', outline: 'none', maxWidth: '90vw', maxHeight: '90vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              {/* Nummerierung oben links im Modal */}
              {lightboxIdx !== null && projectImages.length > 0 && (
                <div style={{ position: 'absolute', top: 16, left: 24, color: '#fff', fontWeight: 600, fontSize: '1.1rem', background: 'rgba(30,30,40,0.7)', borderRadius: 8, padding: '4px 14px', zIndex: 20 }}>
                  Bild {lightboxIdx + 1}/{projectImages.length}
                </div>
              )}
              <IconButton onClick={prevImg} sx={{ position: 'absolute', left: 16, top: '50%', transform: 'translateY(-50%)', zIndex: 10, bgcolor: 'rgba(30,30,40,0.8)', color: 'white', '&:hover': { bgcolor: 'primary.main' } }}>
                <ArrowBackIcon fontSize="large" />
              </IconButton>
              {lightboxIdx !== null && projectImages.length > 0 && (
                <Image
                  src={projectImages[lightboxIdx]}
                  alt={`${project.name} Screenshot ${lightboxIdx + 1}`}
                  width={900}
                  height={600}
                  style={{ objectFit: 'contain', borderRadius: 16, background: '#18181b', maxHeight: '80vh', maxWidth: '80vw' }}
                />
              )}
              <IconButton onClick={nextImg} sx={{ position: 'absolute', right: 16, top: '50%', transform: 'translateY(-50%)', zIndex: 10, bgcolor: 'rgba(30,30,40,0.8)', color: 'white', '&:hover': { bgcolor: 'primary.main' } }}>
                <ArrowBackIcon fontSize="large" sx={{ transform: 'scaleX(-1)' }} />
              </IconButton>
            </Box>
          </Modal>

          {/* Projektbeschreibung - mehr Abstand, bessere Lesbarkeit, zentriert */}
          <h2 className="text-2xl font-bold mb-4 text-white mt-16 text-center w-full">{t('projects.descriptionLabel')}</h2>
          <p className="text-lg md:text-xl text-gray-300 mb-12 leading-relaxed max-w-3xl mx-auto text-center" style={{ lineHeight: 1.7 }}>
            {project.longDescription}
          </p>

          {/* Tags (Technologies) - kompakt, ruhig, modern */}
          <h2 className="text-2xl font-bold mb-4 text-white text-center w-full">{t('projects.tagsLabel')}</h2>
          <div className="flex flex-wrap gap-2 mb-8 justify-center w-full">
            {techs.map((tech) => (
              <Chip
                key={tech}
                icon={techIcons[tech] ? techIcons[tech] : <FaCogs />}
                label={tech}
                sx={{ 
                  bgcolor: 'rgba(139, 92, 246, 0.12)', 
                  color: '#fff', 
                  fontWeight: 600, 
                  fontSize: '0.98rem', 
                  px: 1.5, 
                  py: 0.2, 
                  borderRadius: 2, 
                  border: '1px solid #a78bfa',
                  boxShadow: '0 0 0 0 #a78bfa',
                  transition: 'all 0.2s',
                  '& .MuiChip-icon': { color: '#a78bfa', fontSize: '1.05rem', transition: 'transform 0.2s' },
                  '&:hover': { 
                    bgcolor: 'rgba(139, 92, 246, 0.22)', 
                    boxShadow: '0 0 8px 2px #a78bfa33',
                    transform: 'translateY(-1px) scale(1.04)',
                    '& .MuiChip-icon': { transform: 'scale(1.1)' }
                  }
                }}
              />
            ))}
          </div>
        </main>
        <div className="hidden md:block flex-1" />
      </div>
      <Footer />
      <Snackbar
        open={snackbarOpen}
        autoHideDuration={2000}
        onClose={() => setSnackbarOpen(false)}
        message={snackbarMsg}
        anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      />
    </div>
  );
} 