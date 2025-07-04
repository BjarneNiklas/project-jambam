"use client";
import React from "react";
import Button from "@mui/material/Button";
import { useLanguage } from "./LanguageContext";
import { useRouter, usePathname } from 'next/navigation';

const LanguageToggle: React.FC = () => {
  const { lang, setLang } = useLanguage();
  const router = useRouter();
  const pathname = usePathname();

  const toggleLanguage = () => {
    const newLang = lang === 'de' ? 'en' : 'de';
    setLang(newLang);
    if (pathname.startsWith('/de/privacy-policy')) {
      router.push('/en/privacy-policy');
    } else if (pathname.startsWith('/en/privacy-policy')) {
      router.push('/de/privacy-policy');
    } else if (pathname.startsWith('/de/legal-notice')) {
      router.push('/en/legal-notice');
    } else if (pathname.startsWith('/en/legal-notice')) {
      router.push('/de/legal-notice');
    } else if (pathname.startsWith('/de/')) {
      router.push('/en' + pathname.slice(3));
    } else if (pathname.startsWith('/en/')) {
      router.push('/de' + pathname.slice(3));
    } else {
      router.push('/' + newLang);
    }
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