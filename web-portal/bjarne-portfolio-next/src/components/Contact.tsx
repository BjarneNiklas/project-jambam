'use client';
import React, { useState } from 'react';
import { Box, Typography, Divider, Container, Card, CardContent, Button, List, ListItem, ListItemIcon, ListItemText, Link, IconButton, Stack } from '@mui/material';
import { FaEnvelope, FaMapMarkerAlt, FaGraduationCap, FaRocket, FaPaperPlane, FaGithub, FaLinkedin, FaYoutube } from 'react-icons/fa';
import CloseIcon from '@mui/icons-material/Close';
import Grid from '@mui/material/Grid';

const contactInfo = [
    { icon: <FaEnvelope />, text: 'aurav.tech@gmail.com', subtext: 'mailto:aurav.tech@gmail.com' },
    { icon: <FaMapMarkerAlt />, text: 'Lübeck, Deutschland' },
    { icon: <FaGraduationCap />, text: 'Technische Hochschule Lübeck' },
];

const socialLinks = [
    { href: 'https://www.linkedin.com/in/bjarne-luttermann/', label: 'LinkedIn', icon: <FaLinkedin /> },
    { href: 'https://www.youtube.com/@bjarnik_interactive', label: 'YouTube', icon: <FaYoutube /> },
    { href: 'https://github.com/BjarneNiklas', label: 'GitHub', icon: <FaGithub /> },
];

const Contact: React.FC = () => {
    const [showDomainNotice, setShowDomainNotice] = useState(true);

    return (
        <Box component="section" id="contact" sx={{ py: 8, bgcolor: 'background.paper', position: 'relative' }}>
            <Container maxWidth="lg">
                <Box sx={{ textAlign: 'center', mb: 6 }}>
                    <Typography variant="h3" component="h2" gutterBottom sx={{ fontWeight: 700 }}>
                        Kontakt & Vernetzung
                    </Typography>
                    <Divider sx={{ width: 80, height: 4, mx: 'auto', bgcolor: 'primary.main', borderRadius: 2 }} />
                </Box>

                <Grid container spacing={4}>
                    <Grid item xs={12} md={6}>
                        <Card elevation={2} sx={{ height: '100%' }}>
                            <CardContent>
                                <Typography variant="h5" component="h3" gutterBottom sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                                    <FaEnvelope /> Kontaktinformationen
                                </Typography>
                                <List>
                                    {contactInfo.map((item, index) => (
                                        <ListItem key={index}>
                                            <ListItemIcon sx={{ color: 'primary.main', fontSize: 24 }}>{item.icon}</ListItemIcon>
                                            {item.subtext ? (
                                                <ListItemText 
                                                    primary={<Link href={item.subtext} underline="hover">{item.text}</Link>} 
                                                />
                                            ) : (
                                                <ListItemText primary={item.text} />
                                            )}
                                        </ListItem>
                                    ))}
                                </List>
                            </CardContent>
                        </Card>
                    </Grid>

                    <Grid item xs={12} md={6}>
                        <Card elevation={2} sx={{ bgcolor: 'primary.main', color: 'primary.contrastText', height: '100%' }}>
                            <CardContent>
                                <Typography variant="h5" component="h3" gutterBottom sx={{ display: 'flex', alignItems: 'center', gap: 1.5 }}>
                                    <FaRocket /> Lass uns zusammenarbeiten
                                </Typography>
                                <Typography variant="body1" sx={{ mb: 2 }}>
                                    Ich bin immer offen für neue Projekte und Kooperationen.
                                </Typography>
                                <Button
                                    variant="contained"
                                    color="secondary"
                                    href="mailto:aurav.tech@gmail.com"
                                    startIcon={<FaPaperPlane />}
                                >
                                    Projekt besprechen
                                </Button>
                            </CardContent>
                        </Card>
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

            {showDomainNotice && (
                <Box sx={{
                    position: 'fixed',
                    bottom: { xs: 16, md: 24 },
                    right: { xs: 16, md: 24 },
                    display: 'inline-flex',
                    alignItems: 'center',
                    bgcolor: 'rgba(0,150,136,0.8)',
                    color: 'primary.contrastText',
                    py: 1,
                    px: 1.5,
                    borderRadius: 2,
                    zIndex: 2000,
                    boxShadow: '0 4px 20px rgba(0,0,0,0.4)',
                    backdropFilter: 'blur(8px)',
                }}>
                    <Link href="mailto:aurav.tech@gmail.com" color="inherit" underline="hover">
                        Diese Domain ist ggf. erwerbbar. Kontaktieren Sie mich bei Interesse.
                    </Link>
                    <IconButton size="small" onClick={() => setShowDomainNotice(false)} sx={{ ml: 1, color: 'inherit' }}>
                        <CloseIcon fontSize="small" />
                    </IconButton>
                </Box>
            )}
        </Box>
    );
};

export default Contact; 