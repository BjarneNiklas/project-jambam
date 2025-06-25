"use client";
import React, { useEffect, useRef, useState } from "react";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import Avatar from "@mui/material/Avatar";
import Box from "@mui/material/Box";
import Stack from "@mui/material/Stack";
import { useTheme } from "@mui/material/styles";
import ArrowForwardIcon from "@mui/icons-material/ArrowForward";

const claims = {
  de: [
    "Deine Vision? Realisiert!",
    "Spitzentechnologie. Echte Ergebnisse.",
    "Gemeinsam Zukunft gestalten."
  ],
  en: [
    "Your vision? Realized!",
    "Cutting-edge tech. Real results.",
    "Shaping the future together."
  ]
};

const Hero: React.FC = () => {
  const [lang, setLang] = useState<'de' | 'en'>('de');
  const [claimIndex, setClaimIndex] = useState(0);
  const theme = useTheme();

  useEffect(() => {
    const interval = setInterval(() => {
      setClaimIndex((prev) => (prev + 1) % claims[lang].length);
    }, 3500);
    return () => clearInterval(interval);
  }, [lang]);

  useEffect(() => {
    const btn = document.getElementById('lang-switch');
    if (btn) {
      btn.textContent = lang === 'de' ? 'EN' : 'DE';
      btn.onclick = () => setLang((l) => (l === 'de' ? 'en' : 'de'));
    }
  }, [lang]);

  return (
    <Box
      id="home"
      sx={{
        minHeight: { xs: 500, md: 600 },
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        bgcolor: theme.palette.background.default,
        py: { xs: 6, md: 10 },
      }}
    >
      <Card
        elevation={6}
        sx={{
          maxWidth: 600,
          width: "100%",
          borderRadius: 6,
          mx: 2,
          p: { xs: 2, sm: 4 },
          background: `linear-gradient(135deg, ${theme.palette.primary.light} 0%, ${theme.palette.secondary.light} 100%)`,
          color: theme.palette.primary.contrastText,
          boxShadow: "0 8px 32px 0 rgba(20,184,166,0.15)",
          position: "relative",
        }}
      >
        <CardContent>
          <Stack direction="column" alignItems="center" spacing={3}>
            <Avatar
              src="/avatar-placeholder.png"
              alt="Bjarne Niklas Luttermann"
              sx={{ width: 96, height: 96, boxShadow: 3, border: `4px solid ${theme.palette.background.paper}` }}
            />
            <Typography
              variant="h2"
              component="div"
              sx={{
                fontWeight: 900,
                fontSize: { xs: 32, sm: 40, md: 48 },
                textAlign: "center",
                letterSpacing: -1,
                lineHeight: 1.1,
                color: theme.palette.primary.main,
                textShadow: "0 2px 8px rgba(20,184,166,0.10)",
                mb: 1,
                transition: 'color 0.5s',
              }}
            >
              {claims[lang][claimIndex]}
            </Typography>
            <Typography
              variant="subtitle1"
              sx={{ color: theme.palette.text.secondary, textAlign: "center", mb: 2 }}
            >
              {lang === 'de'
                ? 'Media Informatics M.Sc. Student, Flutter & Unity Spezialist, Next-Gen Media Platforms.'
                : 'Media Informatics M.Sc. Student, Flutter & Unity Specialist, Next-Gen Media Platforms.'}
            </Typography>
            <Button
              variant="contained"
              color="primary"
              size="large"
              endIcon={<ArrowForwardIcon />}
              href="#projects"
              sx={{
                borderRadius: 8,
                fontWeight: 700,
                fontSize: 18,
                px: 4,
                py: 1.5,
                boxShadow: "0 4px 16px 0 rgba(20,184,166,0.15)",
                textTransform: "none",
              }}
            >
              {lang === 'de' ? 'Projekte entdecken' : 'Discover Projects'}
            </Button>
          </Stack>
        </CardContent>
      </Card>
    </Box>
  );
};

export default Hero; 