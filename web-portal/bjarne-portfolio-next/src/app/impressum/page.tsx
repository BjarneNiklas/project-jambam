import React from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Typography from '@mui/material/Typography';
import Divider from '@mui/material/Divider';
import Box from '@mui/material/Box';
import GavelIcon from '@mui/icons-material/Gavel';
import { useTheme } from '@mui/material/styles';

const Impressum: React.FC = () => {
  const theme = useTheme();
  return (
    <Box sx={{ display: 'flex', justifyContent: 'center', py: { xs: 4, md: 8 } }}>
      <Card elevation={4} sx={{ maxWidth: 700, width: '100%', borderRadius: 6, mx: 2, p: { xs: 2, sm: 4 }, background: theme.palette.background.paper }}>
        <CardContent>
          <Box display="flex" alignItems="center" justifyContent="center" mb={2}>
            <GavelIcon sx={{ color: theme.palette.primary.main, fontSize: 40, mr: 1 }} />
            <Typography variant="h3" component="h1" fontWeight={800} color="primary" sx={{ fontSize: { xs: 24, sm: 32 } }} data-lang-legal="de">Impressum</Typography>
            <Typography variant="h3" component="h1" fontWeight={800} color="primary" sx={{ fontSize: { xs: 24, sm: 32 }, display: 'none' }} data-lang-legal="en">Legal Notice</Typography>
          </Box>
          <Divider sx={{ mb: 3 }} />
          <Typography variant="body1" sx={{ mb: 2 }} data-lang-legal="de">Angaben gemäß § 5 TMG</Typography>
          <Typography variant="body1" sx={{ mb: 2, display: 'none' }} data-lang-legal="en">Information according to § 5 TMG (German law)</Typography>
          <Typography variant="body2" sx={{ mb: 2 }} data-lang-legal="de">Bjarne Niklas Luttermann<br />Musterstraße 1<br />70173 Stuttgart<br />Deutschland</Typography>
          <Typography variant="body2" sx={{ mb: 2, display: 'none' }} data-lang-legal="en">Bjarne Niklas Luttermann<br />Musterstraße 1<br />70173 Stuttgart<br />Germany</Typography>
          <Typography variant="body2" sx={{ mb: 2 }}>E-Mail: <Box component="a" href="mailto:aurav.tech@gmail.com" sx={{ color: theme.palette.primary.main, textDecoration: 'underline' }}>aurav.tech@gmail.com</Box></Typography>
          <Typography variant="body2" sx={{ mb: 3 }} data-lang-legal="de">Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV:<br />Bjarne Niklas Luttermann, Adresse wie oben</Typography>
          <Typography variant="body2" sx={{ mb: 3, display: 'none' }} data-lang-legal="en">Responsible for content according to § 55 Abs. 2 RStV:<br />Bjarne Niklas Luttermann, address as above</Typography>
          <Divider sx={{ my: 3 }} />
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }} data-lang-legal="de">Haftungsausschluss</Typography>
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1, display: 'none' }} data-lang-legal="en">Disclaimer</Typography>
          <Typography variant="body2" sx={{ mb: 2 }} data-lang-legal="de">Trotz sorgfältiger inhaltlicher Kontrolle übernehme ich keine Haftung für die Inhalte externer Links. Für den Inhalt der verlinkten Seiten sind ausschließlich deren Betreiber verantwortlich.</Typography>
          <Typography variant="body2" sx={{ mb: 2, display: 'none' }} data-lang-legal="en">Despite careful content control, I assume no liability for the content of external links. The operators of the linked pages are solely responsible for their content.</Typography>
          <Divider sx={{ my: 3 }} />
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1 }} data-lang-legal="de">Urheberrecht</Typography>
          <Typography variant="h5" fontWeight={700} color="primary" sx={{ mt: 2, mb: 1, display: 'none' }} data-lang-legal="en">Copyright</Typography>
          <Typography variant="body2" sx={{ mb: 2 }} data-lang-legal="de">Die durch den Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Beiträge Dritter sind als solche gekennzeichnet.</Typography>
          <Typography variant="body2" sx={{ mb: 2, display: 'none' }} data-lang-legal="en">The content and works created by the site operator on these pages are subject to German copyright law. Contributions by third parties are marked as such.</Typography>
          <Typography variant="caption" sx={{ color: theme.palette.text.secondary, mt: 4 }} data-lang-legal="de">Dieses Impressum gilt auch für die Social-Media-Profile, sofern vorhanden.</Typography>
          <Typography variant="caption" sx={{ color: theme.palette.text.secondary, mt: 4, display: 'none' }} data-lang-legal="en">This legal notice also applies to social media profiles, if available.</Typography>
        </CardContent>
      </Card>
    </Box>
  );
};

export default Impressum; 