"use client";
import React from "react";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import Stack from "@mui/material/Stack";
import Grid from "@mui/material/Grid";
import Box from "@mui/material/Box";
import EmailIcon from "@mui/icons-material/Email";
import LocationOnIcon from "@mui/icons-material/LocationOn";
import SchoolIcon from "@mui/icons-material/School";
import GitHubIcon from "@mui/icons-material/GitHub";
import LinkedInIcon from "@mui/icons-material/LinkedIn";
import TwitterIcon from "@mui/icons-material/Twitter";
import YouTubeIcon from "@mui/icons-material/YouTube";
import InstagramIcon from "@mui/icons-material/Instagram";
import { useTheme } from "@mui/material/styles";

const socials = [
  { label: "GitHub", icon: <GitHubIcon />, href: "#" },
  { label: "LinkedIn", icon: <LinkedInIcon />, href: "#" },
  { label: "Twitter", icon: <TwitterIcon />, href: "#" },
  { label: "YouTube", icon: <YouTubeIcon />, href: "#" },
  { label: "Instagram", icon: <InstagramIcon />, href: "#" },
];

const Contact: React.FC = () => {
  const theme = useTheme();
  return (
    <Box id="contact" sx={{ display: 'flex', justifyContent: 'center', py: { xs: 4, md: 8 } }}>
      <Card
        elevation={4}
        sx={{
          maxWidth: 700,
          width: '100%',
          borderRadius: 6,
          mx: 2,
          p: { xs: 2, sm: 4 },
          background: theme.palette.background.paper,
          boxShadow: "0 8px 32px 0 rgba(20,184,166,0.10)",
        }}
      >
        <CardContent>
          <Stack direction="column" alignItems="center" spacing={4}>
            <Typography variant="h3" component="div" sx={{ fontWeight: 800, fontSize: { xs: 24, sm: 32 }, color: theme.palette.primary.main, textAlign: 'center', mb: 1 }}>
              Kontakt & Vernetzung
            </Typography>
            <Grid container spacing={2} justifyContent="center">
              <Grid item xs={12} sm={6} key="email">
                <Stack direction="row" alignItems="center" spacing={2}>
                  <EmailIcon color="primary" />
                  <Box>
                    <Typography variant="subtitle1" fontWeight={700}>E-Mail</Typography>
                    <Button href="mailto:aurav.tech@gmail.com" color="primary" sx={{ textTransform: 'none', fontWeight: 600 }}>
                      aurav.tech@gmail.com
                    </Button>
                  </Box>
                </Stack>
              </Grid>
              <Grid item xs={12} sm={6} key="location">
                <Stack direction="row" alignItems="center" spacing={2}>
                  <LocationOnIcon color="primary" />
                  <Box>
                    <Typography variant="subtitle1" fontWeight={700}>Standort</Typography>
                    <Typography variant="body2">Stuttgart, Deutschland</Typography>
                  </Box>
                </Stack>
              </Grid>
              <Grid item xs={12} sm={6} key="university">
                <Stack direction="row" alignItems="center" spacing={2}>
                  <SchoolIcon color="primary" />
                  <Box>
                    <Typography variant="subtitle1" fontWeight={700}>Universität</Typography>
                    <Typography variant="body2">Universität Stuttgart</Typography>
                  </Box>
                </Stack>
              </Grid>
              <Grid item xs={12} sm={6} key="availability">
                <Stack direction="row" alignItems="center" spacing={2}>
                  <Typography variant="subtitle1" fontWeight={700} color={theme.palette.primary.main}>Verfügbarkeit</Typography>
                  <Box>
                    <Typography variant="body2" color="success.main">Freelance: Verfügbar</Typography>
                    <Typography variant="body2" color="warning.main">Vollzeit: ab 2024</Typography>
                    <Typography variant="body2" color="success.main">Beratung: Verfügbar</Typography>
                  </Box>
                </Stack>
              </Grid>
            </Grid>
            <Typography variant="h5" sx={{ color: theme.palette.primary.main, fontWeight: 700, mt: 2, mb: 1, textAlign: 'center' }}>
              Social Media & Portfolio
            </Typography>
            <Stack direction="row" spacing={2} justifyContent="center" flexWrap="wrap">
              {socials.map((s) => (
                <Button
                  key={s.label}
                  href={s.href}
                  startIcon={s.icon}
                  variant="outlined"
                  color="primary"
                  size="large"
                  sx={{ borderRadius: 3, fontWeight: 700, textTransform: 'none', minWidth: 120, m: 0.5 }}
                >
                  {s.label}
                </Button>
              ))}
            </Stack>
            <Box sx={{ mt: 4, textAlign: 'center' }}>
              <Typography variant="body1" sx={{ color: theme.palette.text.secondary, mb: 1 }}>
                Ich bin immer offen für spannende Projekte und neue Herausforderungen. Egal ob Flutter, Unity oder innovative Medienplattformen – lass uns gemeinsam etwas Großartiges schaffen!
              </Typography>
              <Button
                variant="contained"
                color="primary"
                size="large"
                href="mailto:aurav.tech@gmail.com"
                sx={{ borderRadius: 3, fontWeight: 700, textTransform: 'none', mt: 2 }}
                startIcon={<EmailIcon />}
              >
                Projekt besprechen
              </Button>
            </Box>
          </Stack>
        </CardContent>
      </Card>
    </Box>
  );
};

export default Contact; 