import React from 'react';
import { Box, Typography, Container, Paper } from '@mui/material';

const AboutPage: React.FC = () => {
  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          About JambaM
        </Typography>
        <Typography variant="body1" paragraph>
          JambaM is a forward-thinking project dedicated to transforming the landscape of game development.
          We believe in the power of collaboration, innovation, and cutting-edge technology to unlock new creative possibilities.
        </Typography>
        <Typography variant="h5" component="h2" gutterBottom sx={{ mt: 3 }}>
          Our Mission
        </Typography>
        <Typography variant="body1" paragraph>
          Our mission is to provide game developers, from solo indie creators to large studios, with a comprehensive suite of AI-driven tools
          and a vibrant community platform. We aim to streamline the development process, foster creativity, and help bring unique game visions to life.
        </Typography>
        <Typography variant="h5" component="h2" gutterBottom sx={{ mt: 3 }}>
          The Team
        </Typography>
        <Typography variant="body1" paragraph>
          JambaM is powered by a passionate team of developers, designers, and AI enthusiasts. We are committed to building a platform
          that is not only powerful but also intuitive and accessible.
          {/* Add more specific team information here later if desired */}
        </Typography>
        <Typography variant="body1" paragraph>
          We are currently seeking investment and partnerships to accelerate our development and expand our reach.
          If you are interested in learning more about our project or exploring collaboration opportunities, please don't hesitate to contact us.
        </Typography>
      </Paper>
    </Container>
  );
};

export default AboutPage;
