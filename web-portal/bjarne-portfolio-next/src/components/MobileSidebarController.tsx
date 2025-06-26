"use client";
import React, { useState } from "react";
import Sidebar from "./Sidebar";
import MenuIcon from "@mui/icons-material/Menu";
import { IconButton, Box } from "@mui/material";

const MobileSidebarController: React.FC = () => {
  const [mobileOpen, setMobileOpen] = useState(false);
  return (
    <>
      {/* Hamburger Icon für Mobile - nur anzeigen, wenn Sidebar NICHT offen ist */}
      {!mobileOpen && (
        <Box sx={{ position: 'fixed', top: 16, left: 16, zIndex: 2000, display: { xs: 'block', md: 'none' } }}>
          <IconButton onClick={() => setMobileOpen(true)} size="large" sx={{ bgcolor: 'background.paper', boxShadow: 2 }}>
            <MenuIcon fontSize="large" />
          </IconButton>
        </Box>
      )}
      <Sidebar mobileOpen={mobileOpen} setMobileOpen={setMobileOpen} />
    </>
  );
};

export default MobileSidebarController; 