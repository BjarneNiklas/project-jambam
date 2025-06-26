'use client';
import React, { useState } from 'react';
import { Box, Typography, Divider, Container, Card, CardContent, Button, List, ListItem, ListItemIcon, ListItemText, Link, IconButton, Stack, Grid, CardHeader, Chip } from '@mui/material';
import { FaEnvelope, FaMapMarkerAlt, FaGraduationCap, FaRocket, FaPaperPlane, FaGithub, FaLinkedin, FaYoutube } from 'react-icons/fa';
import CloseIcon from '@mui/icons-material/Close';
import MailIcon from '@mui/icons-material/Mail';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import SchoolIcon from '@mui/icons-material/School';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import ArrowForwardIcon from '@mui/icons-material/ArrowForward';

// contactInfo is not used directly in this component anymore, but might be used if the component were more dynamic.
// const contactInfo = [
//     { icon: <FaEnvelope />, text: 'aurav.tech@gmail.com', subtext: 'mailto:aurav.tech@gmail.com' },
//     { icon: <FaMapMarkerAlt />, text: 'Lübeck, Deutschland' },
//     { icon: <FaGraduationCap />, text: 'Technische Hochschule Lübeck' },
// ];

const socialLinks = [
    { href: 'https://www.linkedin.com/in/bjarne-luttermann/', label: 'LinkedIn', icon: <FaLinkedin /> },
    { href: 'https://www.youtube.com/@bjarnik_interactive', label: 'YouTube', icon: <FaYoutube /> },
    { href: 'https://github.com/BjarneNiklas', label: 'GitHub', icon: <FaGithub /> },
];

