import React, { useState, createContext, useContext, useMemo, useCallback } from 'react';
import { BrowserRouter as Router, Route, Routes, Link as RouterLink } from 'react-router-dom';
import { ThemeProvider, createTheme, CssBaseline, AppBar, Toolbar, Typography, Button, Container, Box, Avatar, Chip, Stack, Card, CardContent, Grid, IconButton, Paper, Divider, Modal, LinearProgress, Link } from '@mui/material';
import { deepPurple, teal, pink, grey, orange, green } from '@mui/material/colors';
import { Brightness4, Brightness7, School, Work, Code, Star, Close, GitHub, Launch, Email } from '@mui/icons-material';
import { motion, AnimatePresence } from 'framer-motion';
import '@fontsource/roboto/400.css';
import '@fontsource/roboto/700.css';
import './App.css';

// Dark Mode Context
const ColorModeContext = createContext({ toggleColorMode: () => {} });

const useColorMode = () => {
  const context = useContext(ColorModeContext);
  if (!context) {
    throw new Error('useColorMode must be used within a ColorModeProvider');
  }
  return context;
};

// Project Data
const projectData = [
  {
    id: 1,
    title: 'AI Art Generator',
    subtitle: 'KI-gestützte Kunstgenerierung',
    description: 'Ein fortschrittliches Tool zur Generierung von Kunstwerken aus Textbeschreibungen. Nutzt moderne KI-Modelle für kreative Bildgenerierung.',
    longDescription: 'Dieses Projekt demonstriert die Integration von KI-Modellen für kreative Anwendungen. Features: Text-zu-Bild Generierung, Stil-Transfer, Batch-Verarbeitung, Benutzerfreundliche Web-Interface.',
    image: 'https://via.placeholder.com/400x250/7C3AED/FFFFFF?text=AI+Art+Generator',
    techStack: ['React', 'Python', 'TensorFlow', 'OpenAI API', 'Node.js'],
    github: 'https://github.com/bjarne-luttermann/ai-art-generator',
    live: 'https://ai-art-generator.demo',
    category: 'AI/ML'
  },
  {
    id: 2,
    title: 'Gamified Learning Platform',
    subtitle: 'Interaktive Lernplattform',
    description: 'Eine innovative Plattform für spielerisches Lernen mit Belohnungssystem und personalisierten Lernpfaden.',
    longDescription: 'Diese Lernplattform kombiniert Gamification-Elemente mit modernen Lerntechniken. Features: Punktesystem, Achievements, Personalisierte Lernpfade, Social Learning, Progress Tracking.',
    image: 'https://via.placeholder.com/400x250/06B6D4/FFFFFF?text=Learning+Platform',
    techStack: ['React', 'TypeScript', 'Firebase', 'Framer Motion', 'Material-UI'],
    github: 'https://github.com/bjarne-luttermann/learning-platform',
    live: 'https://learning-platform.demo',
    category: 'Education'
  },
  {
    id: 3,
    title: 'Interactive Media Dashboard',
    subtitle: 'Medienanalyse Dashboard',
    description: 'Ein Dashboard zur Analyse und Visualisierung von Medieninhalten mit Echtzeit-Daten.',
    longDescription: 'Ein umfassendes Dashboard für Medienanalyse mit Echtzeit-Datenvisualisierung. Features: Live-Datenfeeds, Interaktive Charts, Filter-System, Export-Funktionen, Responsive Design.',
    image: 'https://via.placeholder.com/400x250/10B981/FFFFFF?text=Media+Dashboard',
    techStack: ['Vue.js', 'D3.js', 'WebSocket', 'Express.js', 'MongoDB'],
    github: 'https://github.com/bjarne-luttermann/media-dashboard',
    live: 'https://media-dashboard.demo',
    category: 'Analytics'
  }
];

// Skills Data
const skillsData = [
  { name: 'React/TypeScript', level: 90, color: '#61DAFB' },
  { name: 'Python/AI/ML', level: 85, color: '#3776AB' },
  { name: 'UI/UX Design', level: 80, color: '#FF6B6B' },
  { name: 'Node.js/Express', level: 75, color: '#339933' },
  { name: 'Flutter/Dart', level: 70, color: '#02569B' },
  { name: 'Unity/C#', level: 65, color: '#000000' },
  { name: 'Docker/DevOps', level: 60, color: '#2496ED' },
  { name: 'AWS/Cloud', level: 55, color: '#FF9900' }
];

