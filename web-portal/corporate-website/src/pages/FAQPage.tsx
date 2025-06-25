import React from 'react';
import { Box, Typography, Container, Paper, Accordion, AccordionSummary, AccordionDetails } from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';

interface FAQItem {
  question: string;
  answer: string;
}

const faqs: FAQItem[] = [
  {
    question: "What is the AURAX Platform?",
    answer: "The AURAX Platform is an open, modular, and AI-driven media and gaming platform designed by Aurav Technologies. It supports multiple game engines (like Unity, Godot, Bevy, O3DE, and the native LUVY Engine), fosters a community and creator economy, provides analytics, and even enables in-app game development."
  },
  {
    question: "What makes the LUVY Engine unique?",
    answer: "The LUVY Engine is Aurav Technologies' proprietary game engine. Its unique features include the Broxel Engine (a voxel-based system capable of leveraging multiple underlying engine technologies) and deep integration of AI for content generation (e.g., 'LegoGPT' for style transfer, procedural level optimization) and specialized tooling for low-poly design."
  },
  {
    question: "How does Aurav Technologies use AI in game development?",
    answer: "Aurav Technologies integrates AI across the development lifecycle. This includes AI assistance in idea generation (game concepts, mechanics), asset creation (Prompt2World, style transfer), game design balancing, procedural content generation, and potentially fully AI-generated game experiences, all powered by our Mindflow AI Engine."
  },
  {
    question: "What is Aurav's approach to community and the creator economy?",
    answer: "Aurav Technologies aims to democratize game development. The AURAX platform provides tools for game jams, co-creation, an asset marketplace, and collaborative features to empower creators of all levels and foster a vibrant, supportive community."
  },
  {
    question: "What kind of innovative game experiences does Aurav offer?",
    answer: "Beyond tools and platforms, Aurav is developing unique gaming experiences, including a suite of over 30 creative, analytical, and AI-powered minigames. These minigames also serve as a testbed and showcase for the capabilities of the LUVY Engine and AURAX platform."
  }
];

const FAQPage: React.FC = () => {
  const faqSchema = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": faqs.map(faq => ({
      "@type": "Question",
      "name": faq.question,
      "acceptedAnswer": {
        "@type": "Answer",
        "text": faq.answer
      }
    }))
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom align="center">
          Frequently Asked Questions (FAQ)
        </Typography>

        <script type="application/ld+json">
          {JSON.stringify(faqSchema)}
        </script>

        <Box sx={{ mt: 3 }}>
          {faqs.map((faq, index) => (
            <Accordion key={index} sx={{ mb: 1 }}>
              <AccordionSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls={`panel${index}a-content`}
                id={`panel${index}a-header`}
              >
                <Typography variant="h6" component="h2">{faq.question}</Typography>
              </AccordionSummary>
              <AccordionDetails>
                <Typography variant="body1">
                  {faq.answer}
                </Typography>
              </AccordionDetails>
            </Accordion>
          ))}
        </Box>
      </Paper>
    </Container>
  );
};

export default FAQPage;