const Contact: React.FC = () => {
    // const [showDomainNotice, setShowDomainNotice] = useState(true); // Removed as banner is removed

    return (
        <Box component="section" id="contact" sx={{ py: 8, bgcolor: '#0a0a0a', position: 'relative' }}>
            <Container maxWidth="lg">
                <Box sx={{ textAlign: 'center', mb: 6 }}>
                    <Typography variant="h3" component="h2" gutterBottom sx={{ fontWeight: 700 }}>
                        Kontakt & Vernetzung
                    </Typography>
                    <Divider sx={{ width: 80, height: 4, mx: 'auto', bgcolor: 'primary.main', borderRadius: 2 }} />
                </Box>

                <Box sx={{ width: '100%', mt: 6 }}>
                    <Box sx={{ display: 'flex', justifyContent: 'center', gap: 4, maxWidth: 800, mx: 'auto', flexWrap: 'wrap' }}>
                        {/* Direkter Kontakt */}
                        <Box sx={{ flex: 1, minWidth: 300, maxWidth: 400 }}> {/* Removed display:flex and justifyContent:center */}
                            <Card sx={{ height: '100%', borderRadius: 4, boxShadow: 3, p: 2, transition: '0.2s', '&:hover': { boxShadow: 8 } }}>
                                <CardHeader
                                    avatar={<MailIcon color="secondary" sx={{ fontSize: 32 }} />}
                                    title={<Typography variant="h6" fontWeight={700}>Direkter Kontakt</Typography>}
                                />
                                <CardContent>
                                    <List>
                                        <ListItem disablePadding>
                                            <ListItemIcon><MailIcon color="secondary" /></ListItemIcon>
                                            <ListItemText
                                                primary={<Typography fontWeight={600}>E-Mail</Typography>}
                                                secondary={<a href="mailto:aurav.tech@gmail.com" style={{ color: '#a78bfa', textDecoration: 'none', fontWeight: 500 }}>aurav.tech@gmail.com</a>}
                                            />
                                        </ListItem>
                                        <ListItem disablePadding>
                                            <ListItemIcon><LocationOnIcon color="primary" /></ListItemIcon>
                                            <ListItemText
                                                primary={<Typography fontWeight={600}>Standort</Typography>}
                                                secondary={<Typography color="text.secondary">Lübeck, Deutschland</Typography>}
                                            />
                                        </ListItem>
                                        <ListItem disablePadding>
                                            <ListItemIcon><SchoolIcon color="success" /></ListItemIcon>
                                            <ListItemText
                                                primary={<Typography fontWeight={600}>Hochschule</Typography>}
                                                secondary={<Typography color="text.secondary">Technische Hochschule Lübeck</Typography>}
                                            />
                                        </ListItem>
                                    </List>
                                </CardContent>
                            </Card>
                        </Box>
                        {/* Verfügbarkeit */}
                        <Box sx={{ flex: 1, minWidth: 300, maxWidth: 400 }}> {/* Removed display:flex and justifyContent:center */}
                            <Card sx={{ height: '100%', borderRadius: 4, boxShadow: 3, p: 2, transition: '0.2s', '&:hover': { boxShadow: 8 } }}>
                                <CardHeader
                                    avatar={<AccessTimeIcon color="primary" sx={{ fontSize: 32 }} />}
                                    title={<Typography variant="h6" fontWeight={700}>Verfügbarkeit</Typography>}
                                />
                                <CardContent>
                                    <List>
                                        <ListItem disablePadding sx={{ mb: 2 }}>
                                            <ListItemText primary="Freelance Projekte" />
                                            <Chip label="Verfügbar" color="success" size="small" sx={{ fontWeight: 600, ml: 2 }} />
                                        </ListItem>
                                        <ListItem disablePadding sx={{ mb: 2 }}>
                                            <ListItemText primary="Vollzeit Positionen" />
                                            <Chip label="Ab 2026" color="warning" size="small" sx={{ fontWeight: 600, ml: 2 }} />
                                        </ListItem>
                                        <ListItem disablePadding sx={{ mb: 2 }}>
                                            <ListItemText primary="Beratung" />
                                            <Chip label="Verfügbar" color="success" size="small" sx={{ fontWeight: 600, ml: 2 }} />
                                        </ListItem>
                                    </List>
                                </CardContent>
                            </Card>
                        </Box>
                    </Box>
                    {/* Lass uns zusammenarbeiten */}
                    <Box sx={{ maxWidth: 800, mx: 'auto', mt: 4 }}>
                        <Card sx={{ borderRadius: 4, boxShadow: 3, p: 2, transition: '0.2s', '&:hover': { boxShadow: 8 } }}>
                            <CardHeader
                                avatar={<FaRocket style={{ color: '#38bdf8', fontSize: 32 }} />}
                                title={<Typography variant="h6" fontWeight={700}>Lass uns zusammenarbeiten</Typography>}
                            />
                            <CardContent>
                                <Typography color="text.secondary" sx={{ mb: 2 }}>
                                    Ich bin immer offen für spannende Projekte und neue Herausforderungen. Egal ob es um Flutter-Entwicklung, Unity-Projekte oder innovative Medienplattformen geht – lass uns gemeinsam etwas Großartiges schaffen!
                                </Typography>
                                <List>
                                    <ListItem disablePadding>
                                        <ListItemIcon><CheckCircleIcon color="success" /></ListItemIcon>
                                        <ListItemText primary="Schnelle Reaktionszeiten" />
                                    </ListItem>
                                    <ListItem disablePadding>
                                        <ListItemIcon><CheckCircleIcon color="success" /></ListItemIcon>
                                        <ListItemText primary="Moderne Technologien" />
                                    </ListItem>
                                    <ListItem disablePadding>
                                        <ListItemIcon><CheckCircleIcon color="success" /></ListItemIcon>
                                        <ListItemText primary="Qualitätsorientierte Entwicklung" />
                                    </ListItem>
                                </List>
                                <Box sx={{ mt: 3, textAlign: 'center' }}>
                                    <Button
                                        variant="contained"
                                        color="primary"
                                        size="large"
                                        endIcon={<ArrowForwardIcon />}
                                        sx={{ fontWeight: 700, borderRadius: 3, px: 4, boxShadow: 2, textTransform: 'none', transition: '0.2s', '&:hover': { boxShadow: 6, background: 'linear-gradient(90deg, #6366f1 0%, #a78bfa 100%)' } }}
                                        href="mailto:aurav.tech@gmail.com"
                                    >
                                        Projekt besprechen
                                    </Button>
                                </Box>
                            </CardContent>
                        </Card>
                    </Box>
                </Box>

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
            {/* Domain Notice Banner wurde entfernt für klareren Fokus auf Portfolio-Inhalte */}
        </Box>
    );
};

export default Contact; 