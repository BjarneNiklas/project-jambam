import React from 'react';
import { Box, Container, Typography, Link } from '@mui/material';

const Footer: React.FC = () => {
  return (
    <Box
      component="footer"
      sx={{
        py: 3,
        px: 2,
        mt: 'auto',
        backgroundColor: (theme) =>
          theme.palette.mode === 'light'
            ? theme.palette.grey[200]
            : theme.palette.grey[800],
      }}
    >
      <Container maxWidth="lg" sx={{ textAlign: 'center' }}>
        <Typography variant="body1" color="text.primary">
          Aurav Technologies - Innovating Game Development.
        </Typography>
        <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
          {'© '}
          <Link color="inherit" href="https://aurav.tech/">
            Aurav Technologies
          </Link>{' '}
          {new Date().getFullYear()}
          {'.'}
        </Typography>
        <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
          <Link color="inherit" href="/faq" sx={{mr: 2}}>
            FAQ
          </Link>
          <Link color="inherit" href="https://luv-y.com/" target="_blank" rel="noopener noreferrer">
            Creator Portfolio
          </Link>
        </Typography>
      </Container>
    </Box>
  );
};

export default Footer;
