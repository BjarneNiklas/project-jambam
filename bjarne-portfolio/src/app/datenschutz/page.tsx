"use client";
import React from "react";
import { Typography, Link } from "@mui/material";
import { useLanguage } from "../LanguageContext";

const DatenschutzPage: React.FC = () => {
  const { t } = useLanguage();
  return (
    <main style={{ maxWidth: 700, margin: "0 auto", padding: "2rem 1rem" }}>
      <Typography variant="h4" color="primary" gutterBottom>{t("datenschutzTitle")}</Typography>
      <Typography paragraph>{t("datenschutzIntro")}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t("datenschutzContactTitle")}</Typography>
      <Typography paragraph>{t("datenschutzContact")}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t("datenschutzLogTitle")}</Typography>
      <Typography paragraph>{t("datenschutzLog")}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t("datenschutzRightsTitle")}</Typography>
      <Typography paragraph>{t("datenschutzRights")}</Typography>
      <Typography variant="body2" color="text.secondary" mt={4}>
        {t("datenschutzNote")}
        <Link href={`mailto:${t("datenschutzEmail")}`} color="primary">{t("datenschutzEmail")}</Link>
      </Typography>
    </main>
  );
};

export default DatenschutzPage;
