"use client";
import React from "react";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import Stack from "@mui/material/Stack";
import Grid from "@mui/material/Grid";
import Chip from "@mui/material/Chip";
import Box from "@mui/material/Box";
import { useTheme } from "@mui/material/styles";
// @ts-ignore
import cv from '../data/cv.json';

const Skills: React.FC = () => {
  const theme = useTheme();
  const skills = cv.skills || [];
  const frameworks = cv.frameworks || [];
  const tools = cv.tools || [];
  const databases = cv.databases || [];
  return (
    <Box id="skills" sx={{ display: 'flex', justifyContent: 'center', py: { xs: 4, md: 8 } }}>
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
              Fähigkeiten & Technologien
            </Typography>
            <Grid container spacing={2} justifyContent="center">
              <Grid item xs={12}>
                <Typography variant="h5" sx={{ color: theme.palette.primary.main, fontWeight: 700, mb: 1, textAlign: 'center' }}>
                  Hauptskills
                </Typography>
                <Stack direction="row" spacing={1} flexWrap="wrap" justifyContent="center">
                  {skills.map((skill: string) => (
                    <Chip
                      key={skill}
                      label={skill}
                      color="primary"
                      variant="filled"
                      sx={{ fontWeight: 600, fontSize: 16, borderRadius: 2, m: 0.5 }}
                    />
                  ))}
                </Stack>
              </Grid>
              <Grid item xs={12}>
                <Typography variant="h5" sx={{ color: theme.palette.primary.main, fontWeight: 700, mb: 1, textAlign: 'center' }}>
                  Frameworks
                </Typography>
                <Stack direction="row" spacing={1} flexWrap="wrap" justifyContent="center">
                  {frameworks.map((framework: string) => (
                    <Chip
                      key={framework}
                      label={framework}
                      color="secondary"
                      variant="filled"
                      sx={{ fontWeight: 600, fontSize: 16, borderRadius: 2, m: 0.5, bgcolor: theme.palette.secondary.light, color: theme.palette.secondary.contrastText }}
                    />
                  ))}
                </Stack>
              </Grid>
              <Grid item xs={12}>
                <Typography variant="h5" sx={{ color: theme.palette.primary.main, fontWeight: 700, mb: 1, textAlign: 'center' }}>
                  Tools
                </Typography>
                <Stack direction="row" spacing={1} flexWrap="wrap" justifyContent="center">
                  {tools.map((tool: string) => (
                    <Chip
                      key={tool}
                      label={tool}
                      color="primary"
                      variant="outlined"
                      sx={{ fontWeight: 600, fontSize: 16, borderRadius: 2, m: 0.5 }}
                    />
                  ))}
                </Stack>
              </Grid>
              <Grid item xs={12}>
                <Typography variant="h5" sx={{ color: theme.palette.primary.main, fontWeight: 700, mb: 1, textAlign: 'center' }}>
                  Datenbanken
                </Typography>
                <Stack direction="row" spacing={1} flexWrap="wrap" justifyContent="center">
                  {databases.map((database: string) => (
                    <Chip
                      key={database}
                      label={database}
                      color="secondary"
                      variant="outlined"
                      sx={{ fontWeight: 600, fontSize: 16, borderRadius: 2, m: 0.5, bgcolor: theme.palette.secondary.light, color: theme.palette.secondary.contrastText }}
                    />
                  ))}
                </Stack>
              </Grid>
            </Grid>
          </Stack>
        </CardContent>
      </Card>
    </Box>
  );
};

export default Skills; 