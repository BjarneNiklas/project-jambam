"use client";
import React from "react";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import Grid from "@mui/material/Grid";
import Chip from "@mui/material/Chip";
import Stack from "@mui/material/Stack";
import Box from "@mui/material/Box";
import { useTheme } from "@mui/material/styles";
import LaunchIcon from "@mui/icons-material/Launch";
import GitHubIcon from "@mui/icons-material/GitHub";

const projects = [
  {
    name: "Aurax Media Platform",
    description: "Next-Gen Medienplattform mit Gamification und Community-Building.",
    tech: ["Flutter", "Unity", "Python", "React", "Node.js"],
    demo: "#",
    code: "#",
    featured: true,
  },
  {
    name: "Flutter Portfolio App",
    description: "Cross-platform Portfolio App mit modernem UI/UX Design und interaktiven Animationen.",
    tech: ["Flutter", "Dart"],
    demo: "#",
    code: "#",
  },
  {
    name: "Unity VR Experience",
    description: "Immersive VR-Erfahrung mit interaktiven 3D-Elementen und haptischem Feedback.",
    tech: ["Unity", "C#"],
    demo: "#",
    code: "#",
  },
  {
    name: "AI Content Generator",
    description: "KI-gestützte Plattform zur automatischen Generierung von Medieninhalten.",
    tech: ["Python", "TensorFlow"],
    demo: "#",
    code: "#",
  },
  {
    name: "Analytics Dashboard",
    description: "Echtzeit-Dashboard für Datenanalyse und Performance-Monitoring.",
    tech: ["React", "Node.js"],
    demo: "#",
    code: "#",
  },
  {
    name: "Community Platform",
    description: "Plattform für Community-Building, Wettbewerbe und Teamwork.",
    tech: ["React", "Node.js"],
    demo: "#",
    code: "#",
  },
];

const Projects: React.FC = () => {
  const theme = useTheme();
  return (
    <Box id="projects" sx={{ px: { xs: 1, md: 4 }, py: { xs: 4, md: 8 }, maxWidth: 1400, mx: 'auto' }}>
      <Typography variant="h3" component="div" sx={{ fontWeight: 800, fontSize: { xs: 24, sm: 32 }, color: theme.palette.primary.main, textAlign: 'center', mb: 6 }}>
        Projekte & Arbeiten
      </Typography>
      <Grid container spacing={4} justifyContent="center">
        {projects.map((project, idx) => (
          <Grid item xs={12} sm={6} md={4} key={project.name}>
            <Card
              elevation={project.featured ? 8 : 3}
              sx={{
                borderRadius: 5,
                p: 2,
                background: project.featured
                  ? `linear-gradient(135deg, ${theme.palette.primary.light} 0%, ${theme.palette.secondary.light} 100%)`
                  : theme.palette.background.paper,
                color: project.featured ? theme.palette.primary.contrastText : theme.palette.text.primary,
                boxShadow: project.featured ? "0 8px 32px 0 rgba(20,184,166,0.18)" : "0 4px 16px 0 rgba(20,184,166,0.10)",
                transition: 'transform 0.2s, box-shadow 0.2s',
                '&:hover': {
                  transform: 'translateY(-6px) scale(1.03)',
                  boxShadow: '0 12px 36px 0 rgba(20,184,166,0.18)',
                },
                minHeight: 320,
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between',
              }}
            >
              <CardContent>
                <Typography variant="h5" sx={{ fontWeight: 700, mb: 1, color: theme.palette.primary.main }}>
                  {project.name}
                </Typography>
                <Typography variant="body1" sx={{ mb: 2, color: theme.palette.text.secondary }}>
                  {project.description}
                </Typography>
                <Stack direction="row" spacing={1} flexWrap="wrap" sx={{ mb: 2 }}>
                  {project.tech.map((tech) => (
                    <Chip
                      key={tech}
                      label={tech}
                      color={project.featured ? "secondary" : "primary"}
                      variant={project.featured ? "filled" : "outlined"}
                      sx={{ fontWeight: 600, fontSize: 14, borderRadius: 2, m: 0.5, bgcolor: project.featured ? theme.palette.secondary.light : undefined, color: project.featured ? theme.palette.secondary.contrastText : undefined }}
                    />
                  ))}
                </Stack>
                <Stack direction="row" spacing={2}>
                  <Button
                    variant="contained"
                    color="primary"
                    size="small"
                    href={project.demo}
                    endIcon={<LaunchIcon />}
                    sx={{ borderRadius: 3, fontWeight: 700, textTransform: 'none', minWidth: 0 }}
                  >
                    Demo
                  </Button>
                  <Button
                    variant="outlined"
                    color="primary"
                    size="small"
                    href={project.code}
                    endIcon={<GitHubIcon />}
                    sx={{ borderRadius: 3, fontWeight: 700, textTransform: 'none', minWidth: 0 }}
                  >
                    Code
                  </Button>
                </Stack>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default Projects; 