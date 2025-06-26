import React from 'react';
import { Box, Stack, Divider, Typography, Link, IconButton, Container } from '@mui/material';
import { FaLinkedin, FaYoutube, FaGithub } from 'react-icons/fa';
import { useLanguage } from '../app/LanguageContext';

const socialLinks = [
    { href: 'https://www.linkedin.com/in/bjarne-luttermann/', label: 'LinkedIn', icon: <FaLinkedin /> },
    { href: 'https://www.youtube.com/@bjarnik_interactive', label: 'YouTube', icon: <FaYoutube /> },
    { href: 'https://github.com/BjarneNiklas', label: 'GitHub', icon: <FaGithub /> },
];

const Footer: React.FC = () => {
    const { t } = useLanguage();
    
    return (
        <Box sx={{ 
            mt: 8, 
            pt: 4, 
            borderTop: 1, 
            borderColor: 'divider', 
            bgcolor: 'transparent',
            position: 'relative',
            overflow: 'hidden'
        }} component="footer">
            <Container maxWidth="lg">
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2, flexWrap: 'wrap', gap: 2 }}>
                    <Stack direction="row" spacing={1} divider={<Divider orientation="vertical" flexItem />}>
                        <Link href="/impressum" underline="hover" color="text.secondary">Impressum</Link>
                        <Link href="/datenschutz" underline="hover" color="text.secondary">Datenschutz</Link>
                    </Stack>
                    <Stack direction="row" spacing={1}>
                        {socialLinks.map((link) => (
                            <IconButton key={link.label} component="a" href={link.href} target="_blank" rel="noopener" aria-label={link.label} sx={{ color: 'text.secondary' }}>
                                {link.icon}
                            </IconButton>
                        ))}
                    </Stack>
                </Box>
                <Typography variant="body2" color="text.secondary" align="center" sx={{ pb: 4 }}>
                    {t('footer.copyright')}
                </Typography>
            </Container>
        </Box>
    );
};

export default Footer;