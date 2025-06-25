"use client";
import React from "react";
import AppBar from "@mui/material/AppBar";
import Toolbar from "@mui/material/Toolbar";
import Typography from "@mui/material/Typography";
import IconButton from "@mui/material/IconButton";
import MenuIcon from "@mui/icons-material/Menu";
import Drawer from "@mui/material/Drawer";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemButton from "@mui/material/ListItemButton";
import ListItemIcon from "@mui/material/ListItemIcon";
import ListItemText from "@mui/material/ListItemText";
import HomeIcon from "@mui/icons-material/Home";
import InfoIcon from "@mui/icons-material/Info";
import BuildIcon from "@mui/icons-material/Build";
import WorkIcon from "@mui/icons-material/Work";
import ContactMailIcon from "@mui/icons-material/ContactMail";
import BusinessIcon from "@mui/icons-material/Business";
import Button from "@mui/material/Button";
import Box from "@mui/material/Box";
import useMediaQuery from "@mui/material/useMediaQuery";
import { useTheme } from "@mui/material/styles";

const navLinks = [
  { href: "/#home", label: "Home", icon: <HomeIcon /> },
  { href: "/#about", label: "Über mich", icon: <InfoIcon /> },
  { href: "/#skills", label: "Skills", icon: <BuildIcon /> },
  { href: "/#projects", label: "Projekte", icon: <WorkIcon /> },
  { href: "/#contact", label: "Kontakt", icon: <ContactMailIcon /> },
  { href: "https://aurav.tech", label: "AuraV", icon: <BusinessIcon />, external: true },
];

const AppHeader: React.FC = () => {
  const [drawerOpen, setDrawerOpen] = React.useState(false);
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down("md"));

  const handleDrawerToggle = () => setDrawerOpen((open) => !open);

  return (
    <AppBar
      position="sticky"
      elevation={3}
      sx={{
        backdropFilter: "blur(12px)",
        background: "rgba(255,255,255,0.85)",
        color: theme.palette.primary.main,
        boxShadow: "0 4px 24px 0 rgba(20,184,166,0.10)",
        borderBottomLeftRadius: 24,
        borderBottomRightRadius: 24,
        zIndex: theme.zIndex.drawer + 1,
      }}
    >
      <Toolbar sx={{ minHeight: 72, display: "flex", justifyContent: "space-between" }}>
        <Box display="flex" alignItems="center" gap={2}>
          <a href="/" style={{ display: "flex", alignItems: "center" }}>
            <img src="/favicon.svg" alt="Logo" style={{ height: 40, width: 40, borderRadius: 12, boxShadow: "0 2px 8px rgba(20,184,166,0.15)" }} />
          </a>
          <Typography
            variant="h6"
            component="span"
            sx={{
              fontWeight: 800,
              letterSpacing: 0.5,
              color: theme.palette.primary.main,
              fontSize: { xs: 18, sm: 22, md: 24 },
              textShadow: "0 2px 8px rgba(20,184,166,0.10)",
            }}
          >
            Bjarne Niklas Luttermann
          </Typography>
        </Box>
        {isMobile ? (
          <>
            <IconButton
              edge="end"
              color="primary"
              aria-label="menu"
              onClick={handleDrawerToggle}
              size="large"
              sx={{ ml: 2 }}
            >
              <MenuIcon fontSize="inherit" />
            </IconButton>
            <Drawer
              anchor="right"
              open={drawerOpen}
              onClose={handleDrawerToggle}
              PaperProps={{
                sx: {
                  width: 260,
                  borderTopLeftRadius: 24,
                  borderBottomLeftRadius: 24,
                  background: "rgba(255,255,255,0.97)",
                  boxShadow: "0 8px 32px 0 rgba(20,184,166,0.15)",
                },
              }}
            >
              <List sx={{ mt: 2 }}>
                {navLinks.map((link) => (
                  <ListItem key={link.href} disablePadding>
                    <ListItemButton
                      component="a"
                      href={link.href}
                      target={link.external ? "_blank" : undefined}
                      rel={link.external ? "noopener" : undefined}
                      onClick={handleDrawerToggle}
                    >
                      <ListItemIcon sx={{ color: theme.palette.primary.main }}>{link.icon}</ListItemIcon>
                      <ListItemText primary={link.label} />
                    </ListItemButton>
                  </ListItem>
                ))}
              </List>
            </Drawer>
          </>
        ) : (
          <Box display="flex" gap={1.5} alignItems="center">
            {navLinks.map((link) => (
              <Button
                key={link.href}
                href={link.href}
                target={link.external ? "_blank" : undefined}
                rel={link.external ? "noopener" : undefined}
                color="primary"
                variant="text"
                size="large"
                sx={{
                  fontWeight: 700,
                  fontSize: 16,
                  borderRadius: 2,
                  px: 2.5,
                  py: 1.2,
                  letterSpacing: 0.2,
                  textTransform: "none",
                  '&:hover': {
                    background: theme.palette.primary.light,
                    color: '#fff',
                  },
                }}
                startIcon={link.icon}
              >
                {link.label}
              </Button>
            ))}
          </Box>
        )}
      </Toolbar>
    </AppBar>
  );
};

export default AppHeader; 