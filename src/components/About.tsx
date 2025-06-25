"use client";
import React from "react";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import Avatar from "@mui/material/Avatar";
import Stack from "@mui/material/Stack";
import Grid from "@mui/material/Grid";
import Chip from "@mui/material/Chip";
import Button from "@mui/material/Button";
import LinkedInIcon from "@mui/icons-material/LinkedIn";
import Box from "@mui/material/Box";
import { useTheme } from "@mui/material/styles";
// @ts-ignore
import cv from '../data/cv.json';

const iconMap: Record<string, React.ReactNode> = {
  'Reisen': <span role="img" aria-label="Reisen">✈️</span>,
  'EDM/Pop Musik': <span role="img" aria-label="Musik">🎵</span>,
  'Sport': <span role="img" aria-label="Sport">🏋️‍♂️</span>,
  'Freunde & Familie': <span role="img" aria-label="Freunde & Familie">👨‍👩‍👧‍👦</span>,
  'Generative KI': <span role="img" aria-label="KI">🤖</span>,
  'Tech News': <span role="img" aria-label="Tech News">📰</span>,
};

const About: React.FC = () => {
  const theme = useTheme();
  const interestsWithIcons = (cv.interests as string[]).map(label => ({
    icon: iconMap[label] || <span role="img" aria-label="Interesse">⭐</span>,
    label
  }));
  return (
    <Box id="about" sx={{ display: 'flex', justifyContent: 'center', py: { xs: 4, md: 8 } }}>
      <Card
        elevation={4}
        sx={{
          maxWidth: 600,
          width: '100%',
          borderRadius: 6,
          mx: 2,
          p: { xs: 2, sm: 4 },
          background: theme.palette.background.paper,
          boxShadow: "0 8px 32px 0 rgba(20,184,166,0.10)",
        }}
      >
        <CardContent>
          <Stack direction="column" alignItems="center" spacing={3}>
            <Avatar
              src="/avatar-placeholder.png"
              alt="Bjarne Niklas Luttermann"
              sx={{ width: 88, height: 88, boxShadow: 2, border: `3px solid ${theme.palette.primary.light}` }}
            />
            <Typography variant="h3" component="div" sx={{ fontWeight: 800, fontSize: { xs: 24, sm: 32 }, color: theme.palette.primary.main, textAlign: 'center', mb: 1 }}>
              Über Mich
            </Typography>
            <Typography variant="body1" sx={{ color: theme.palette.text.primary, textAlign: 'center', mb: 2 }}>
              {cv.about}
            </Typography>
            <Button
              variant="contained"
              color="secondary"
              size="medium"
              href={cv.linkedin}
              target="_blank"
              rel="noopener"
              startIcon={<LinkedInIcon />}
              sx={{ borderRadius: 6, fontWeight: 700, textTransform: 'none', mb: 2 }}
            >
              LinkedIn-Profil ansehen
            </Button>
            <Grid container spacing={2} justifyContent="center" sx={{ mb: 2 }}>
              {(cv.facts as { label: string, value: string }[]).map(f => (
                <Grid item xs={12} sm={6} key={f.label}>
                  <Chip
                    label={`${f.value} ${f.label}`}
                    color="primary"
                    variant="outlined"
                    sx={{ fontWeight: 600, fontSize: 16, px: 2, py: 1, borderRadius: 2 }}
                  />
                </Grid>
              ))}
            </Grid>
            <Typography variant="h5" sx={{ color: theme.palette.primary.main, fontWeight: 700, mb: 1, textAlign: 'center' }}>
              Interessen & Hobbys
            </Typography>
            <Grid container spacing={1} justifyContent="center">
              {interestsWithIcons.map(i => (
                <Grid item xs={12} sm={6} key={i.label}>
                  <Chip
                    icon={i.icon}
                    label={i.label}
                    color="secondary"
                    variant="filled"
                    sx={{ fontWeight: 500, fontSize: 15, borderRadius: 2, bgcolor: theme.palette.secondary.light, color: theme.palette.secondary.contrastText }}
                  />
                </Grid>
              ))}
            </Grid>
          </Stack>
        </CardContent>
      </Card>
    </Box>
  );
};

export default About; 