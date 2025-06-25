"use client";
import React, { useEffect, useState } from 'react';
import { LinearProgress } from '@mui/material';
import { useTheme } from '@mui/material/styles';

const ProgressBar: React.FC = () => {
  const [scrollProgress, setScrollProgress] = useState(0);
  const theme = useTheme();

  useEffect(() => {
    const handleScroll = () => {
      const scrollTop = window.scrollY;
      const docHeight = document.documentElement.scrollHeight - window.innerHeight;
      const scrollPercent = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
      setScrollProgress(scrollPercent);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <LinearProgress
      variant="determinate"
      value={scrollProgress}
      sx={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        height: '3px',
        zIndex: 2000,
        bgcolor: 'rgba(0,150,136,0.10)',
        '& .MuiLinearProgress-bar': {
          bgcolor: theme.palette.primary.main,
          transition: 'transform 0.1s ease',
        },
      }}
    />
  );
};

export default ProgressBar; 