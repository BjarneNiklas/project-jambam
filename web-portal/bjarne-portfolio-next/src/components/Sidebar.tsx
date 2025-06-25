"use client";

import React, { useState } from 'react';
import { Box, Typography, IconButton, List, ListItemIcon, ListItemText, Divider, Tooltip, ListItemButton, Button, Menu, MenuItem } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import CloseIcon from '@mui/icons-material/Close';
import ChevronLeftIcon from '@mui/icons-material/ChevronLeft';
import InfoIcon from '@mui/icons-material/Info';
import BuildIcon from '@mui/icons-material/Build';
import WorkIcon from '@mui/icons-material/Work';
import MailIcon from '@mui/icons-material/Mail';
import GitHubIcon from '@mui/icons-material/GitHub';
import LinkedInIcon from '@mui/icons-material/LinkedIn';
import YouTubeIcon from '@mui/icons-material/YouTube';
import OpenInNewIcon from '@mui/icons-material/OpenInNew';
import ArrowDropDownIcon from '@mui/icons-material/ArrowDropDown';

// --- Konstanten (Flags, Links etc.) ---
const GermanFlag: React.FC<{ size?: number }> = ({ size = 20 }) => (
    <svg width={size} height={size * 0.6} viewBox="0 0 5 3" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="5" height="3" fill="#FFCE00"/><rect width="5" height="2" fill="#DD0000"/><rect width="5" height="1" fill="#000000"/>
    </svg>
);
const UKFlag: React.FC<{ size?: number }> = ({ size = 20 }) => (
    <svg width={size} height={size * 0.6} viewBox="0 0 60 36" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="60" height="36" fill="#012169"/><path d="M0,0 L60,36 M60,0 L0,36" stroke="#FFFFFF" strokeWidth="6"/><path d="M0,0 L60,36 M60,0 L0,36" stroke="#C8102E" strokeWidth="4"/><path d="M30,0 V36 M0,18 H60" stroke="#FFFFFF" strokeWidth="10"/><path d="M30,0 V36 M0,18 H60" stroke="#C8102E" strokeWidth="6"/>
    </svg>
);
const navLinks = [
    { href: '#about', label: 'About', icon: <InfoIcon /> },
    { href: '#skills', label: 'Skills', icon: <BuildIcon /> },
    { href: '#projects', label: 'Projects', icon: <WorkIcon /> },
    { href: '#contact', label: 'Contact', icon: <MailIcon /> },
];
const projects = [
    { href: 'https://aurav.tech', label: 'AuraVention', icon: <img src="/av_logo.webp" alt="AuraVention" style={{ width: 24, height: 24, borderRadius: 4 }} />, external: true },
    { href: '#', label: 'Project Y', icon: <img src="/y_logo.webp" alt="Project Y" style={{ width: 24, height: 24, borderRadius: 4 }} />, external: true },
];
const socials = [
    { href: 'https://www.linkedin.com/in/bjarne-luttermann/', label: 'LinkedIn', icon: <LinkedInIcon /> },
    { href: 'https://www.youtube.com/@bjarnik_interactive', label: 'YouTube', icon: <YouTubeIcon /> },
    { href: 'https://github.com/BjarneNiklas', label: 'GitHub', icon: <GitHubIcon /> },
];

