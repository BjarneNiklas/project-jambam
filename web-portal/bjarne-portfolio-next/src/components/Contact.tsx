'use client';
import React from 'react';
import { Box, Typography, Divider, Container, Card, CardContent, Button, List, ListItem, ListItemIcon, ListItemText, Chip } from '@mui/material';
import MailIcon from '@mui/icons-material/Mail';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import SchoolIcon from '@mui/icons-material/School';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import ArrowForwardIcon from '@mui/icons-material/ArrowForward';
import { useLanguage } from '../app/LanguageContext';
import CardHeader from '@mui/material/CardHeader';
import { FaRocket } from 'react-icons/fa';

// contactInfo is not used directly in this component anymore, but might be used if the component were more dynamic.
// const contactInfo = [
//     { icon: <FaEnvelope />, text: 'aurav.tech@gmail.com', subtext: 'mailto:aurav.tech@gmail.com' },
//     { icon: <FaMapMarkerAlt />, text: 'Lübeck, Deutschland' },
//     { icon: <FaGraduationCap />, text: 'Technische Hochschule Lübeck' },
// ];

const Contact: React.FC = () => {
    const { t } = useLanguage();
    // const [showDomainNotice, setShowDomainNotice] = useState(true); // Removed as banner is removed

    return (
        <Box component="section" id="contact" sx={{ py: 8, bgcolor: '#0a0a0a', position: 'relative' }}>
            <Container maxWidth="lg">
                <Box sx={{ textAlign: 'center', mb: 6 }}>
                    <Typography variant="h3" component="h2" gutterBottom sx={{ fontWeight: 700 }}>
                        {t('contact.title')} & {t('contact.networking')}
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
                                    title={<Typography variant="h6" fontWeight={700}>{t('contact.directContact')}</Typography>}
                                />
                                <CardContent>
                                    <List>
                                        <ListItem disablePadding>
                                            <ListItemIcon><MailIcon color="secondary" /></ListItemIcon>
                                            <ListItemText
                                                primary={<Typography fontWeight={600}>{t('contact.email')}</Typography>}
                                                secondary={<a href="mailto:aurav.tech@gmail.com" style={{ color: '#a78bfa', textDecoration: 'none', fontWeight: 500 }}>aurav.tech@gmail.com</a>}
                                            />
                                        </ListItem>
                                        <ListItem disablePadding>
                                            <ListItemIcon><LocationOnIcon color="primary" /></ListItemIcon>
                                            <ListItemText
                                                primary={<Typography fontWeight={600}>{t('contact.location')}</Typography>}
                                                secondary={<Typography color="text.secondary">Lübeck, Deutschland</Typography>}
                                            />
                                        </ListItem>
                                        <ListItem disablePadding>
                                            <ListItemIcon><SchoolIcon color="success" /></ListItemIcon>
                                            <ListItemText
                                                primary={<Typography fontWeight={600}>{t('contact.university')}</Typography>}
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
                                    title={<Typography variant="h6" fontWeight={700}>{t('contact.availability')}</Typography>}
                                />
                                <CardContent>
                                    <List>
                                        <ListItem disablePadding sx={{ mb: 2 }}>
                                            <ListItemText primary={t('contact.freelance')} />
                                            <Chip label={t('contact.available')} color="success" size="small" sx={{ fontWeight: 600, ml: 2 }} />
                                        </ListItem>
                                        <ListItem disablePadding sx={{ mb: 2 }}>
                                            <ListItemText primary={t('contact.fulltime')} />
                                            <Chip label={t('contact.from2026')} color="warning" size="small" sx={{ fontWeight: 600, ml: 2 }} />
                                        </ListItem>
                                        <ListItem disablePadding sx={{ mb: 2 }}>
                                            <ListItemText primary={t('contact.consulting')} />
                                            <Chip label={t('contact.available')} color="success" size="small" sx={{ fontWeight: 600, ml: 2 }} />
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
                                title={<Typography variant="h6" fontWeight={700}>{t('contact.letsWorkTogether')}</Typography>}
                            />
                            <CardContent>
                                <Typography color="text.secondary" sx={{ mb: 2 }}>
                                    {t('contact.workTogetherDesc')}
                                </Typography>
                                <List>
                                    <ListItem disablePadding>
                                        <ListItemIcon><CheckCircleIcon color="success" /></ListItemIcon>
                                        <ListItemText primary={t('contact.quickResponse')} />
                                    </ListItem>
                                    <ListItem disablePadding>
                                        <ListItemIcon><CheckCircleIcon color="success" /></ListItemIcon>
                                        <ListItemText primary={t('contact.modernTech')} />
                                    </ListItem>
                                    <ListItem disablePadding>
                                        <ListItemIcon><CheckCircleIcon color="success" /></ListItemIcon>
                                        <ListItemText primary={t('contact.qualityDev')} />
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
                                        {t('contact.discussProject')}
                                    </Button>
                                </Box>
                            </CardContent>
                        </Card>
                    </Box>
                </Box>

                {/* Footer entfernt */}
            </Container>
            {/* Domain Notice Banner wurde entfernt für klareren Fokus auf Portfolio-Inhalte */}
        </Box>
    );
};

export default Contact; 