import React, { useState, useEffect } from 'react';
import { Link, NavLink, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../../auth/AuthContext';
import LogoHexSpark from '../LogoHexSpark';
import LanguageSwitcher from '../LanguageSwitcher';
import {
  Drawer, List, ListItemIcon, ListItemText, IconButton, Divider, useMediaQuery, Tooltip, Accordion, AccordionSummary, AccordionDetails, Avatar, Box, Collapse, ListItemButton
} from '@mui/material';
import {
  Home, Feed, Radar, Info, Map, Science, Group, Flag, EmojiEvents, Settings, ExpandMore, ChevronLeft, ChevronRight, Login, Logout, PersonAdd
} from '@mui/icons-material';
import { useTheme } from '@mui/material/styles';
import './Sidebar.css';

const navStructure = [
  {
    label: 'Allgemein',
    items: [
      { to: '/', labelKey: 'nav.home', defaultLabel: 'Start', icon: <Home /> },
      { to: '/feed', labelKey: 'nav.feed', defaultLabel: 'Aktuelles', icon: <Feed /> },
      { to: '/tech-radar', labelKey: 'nav.techRadar', defaultLabel: 'Tech Radar', icon: <Radar /> },
    ],
  },
  {
    label: 'Über JamBam',
    items: [
      { to: '/about', labelKey: 'nav.about', defaultLabel: 'Über uns', icon: <Info /> },
      { to: '/team', labelKey: 'nav.team', defaultLabel: 'Team', icon: <Group /> },
      { to: '/vision-mission', labelKey: 'nav.visionMission', defaultLabel: 'Vision & Mission', icon: <Flag /> },
      { to: '/roadmap', labelKey: 'nav.roadmap', defaultLabel: 'Roadmap', icon: <Map /> },
    ],
  },
  {
    label: 'Features & Tools',
    items: [
      { to: '/research-agent', labelKey: 'nav.researchAgent', defaultLabel: 'Research Agent', icon: <Science /> },
    ],
  },
  {
    label: 'Förderung',
    items: [
      { to: '/funding-worthiness', labelKey: 'nav.funding', defaultLabel: 'Förderung', icon: <EmojiEvents /> },
    ],
  },
];

const Sidebar: React.FC<{ mobileOpen: boolean; onMobileClose: () => void; }> = ({ mobileOpen, onMobileClose }) => {
  const { t } = useTranslation();
  const { isAuthenticated, profile, user, logout } = useAuth();
  const theme = useTheme();
  const isDesktop = useMediaQuery(theme.breakpoints.up('md'));
  const [collapsed, setCollapsed] = useState(() => {
    const stored = localStorage.getItem('sidebarCollapsed');
    return stored === 'true';
  });
  const [expanded, setExpanded] = useState<string | false>(false);
  const navigate = useNavigate();

  useEffect(() => {
    localStorage.setItem('sidebarCollapsed', String(collapsed));
  }, [collapsed]);

  const handleAccordion = (panel: string) => (_event: React.SyntheticEvent, isExpanded: boolean) => {
    setExpanded(isExpanded ? panel : false);
  };

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  // User avatar fallback
  const displayName = profile?.username || user?.email || 'Gast';

  // Sidebar width
  const sidebarWidth = collapsed ? 72 : 240;

  // Sidebar content
  const drawerContent = (
    <Box sx={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
      {/* Logo & Collapse Button */}
      <Box className="sidebar-logo" sx={{ justifyContent: collapsed ? 'center' : 'flex-start' }}>
        <Link to="/">
          <LogoHexSpark />
          {!collapsed && <span className="sidebar-title">JamBam</span>}
        </Link>
        <IconButton onClick={() => setCollapsed(c => !c)} sx={{ ml: 'auto', display: { xs: 'none', md: 'inline-flex' } }}>
          {collapsed ? <ChevronRight /> : <ChevronLeft />}
        </IconButton>
      </Box>
      <Divider />
      {/* Navigation */}
      <Box sx={{ flex: 1, overflowY: 'auto', mt: 1 }}>
        {navStructure.map((section, idx) => (
          <Box key={section.label} sx={{ mb: 1 }}>
            {!collapsed && <Box sx={{ px: 2, py: 0.5, fontSize: '0.95rem', color: '#7be7e0', fontWeight: 600, opacity: 0.8 }}>{section.label}</Box>}
            <List>
              {section.items.map(item => (
                <Tooltip key={item.to} title={collapsed ? t(item.labelKey, item.defaultLabel) : ''} placement="right" arrow>
                  <NavLink
                    to={item.to}
                    style={{ textDecoration: 'none' }}
                    end
                  >
                    {({ isActive }: { isActive: boolean }) => (
                      <ListItemButton
                        component="li"
                        onClick={onMobileClose}
                        selected={isActive}
                        className={isActive ? 'active-link' : ''}
                        sx={{
                          justifyContent: collapsed ? 'center' : 'flex-start',
                          px: collapsed ? 1 : 2,
                          py: 1.1,
                          minHeight: 44,
                          '& .MuiListItemText-root': { display: collapsed ? 'none' : 'block' },
                          '& .MuiListItemIcon-root': { minWidth: 0, mr: collapsed ? 0 : 2, justifyContent: 'center' },
                        }}
                      >
                        <ListItemIcon>{item.icon}</ListItemIcon>
                        <ListItemText primary={t(item.labelKey, item.defaultLabel)} />
                      </ListItemButton>
                    )}
                  </NavLink>
                </Tooltip>
              ))}
            </List>
          </Box>
        ))}
      </Box>
      {/* App Button */}
      <Box className="sidebar-app-button" sx={{ mx: collapsed ? 1 : 2, mb: 2, mt: 1 }}>
        <a
          href="https://www.auravention.com"
          target="_blank"
          rel="noopener noreferrer"
          className="cta-button"
          style={{ width: '100%', display: 'inline-block', fontSize: collapsed ? 0 : undefined, minHeight: 36 }}
        >
          <span style={{ display: collapsed ? 'none' : 'inline' }}>📱 {t('header.getApp', 'App laden')}</span>
          <span style={{ display: collapsed ? 'inline' : 'none' }}><EmojiEvents /></span>
        </a>
      </Box>
      {/* User & Settings Bereich */}
      <Box sx={{ px: collapsed ? 0.5 : 2, pb: 1, pt: 0.5 }}>
        <Divider sx={{ mb: 1 }} />
        <Box sx={{ display: 'flex', alignItems: 'center', flexDirection: collapsed ? 'column' : 'row', gap: 1 }}>
          <Avatar sx={{ width: 36, height: 36, bgcolor: '#5b47fb', fontWeight: 700 }}>{profile?.username?.[0]?.toUpperCase() || user?.email?.[0]?.toUpperCase() || '?'}</Avatar>
          {!collapsed && <Box sx={{ flex: 1, minWidth: 0 }}>
            <Box sx={{ fontWeight: 600, fontSize: '1.01rem', color: '#e6e6e6', textOverflow: 'ellipsis', overflow: 'hidden', whiteSpace: 'nowrap' }}>{displayName}</Box>
            <Box sx={{ fontSize: '0.92rem', color: '#7be7e0', textOverflow: 'ellipsis', overflow: 'hidden', whiteSpace: 'nowrap' }}>{user?.email || ''}</Box>
          </Box>}
          <Tooltip title={t('nav.settings', 'Einstellungen')} placement="top">
            <IconButton onClick={() => navigate('/settings')} size="small" sx={{ color: '#7be7e0' }}>
              <Settings />
            </IconButton>
          </Tooltip>
        </Box>
        <Box sx={{ mt: 1, display: 'flex', flexDirection: collapsed ? 'column' : 'row', gap: 1, justifyContent: 'center' }}>
          {isAuthenticated ? (
            <Tooltip title={t('nav.logout', 'Abmelden')} placement="top">
              <IconButton onClick={handleLogout} size="small" sx={{ color: '#e57373' }}>
                <Logout />
              </IconButton>
            </Tooltip>
          ) : (
            <>
              <Tooltip title={t('nav.login', 'Anmelden')} placement="top">
                <IconButton onClick={() => navigate('/login')} size="small" sx={{ color: '#7be7e0' }}>
                  <Login />
                </IconButton>
              </Tooltip>
              <Tooltip title={t('nav.register', 'Registrieren')} placement="top">
                <IconButton onClick={() => navigate('/register')} size="small" sx={{ color: '#5b47fb' }}>
                  <PersonAdd />
                </IconButton>
              </Tooltip>
            </>
          )}
        </Box>
      </Box>
      {/* Language Switcher ganz unten */}
      <Box sx={{ px: collapsed ? 0.5 : 2, pb: 2, pt: 0.5, display: 'flex', justifyContent: 'center' }}>
        <LanguageSwitcher />
      </Box>
    </Box>
  );

  return (
    <>
      {isDesktop ? (
        <Drawer
          variant="permanent"
          open
          anchor="left"
          className="sidebar-drawer"
          PaperProps={{ className: 'sidebar-paper' }}
          sx={{ width: sidebarWidth, flexShrink: 0, '& .MuiDrawer-paper': { width: sidebarWidth, transition: 'width 0.2s' } }}
        >
          {drawerContent}
        </Drawer>
      ) : (
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={onMobileClose}
          anchor="left"
          className="sidebar-drawer"
          PaperProps={{ className: 'sidebar-paper' }}
        >
          {drawerContent}
        </Drawer>
      )}
    </>
  );
};

export default Sidebar; 