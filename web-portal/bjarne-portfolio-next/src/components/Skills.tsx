'use client';
import React from 'react';
import { Box, Typography, Chip, Stack, Divider, Container, Button } from '@mui/material';
import CodeIcon from '@mui/icons-material/Code';
import JavascriptIcon from '@mui/icons-material/Javascript';
import TypeScriptIcon from '@mui/icons-material/IntegrationInstructions';
import JavaIcon from '@mui/icons-material/Coffee';
import CSharpIcon from '@mui/icons-material/Terminal';
import CppIcon from '@mui/icons-material/Memory';
import HtmlIcon from '@mui/icons-material/Html';
import CssIcon from '@mui/icons-material/Css';
import SqlIcon from '@mui/icons-material/Storage';
import RustIcon from '@mui/icons-material/Settings';
import FlutterIcon from '@mui/icons-material/PhoneIphone';
import UnityIcon from '@mui/icons-material/VideogameAsset';
import GamepadIcon from '@mui/icons-material/SportsEsports';
import EmojiEventsIcon from '@mui/icons-material/EmojiEvents';
import AutoAwesomeIcon from '@mui/icons-material/AutoAwesome';
import PsychologyIcon from '@mui/icons-material/Psychology';
import EngineeringIcon from '@mui/icons-material/Engineering';
import StorageIcon from '@mui/icons-material/Storage';
import CloudIcon from '@mui/icons-material/Cloud';
import ApiIcon from '@mui/icons-material/Api';
import GitHubIcon from '@mui/icons-material/GitHub';
import SlackIcon from '@mui/icons-material/Chat';
import VpnKeyIcon from '@mui/icons-material/VpnKey';
import DesignServicesIcon from '@mui/icons-material/DesignServices';
import ForumIcon from '@mui/icons-material/Forum';
import ScienceIcon from '@mui/icons-material/Science';
import GroupWorkIcon from '@mui/icons-material/GroupWork';
import TrackChangesIcon from '@mui/icons-material/TrackChanges';
import RocketLaunchIcon from '@mui/icons-material/RocketLaunch';
import StarIcon from '@mui/icons-material/Star';
import OpenInNewIcon from '@mui/icons-material/OpenInNew';
import { useLanguage } from '../app/LanguageContext';

const skillGroups = [
  {
    title: 'programmingLanguages',
    skills: [
      { label: 'Dart', icon: <CodeIcon /> },
      { label: 'C#', icon: <CSharpIcon /> },
      { label: 'Python', icon: <CodeIcon /> },
      { label: 'JavaScript', icon: <JavascriptIcon /> },
      { label: 'TypeScript', icon: <TypeScriptIcon /> },
      { label: 'Java', icon: <JavaIcon /> },
      { label: 'C', icon: <CppIcon /> },
      { label: 'C++', icon: <CppIcon /> },
      { label: 'Rust', icon: <RustIcon /> },
      { label: 'HTML', icon: <HtmlIcon /> },
      { label: 'CSS', icon: <CssIcon /> },
      { label: 'SQL', icon: <SqlIcon /> },
    ],
  },
  {
    title: 'frameworks',
    skills: [
      { label: 'Flutter', icon: <FlutterIcon /> },
      { label: 'React', icon: <CodeIcon /> },
      { label: 'Next.js', icon: <CodeIcon /> },
    ],
  },
  {
    title: 'gameDev',
    skills: [
      { label: 'Unity Engine', icon: <UnityIcon /> },
      { label: 'Game Design', icon: <GamepadIcon /> },
      { label: 'Gamification', icon: <EmojiEventsIcon /> },
    ],
  },
  {
    title: 'dataAI',
    skills: [
      { label: 'Generative KI', icon: <AutoAwesomeIcon /> },
      { label: 'Prompt Engineering', icon: <EngineeringIcon /> },
      { label: 'Deep Learning', icon: <PsychologyIcon /> },
      { label: 'TensorFlow', icon: <PsychologyIcon /> },
      { label: 'PyTorch', icon: <PsychologyIcon /> },
      { label: 'Data Science', icon: <ScienceIcon /> },
      { label: 'Analytics', icon: <TrackChangesIcon /> },
      { label: 'MongoDB', icon: <StorageIcon /> },
    ],
  },
  {
    title: 'cloudBackend',
    skills: [
      { label: 'Firebase', icon: <CloudIcon /> },
      { label: 'Google Cloud Platform (GCP)', icon: <CloudIcon /> },
      { label: 'Supabase', icon: <CloudIcon /> },
      { label: 'PostgreSQL', icon: <StorageIcon /> }, // <-- hinzugefügt
      { label: 'Docker', icon: <ApiIcon /> },
      { label: 'Kubernetes', icon: <ApiIcon /> },
      { label: 'REST API Design', icon: <ApiIcon /> },
      { label: 'GraphQL', icon: <ApiIcon /> },
      { label: 'NoSQL Datenbanken', icon: <StorageIcon /> },
    ],
  },
  {
    title: 'tools',
    skills: [
      { label: 'Slack', icon: <SlackIcon /> },
      { label: 'VS Code', icon: <CodeIcon /> },
      { label: 'Discord', icon: <ForumIcon /> },
      { label: 'GitHub', icon: <GitHubIcon /> },
      { label: 'Jira', icon: <RocketLaunchIcon /> },
      { label: 'Confluence', icon: <ForumIcon /> },
      { label: 'CI/CD', icon: <VpnKeyIcon /> },
      { label: 'Figma', icon: <DesignServicesIcon /> }, // <-- hinzugefügt
      { label: 'Miro', icon: <ForumIcon /> },           // <-- hinzugefügt
    ],
  },
  {
    title: 'general',
    skills: [
      { label: 'UX Design', icon: <DesignServicesIcon /> },
      { label: 'Transparente Kommunikation', icon: <ForumIcon /> },
      { label: 'Forschung', icon: <ScienceIcon /> },
      { label: 'Software Engineering', icon: <EngineeringIcon /> },
      { label: 'Agile Methoden', icon: <GroupWorkIcon /> },
      { label: 'Scrum', icon: <GroupWorkIcon /> },
    ],
  },
];

