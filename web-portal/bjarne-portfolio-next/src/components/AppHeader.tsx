'use client';
import React, { useState, useEffect } from 'react';
import { AppBar, Toolbar, Typography, Box, IconButton, Link, useTheme, LinearProgress, Button, Tooltip, Menu, MenuItem, ListItemIcon, ListItemText } from '@mui/material';
import OpenInNewIcon from '@mui/icons-material/OpenInNew';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';

const navLinks = [
  // { href: '#home', label: 'Home' }, // entfernt
  { href: '#about', label: 'About' },
  { href: '#skills', label: 'Skills' },
  { href: '#projects', label: 'Projects' },
  { href: '#contact', label: 'Contact' },
];

// German Flag SVG Component
const GermanFlag: React.FC<{ size?: number }> = ({ size = 28 }) => (
  <svg width={size} height={size * 0.6} viewBox="0 0 5 3" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect width="5" height="3" fill="#FFCE00"/>
    <rect width="5" height="2" fill="#DD0000"/>
    <rect width="5" height="1" fill="#000000"/>
  </svg>
);
// UK Flag (Union Jack) SVG Component
const UKFlag: React.FC<{ size?: number }> = ({ size = 28 }) => (
    <svg width={size} height={size * 0.6} viewBox="0 0 60 36" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="60" height="36" fill="#012169"/>
        <path d="M0,0 L60,36 M60,0 L0,36" stroke="#FFFFFF" strokeWidth="6"/>
        <path d="M0,0 L60,36 M60,0 L0,36" stroke="#C8102E" strokeWidth="4" strokeDasharray="30 30" transform="translate(5, -5)"/>
        <path d="M30,0 V36 M0,18 H60" stroke="#FFFFFF" strokeWidth="10"/>
        <path d="M30,0 V36 M0,18 H60" stroke="#C8102E" strokeWidth="6"/>
    </svg>
);

