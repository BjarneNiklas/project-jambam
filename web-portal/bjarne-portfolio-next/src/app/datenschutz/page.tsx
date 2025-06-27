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

const Datenschutz: React.FC = () => {
  const theme = useTheme();
  const { t } = useLanguage();

  return (
    <>
    <Box sx={{ 
      background: '#0a0a0a',
      display: 'flex',
      alignItems: 'flex-start',
      justifyContent: 'center',
        pt: { xs: 2, md: 4 },
        pb: { xs: 4, md: 8 }
    }}>
      <Card elevation={4} sx={{ maxWidth: 700, width: '100%', borderRadius: 6, mx: 2, p: { xs: 2, sm: 4 }, background: theme.palette.background.paper }}>
        <CardContent>
          <Box display="flex" alignItems="center" justifyContent="center" mb={2}>
            <PolicyIcon sx={{ color: theme.palette.primary.main, fontSize: 40, mr: 1 }} />
              <Typography variant="h3" component="h1" fontWeight={800} color="primary" sx={{ fontSize: { xs: 24, sm: 32 } }}>
                {t('legal.datenschutz.title')}
              </Typography>
          </Box>
          <Divider sx={{ mb: 3 }} />
            <Typography variant="body1" sx={{ mb: 2 }}>
              {t('legal.datenschutz.content')}
            </Typography>
          <Divider sx={{ my: 3 }} />
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>
              {t('legal.datenschutz.contact.title')}
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              {t('legal.datenschutz.contact.content')}
            </Typography>
          <Divider sx={{ my: 3 }} />
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>
              {t('legal.datenschutz.serverlog.title')}
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              {t('legal.datenschutz.serverlog.content')}
            </Typography>
          <Divider sx={{ my: 3 }} />
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>
              {t('legal.datenschutz.rights.title')}
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              {t('legal.datenschutz.rights.content')}
            </Typography>
            <Typography variant="caption" sx={{ color: theme.palette.text.secondary, mt: 4 }}>
              {t('legal.datenschutz.contact.caption')}
            </Typography>
        </CardContent>
      </Card>
    </Box>
      <Footer />
    </>
  );
};

export default Datenschutz; 