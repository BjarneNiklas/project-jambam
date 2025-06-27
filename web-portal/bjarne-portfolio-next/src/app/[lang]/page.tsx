'use client';
import React from 'react';
import { Box } from '@mui/material';
import Hero from '../../components/Hero';
import About from '../../components/About';
import Skills from '../../components/Skills';
import ExperienceEducation from '../../components/ExperienceEducation';
import Projects from '../../components/Projects';
import Contact from '../../components/Contact';
import Footer from '../../components/Footer';
import { useLanguage } from '../../app/LanguageContext';
import { useEffect } from 'react';

interface PageProps {
  params: Promise<{
    lang: string;
  }>;
}

const HomePage: React.FC<PageProps> = ({ params }) => {
  const { setLang } = useLanguage();
  const resolvedParams = React.use(params);

  useEffect(() => {
    // Setze die Sprache basierend auf der URL
    if (resolvedParams.lang === 'en' || resolvedParams.lang === 'de') {
      setLang(resolvedParams.lang);
    }
  }, [resolvedParams.lang, setLang]);

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: 'background.default' }}>
      <Hero />
      <About />
      <Skills />
      <ExperienceEducation />
      <Projects />
      <Contact />
      <Footer />
    </Box>
  );
};

export default HomePage; 