"use client";
import React from "react";
import { Typography, Link } from "@mui/material";
import { useLanguage } from "../LanguageContext";

const content = {
  de: {
    title: "Impressum",
    address: [
      "Angaben gemäß § 5 TMG",
      "Bjarne Niklas Luttermann",
      "Musterstraße 1",
      "70173 Stuttgart",
      "Deutschland",
    ],
    email: "aurav.tech@gmail.com",
    responsible: "Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV: Bjarne Niklas Luttermann, Adresse wie oben",
    disclaimerTitle: "Haftungsausschluss",
    disclaimer: "Trotz sorgfältiger inhaltlicher Kontrolle übernehme ich keine Haftung für die Inhalte externer Links. Für den Inhalt der verlinkten Seiten sind ausschließlich deren Betreiber verantwortlich.",
    copyrightTitle: "Urheberrecht",
    copyright: "Die durch den Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Beiträge Dritter sind als solche gekennzeichnet.",
    note: "Dieses Impressum gilt auch für die Social-Media-Profile, sofern vorhanden.",
  },
  en: {
    title: "Legal Notice",
    address: [
      "Information according to § 5 TMG (German law)",
      "Bjarne Niklas Luttermann",
      "Musterstraße 1",
      "70173 Stuttgart",
      "Germany",
    ],
    email: "aurav.tech@gmail.com",
    responsible: "Responsible for content according to § 55 Abs. 2 RStV: Bjarne Niklas Luttermann, address as above",
    disclaimerTitle: "Disclaimer",
    disclaimer: "Despite careful content control, I assume no liability for the content of external links. The operators of the linked pages are solely responsible for their content.",
    copyrightTitle: "Copyright",
    copyright: "The content and works created by the site operator on these pages are subject to German copyright law. Contributions by third parties are marked as such.",
    note: "This legal notice also applies to social media profiles, if available.",
  },
};

const ImpressumPage: React.FC = () => {
  const { lang } = useLanguage();
  const t = content[lang];
  return (
    <main style={{ maxWidth: 700, margin: "0 auto", padding: "2rem 1rem" }}>
      <Typography variant="h4" color="primary" gutterBottom>{t.title}</Typography>
      {t.address.map((line, i) => (
        <Typography key={i}>{line}</Typography>
      ))}
      <Typography>
        E-Mail: <Link href="mailto:aurav.tech@gmail.com" color="primary">aurav.tech@gmail.com</Link>
      </Typography>
      <Typography paragraph>{t.responsible}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t.disclaimerTitle}</Typography>
      <Typography paragraph>{t.disclaimer}</Typography>
      <Typography variant="h6" color="secondary" gutterBottom>{t.copyrightTitle}</Typography>
      <Typography paragraph>{t.copyright}</Typography>
      <Typography variant="body2" color="text.secondary" mt={4}>{t.note}</Typography>
    </main>
  );
};

export default ImpressumPage;
