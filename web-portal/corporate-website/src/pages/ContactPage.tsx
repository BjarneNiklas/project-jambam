import React from 'react';
import { Box, Typography, Container, Paper, Link } from '@mui/material';
import EmailIcon from '@mui/icons-material/Email';

const ContactPage: React.FC = () => {
  // Replace with actual contact email
  const contactEmail = "contact@aurav.tech"; // Updated placeholder email

  return (
    <Container maxWidth="sm" sx={{ py: 4 }}>
      <Paper elevation={3} sx={{ p: 4, textAlign: 'center' }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Contact Us
        </Typography>
        <Typography variant="body1" paragraph>
          We'd love to hear from you! Whether you're interested in investing, partnering,
          or just want to learn more about Aurav Technologies, the AURAX platform, or the LUVY engine, feel free to reach out.
        </Typography>
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', mt: 3 }}>
          <EmailIcon sx={{ mr: 1 }} />
          <Typography variant="h6">
            <Link href={`mailto:${contactEmail}`} color="inherit">
              {contactEmail}
            </Link>
          </Typography>
        </Box>
        {/*
          Placeholder for a potential future contact form.
          For an MVP, a direct email link is often sufficient.
          <Box sx={{ mt: 4 }}>
            <Typography variant="h5" gutterBottom>Or send us a message:</Typography>
            // Add Contact Form component here if implemented
          </Box>
        */}
      </Paper>
    </Container>
  );
};

export default ContactPage;
