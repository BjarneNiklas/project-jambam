'use client';

import React from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import Divider from '@mui/material/Divider';
import Box from '@mui/material/Box';
import PolicyIcon from '@mui/icons-material/Policy';
import { useTheme } from '@mui/material/styles';
import Footer from '@/components/Footer';
import { useLanguage } from '../LanguageContext';
import { Metadata } from 'next';

const Datenschutz: React.FC = () => {
  const theme = useTheme();
  const { t } = useLanguage();

  return (
    <>
    <Box sx={{ 
      background: 'linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%)',
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'flex-start',
      justifyContent: 'center',
      pt: { xs: 4, md: 6 },
      pb: { xs: 6, md: 10 }
    }}>
      <Card elevation={0} sx={{ 
        maxWidth: 800, 
        width: '100%', 
        borderRadius: 4, 
        mx: 2, 
        p: { xs: 3, sm: 5 }, 
        background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.05) 0%, rgba(20, 184, 166, 0.02) 100%)',
        border: '1px solid rgba(20, 184, 166, 0.2)',
        backdropFilter: 'blur(10px)',
        boxShadow: '0 20px 40px rgba(0, 0, 0, 0.3)'
      }}>
        <CardContent>
          <Box display="flex" alignItems="center" justifyContent="center" mb={4}>
            <Box sx={{
              display: 'inline-flex',
              alignItems: 'center',
              justifyContent: 'center',
              width: 80,
              height: 80,
              borderRadius: '50%',
              background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.2) 0%, rgba(20, 184, 166, 0.1) 100%)',
              border: '2px solid rgba(20, 184, 166, 0.3)',
              mr: 3
            }}>
              <PolicyIcon sx={{ color: '#14b8a6', fontSize: 40 }} />
            </Box>
            <Typography variant="h3" component="h1" fontWeight={800} color="primary" sx={{ fontSize: { xs: 28, sm: 36 }, background: 'linear-gradient(135deg, #14b8a6 0%, #0d9488 100%)', backgroundClip: 'text', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
              Datenschutz
            </Typography>
          </Box>
          
          <Divider sx={{ mb: 4, background: 'linear-gradient(90deg, transparent 0%, rgba(20, 184, 166, 0.3) 50%, transparent 100%)' }} />
          
          <Box sx={{ mb: 4 }}>
            <Typography variant="body1" sx={{ 
              mb: 2, 
              lineHeight: 1.8,
              color: '#e5e7eb',
              fontSize: '1.1rem'
            }}>
              {t('legal.datenschutz.content')}
            </Typography>
          </Box>
          
          <Divider sx={{ my: 4, background: 'linear-gradient(90deg, transparent 0%, rgba(20, 184, 166, 0.3) 50%, transparent 100%)' }} />
          
          <Box sx={{ mb: 4 }}>
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ 
              mt: 2, 
              mb: 2,
              background: 'linear-gradient(135deg, #14b8a6 0%, #0d9488 100%)',
              backgroundClip: 'text',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent'
            }}>
              {t('legal.datenschutz.contact.title')}
            </Typography>
            <Typography variant="body2" sx={{ 
              mb: 2, 
              lineHeight: 1.7,
              color: '#d1d5db'
            }}>
              {t('legal.datenschutz.contact.content')}
            </Typography>
          </Box>
          
          <Divider sx={{ my: 4, background: 'linear-gradient(90deg, transparent 0%, rgba(20, 184, 166, 0.3) 50%, transparent 100%)' }} />
          
          <Box sx={{ mb: 4 }}>
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ 
              mt: 2, 
              mb: 2,
              background: 'linear-gradient(135deg, #14b8a6 0%, #0d9488 100%)',
              backgroundClip: 'text',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent'
            }}>
              {t('legal.datenschutz.serverlog.title')}
            </Typography>
            <Typography variant="body2" sx={{ 
              mb: 2, 
              lineHeight: 1.7,
              color: '#d1d5db'
            }}>
              {t('legal.datenschutz.serverlog.content')}
            </Typography>
          </Box>
          
          <Divider sx={{ my: 4, background: 'linear-gradient(90deg, transparent 0%, rgba(20, 184, 166, 0.3) 50%, transparent 100%)' }} />
          
          <Box sx={{ mb: 4 }}>
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ 
              mt: 2, 
              mb: 2,
              background: 'linear-gradient(135deg, #14b8a6 0%, #0d9488 100%)',
              backgroundClip: 'text',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent'
            }}>
              {t('legal.datenschutz.rights.title')}
            </Typography>
            <Typography variant="body2" sx={{ 
              mb: 2, 
              lineHeight: 1.7,
              color: '#d1d5db'
            }}>
              {t('legal.datenschutz.rights.content')}
            </Typography>
          </Box>
          
          <Box sx={{ 
            mt: 6, 
            p: 3, 
            borderRadius: 2, 
            background: 'linear-gradient(135deg, rgba(20, 184, 166, 0.1) 0%, rgba(20, 184, 166, 0.05) 100%)',
            border: '1px solid rgba(20, 184, 166, 0.2)'
          }}>
            <Typography variant="caption" sx={{ 
              color: '#9ca3af', 
              mt: 4,
              display: 'block',
              textAlign: 'center',
              fontSize: '0.9rem'
            }}>
              {t('legal.datenschutz.contact.caption')}
            </Typography>
          </Box>
        </CardContent>
      </Card>
    </Box>
      <Footer />
    </>
  );
};

export default Datenschutz;

export const metadata: Metadata = {
  title: 'Datenschutz',
}; 