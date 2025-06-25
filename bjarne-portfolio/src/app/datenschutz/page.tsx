"use client";
import React from "react";
import { Typography, Link } from "@mui/material";
import { useLanguage } from "../LanguageContext";

const content = {
  de: {
    title: "Datenschutzerklärung",
    intro: "Diese Website erhebt und speichert keine personenbezogenen Daten. Es werden keine Cookies gesetzt und kein Tracking eingesetzt.",
    contactTitle: "Kontaktaufnahme",
    contact: "Wenn Sie mir per E-Mail Anfragen zukommen lassen, werden Ihre Angaben aus der E-Mail inklusive der von Ihnen dort angegebenen Kontaktdaten zwecks Bearbeitung der Anfrage und für den Fall von Anschlussfragen gespeichert. Diese Daten gebe ich nicht ohne Ihre Einwilligung weiter.",
    logTitle: "Server-Log-Files",
    log: "Der Provider der Seiten erhebt und speichert automatisch Informationen in so genannten Server-Log Files, die Ihr Browser automatisch übermittelt. Diese Daten sind nicht bestimmten Personen zuordenbar. Eine Zusammenführung dieser Daten mit anderen Datenquellen wird nicht vorgenommen.",
    rightsTitle: "Rechte",
    rights: "Sie haben jederzeit das Recht auf unentgeltliche Auskunft über Ihre gespeicherten personenbezogenen Daten, deren Herkunft und Empfänger und den Zweck der Datenverarbeitung sowie ein Recht auf Berichtigung, Sperrung oder Löschung dieser Daten.",
    note: "Für Fragen zum Datenschutz wenden Sie sich bitte an: ",
    email: "aurav.tech@gmail.com",
  },
  en: {
    title: "Privacy Policy",
    intro: "This website does not collect or store any personal data. No cookies are set and no tracking is used.",
    contactTitle: "Contact",
    contact: "If you send me inquiries by e-mail, your details from the e-mail, including the contact details you provide there, will be stored for the purpose of processing the inquiry and in case of follow-up questions. I will not pass on this data without your consent.",
    logTitle: "Server Log Files",
    log: "The provider of these pages automatically collects and stores information in so-called server log files, which your browser automatically transmits. This data cannot be assigned to specific persons. This data is not merged with other data sources.",
    rightsTitle: "Your Rights",
    rights: "You have the right at any time to free information about your stored personal data, its origin and recipient and the purpose of data processing as well as a right to correction, blocking or deletion of this data.",
    note: "For questions about data protection, please contact: ",
    email: "aurav.tech@gmail.com",
  },
};

const DatenschutzPage: React.FC = () => {
  const { lang } = useLanguage();
  const t = content[lang];
  return (
    <main style={{ maxWidth: 700, margin: "0 auto", padding: "2rem 1rem" }}>
      <Typography variant="h4" color="primary" gutterBottom>{t.title}</Typography>
      <Typography paragraph>{t.intro}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t.contactTitle}</Typography>
      <Typography paragraph>{t.contact}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t.logTitle}</Typography>
      <Typography paragraph>{t.log}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t.rightsTitle}</Typography>
      <Typography paragraph>{t.rights}</Typography>
      <Typography variant="body2" color="text.secondary" mt={4}>
        {t.note}
        <Link href={`mailto:${t.email}`} color="primary">{t.email}</Link>
      </Typography>
    </main>
  );
};

export default DatenschutzPage;
