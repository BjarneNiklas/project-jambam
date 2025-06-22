import React, { useState, useMemo } from 'react';
import { useTranslation } from 'react-i18next';
import {
  Box,
  Paper,
  Typography,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Chip,
  IconButton,
  Tooltip,
  useTheme,
  Stack,
  Divider,
  Fade,
} from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import SortIcon from '@mui/icons-material/Sort';
import { TechItem, techRadarData } from '../data/techRadarData';

interface TechnologyMatrixProps {
  items: TechItem[];
}

type SortKey = 'name' | 'ring';

const ringOrder: { [key: string]: number } = {
  ADOPT: 0,
  TRIAL: 1,
  ASSESS: 2,
  HOLD: 3,
};

export const TechnologyMatrix: React.FC<TechnologyMatrixProps> = ({ items }) => {
  const { t } = useTranslation();
  const theme = useTheme();
  const [sortBy, setSortBy] = useState<SortKey>('name');

  const ringColors: { [key: string]: string } = {
    ADOPT: theme.palette.success.main,
    TRIAL: theme.palette.warning.main,
    ASSESS: theme.palette.info.main,
    HOLD: theme.palette.error.main,
  };

  const groupedItems = useMemo(() => {
    const groups: { [key: string]: TechItem[] } = {};
    techRadarData.quadrants.forEach(q => {
        groups[q.name] = [];
    });
    
    items.forEach(item => {
      if (groups[item.quadrant]) {
        groups[item.quadrant].push(item);
      }
    });

    // Sort items within each group
    for (const quadrant in groups) {
      groups[quadrant].sort((a, b) => {
        if (sortBy === 'ring') {
          return ringOrder[a.ring] - ringOrder[b.ring];
        }
        return a.name.localeCompare(b.name);
      });
    }

    return groups;
  }, [items, sortBy]);

  const toggleSort = () => {
    setSortBy(prev => (prev === 'name' ? 'ring' : 'name'));
  };

  const tooltipTitle = sortBy === 'name' 
    ? t('matrix.sortBy_ring') 
    : t('matrix.sortBy_name');

  return (
    <Fade in timeout={800}>
      <Box sx={{ p: { xs: 1, md: 2 } }}>
        <Box sx={{ display: 'flex', justifyContent: 'flex-end', alignItems: 'center', mb: 2 }}>
          <Tooltip title={tooltipTitle} arrow>
            <IconButton onClick={toggleSort} color="inherit">
              <SortIcon />
            </IconButton>
          </Tooltip>
        </Box>

        {Object.entries(groupedItems).map(([quadrant, quadrantItems]) => (
          quadrantItems.length > 0 && (
            <Accordion 
              key={quadrant} 
              defaultExpanded
              sx={{
                background: 'rgba(255, 255, 255, 0.05)',
                backdropFilter: 'blur(20px)',
                border: '1px solid rgba(255, 255, 255, 0.1)',
                '&:before': { display: 'none' },
                mb: 2,
              }}
            >
              <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                <Typography variant="h6" sx={{ fontWeight: 700 }}>{quadrant}</Typography>
                <Chip label={quadrantItems.length} size="small" sx={{ ml: 2, background: 'rgba(255, 255, 255, 0.2)' }} />
              </AccordionSummary>
              <AccordionDetails sx={{ p: 0 }}>
                <Stack divider={<Divider sx={{ borderColor: 'rgba(255, 255, 255, 0.1)' }} />}>
                  {quadrantItems.map((item) => (
                    <Box key={item.name} sx={{ p: 3, display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                      <Box sx={{ flex: '1 1 30%' }}>
                        <Typography variant="body1" sx={{ fontWeight: 600 }}>{item.name}</Typography>
                      </Box>
                      <Box sx={{ flex: '0 0 120px' }}>
                        <Chip 
                          label={item.ring}
                          size="small"
                          sx={{
                            color: 'white',
                            fontWeight: 'bold',
                            backgroundColor: ringColors[item.ring] || theme.palette.grey[700],
                            minWidth: 80,
                          }}
                        />
                      </Box>
                      <Box sx={{ flex: '1 1 60%' }}>
                        <Typography variant="body2" sx={{ color: 'text.secondary' }}>{item.description}</Typography>
                      </Box>
                    </Box>
                  ))}
                </Stack>
              </AccordionDetails>
            </Accordion>
          )
        ))}
      </Box>
    </Fade>
  );
}; 