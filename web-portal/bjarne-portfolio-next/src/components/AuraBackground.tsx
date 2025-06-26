'use client';

import { Box } from '@mui/material';
import React from 'react';

const AuraBackground: React.FC = () => (
    <Box sx={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        overflow: 'hidden',
        zIndex: -1,
        '&::before': {
            content: '""',
            position: 'absolute',
            left: '50%',
            top: '50%',
            width: '200%', // Vergrößert für eine breitere Abdeckung
            paddingBottom: '200%', // Vergrößert für eine breitere Abdeckung
            borderRadius: '50%',
            transform: 'translate(-50%, -50%)',
            background: 'radial-gradient(circle, rgba(255,165,0,0.25) 0%, rgba(255,140,0,0.15) 25%, rgba(255,69,0,0.05) 50%, rgba(0,0,0,0) 70%)',
            filter: 'blur(80px)', // Etwas stärkerer Blur
            animation: 'aurora 25s linear infinite',
        },
        '@keyframes aurora': {
            '0%': { transform: 'translate(-50%, -50%) rotate(0deg)' },
            '100%': { transform: 'translate(-50%, -50%) rotate(360deg)' },
        }
    }} />
);

export default AuraBackground;