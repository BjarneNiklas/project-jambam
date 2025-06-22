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
import { alpha } from '@mui/material/styles';
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
              elevation={0} // Remove MUI default shadow if we use custom glass
              sx={{
                // background: 'rgba(255, 255, 255, 0.05)', // Old
                background: `rgba(${theme.palette.mode === 'dark' ? 'var(--card-bg-rgb, 31, 41, 55)' : 'var(--card-bg-rgb, 255, 255, 255)'}, 0.7)`, // Use theme variable
                backdropFilter: 'blur(12px)', // Consistent blur
                border: `1px solid ${theme.palette.divider}`,
                borderRadius: '12px', // Consistent border radius
                '&:before': { display: 'none' }, // Remove MUI's default top border on Accordion
                mb: 2.5, // Increased margin bottom
                transition: 'background 0.3s ease, box-shadow 0.3s ease',
                '&:hover': {
                  // Slightly change background or add a subtle shadow on hover
                  background: `rgba(${theme.palette.mode === 'dark' ? 'var(--card-bg-rgb, 31, 41, 55)' : 'var(--card-bg-rgb, 255, 255, 255)'}, 0.85)`,
                  boxShadow: `0 6px 20px rgba(${theme.palette.mode === 'dark' ? 'var(--shadow-color-rgb, 0,0,0)' : 'var(--shadow-color-rgb, 0,0,0)'}, 0.1)`,
                }
              }}
            >
              <AccordionSummary
                expandIcon={<ExpandMoreIcon sx={{ color: 'text.secondary' }} />}
                sx={{
                  py: 1, px: 2.5, // Adjusted padding
                  '& .MuiAccordionSummary-content': {
                    alignItems: 'center',
                  }
                }}
              >
                <Typography variant="h6" component="div" sx={{ fontWeight: 600, flexGrow: 1 }}> {/* Adjusted weight */}
                  {quadrant}
                </Typography>
                <Chip
                  label={quadrantItems.length}
                  size="small"
                  sx={{
                    ml: 2,
                    background: alpha(theme.palette.text.primary, 0.12), // Theme aware background
                    color: 'text.secondary', // Theme aware text
                    fontWeight: 500,
                  }}
                />
              </AccordionSummary>
              <AccordionDetails sx={{ p: 0, pt: 0 }}>
                <Stack divider={<Divider sx={{ borderColor: alpha(theme.palette.divider, 0.5) }} />}> {/* Softer divider */}
                  {quadrantItems.map((item, index) => (
                    <Box
                      key={item.name}
                      sx={{
                        p: { xs: 2, md: 2.5 }, // Adjusted padding
                        display: 'flex',
                        flexDirection: { xs: 'column', md: 'row' },
                        gap: { xs: 1, md: 2 },
                        transition: 'background-color 0.2s ease',
                        '&:hover': {
                          backgroundColor: alpha(theme.palette.action.hover, 0.05),
                        },
                        // Add top border if not the first item, to visually separate from summary if accordion is collapsed then expanded
                        // borderTop: index === 0 ? 'none' : `1px solid ${alpha(theme.palette.divider, 0.3)}`,
                      }}
                    >
                      <Box sx={{ flex: '1 1 30%', minWidth: '150px' }}>
                        <Typography variant="subtitle1" sx={{ fontWeight: 600 }}>{item.name}</Typography> {/* Upped to subtitle1 */}
                      </Box>
                      <Box sx={{ flex: '0 0 auto', pr: {md: 2}, alignSelf: {xs: 'flex-start', md: 'center'} }}> {/* Auto width, padding right for spacing */}
                        <Chip 
                          label={item.ring}
                          size="small"
                          variant="filled" // Make it filled
                          sx={{
                            color: theme.palette.getContrastText(ringColors[item.ring] || theme.palette.grey[700]), // Ensure contrast
                            fontWeight: '600',
                            backgroundColor: ringColors[item.ring] || theme.palette.grey[700],
                            minWidth: 80,
                            borderRadius: '8px', // Softer radius
                          }}
                        />
                      </Box>
                      <Box sx={{ flex: '1 1 60%' }}>
                        <Typography variant="body2" sx={{ color: 'text.secondary', lineHeight: 1.6 }}>{item.description}</Typography> {/* Improved line height */}
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