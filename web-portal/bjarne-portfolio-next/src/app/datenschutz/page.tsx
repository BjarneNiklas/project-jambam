'use client';

import React, { useEffect } from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import Divider from '@mui/material/Divider';
import Box from '@mui/material/Box';
import PolicyIcon from '@mui/icons-material/Policy';
import { useTheme } from '@mui/material/styles';

const Datenschutz: React.FC = () => {
  const theme = useTheme();

  useEffect(() => {
    const updateLang = () => {
      const lang = document.documentElement.lang || 'de';
      document.querySelectorAll('[data-lang-legal]').forEach(el => {
        const show = el.getAttribute('data-lang-legal') === lang;
        (el as HTMLElement).style.display = show ? '' : 'none';
      });
    };
    updateLang();
    window.addEventListener('languagechange', updateLang);
    return () => window.removeEventListener('languagechange', updateLang);
  }, []);

  return (
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
            <Typography variant="h3" component="h1" fontWeight={800} color="primary" sx={{ fontSize: { xs: 24, sm: 32 } }} data-lang-legal="de">Datenschutzerklärung</Typography>
            <Typography variant="h3" component="h1" fontWeight={800} color="primary" sx={{ fontSize: { xs: 24, sm: 32 }, display: 'none' }} data-lang-legal="en">Privacy Policy</Typography>
          </Box>
          <Divider sx={{ mb: 3 }} />
          <Typography variant="body1" sx={{ mb: 2 }} data-lang-legal="de">Diese Website erhebt und speichert keine personenbezogenen Daten. Es werden keine Cookies gesetzt und kein Tracking eingesetzt.</Typography>
          <Typography variant="body1" sx={{ mb: 2, display: 'none' }} data-lang-legal="en">This website does not collect or store any personal data. No cookies are set and no tracking is used.</Typography>
          <Divider sx={{ my: 3 }} />
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }} data-lang-legal="de">Kontaktaufnahme</Typography>
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1, display: 'none' }} data-lang-legal="en">Contact</Typography>
          <Typography variant="body2" sx={{ mb: 2 }} data-lang-legal="de">Wenn Sie mir per E-Mail Anfragen zukommen lassen, werden Ihre Angaben aus der E-Mail inklusive der von Ihnen dort angegebenen Kontaktdaten zwecks Bearbeitung der Anfrage und für den Fall von Anschlussfragen gespeichert. Diese Daten gebe ich nicht ohne Ihre Einwilligung weiter.</Typography>
          <Typography variant="body2" sx={{ mb: 2, display: 'none' }} data-lang-legal="en">If you send me inquiries by e-mail, your details from the e-mail, including the contact details you provide there, will be stored for the purpose of processing the inquiry and in case of follow-up questions. I will not pass on this data without your consent.</Typography>
          <Divider sx={{ my: 3 }} />
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }} data-lang-legal="de">Server-Log-Files</Typography>
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1, display: 'none' }} data-lang-legal="en">Server Log Files</Typography>
          <Typography variant="body2" sx={{ mb: 2 }} data-lang-legal="de">Der Provider der Seiten erhebt und speichert automatisch Informationen in so genannten Server-Log Files, die Ihr Browser automatisch übermittelt. Diese Daten sind nicht bestimmten Personen zuordenbar. Eine Zusammenführung dieser Daten mit anderen Datenquellen wird nicht vorgenommen.</Typography>
          <Typography variant="body2" sx={{ mb: 2, display: 'none' }} data-lang-legal="en">The provider of these pages automatically collects and stores information in so-called server log files, which your browser automatically transmits. This data cannot be assigned to specific persons. This data is not merged with other data sources.</Typography>
          <Divider sx={{ my: 3 }} />
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }} data-lang-legal="de">Rechte</Typography>
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1, display: 'none' }} data-lang-legal="en">Your Rights</Typography>
          <Typography variant="body2" sx={{ mb: 2 }} data-lang-legal="de">Sie haben jederzeit das Recht auf unentgeltliche Auskunft über Ihre gespeicherten personenbezogenen Daten, deren Herkunft und Empfänger und den Zweck der Datenverarbeitung sowie ein Recht auf Berichtigung, Sperrung oder Löschung dieser Daten.</Typography>
          <Typography variant="body2" sx={{ mb: 2, display: 'none' }} data-lang-legal="en">You have the right at any time to free information about your stored personal data, its origin and recipient and the purpose of data processing as well as a right to correction, blocking or deletion of this data.</Typography>
          <Typography variant="caption" sx={{ color: theme.palette.text.secondary, mt: 4 }} data-lang-legal="de">Für Fragen zum Datenschutz wenden Sie sich bitte an: <Box component="a" href="mailto:aurav.tech@gmail.com" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>aurav.tech@gmail.com</Box></Typography>
          <Typography variant="caption" sx={{ color: theme.palette.text.secondary, mt: 4, display: 'none' }} data-lang-legal="en">For questions about data protection, please contact: <Box component="a" href="mailto:aurav.tech@gmail.com" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>aurav.tech@gmail.com</Box></Typography>
        </CardContent>
      </Card>
    </Box>
  );
};

export default Datenschutz; 