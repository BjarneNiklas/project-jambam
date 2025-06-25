'use client';
import React, { useState } from 'react';
import { Box, Typography, Divider, Container, Card, CardContent, Button, Grid, List, ListItem, ListItemIcon, ListItemText, Link, IconButton, Stack, Paper, TextField, Alert } from '@mui/material';
import { FaEnvelope, FaMapMarkerAlt, FaGraduationCap, FaRocket, FaPaperPlane, FaGithub, FaLinkedin, FaYoutube } from 'react-icons/fa';
import CloseIcon from '@mui/icons-material/Close';

const contactInfo = [
    { icon: <FaEnvelope />, title: 'Email', content: 'bjarne.luttermann.auravention@gmail.com' },
    { icon: <FaMapMarkerAlt />, title: 'Standort', content: 'Niedersachsen, Deutschland' },
    { icon: <FaGraduationCap />, title: 'Ausbildung', content: 'M.Sc. Medieninformatik (in progress)' },
    { icon: <FaRocket />, title: 'Interessen', content: 'Next-Gen UI/UX, KI, Flutter, Next.js' },
];

const socialLinks = [
    { href: 'https://www.linkedin.com/in/bjarne-luttermann/', label: 'LinkedIn', icon: <FaLinkedin /> },
    { href: 'https://www.youtube.com/@bjarnik_interactive', label: 'YouTube', icon: <FaYoutube /> },
    { href: 'https://github.com/BjarneNiklas', label: 'GitHub', icon: <FaGithub /> },
];

const Contact: React.FC = () => {
    const [showBanner, setShowBanner] = useState(true);

    const handleCloseBanner = () => {
        setShowBanner(false);
    };

    return (
        <Container maxWidth="lg" sx={{ mt: 8, mb: 4 }}>
            {showBanner && (
                <Alert
                    severity="info"
                    onClose={handleCloseBanner}
                    sx={{
                        position: 'fixed',
                        bottom: 16,
                        right: 16,
                        zIndex: 1300,
                        boxShadow: 3,
                        bgcolor: 'primary.main',
                        color: 'primary.contrastText',
                        '& .MuiAlert-icon': {
                            color: 'primary.contrastText',
                        },
                        '& .MuiAlert-action': {
                            '& .MuiIconButton-root': {
                                color: 'primary.contrastText',
                            },
                        },
                    }}
                >
                    Diese Domain ist ggf. erwerbbar. Kontaktieren Sie mich bei Interesse.
                </Alert>
            )}

            <Box sx={{ mt: 8, textAlign: 'center' }}>
                <Typography variant="h3" component="h2" gutterBottom>Kontakt</Typography>
                <Typography variant="h6" color="text.secondary" paragraph>Ich freue mich auf Ihre Nachricht.</Typography>
            </Box>

            <Grid container spacing={4} sx={{ mt: 4 }}>
                <Grid item xs={12} md={6}>
                    <Card elevation={2} sx={{ height: '100%' }}>
                        <CardContent>
                            <Typography variant="h5" gutterBottom>Nachricht senden</Typography>
                            <Box component="form" noValidate autoComplete="off">
                                <TextField fullWidth label="Name" margin="normal" />
                                <TextField fullWidth label="Email" margin="normal" />
                                <TextField fullWidth label="Betreff" margin="normal" />
                                <TextField fullWidth label="Ihre Nachricht" margin="normal" multiline rows={4} />
                                <Button variant="contained" color="primary" sx={{ mt: 2 }} endIcon={<FaPaperPlane />}>
                                    Senden
                                </Button>
                            </Box>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} md={6}>
                     <Stack spacing={2}>
                        {contactInfo.map((item, index) => (
                            <Paper key={index} elevation={1} sx={{ p: 2, display: 'flex', alignItems: 'center' }}>
                                <Box sx={{ mr: 2, color: 'primary.main' }}>
                                    {item.icon}
                                </Box>
                                <Box>
                                    <Typography variant="subtitle1" fontWeight="bold">{item.title}</Typography>
                                    <Typography variant="body2" color="text.secondary">{item.content}</Typography>
                                </Box>
                            </Paper>
                        ))}
                    </Stack>
                </Grid>
            </Grid>

            {/* Footer */}
            <Box sx={{ mt: 8, pt: 4, borderTop: 1, borderColor: 'divider' }}>
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                    <Stack direction="row" spacing={1} divider={<Divider orientation="vertical" flexItem />}>
                        <Link href="/impressum" underline="hover" color="text.secondary">Impressum</Link>
                        <Link href="/datenschutz" underline="hover" color="text.secondary">Datenschutz</Link>
                    </Stack>
                    
                    <Stack direction="row" spacing={1}>
                        {socialLinks.map((link) => (
                            <IconButton key={link.label} component="a" href={link.href} target="_blank" rel="noopener" aria-label={link.label} sx={{ color: 'text.secondary' }}>
                                {link.icon}
                            </IconButton>
                        ))}
                    </Stack>
                </Box>
                
                <Typography variant="body2" color="text.secondary" align="center">
                    © {new Date().getFullYear()} Bjarne Niklas Luttermann. All rights reserved.
                </Typography>
            </Box>
        </Container>
    );
};

export default Contact; 