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
          Aurav Technologies
        </Typography>
        <Typography variant="h4" component="h2" align="center" color="text.secondary" paragraph sx={{mb: 3}}>
          AI-Driven Game Development &amp; Creator Platforms
        </Typography>
        <Typography variant="h6" align="center" color="text.secondary" paragraph>
          Pioneering the future of interactive entertainment with the AURAX platform and LUVY engine. We empower creators with AI-powered tools, multi-engine support, and a vibrant community ecosystem for collaborative game creation and metaverse experiences.
          {/* This text should be further expanded with details about the 5 core offerings */}
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
