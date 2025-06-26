'use client';
import React from 'react';
import { Box } from '@mui/material';
import Hero from '../../components/Hero';
import About from '../../components/About';
import Projects from '../../components/Projects';
import Contact from '../../components/Contact';
import Footer from '../../components/Footer';
import { useLanguage } from '../../app/LanguageContext';
import { useEffect } from 'react';

interface PageProps {
  params: {
    lang: string;
  };
}

const HomePage: React.FC<PageProps> = ({ params }) => {
  const { setLang } = useLanguage();

  useEffect(() => {
    // Setze die Sprache basierend auf der URL
    if (params.lang === 'en' || params.lang === 'de') {
      setLang(params.lang);
    }
  }, [params.lang, setLang]);

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: 'background.default' }}>
      <Hero />
      <About />
      <Projects />
      <Contact />
      <Footer />
    </Box>
  );
};

export default HomePage; 