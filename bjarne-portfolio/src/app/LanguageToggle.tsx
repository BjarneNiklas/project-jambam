"use client";
import React from "react";
import Button from "@mui/material/Button";
import { useLanguage } from "./LanguageContext";

const LanguageToggle: React.FC = () => {
  const { lang, setLang } = useLanguage();
  const toggleLang = () => setLang(lang === "de" ? "en" : "de");
  return (
    <Button variant="outlined" color="primary" onClick={toggleLang} sx={{ ml: 2 }}>
      {lang === "de" ? "EN" : "DE"}
    </Button>
  );
};

export default LanguageToggle;
