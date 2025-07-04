"use client";
import React from "react";
import { Box, Typography, Button } from "@mui/material";
import SentimentVeryDissatisfiedIcon from '@mui/icons-material/SentimentVeryDissatisfied';
import { useRouter, usePathname } from 'next/navigation';
import { useLanguage } from '../app/LanguageContext';

const NotFound = () => {
  const router = useRouter();
  const { t, lang } = useLanguage();

  return (
    <Box sx={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%)',
      color: '#fff',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      textAlign: 'center',
      px: 2,
      position: 'relative',
      overflow: 'hidden'
    }}>
      {/* Animated Background Elements */}
      <Box sx={{
        position: 'absolute',
        top: '20%',
        left: '10%',
        width: 200,
        height: 200,
        borderRadius: '50%',
        background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.1) 0%, rgba(20, 184, 166, 0.05) 100%)',
        animation: 'float 6s ease-in-out infinite',
        zIndex: 0
      }} />
      <Box sx={{
        position: 'absolute',
        bottom: '20%',
        right: '10%',
        width: 150,
        height: 150,
        borderRadius: '50%',
        background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.08) 0%, rgba(20, 184, 166, 0.03) 100%)',
        animation: 'float 8s ease-in-out infinite reverse',
        zIndex: 0
      }} />
      
      <Box sx={{ position: 'relative', zIndex: 1 }}>
        <Box sx={{
          display: 'inline-flex',
          alignItems: 'center',
          justifyContent: 'center',
          width: 120,
          height: 120,
          borderRadius: '50%',
          background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.2) 0%, rgba(20, 184, 166, 0.1) 100%)',
          border: '3px solid rgba(20, 184, 166, 0.3)',
          mb: 4,
          animation: 'pulse 2s infinite'
        }}>
          <SentimentVeryDissatisfiedIcon sx={{ 
            fontSize: 60, 
            color: '#14b8a6',
            animation: 'shake 1.2s infinite alternate'
          }} />
        </Box>
        
        <Typography variant="h1" sx={{ 
          fontWeight: 900, 
          fontSize: { xs: 64, md: 96 }, 
          mb: 3, 
          letterSpacing: 3,
          background: 'linear-gradient(135deg, #14b8a6 0%, #0d9488 100%)',
          backgroundClip: 'text',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          textShadow: '0 4px 32px rgba(20, 184, 166, 0.3)'
        }}>
          404
        </Typography>
        
        <Typography variant="h3" sx={{ 
          fontWeight: 700, 
          mb: 3,
          background: 'linear-gradient(135deg, #e5e7eb 0%, #d1d5db 100%)',
          backgroundClip: 'text',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent'
        }}>
          {t('error.404.title')}
        </Typography>
        
        <Typography variant="h6" sx={{ 
          mb: 6, 
          color: '#9ca3af', 
          maxWidth: 600, 
          mx: 'auto',
          lineHeight: 1.6,
          fontSize: '1.1rem'
        }}>
          {t('error.404.description')}
        </Typography>
        
        <Button
          variant="contained"
          size="large"
          sx={{
            background: 'linear-gradient(135deg, #14b8a6 0%, #0d9488 100%)',
            fontWeight: 700,
            fontSize: 18,
            px: 6,
            py: 2,
            borderRadius: 3,
            boxShadow: '0 8px 32px rgba(20, 184, 166, 0.3)',
            transition: 'all 0.3s ease',
            '&:hover': {
              transform: 'translateY(-2px)',
              boxShadow: '0 12px 40px rgba(20, 184, 166, 0.4)',
              background: 'linear-gradient(135deg, #0d9488 0%, #14b8a6 100%)'
            }
          }}
          onClick={() => router.push(`/${lang}`)}
        >
          {t('error.404.button')}
        </Button>
      </Box>
      <style jsx global>{`
        @keyframes shake {
          0% { transform: rotate(-8deg); }
          100% { transform: rotate(8deg); }
        }
        @keyframes pulse {
          0% { box-shadow: 0 0 0 0 rgba(20,184,166,0.18); }
          70% { box-shadow: 0 0 0 16px rgba(20,184,166,0.01); }
          100% { box-shadow: 0 0 0 0 rgba(20,184,166,0.18); }
        }
        @keyframes float {
          0%, 100% { transform: translateY(0px) rotate(0deg); }
          50% { transform: translateY(-20px) rotate(180deg); }
        }
      `}</style>
    </Box>
  );
};

export default NotFound; 