// Timeline Data
const timelineData = [
  {
    id: 1,
    year: '2023 - Heute',
    title: 'Medieninformatik Master',
    subtitle: 'Hochschule für Medien',
    description: 'Vertiefung in KI, UX/UI, Gamification und interaktive Medien',
    icon: <School />,
    color: deepPurple[500]
  },
  {
    id: 2,
    year: '2022 - 2023',
    title: 'Software Developer',
    subtitle: 'Tech Startup',
    description: 'Entwicklung von Web-Apps mit React, Node.js und Cloud-Services',
    icon: <Work />,
    color: teal[500]
  },
  {
    id: 3,
    year: '2021 - 2022',
    title: 'Bachelor Medieninformatik',
    subtitle: 'Hochschule für Medien',
    description: 'Grundlagen der Informatik, Medienproduktion und Softwareentwicklung',
    icon: <Code />,
    color: pink[500]
  },
  {
    id: 4,
    year: '2020 - 2021',
    title: 'Praktikum UX/UI Design',
    subtitle: 'Digital Agency',
    description: 'User Experience Design, Prototyping und Usability Testing',
    icon: <Star />,
    color: deepPurple[300]
  }
];

// Project Modal Component
const ProjectModal = React.memo(({ project, open, onClose }: { project: any, open: boolean, onClose: () => void }) => {
  if (!project) return null;

  return (
    <Modal
      open={open}
      onClose={onClose}
      aria-labelledby="project-modal-title"
      sx={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        p: 2
      }}
    >
      <Paper
        sx={{
          maxWidth: 800,
          width: '100%',
          maxHeight: '90vh',
          overflow: 'auto',
          position: 'relative',
          p: 3
        }}
      >
        <IconButton
          onClick={onClose}
          sx={{ position: 'absolute', right: 8, top: 8, zIndex: 1 }}
        >
          <Close />
        </IconButton>
        
        <Box sx={{ mb: 3 }}>
          <img 
            src={project.image} 
            alt={project.title}
            style={{ 
              width: '100%', 
              height: 250, 
              objectFit: 'cover', 
              borderRadius: 12 
            }}
          />
        </Box>
        
        <Typography variant="h4" gutterBottom>
          {project.title}
        </Typography>
        <Typography variant="h6" color="text.secondary" gutterBottom>
          {project.subtitle}
        </Typography>
        
        <Typography variant="body1" sx={{ mb: 3 }}>
          {project.longDescription}
        </Typography>
        
        <Box sx={{ mb: 3 }}>
          <Typography variant="h6" gutterBottom>Technologien:</Typography>
          <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap>
            {project.techStack.map((tech: string) => (
              <Chip key={tech} label={tech} variant="outlined" size="small" />
            ))}
          </Stack>
        </Box>
        
        <Stack direction="row" spacing={2}>
          {project.github && (
            <Button
              variant="outlined"
              startIcon={<GitHub />}
              href={project.github}
              target="_blank"
              rel="noopener noreferrer"
            >
              GitHub
            </Button>
          )}
          {project.live && (
            <Button
              variant="contained"
              startIcon={<Launch />}
              href={project.live}
              target="_blank"
              rel="noopener noreferrer"
            >
              Live Demo
            </Button>
          )}
        </Stack>
      </Paper>
    </Modal>
  );
});

// Skills Component
const SkillsSection = React.memo(() => {
  return (
    <Box sx={{ py: 4 }}>
      <Typography variant="h3" gutterBottom sx={{ mb: 4 }}>
        Skills & Technologien
      </Typography>
      <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', md: '1fr 1fr' }, gap: 3 }}>
        {skillsData.map((skill, index) => (
          <Box key={skill.name}>
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              whileInView={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              viewport={{ once: true }}
            >
              <Box sx={{ mb: 2 }}>
                <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 1 }}>
                  <Typography variant="body1" fontWeight="medium">
                    {skill.name}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    {skill.level}%
                  </Typography>
                </Box>
                <LinearProgress
                  variant="determinate"
                  value={skill.level}
                  sx={{
                    height: 8,
                    borderRadius: 4,
                    backgroundColor: 'rgba(0,0,0,0.1)',
                    '& .MuiLinearProgress-bar': {
                      backgroundColor: skill.color,
                      borderRadius: 4
                    }
                  }}
                />
              </Box>
            </motion.div>
          </Box>
        ))}
      </Box>
    </Box>
  );
});

