import React from 'react';
import { Box, Typography, Container, Button } from '@mui/material';
import { Link as RouterLink } from 'react-router-dom';

const HomePage: React.FC = () => {
  return (
    <Box sx={{ bgcolor: 'background.paper', pt: 8, pb: 6 }}>
      <Container maxWidth="sm">
        <Typography
          component="h1"
          variant="h2"
          align="center"
          color="text.primary"
          gutterBottom
        >
          JambaM
        </Typography>
        <Typography variant="h5" align="center" color="text.secondary" paragraph>
          Revolutionizing game development with AI-powered tools and a collaborative platform.
          Our vision is to empower creators of all sizes to build innovative and engaging games faster and more efficiently.
        </Typography>
        <Box sx={{ pt: 4, display: 'flex', justifyContent: 'center' }}>
          <Button variant="contained" component={RouterLink} to="/about" sx={{ mr: 2 }}>
            Learn More About Us
          </Button>
          <Button variant="outlined" component={RouterLink} to="/contact">
            Get in Touch
          </Button>
        </Box>
      </Container>
    </Box>
  );
};

export default HomePage;
