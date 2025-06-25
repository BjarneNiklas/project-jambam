'use client';
import React from 'react';
import { Box, Typography, Chip, Stack, Divider, Container } from '@mui/material';
import cv from '../data/cv.json';

const skillSections = [
    { title: 'Hauptskills', data: cv.skills },
    { title: 'Frameworks', data: cv.frameworks },
    { title: 'Tools', data: cv.tools },
    { title: 'Datenbanken', data: cv.databases },
];

const Skills: React.FC = () => {
  return (
    <Box component="section" id="skills" sx={{ py: 8, bgcolor: 'background.default' }}>
      <Container maxWidth="md">
        <Box sx={{ textAlign: 'center', mb: 6 }}>
          <Typography 
            variant="h3" 
            component="h2" 
            gutterBottom 
            sx={{ 
              fontWeight: 700,
            }}
          >
            Fähigkeiten & Technologien
          </Typography>
          <Divider 
            sx={{ 
              width: 80, 
              height: 4, 
              mx: 'auto', 
              bgcolor: 'primary.main',
              borderRadius: 2
            }} 
          />
        </Box>

        {skillSections.map(section => (
            section.data && section.data.length > 0 && (
                <Box key={section.title} mb={4}>
                    <Typography variant="h5" component="h3" sx={{ textAlign: 'center', mb: 3, fontWeight: 600, color: 'text.secondary' }}>
                        {section.title}
                    </Typography>
                    <Stack direction="row" flexWrap="wrap" justifyContent="center" gap={1.5}>
                        {(section.data as string[]).map((skill: string) => (
                            <Chip 
                                key={skill} 
                                label={skill} 
                                color="primary"
                                variant="outlined" 
                                sx={{ 
                                    fontSize: '1rem', 
                                    fontWeight: 500,
                                    p: 2,
                                    cursor: 'pointer',
                                    transition: 'all 0.2s',
                                    '&:hover': {
                                        transform: 'scale(1.05)',
                                        bgcolor: 'primary.main',
                                        color: 'primary.contrastText',
                                        boxShadow: 3,
                                    }
                                }} 
                            />
                        ))}
                    </Stack>
                </Box>
            )
        ))}
        
      </Container>
    </Box>
  );
};

export default Skills; 