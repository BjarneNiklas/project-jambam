import React from 'react';
import { Box, Typography, Container, Paper } from '@mui/material';

const AboutPage: React.FC = () => {
  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          About Aurav Technologies
        </Typography>
        <Typography variant="body1" paragraph>
          Aurav Technologies is a pioneering company dedicated to revolutionizing the media and gaming landscape.
          We are building the AURAX platform and the LUVY Engine to empower creators with AI-driven tools, foster a global community, and enable innovative game development and interactive experiences.
        </Typography>
        <Typography variant="h5" component="h2" gutterBottom sx={{ mt: 3 }}>
          Our Mission
        </Typography>
        <Typography variant="body1" paragraph>
          To democratize game development and foster a vibrant global creator community through innovative, accessible, and AI-driven technologies.
          We aim to provide comprehensive solutions for everything from initial concept and asset generation to multi-engine deployment and community engagement.
          {/* This text should be expanded with details on the 5 core offerings: AURAX Platform, LUVY Engine, AI-Driven Dev, Community Empowerment, Innovative Experiences */}
        </Typography>
        <Typography variant="h5" component="h2" gutterBottom sx={{ mt: 3 }}>
          Our Vision
        </Typography>
        <Typography variant="body1" paragraph>
          To be the leading open platform for collaborative game creation, AI-powered content generation, and community-driven entertainment experiences,
          shaping the future of the metaverse and interactive media.
        </Typography>
        <Typography variant="body1" paragraph sx={{mt: 2}}>
          We are actively seeking partnerships and collaborations to expand our ecosystem.
          If you're interested in our vision for the future of game development, please get in touch.
        </Typography>
      </Paper>
    </Container>
  );
};

export default AboutPage;