// Timeline Component
const Timeline = React.memo(() => {
  return (
    <Box sx={{ position: 'relative', py: 4 }}>
      {/* Timeline Line */}
      <Box
        sx={{
          position: 'absolute',
          left: '50%',
          top: 0,
          bottom: 0,
          width: 2,
          bgcolor: 'primary.main',
          transform: 'translateX(-50%)',
          zIndex: 1
        }}
      />
      
      {timelineData.map((item, index) => (
        <motion.div
          key={item.id}
          initial={{ opacity: 0, x: index % 2 === 0 ? -50 : 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6, delay: index * 0.2 }}
          viewport={{ once: true }}
        >
          <Box
            sx={{
              display: 'flex',
              alignItems: 'center',
              mb: 4,
              flexDirection: index % 2 === 0 ? 'row' : 'row-reverse'
            }}
          >
            {/* Content */}
            <Box
              sx={{
                flex: 1,
                textAlign: index % 2 === 0 ? 'right' : 'left',
                pr: index % 2 === 0 ? 4 : 0,
                pl: index % 2 === 0 ? 0 : 4
              }}
            >
              <Paper
                elevation={3}
                sx={{
                  p: 3,
                  borderRadius: 3,
                  background: `linear-gradient(135deg, ${item.color}15, ${item.color}05)`,
                  border: `1px solid ${item.color}30`
                }}
              >
                <Typography variant="h6" color="primary" gutterBottom>
                  {item.year}
                </Typography>
                <Typography variant="h5" gutterBottom fontWeight="bold">
                  {item.title}
                </Typography>
                <Typography variant="subtitle1" color="text.secondary" gutterBottom>
                  {item.subtitle}
                </Typography>
                <Typography variant="body2">
                  {item.description}
                </Typography>
              </Paper>
            </Box>

            {/* Icon */}
            <Box
              sx={{
                position: 'relative',
                zIndex: 2,
                width: 60,
                height: 60,
                borderRadius: '50%',
                bgcolor: item.color,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: 'white',
                boxShadow: 3,
                mx: 2
              }}
            >
              {item.icon}
            </Box>

            {/* Empty space for alignment */}
            <Box sx={{ flex: 1 }} />
          </Box>
        </motion.div>
      ))}
    </Box>
  );
});

