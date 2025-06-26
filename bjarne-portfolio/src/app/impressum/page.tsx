"use client";
import React from "react";
import { Typography, Link } from "@mui/material";
import { useLanguage } from "../LanguageContext";

const ImpressumPage: React.FC = () => {
  const { t } = useLanguage();

  const addressLines = [
    t("impressumAddressLine1"),
    t("impressumAddressLine2"),
    t("impressumAddressLine3"),
    t("impressumAddressLine4"),
    t("impressumAddressLine5"),
  ];

  return (
    <main style={{ maxWidth: 700, margin: "0 auto", padding: "2rem 1rem" }}>
      <Typography variant="h4" color="primary" gutterBottom>{t("impressumTitle")}</Typography>
      {addressLines.map((line, i) => (
        <Typography key={i}>{line}</Typography>
      ))}
      <Typography>
        E-Mail: <Link href={`mailto:${t("impressumEmail")}`} color="primary">{t("impressumEmail")}</Link>
      </Typography>
      <Typography paragraph>{t("impressumResponsible")}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t("impressumDisclaimerTitle")}</Typography>
      <Typography paragraph>{t("impressumDisclaimer")}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t("impressumCopyrightTitle")}</Typography>
      <Typography paragraph>{t("impressumCopyright")}</Typography>
      <Typography variant="body2" color="text.secondary" mt={4}>{t("impressumNote")}</Typography>
    </main>
  );
};

export default ImpressumPage;