// --- Hauptkomponente ---
const Sidebar: React.FC = () => {
    // State für Mobile (Drawer) und Desktop (collapsible)
    const [mobileOpen, setMobileOpen] = useState(false);
    const [desktopOpen, setDesktopOpen] = useState(true);

    const [language, setLanguage] = useState<'de' | 'en'>('de');
    const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
    const handleLangMenuOpen = (event: React.MouseEvent<HTMLElement>) => setAnchorEl(event.currentTarget);
    const handleLangMenuClose = () => setAnchorEl(null);
    const handleLangChange = (lang: 'de' | 'en') => { setLanguage(lang); setAnchorEl(null); };
    const flagIcon = language === 'de' ? <GermanFlag /> : <UKFlag />;

    // --- Wiederverwendbarer Sidebar-Inhalt ---
    const SidebarContent = ({ isOpen }: { isOpen: boolean }) => (
        <Box
            sx={{
                display: 'flex',
                flexDirection: 'column',
                height: '100%',
                overflowY: 'auto',
                '&::-webkit-scrollbar': { display: 'none' },
                msOverflowStyle: 'none',
                scrollbarWidth: 'none',
            }}
        >
            {/* Header */}
            <Box sx={{ p: 2, display: 'flex', alignItems: 'center', justifyContent: isOpen ? 'space-between' : 'center' }}>
                <Typography variant="h6" fontWeight={700} sx={{ whiteSpace: 'nowrap', opacity: isOpen ? 1 : 0, transition: 'opacity 0.2s' }}>
                    Bjarne Luttermann
                </Typography>
                <IconButton onClick={() => setDesktopOpen(!desktopOpen)} sx={{ display: { xs: 'none', md: 'inline-flex' } }}>
                    {desktopOpen ? <ChevronLeftIcon /> : <MenuIcon />}
                </IconButton>
            </Box>
            <Divider />

            {/* Hauptnavigation */}
            <List sx={{ px: 1.5, py: 1 }}>
                {navLinks.map((link) => (
                    <Tooltip key={link.label} title={!isOpen ? link.label : ''} placement="right" arrow>
                        <ListItemButton component="a" href={link.href} sx={{ borderRadius: 2, mb: 0.5, justifyContent: isOpen ? 'flex-start' : 'center' }}>
                            <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}>{link.icon}</ListItemIcon>
                            {isOpen && <ListItemText primary={link.label} sx={{ ml: 2, whiteSpace: 'nowrap' }} />}
                        </ListItemButton>
                    </Tooltip>
                ))}
            </List>
            <Divider sx={{ mx: 2 }} />

            {/* Projekte & Socials etc. */}
            <Box sx={{ flexGrow: 1, py: 1 }}>
                <Typography variant="caption" color="text.secondary" sx={{ display: isOpen ? 'block' : 'none', px: 3, mb: 1, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                    Projects
                </Typography>
                 <List sx={{ px: 1.5 }}>
                    {projects.map(proj => (
                        <Tooltip key={proj.label} title={!isOpen ? proj.label : ''} placement="right" arrow>
                            <ListItemButton component="a" href={proj.href} target="_blank" rel="noopener" sx={{ borderRadius: 2, mb: 0.5, justifyContent: isOpen ? 'flex-start' : 'center' }}>
                                <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}>{proj.icon}</ListItemIcon>
                                {isOpen && <ListItemText primary={proj.label} sx={{ ml: 2, whiteSpace: 'nowrap' }} />}
                                {isOpen && <OpenInNewIcon fontSize="small" sx={{ color: 'text.secondary', ml: 'auto' }} />}
                            </ListItemButton>
                        </Tooltip>
                    ))}
                </List>
                <Divider sx={{ mx: 2, my: 1 }} />
                <Typography variant="caption" color="text.secondary" sx={{ display: isOpen ? 'block' : 'none', px: 3, mb: 1, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                    Socials
                </Typography>
                <List sx={{ px: 1.5 }}>
                    {socials.map(soc => (
                        <Tooltip key={soc.label} title={!isOpen ? soc.label : ''} placement="right" arrow>
                            <ListItemButton component="a" href={soc.href} target="_blank" rel="noopener" sx={{ borderRadius: 2, mb: 0.5, justifyContent: isOpen ? 'flex-start' : 'center' }}>
                                <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}>{soc.icon}</ListItemIcon>
                                {isOpen && <ListItemText primary={soc.label} sx={{ ml: 2, whiteSpace: 'nowrap' }} />}
                            </ListItemButton>
                        </Tooltip>
                    ))}
                </List>
            </Box>

            {/* Footer mit Sprachumschalter */}
            <Divider />
            <Box sx={{ p: 2, display: 'flex', justifyContent: 'center' }}>
                 {isOpen ? (
                    <Button fullWidth variant="outlined" startIcon={flagIcon} onClick={handleLangMenuOpen} endIcon={<ArrowDropDownIcon />}>
                        {language === 'de' ? 'Deutsch' : 'English'}
                    </Button>
                ) : (
                    <Tooltip title={language === 'de' ? 'Sprache' : 'Language'} placement="right" arrow>
                        <IconButton onClick={handleLangMenuOpen}>{flagIcon}</IconButton>
                    </Tooltip>
                )}
                <Menu
                    anchorEl={anchorEl}
                    open={Boolean(anchorEl)}
                    onClose={handleLangMenuClose}
                    anchorOrigin={{
                        vertical: 'top',
                        horizontal: 'center',
                    }}
                    transformOrigin={{
                        vertical: 'bottom',
                        horizontal: 'center',
                    }}
                >
                    <MenuItem onClick={() => handleLangChange('de')}><ListItemIcon><GermanFlag /></ListItemIcon>Deutsch</MenuItem>
                    <MenuItem onClick={() => handleLangChange('en')}><ListItemIcon><UKFlag /></ListItemIcon>English</MenuItem>
                </Menu>
            </Box>
        </Box>
    );

    return (
        <>
            {/* --- Mobile: Floating Button + Drawer --- */}
            <IconButton
                onClick={() => setMobileOpen(!mobileOpen)}
                sx={{ position: 'fixed', top: 16, left: 16, zIndex: 1301, display: { xs: 'inline-flex', md: 'none' }, bgcolor: 'background.paper', boxShadow: 3 }}
            >
                {mobileOpen ? <CloseIcon /> : <MenuIcon />}
            </IconButton>
            <Box
                onClick={() => setMobileOpen(false)}
                sx={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, bgcolor: 'rgba(0,0,0,0.4)', zIndex: 1200, display: { xs: mobileOpen ? 'block' : 'none', md: 'none' }, backdropFilter: 'blur(2px)' }}
            />
            <Box
                component="aside"
                sx={{
                    position: 'fixed', top: 0, left: 0, height: '100vh', width: 280,
                    bgcolor: 'background.paper', boxShadow: 3, zIndex: 1201,
                    display: { xs: 'block', md: 'none' },
                    transform: mobileOpen ? 'translateX(0)' : 'translateX(-100%)',
                    transition: 'transform 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                }}
            >
                <SidebarContent isOpen={true} />
            </Box>

            {/* --- Desktop: Sticky, Collapsible Sidebar --- */}
            <Box
                component="aside"
                sx={{
                    position: 'sticky', top: 0, left: 0, height: '100vh',
                    width: desktopOpen ? 220 : 80,
                    bgcolor: 'background.paper',
                    borderRight: '1.5px solid #222',
                    zIndex: 1,
                    display: { xs: 'none', md: 'block' },
                    transition: 'width 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
                }}
            >
                <SidebarContent isOpen={desktopOpen} />
            </Box>
        </>
    );
};

export default Sidebar; 