function App() {
  const [mode, setMode] = useState<'light' | 'dark'>('light');
  const [selectedProject, setSelectedProject] = useState<any>(null);
  const [modalOpen, setModalOpen] = useState(false);
  
  const colorMode = useMemo(
    () => ({
      toggleColorMode: () => {
        setMode((prevMode) => (prevMode === 'light' ? 'dark' : 'light'));
      },
    }),
    [],
  );

  const handleProjectClick = useCallback((project: any) => {
    setSelectedProject(project);
    setModalOpen(true);
  }, []);

  const handleModalClose = useCallback(() => {
    setModalOpen(false);
    setSelectedProject(null);
  }, []);

  const theme = useMemo(
    () =>
      createTheme({
        palette: {
          mode,
          primary: { main: deepPurple[500] },
          secondary: { main: teal[400] },
          background: {
            default: mode === 'light' ? '#F3F0FF' : '#121212',
            paper: mode === 'light' ? '#fff' : '#1E1E1E',
          },
          text: {
            primary: mode === 'light' ? '#1A1A1A' : '#FFFFFF',
            secondary: mode === 'light' ? '#666666' : '#B0B0B0',
          },
        },
        typography: {
          fontFamily: 'Roboto, Arial',
          h1: { fontWeight: 900, fontSize: '3rem', letterSpacing: '-2px' },
          h2: { fontWeight: 700, fontSize: '2rem' },
          h3: { fontWeight: 700, fontSize: '1.5rem' },
          h4: { fontWeight: 700, fontSize: '1.25rem' },
          h5: { fontWeight: 700, fontSize: '1rem' },
          h6: { fontWeight: 700, fontSize: '0.875rem' },
        },
        shape: { borderRadius: 20 },
      }),
    [mode],
  );

  const heroVariants = {
    hidden: { opacity: 0, y: 40 },
    visible: { opacity: 1, y: 0, transition: { duration: 1 } },
  };

  const TypingEffect = React.memo(({ text }: { text: string }) => {
    const [displayed, setDisplayed] = React.useState('');
    React.useEffect(() => {
      let i = 0;
      const interval = setInterval(() => {
        setDisplayed(text.slice(0, i + 1));
        i++;
        if (i === text.length) clearInterval(interval);
      }, 60);
      return () => clearInterval(interval);
    }, [text]);
    return <span style={{ borderRight: '2px solid', paddingRight: 2 }}>{displayed}</span>;
  });

  const HeroSection = React.memo(() => (
    <Box sx={{
      minHeight: '60vh',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      background: mode === 'light' 
        ? 'linear-gradient(120deg, #7C3AED 0%, #06B6D4 100%)'
        : 'linear-gradient(120deg, #4C1D95 0%, #0E7490 100%)',
      color: '#fff',
      borderRadius: 6,
      boxShadow: 3,
      mt: 4,
      mb: 6,
      position: 'relative',
      overflow: 'hidden',
    }}>
      <motion.div initial="hidden" animate="visible" variants={heroVariants}>
        <Avatar sx={{ width: 100, height: 100, mb: 2, bgcolor: 'secondary.main', fontSize: 48 }}>BNL</Avatar>
        <Typography variant="h1" sx={{ mb: 1, textShadow: '0 4px 24px #0004' }}>Bjarne Niklas Luttermann</Typography>
        <Typography variant="h4" sx={{ mb: 2, fontWeight: 400 }}>
          <TypingEffect text="Medieninformatik Masterstudent · Creative Technologist · Future-Ready" />
        </Typography>
        <Stack direction="row" spacing={2} justifyContent="center">
          <Chip label="Innovation" color="primary" variant="filled" />
          <Chip label="UX/UI" color="secondary" variant="outlined" />
          <Chip label="AI & Media" color="primary" variant="outlined" />
          <Chip label="Gamification" color="secondary" variant="filled" />
        </Stack>
      </motion.div>
      {/* Subtle animated background shapes */}
      <motion.div animate={{ x: [0, 40, -40, 0] }} transition={{ repeat: Infinity, duration: 12 }} style={{ position: 'absolute', top: 0, left: 0, width: 200, height: 200, background: 'rgba(255,255,255,0.07)', borderRadius: '50%', filter: 'blur(24px)' }} />
      <motion.div animate={{ y: [0, 30, -30, 0] }} transition={{ repeat: Infinity, duration: 10 }} style={{ position: 'absolute', bottom: 0, right: 0, width: 180, height: 180, background: 'rgba(255,255,255,0.09)', borderRadius: '50%', filter: 'blur(32px)' }} />
    </Box>
  ));

  const HomePage = React.memo(() => (
    <>
      <HeroSection />
      <Typography variant="h3" sx={{ mb: 2 }}>Über mich</Typography>
      <Typography variant="body1" sx={{ mb: 4, maxWidth: 700 }}>
        Ich bin ein kreativer Medieninformatik-Masterstudent mit Fokus auf innovative, interaktive und zukunftsweisende Medienlösungen. Mein Portfolio zeigt Projekte aus den Bereichen KI, UX/UI, Gamification und mehr.
      </Typography>
      <SkillsSection />
    </>
  ));

  const ProjectsPage = React.memo(() => (
    <Box>
      <Typography variant="h2" gutterBottom sx={{ mb: 4 }}>Projekte</Typography>
      <Box sx={{ display: 'grid', gridTemplateColumns: { xs: '1fr', md: '1fr 1fr', lg: '1fr 1fr 1fr' }, gap: 3 }}>
        {projectData.map((project) => (
          <Box key={project.id}>
            <motion.div
              whileHover={{ y: -8 }}
              transition={{ duration: 0.3 }}
            >
              <Card 
                sx={{ 
                  height: '100%',
                  cursor: 'pointer',
                  boxShadow: 4, 
                  borderRadius: 4, 
                  background: mode === 'light' 
                    ? 'linear-gradient(135deg, #F3E8FF 0%, #E0F7FA 100%)'
                    : 'linear-gradient(135deg, #2D1B69 0%, #0F4C75 100%)',
                  transition: 'all 0.3s ease-in-out',
                  '&:hover': { 
                    boxShadow: 8,
                    transform: 'translateY(-8px)'
                  }
                }}
                onClick={() => handleProjectClick(project)}
              >
                <Box sx={{ position: 'relative' }}>
                  <img 
                    src={project.image} 
                    alt={project.title}
                    style={{ 
                      width: '100%', 
                      height: 200, 
                      objectFit: 'cover',
                      borderTopLeftRadius: 16,
                      borderTopRightRadius: 16
                    }}
                    loading="lazy"
                  />
                  <Chip 
                    label={project.category} 
                    size="small" 
                    sx={{ 
                      position: 'absolute', 
                      top: 8, 
                      right: 8,
                      backgroundColor: 'rgba(0,0,0,0.7)',
                      color: 'white'
                    }} 
                  />
                </Box>
                <CardContent>
                  <Typography variant="h5" gutterBottom>
                    {project.title}
                  </Typography>
                  <Typography variant="subtitle1" color="text.secondary" gutterBottom>
                    {project.subtitle}
                  </Typography>
                  <Typography variant="body2" sx={{ mb: 2 }}>
                    {project.description}
                  </Typography>
                  <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap>
                    {project.techStack.slice(0, 3).map((tech: string) => (
                      <Chip key={tech} label={tech} size="small" variant="outlined" />
                    ))}
                    {project.techStack.length > 3 && (
                      <Chip label={`+${project.techStack.length - 3}`} size="small" />
                    )}
                  </Stack>
                </CardContent>
              </Card>
            </motion.div>
          </Box>
        ))}
      </Box>
      
      <AnimatePresence>
        {modalOpen && selectedProject && (
          <ProjectModal 
            project={selectedProject} 
            open={modalOpen} 
            onClose={handleModalClose} 
          />
        )}
      </AnimatePresence>
    </Box>
  ));

  const ResumePage = React.memo(() => (
    <Box>
      <Typography variant="h2" gutterBottom sx={{ mb: 4 }}>Lebenslauf & Erfahrung</Typography>
      <Timeline />
    </Box>
  ));

  const ContactPage = React.memo(() => (
    <Box>
      <Typography variant="h2" gutterBottom sx={{ mb: 4 }}>Kontakt</Typography>
      <Paper sx={{ p: 4, textAlign: 'center' }}>
        <Avatar sx={{ width: 80, height: 80, mx: 'auto', mb: 2, bgcolor: 'primary.main' }}>
          <Email sx={{ fontSize: 40 }} />
        </Avatar>
        <Typography variant="h4" gutterBottom>
          Lass uns zusammenarbeiten!
        </Typography>
        <Typography variant="body1" sx={{ mb: 3 }}>
          Ich bin immer offen für neue Projekte, Kooperationen und interessante Gespräche über Technologie und Innovation.
        </Typography>
        <Button
          variant="contained"
          size="large"
          startIcon={<Email />}
          href="mailto:aurav.tech@gmail.com"
          sx={{ 
            px: 4, 
            py: 1.5,
            fontSize: '1.1rem',
            background: 'linear-gradient(45deg, #7C3AED 30%, #06B6D4 90%)',
            '&:hover': {
              background: 'linear-gradient(45deg, #6D28D9 30%, #0891B2 90%)',
            }
          }}
        >
          aurav.tech@gmail.com
        </Button>
        <Typography variant="body2" color="text.secondary" sx={{ mt: 2 }}>
          Antwortzeit: innerhalb von 24 Stunden
        </Typography>
      </Paper>
    </Box>
  ));

  return (
    <ColorModeContext.Provider value={colorMode}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
    <Router>
          <AppBar position="sticky" color="primary" enableColorOnDark sx={{ boxShadow: 3 }}>
            <Toolbar>
              <Avatar sx={{ bgcolor: 'secondary.main', mr: 2 }}>BNL</Avatar>
              <Typography variant="h6" sx={{ flexGrow: 1, fontWeight: 700 }}>
                Bjarne Niklas Luttermann
              </Typography>
              <Button color="inherit" component={RouterLink} to="/">Home</Button>
              <Button color="inherit" component={RouterLink} to="/projects">Projekte</Button>
              <Button color="inherit" component={RouterLink} to="/resume">Lebenslauf</Button>
              <Button color="inherit" component={RouterLink} to="/contact">Kontakt</Button>
              <IconButton color="inherit" onClick={colorMode.toggleColorMode} sx={{ ml: 1 }}>
                {mode === 'dark' ? <Brightness7 /> : <Brightness4 />}
              </IconButton>
            </Toolbar>
          </AppBar>
          <Container sx={{ mt: 4, mb: 8 }}>
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/projects" element={<ProjectsPage />} />
          <Route path="/resume" element={<ResumePage />} />
          <Route path="/contact" element={<ContactPage />} />
        </Routes>
          </Container>
    </Router>
      </ThemeProvider>
    </ColorModeContext.Provider>
  );
}

export default App;
