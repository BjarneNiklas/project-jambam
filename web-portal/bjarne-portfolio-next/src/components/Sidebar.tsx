"use client";

import React, { useState } from 'react';
import { Box, Typography, IconButton, List, ListItemIcon, ListItemText, Divider, Tooltip, ListItemButton, Button, Menu, MenuItem } from '@mui/material';
import Image from 'next/image';
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
import SportsEsportsIcon from '@mui/icons-material/SportsEsports';
import BubbleChartIcon from '@mui/icons-material/BubbleChart';
import Grid4x4Icon from '@mui/icons-material/Grid4x4';
import ScienceIcon from '@mui/icons-material/Science';
import HubIcon from '@mui/icons-material/Hub';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import PersonIcon from '@mui/icons-material/Person';
import SchoolIcon from '@mui/icons-material/School';
import { BiCube } from 'react-icons/bi';
import { useLanguage } from '../app/LanguageContext';
import { createLocalizedUrl, createLocalizedHashUrl } from '../utils/urlHelpers';

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

// --- Hauptkomponente ---
interface SidebarProps {
    mobileOpen?: boolean;
    setMobileOpen?: (open: boolean) => void;
}
const Sidebar: React.FC<SidebarProps> = ({ mobileOpen = false, setMobileOpen }) => {
    // State für Mobile (Drawer) und Desktop (collapsible)
    const [desktopOpen, setDesktopOpen] = useState(true);
    const [gamesOpen, setGamesOpen] = useState(false);
    const [aboutOpen, setAboutOpen] = useState(false);

    const { lang, setLang, t } = useLanguage();
    const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
    const handleLangMenuOpen = (event: React.MouseEvent<HTMLElement>) => setAnchorEl(event.currentTarget);
    const handleLangMenuClose = () => setAnchorEl(null);
    const handleLangChange = (language: 'de' | 'en') => {
        setLang(language);
        setAnchorEl(null);
        // Only access DOM APIs on the client side
        if (typeof window !== 'undefined' && typeof document !== 'undefined') {
            document.documentElement.lang = language;
            window.dispatchEvent(new Event('languagechange'));
        }
    };
    const flagIcon = lang === 'de' ? <GermanFlag /> : <UKFlag />;

    // Dynamische Links basierend auf Sprache
    const navLinks = [
        {
            label: { de: 'About Me', en: 'About Me' },
            icon: <InfoIcon />,
            subLinks: [
                { href: createLocalizedHashUrl('about', lang), label: { de: 'Profil', en: 'Profile' }, icon: <PersonIcon /> },
                { href: createLocalizedHashUrl('experience-education', lang), label: { de: 'Erfahrung & Ausbildung', en: 'Experience & Education' }, icon: <SchoolIcon /> },
                { href: createLocalizedHashUrl('skills', lang), label: { de: 'Skills & Tech', en: 'Skills & Tech' }, icon: <BuildIcon /> },
            ],
        },
        { href: createLocalizedHashUrl('projects', lang), label: { de: 'Projekte', en: 'Projects' }, icon: <WorkIcon /> },
        { href: createLocalizedHashUrl('contact', lang), label: { de: 'Kontakt', en: 'Contact' }, icon: <MailIcon /> },
    ];
    
    const projects = [
        { href: '#projects', label: 'AuraVention', icon: <Image src="/av_logo.webp" alt="AuraVention" width={24} height={24} style={{ borderRadius: 4 }} />, external: false },
        { href: '#projects', label: 'Broxel Engine', icon: <BiCube size={24} style={{ color: '#14b8a6' }} />, external: false },
        { href: '#projects', label: 'Project Y', icon: <Image src="/y_logo.webp" alt="Project Y" width={24} height={24} style={{ borderRadius: 4 }} />, external: false },
    ];
    
    const socials = [
        { href: 'https://www.linkedin.com/in/bjarne-luttermann/', label: 'LinkedIn', icon: <LinkedInIcon /> },
        { href: 'https://www.youtube.com/@bjarnik_interactive', label: 'YouTube', icon: <YouTubeIcon /> },
        { href: 'https://github.com/BjarneNiklas', label: 'GitHub', icon: <GitHubIcon /> },
    ];

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
            <Box sx={{ 
                p: 2.5, 
                pr: isOpen ? 3.5 : 2.5,
                display: 'flex', 
                alignItems: 'center', 
                justifyContent: isOpen ? 'space-between' : 'center',
                minHeight: 72,
                position: 'relative',
                borderBottom: '1px solid rgba(255,255,255,0.1)',
            }}>
                {isOpen ? (
                    <Typography 
                        variant="body1" 
                        fontWeight={600} 
                        component="a"
                        href={`/${lang}`}
                        sx={{ 
                            whiteSpace: 'nowrap',
                            transition: 'all 0.2s ease-in-out',
                            fontSize: '1.05rem',
                            lineHeight: 1.3,
                            color: 'rgba(255,255,255,0.95)',
                            letterSpacing: '0.02em',
                            cursor: 'pointer',
                            textDecoration: 'none',
                            '&:hover': {
                                color: 'primary.main',
                            },
                        }}
                    >
                        Bjarne Niklas<br />
                        Luttermann
                    </Typography>
                ) : null}
                {/* Mobile Close Icon - positioned to the right */}
                <IconButton
                    onClick={() => setMobileOpen?.(false)}
                    sx={{
                        display: { xs: 'inline-flex', md: 'none' },
                        position: 'absolute',
                        right: 8,
                        top: '50%',
                        transform: 'translateY(-50%)',
                        color: 'white',
                        zIndex: 2,
                    }}
                >
                    <CloseIcon />
                </IconButton>
                <Tooltip title={isOpen ? 'Sidebar einklappen' : 'Sidebar ausklappen'} placement="right" arrow>
                    <IconButton 
                        onClick={() => setDesktopOpen(!desktopOpen)} 
                        sx={{ 
                            display: { xs: 'none', md: 'inline-flex' },
                            color: 'white',
                            '&:hover': {
                                backgroundColor: 'rgba(255,255,255,0.15)',
                                color: 'white',
                                transform: 'scale(1.05)',
                            },
                            transition: 'all 0.2s ease-in-out',
                            ...(isOpen ? { 
                                mr: -0.5,
                                p: 1,
                            } : { 
                                position: 'static',
                                backgroundColor: 'transparent',
                                boxShadow: 'none',
                                p: 1.5,
                                '&:hover': {
                                    backgroundColor: 'rgba(255,255,255,0.1)',
                                    color: 'white',
                                    boxShadow: 'none',
                                    transform: 'scale(1.05)',
                                }
                            })
                        }}
                    >
                        {desktopOpen ? <ChevronLeftIcon /> : <MenuIcon />}
                    </IconButton>
                </Tooltip>
            </Box>
            <Divider />

            {/* Hauptnavigation */}
            <List sx={{ px: 1.5, py: 1 }}>
                {/* About Me Dropdown */}
                <Tooltip title={isOpen ? '' : t('sidebar.about')} placement="right" arrow>
                    <ListItemButton
                        onClick={() => {
                            if (!isOpen) {
                                if (typeof window !== 'undefined') {
                                    window.location.hash = '#about';
                                }
                            } else {
                                setAboutOpen(!aboutOpen);
                            }
                        }}
                        sx={{ borderRadius: 2, mb: 0.5, justifyContent: isOpen ? 'flex-start' : 'center' }}
                    >
                        <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}><InfoIcon /></ListItemIcon>
                        {isOpen && <ListItemText primary={t('sidebar.about')} sx={{ ml: 2, whiteSpace: 'nowrap' }} />}
                        {isOpen && <ExpandMoreIcon sx={{ transform: aboutOpen ? 'rotate(180deg)' : 'rotate(0deg)', transition: '0.2s' }} />}
                    </ListItemButton>
                </Tooltip>
                {aboutOpen && isOpen && (
                    <List component="div" disablePadding sx={{ pl: 4 }}>
                        <ListItemButton component="a" href={createLocalizedHashUrl('about', lang)} sx={{ borderRadius: 2, mb: 0.5 }}>
                            <ListItemIcon><PersonIcon /></ListItemIcon>
                            <ListItemText primary={t('about.title')} />
                        </ListItemButton>
                        <ListItemButton component="a" href={createLocalizedHashUrl('skills', lang)} sx={{ borderRadius: 2, mb: 0.5 }}>
                            <ListItemIcon><BuildIcon /></ListItemIcon>
                            <ListItemText primary={t('skills.title')} />
                        </ListItemButton>
                        <ListItemButton component="a" href={createLocalizedHashUrl('experience-education', lang)} sx={{ borderRadius: 2, mb: 0.5 }}>
                            <ListItemIcon><SchoolIcon /></ListItemIcon>
                            <ListItemText primary={t('experience.title')} />
                        </ListItemButton>
                    </List>
                )}
                {/* Restliche Links */}
                {navLinks.slice(1).map((link) => (
                    <Tooltip key={link.label[lang]} title={!isOpen ? link.label[lang] : ''} placement="right" arrow>
                        <ListItemButton
                            component="a"
                            href={link.label[lang] === 'My Games' ? undefined : link.href}
                            onClick={link.label[lang] === 'My Games' ? (e) => { 
                                e.preventDefault(); 
                                if (typeof window !== 'undefined') {
                                    window.location.hash = '#projects'; 
                                }
                            } : undefined}
                            sx={{ borderRadius: 2, mb: 0.5, justifyContent: isOpen ? 'flex-start' : 'center' }}
                        >
                            <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}>{link.icon}</ListItemIcon>
                            {isOpen && <ListItemText primary={link.label[lang]} sx={{ ml: 2, whiteSpace: 'nowrap' }} />}
                        </ListItemButton>
                    </Tooltip>
                ))}
            </List>
            <Divider sx={{ mx: 2 }} />

            {/* Projekte & Socials etc. */}
            <Box sx={{ flexGrow: 1, py: 1 }}>
                <Typography variant="caption" color="text.secondary" sx={{ display: isOpen ? 'block' : 'none', px: 3, mb: 1, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                    {t('sidebar.projects')}
                </Typography>
                 <List sx={{ px: 1.5 }}>
                    {projects.map(proj => (
                        <Tooltip key={proj.label} title={!isOpen ? proj.label : ''} placement="right" arrow>
                            <ListItemButton component="a" href={proj.href} target={proj.external ? "_blank" : undefined} rel={proj.external ? "noopener" : undefined} sx={{ borderRadius: 2, mb: 0.5, justifyContent: isOpen ? 'flex-start' : 'center' }}>
                                <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}>{proj.icon}</ListItemIcon>
                                {isOpen && (
                                  <Box sx={{ display: 'flex', alignItems: 'center', width: '100%', justifyContent: 'space-between' }}>
                                    <ListItemText primary={proj.label} sx={{ ml: 2, whiteSpace: 'nowrap' }} />
                                    <OpenInNewIcon fontSize="small" sx={{ color: 'text.secondary', ml: 1, mr: -1 }} />
                                  </Box>
                                )}
                            </ListItemButton>
                        </Tooltip>
                    ))}
                    
                    {/* Games within Projects */}
                    <Tooltip title={!isOpen ? t('sidebar.games') : ''} placement="right" arrow>
                        <ListItemButton 
                            onClick={() => {
                                if (!isOpen) {
                                    if (typeof window !== 'undefined') {
                                        window.location.hash = '#projects';
                                    }
                                } else {
                                    setGamesOpen(!gamesOpen);
                                }
                            }}
                            sx={{ borderRadius: 2, mb: 0.5, justifyContent: isOpen ? 'flex-start' : 'center' }}
                        >
                            <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}>
                                <SportsEsportsIcon />
                            </ListItemIcon>
                            {isOpen && <ListItemText primary={t('sidebar.games')} sx={{ ml: 2, whiteSpace: 'nowrap' }} />}
                            {isOpen && (
                                <IconButton size="small" sx={{ ml: 'auto', p: 0 }}>
                                    {gamesOpen ? <ChevronLeftIcon /> : <ArrowDropDownIcon />}
                                </IconButton>
                            )}
                        </ListItemButton>
                    </Tooltip>
                    
                    {/* Games Submenu */}
                    {gamesOpen && isOpen && (
                        <List sx={{ pl: 2 }}>
                            <Tooltip title={!isOpen ? 'Black Forest Asylum' : ''} placement="right" arrow>
                                <ListItemButton component="a" href="/projects/black-forest-asylum" sx={{ borderRadius: 2, mb: 0.5, justifyContent: 'flex-start', pl: 3 }}>
                                    <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}><ScienceIcon /></ListItemIcon>
                                    <ListItemText primary="Black Forest Asylum" sx={{ ml: 2, whiteSpace: 'nowrap' }} />
                                </ListItemButton>
                            </Tooltip>
                            <Tooltip title={!isOpen ? 'Maze of Space' : ''} placement="right" arrow>
                                <ListItemButton component="a" href="/projects/maze-of-space" sx={{ borderRadius: 2, mb: 0.5, justifyContent: 'flex-start', pl: 3 }}>
                                    <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}><HubIcon /></ListItemIcon>
                                    <ListItemText primary="Maze of Space" sx={{ ml: 2, whiteSpace: 'nowrap' }} />
                                </ListItemButton>
                            </Tooltip>
                            <Tooltip title={!isOpen ? 'SLIME' : ''} placement="right" arrow>
                                <ListItemButton component="a" href="/projects/slime" sx={{ borderRadius: 2, mb: 0.5, justifyContent: 'flex-start', pl: 3 }}>
                                    <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}><BubbleChartIcon /></ListItemIcon>
                                    <ListItemText primary="SLIME" sx={{ ml: 2, whiteSpace: 'nowrap' }} />
                                </ListItemButton>
                            </Tooltip>
                            <Tooltip title={!isOpen ? 'Block Reversal' : ''} placement="right" arrow>
                                <ListItemButton component="a" href="/projects/block-reversal" sx={{ borderRadius: 2, mb: 0.5, justifyContent: 'flex-start', pl: 3 }}>
                                    <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}><Grid4x4Icon /></ListItemIcon>
                                    <ListItemText primary="Block Reversal" sx={{ ml: 2, whiteSpace: 'nowrap' }} />
                                </ListItemButton>
                            </Tooltip>
                        </List>
                    )}
                </List>
                <Divider sx={{ mx: 2, my: 1 }} />
                <Typography variant="caption" color="text.secondary" sx={{ display: isOpen ? 'block' : 'none', px: 3, mb: 1, textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                    {t('contact.title')}
                </Typography>
                <List sx={{ px: 1.5 }}>
                    {socials.map(soc => (
                        <Tooltip key={soc.label} title={!isOpen ? soc.label : ''} placement="right" arrow>
                            <ListItemButton component="a" href={soc.href} target="_blank" rel="noopener" sx={{ borderRadius: 2, mb: 0.5, justifyContent: isOpen ? 'flex-start' : 'center' }}>
                                <ListItemIcon sx={{ minWidth: 0, justifyContent: 'center' }}>{soc.icon}</ListItemIcon>
                                {isOpen && <ListItemText primary={soc.label} sx={{ ml: 2, whiteSpace: 'nowrap' }} />}
                                {isOpen && <OpenInNewIcon fontSize="small" sx={{ color: 'text.secondary', ml: 8, mr: -1 }} />}
                            </ListItemButton>
                        </Tooltip>
                    ))}
                </List>
                
            </Box>

            {/* Footer mit Sprachumschalter */}
            <Divider />
            <Box sx={{ p: 2, display: 'flex', justifyContent: 'center', position: 'relative' }}>
                 {isOpen ? (
                    <Button fullWidth variant="outlined" startIcon={flagIcon} onClick={handleLangMenuOpen} endIcon={<ArrowDropDownIcon />}>
                        {lang === 'de' ? 'Deutsch' : 'English'}
                    </Button>
                ) : (
                    <Tooltip title={t('sidebar.language')} placement="right" arrow>
                        <IconButton onClick={handleLangMenuOpen}>{flagIcon}</IconButton>
                    </Tooltip>
                )}
                <Menu
                    anchorReference="anchorPosition"
                    anchorPosition={{ top: typeof window !== 'undefined' ? window.innerHeight - 56 : 0, left: 0 }}
                    open={Boolean(anchorEl)}
                    onClose={handleLangMenuClose}
                    PaperProps={{
                        sx: {
                            left: '50%',
                            transform: 'translateX(-50%)',
                            width: 180,
                            minWidth: 120,
                            position: 'fixed',
                            bottom: 56,
                            m: 0,
                            boxShadow: 6,
                        }
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
            {/* --- Mobile: Drawer --- */}
            <Box
                onClick={() => setMobileOpen?.(false)}
                sx={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, bgcolor: 'rgba(0,0,0,0.6)', zIndex: 1200, display: { xs: mobileOpen ? 'block' : 'none', md: 'none' }, backdropFilter: 'blur(4px)' }}
            />
            <Box
                component="aside"
                sx={{
                    position: 'fixed', top: 0, left: 0, height: '100vh', width: 280,
                    bgcolor: 'rgba(26, 26, 26, 0.70)', boxShadow: 3, zIndex: 1201,
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
                    position: 'sticky',
                    top: 0,
                    left: 0,
                    height: '100vh',
                    width: desktopOpen ? (gamesOpen ? 280 : 220) : 80,
                    bgcolor: 'rgba(26, 26, 26, 0.70)',
                    borderRight: '1.5px solid #222',
                    zIndex: 1,
                    display: { xs: 'none', md: 'block' },
                    transition: 'width 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
                    backdropFilter: 'blur(12px)',
                    WebkitBackdropFilter: 'blur(12px)',
                }}
            >
                <SidebarContent isOpen={desktopOpen} />
            </Box>
        </>
    );
};

export default Sidebar;