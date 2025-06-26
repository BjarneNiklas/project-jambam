'use client';
import React, { useEffect } from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import Divider from '@mui/material/Divider';
import Box from '@mui/material/Box';
import PolicyIcon from '@mui/icons-material/Policy';
import { useTheme } from '@mui/material/styles';
import Footer from '../../../components/Footer';
import { useLanguage } from '../../../app/LanguageContext';

interface PageProps {
  params: {
    lang: string;
  };
}

const ImpressumPage: React.FC<PageProps> = ({ params }) => {
  const theme = useTheme();
  const { t, setLang } = useLanguage();

  useEffect(() => {
    // Setze die Sprache basierend auf der URL
    if (params.lang === 'en' || params.lang === 'de') {
      setLang(params.lang);
    }
  }, [params.lang, setLang]);

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
                {t('legal.impressum.title')}
              </Typography>
            </Box>
            <Divider sx={{ mb: 3 }} />
            <Typography variant="body1" sx={{ mb: 2 }}>
              {t('legal.impressum.content')}
            </Typography>
            <Divider sx={{ my: 3 }} />
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>
              {t('legal.impressum.info.title')}
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }} dangerouslySetInnerHTML={{ __html: t('legal.impressum.info.content') }} />
            <Typography variant="body2" sx={{ mb: 2, fontStyle: 'italic' }}>
              {t('legal.impressum.note')}
            </Typography>
            <Divider sx={{ my: 3 }} />
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>
              {t('legal.impressum.contact.title')}
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }} dangerouslySetInnerHTML={{ __html: t('legal.impressum.contact.content') }} />
            <Divider sx={{ my: 3 }} />
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>
              {t('legal.impressum.responsible.title')}
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              {t('legal.impressum.responsible.content')}
            </Typography>
            <Divider sx={{ my: 3 }} />
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>
              {t('legal.impressum.disclaimer.title')}
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              {t('legal.impressum.disclaimer.content')}
            </Typography>
            <Divider sx={{ my: 3 }} />
            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>
              {t('legal.impressum.copyright.title')}
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              {t('legal.impressum.copyright.content')}
            </Typography>
            <Divider sx={{ my: 3 }} />
            <Typography variant="body2" sx={{ mb: 2 }}>
              Für Informationen zum Datenschutz siehe unsere <Box component="a" href={`/${params.lang}/datenschutz`} sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>Datenschutzerklärung</Box>.
            </Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              Die Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung (OS) bereit: <Box component="a" href="https://ec.europa.eu/consumers/odr/" target="_blank" rel="noopener" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>https://ec.europa.eu/consumers/odr/</Box>.<br />
              Wir sind weder bereit noch verpflichtet, an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen.
            </Typography>
            <Typography variant="caption" sx={{ color: theme.palette.text.secondary, mt: 2 }}>
              Dieses Impressum gilt auch für folgende Social-Media-Profile:
              <ul style={{ margin: 0, paddingLeft: 18 }}>
                <li>
                  <Box component="a" href="https://www.linkedin.com/in/bjarne-luttermann/" target="_blank" rel="noopener" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>LinkedIn</Box>
                </li>
                <li>
                  <Box component="a" href="https://github.com/BjarneNiklas" target="_blank" rel="noopener" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>GitHub</Box>
                </li>
                <li>
                  <Box component="a" href="https://www.youtube.com/@bjarnik_interactive" target="_blank" rel="noopener" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>YouTube</Box>
                </li>
              </ul>
            </Typography>
          </CardContent>
        </Card>
      </Box>
      <Footer />
    </>
  );
};

export default ImpressumPage; 