const topSkills = [
  'Dart', 'C#', 'Python', 'Flutter', 'Unity Engine', 'Gamification', 'Game Design',
  'Generative KI', 'Prompt Engineering', 'Firebase', 'Google Cloud Platform (GCP)', 'Supabase',
  'VS Code', 'GitHub', 'UX Design', 'Slack', 'Discord', 'Transparente Kommunikation'
];

const Skills: React.FC = () => {
  const { t } = useLanguage();
  
  return (
    <Box component="section" id="skills" sx={{ py: 8, bgcolor: 'background.default' }}>
      <Container maxWidth="md">
        <Box sx={{ textAlign: 'center', mb: 6 }}>
          <Typography 
            variant="h3" 
            component="h2" 
            gutterBottom 
            sx={{ fontWeight: 700, color: 'primary.main' }}
          >
            {t('skills.title')}
          </Typography>
          <Divider 
            sx={{ width: 80, height: 4, mx: 'auto', bgcolor: 'primary.main', borderRadius: 2 }} 
          />
          {/* Tech Radar Button */}
          <Box sx={{ display: 'flex', justifyContent: 'center', mb: 3 }}>
            <Button
              variant="contained"
              color="primary"
              startIcon={<TrackChangesIcon />}
              endIcon={<OpenInNewIcon />}
              href="https://www.auravention.com/tech-radar"
              target="_blank"
              sx={{
                fontWeight: 700,
                borderRadius: 3,
                px: 2.5,
                py: 1.2,
                fontSize: '1.08rem',
                textTransform: 'none',
                boxShadow: 2,
                color: 'primary.contrastText',
                '&:hover': {
                  bgcolor: 'primary.dark',
                  color: 'primary.contrastText',
                  boxShadow: 4,
                }
              }}
              title="Interaktive Übersicht aller Technologien im Projekt"
            >
              {t('skills.techRadar')}
            </Button>
          </Box>
        </Box>
        {skillGroups.map((group) => (
          <Box key={group.title} mb={4}>
            <Typography variant="h5" component="h3" sx={{ mb: 2, fontWeight: 600, color: '#fff' }}>
              {t(`skills.groups.${group.title}`)}
            </Typography>
            <Stack direction="row" flexWrap="wrap" gap={1.5}>
              {group.skills.map((skill) => {
                const isTop = topSkills.includes(skill.label);
                return (
                  <Chip
                    key={skill.label}
                    label={
                      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                        {skill.icon}
                        <span>{skill.label}</span>
                        {isTop && <StarIcon sx={{ fontSize: 18, color: 'gold', ml: 0.5 }} />}
                      </Box>
                    }
                    color={isTop ? 'primary' : undefined}
                    variant={isTop ? 'filled' : 'outlined'}
                    sx={{
                      fontSize: '1rem',
                      fontWeight: 500,
                      p: 2,
                      cursor: 'pointer',
                      borderColor: 'primary.main',
                      background: 'rgba(179,157,219,0.07)',
                      transition: 'all 0.2s',
                      '&:hover': {
                        transform: 'scale(1.05)',
                        bgcolor: 'primary.main',
                        color: 'primary.contrastText',
                        boxShadow: 3,
                      },
                    }}
                  />
                );
              })}
            </Stack>
          </Box>
        ))}
      </Container>
    </Box>
  );
};

export default Skills; 