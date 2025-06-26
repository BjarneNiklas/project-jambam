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

const Imprint: React.FC = () => {
  const theme = useTheme();
  return (
    <>
      <Box sx={{ 
        background: '#0a0a0a',
        display: 'flex',
        alignItems: 'flex-start',
        justifyContent: 'center',
        pt: { xs: 2, md: 4 }, // Reduced top padding
        pb: { xs: 4, md: 8 }  // Kept bottom padding
      }}>
        <Card elevation={4} sx={{ maxWidth: 700, width: '100%', borderRadius: 6, mx: 2, p: { xs: 2, sm: 4 }, background: theme.palette.background.paper }}>
          <CardContent>
            <Box display="flex" alignItems="center" justifyContent="center" mb={2}>
              <PolicyIcon sx={{ color: theme.palette.primary.main, fontSize: 40, mr: 1 }} />
              <Typography variant="h3" component="h1" fontWeight={800} color="primary" sx={{ fontSize: { xs: 24, sm: 32 } }}>Imprint</Typography>
            </Box>
            <Divider sx={{ mb: 3 }} />

            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>Information according to § 5 TMG</Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              Bjarne Niklas Luttermann<br />
              Julius-Brecht-Str. 9a<br />
              23560 Lübeck<br />
              Germany<br />
              Email: <Box component="a" href="mailto:aurav.tech@gmail.com" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>aurav.tech@gmail.com</Box>
            </Typography>

            <Typography variant="body2" sx={{ mb: 2, fontStyle: 'italic' }}>
              Note: AuraV Technologies is not a registered company, but a private project by Bjarne Niklas Luttermann.
            </Typography>

            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>Responsible for content according to § 55 Abs. 2 RStV</Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              Bjarne Niklas Luttermann, address as above
            </Typography>

            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>Disclaimer</Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              Despite careful content control, I assume no liability for the content of external links. The operators of the linked pages are solely responsible for their content.
            </Typography>

            <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }}>Copyright</Typography>
            <Typography variant="body2" sx={{ mb: 2 }}>
              The content and works created by the site operator on these pages are subject to German copyright law. Third-party contributions are marked as such.
            </Typography>

            <Divider sx={{ my: 3 }} />

            <Typography variant="body2" sx={{ mb: 2 }}>
              For information on data protection, please see our <Box component="a" href="/datenschutz" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>Privacy Policy</Box>.
            </Typography>

            <Typography variant="body2" sx={{ mb: 2 }}>
              The European Commission provides a platform for online dispute resolution (ODR): <Box component="a" href="https://ec.europa.eu/consumers/odr/" target="_blank" rel="noopener" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>https://ec.europa.eu/consumers/odr/</Box>.<br />
              We are neither obliged nor willing to participate in a dispute settlement procedure before a consumer arbitration board.
            </Typography>

            <Typography variant="caption" sx={{ color: theme.palette.text.secondary, mt: 2 }}>
              This imprint also applies to the following social media profiles:
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

export default Imprint; 