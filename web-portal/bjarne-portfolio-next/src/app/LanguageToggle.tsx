"use client";
import React from "react";
import Button from "@mui/material/Button";
import { useLanguage } from "./LanguageContext";

const LanguageToggle: React.FC = () => {
  const { lang, setLang } = useLanguage();

  const toggleLanguage = () => {
    setLang(lang === 'de' ? 'en' : 'de');
  };

  return (
    <Button
      onClick={toggleLanguage}
      variant="outlined"
      size="small"
      sx={{
        color: 'primary.main',
        borderColor: 'primary.main',
        '&:hover': {
          borderColor: 'secondary.main',
          color: 'secondary.main',
        },
        minWidth: 'auto',
        px: 1,
        py: 0.5,
        fontSize: '0.75rem',
      }}
    >
      {lang === 'de' ? 'EN' : 'DE'}
    </Button>
  );
};

export default LanguageToggle; 