const AppHeader: React.FC = () => {
    const theme = useTheme();
    const [scrollProgress, setScrollProgress] = useState(0);
    const [language, setLanguage] = useState<'de' | 'en'>('de');
    const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);

    // Scroll progress calculation
    useEffect(() => {
        const handleScroll = () => {
            const scrollTop = window.scrollY;
            const docHeight = document.documentElement.scrollHeight - window.innerHeight;
            const scrollPercent = (scrollTop / docHeight) * 100;
            setScrollProgress(scrollPercent);
        };

        window.addEventListener('scroll', handleScroll);
        return () => window.removeEventListener('scroll', handleScroll);
    }, []);

    const handleLangMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
        setAnchorEl(event.currentTarget);
    };

    const handleLangMenuClose = () => {
        setAnchorEl(null);
    };

    const handleLangChange = (lang: 'de' | 'en') => {
        setLanguage(lang);
        setAnchorEl(null);
    };

    const flagIcon = language === 'de' ? <GermanFlag size={22} /> : <UKFlag size={22} />;

    return (
        <>
            <AppBar position="fixed" elevation={6} sx={{
                bgcolor: 'rgba(10,10,10,0.98)', // Noch dunkler
                boxShadow: '0 4px 24px 0 rgba(0,0,0,0.10)',
                borderBottom: '1.5px solid rgba(0,0,0,0.15)',
                backdropFilter: 'blur(8px)',
                zIndex: 1300, // Höherer Z-Index für bessere Sichtbarkeit
            }}>
                {/* Progress Bar */}
                <LinearProgress 
                    variant="determinate" 
                    value={scrollProgress} 
                    sx={{ 
                        position: 'absolute',
                        top: 0,
                        left: 0,
                        right: 0,
                        height: '3px',
                        bgcolor: 'rgba(0,150,136,0.10)',
                        '& .MuiLinearProgress-bar': {
                            bgcolor: theme.palette.primary.main,
                            transition: 'transform 0.1s ease',
                        }
                    }} 
                />
                <Toolbar sx={{ minHeight: { xs: 56, sm: 64 } }}>
                    <Box sx={{ flexGrow: 1, display: 'flex', alignItems: 'center' }}>
                        <Typography
                            variant="h6"
                            component="a"
                            href="#home"
                            sx={{
                                fontWeight: 700,
                                color: '#fff',
                                letterSpacing: 0.5,
                                textDecoration: 'none',
                                cursor: 'pointer',
                                '&:hover': { color: theme.palette.primary.main },
                            }}
                        >
                            Bjarne Niklas Luttermann
                        </Typography>
                    </Box>

                    {/* Desktop: Navigation Links */}
                    <Box sx={{ 
                        display: { xs: 'none', md: 'flex' }, 
                        gap: 3,
                        alignItems: 'center',
                    }}>
                        {navLinks.map((link) => (
                            <Link 
                                key={link.href} 
                                href={link.href} 
                                color="inherit" 
                                underline="none"
                                sx={{ 
                                    fontWeight: 600,
                                    fontSize: '1rem',
                                    letterSpacing: 0.5,
                                    color: '#fff',
                                    px: 2,
                                    py: 1,
                                    borderRadius: 2,
                                    position: 'relative',
                                    transition: 'all 0.2s',
                                    '&:hover': {
                                        color: theme.palette.primary.main,
                                        bgcolor: 'rgba(0,150,136,0.10)',
                                        transform: 'translateY(-1px)',
                                    },
                                    '&::after': {
                                        content: '""',
                                        position: 'absolute',
                                        bottom: 0,
                                        left: '50%',
                                        width: 0,
                                        height: '2px',
                                        bgcolor: theme.palette.primary.main,
                                        transition: 'all 0.3s ease',
                                        transform: 'translateX(-50%)',
                                    },
                                    '&:hover::after': {
                                        width: '80%',
                                    }
                                }}
                            >
                                {link.label}
                            </Link>
                        ))}
                        {/* Primärfarben-Button rechts */}
                        <Button
                            variant="contained"
                            color="primary"
                            href="https://aurav.tech"
                            target="_blank"
                            rel="noopener"
                            startIcon={<img src="/av_logo.webp" alt="AuraV Logo" style={{ width: 22, height: 22, borderRadius: 4, background: '#fff' }} />}
                            endIcon={<OpenInNewIcon />}
                            sx={{
                                ml: 3,
                                fontWeight: 700,
                                borderRadius: 2,
                                px: 2.5,
                                py: 1.2,
                                boxShadow: 'none',
                                textTransform: 'none',
                                fontSize: '1rem',
                                letterSpacing: 0.5,
                                '&:hover': {
                                    backgroundColor: theme.palette.primary.dark,
                                    boxShadow: 'none',
                                },
                            }}
                        >
                            AuraV
                        </Button>
                        <Button
                            variant="outlined"
                            color="primary"
                            href="#"
                            startIcon={<img src="/y_logo.webp" alt="Project Y Logo" style={{ width: 22, height: 22, borderRadius: 4, background: '#fff' }} />}
                            sx={{
                                ml: 2,
                                fontWeight: 700,
                                borderRadius: 2,
                                px: 2.2,
                                py: 1.1,
                                boxShadow: 'none',
                                textTransform: 'none',
                                fontSize: '1rem',
                                letterSpacing: 0.5,
                                borderWidth: 2,
                                '&:hover': {
                                    backgroundColor: 'rgba(0,150,136,0.08)',
                                    borderWidth: 2,
                                },
                            }}
                        >
                            Project Y
                        </Button>
                        {/* Sprachwechsel als Dropdown mit Flaggen */}
                        <Box sx={{ display: 'flex', alignItems: 'center', ml: 2 }}>
                            <Tooltip title={language === 'de' ? 'Deutsch' : 'English'} arrow>
                                <IconButton
                                    size="small"
                                    onClick={handleLangMenuOpen}
                                    sx={{
                                        ml: 1,
                                    }}
                                >
                                    {flagIcon}
                                    <ArrowDropDownIcon sx={{ color: '#fff', ml: 0.5 }} />
                                </IconButton>
                            </Tooltip>
                            <Menu
                                anchorEl={anchorEl}
                                open={Boolean(anchorEl)}
                                onClose={handleLangMenuClose}
                                anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
                                transformOrigin={{ vertical: 'top', horizontal: 'right' }}
                            >
                                <MenuItem selected={language === 'de'} onClick={() => handleLangChange('de')}>
                                    <ListItemIcon><GermanFlag size={22} /></ListItemIcon>
                                    <ListItemText>Deutsch</ListItemText>
                                </MenuItem>
                                <MenuItem selected={language === 'en'} onClick={() => handleLangChange('en')}>
                                    <ListItemIcon><UKFlag size={22} /></ListItemIcon>
                                    <ListItemText>English</ListItemText>
                                </MenuItem>
                            </Menu>
                        </Box>
                    </Box>
                </Toolbar>
            </AppBar>
            <Toolbar /> 
        </>
    );
};

export default AppHeader; 