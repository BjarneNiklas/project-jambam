import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import {
  Box,
  Paper,
  Typography,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  TextField,
  Chip,
  Stack,
  Button,
  Fade,
  Grow,
  IconButton,
  Tooltip,
  useMediaQuery,
  useTheme,
  Checkbox,
  ListItemText,
  OutlinedInput
} from '@mui/material';
import {
  FilterList as FilterIcon,
  Clear as ClearIcon,
  Search as SearchIcon,
  TrendingUp as TrendingIcon,
  Check as CheckIcon
} from '@mui/icons-material';
import { TechRadarData, TechItem } from '../data/techRadarData';

interface TechnologyFiltersProps {
  data: TechRadarData;
  onFilterChange: (filteredItems: TechItem[]) => void;
}

// Modern Chip Style
const getChipSx = (selected: boolean, color: string, borderColor: string) => ({
  background: selected ? color : 'rgba(255,255,255,0.08)',
  color: selected ? '#fff' : color,
  border: `1.5px solid ${selected ? color : borderColor}`,
  fontWeight: 600,
  boxShadow: selected ? `0 2px 12px 0 ${color}33` : 'none',
  transition: 'all 0.2s cubic-bezier(.4,0,.2,1)',
  px: 1.5,
  py: 0.5,
  '.MuiChip-label': { display: 'flex', alignItems: 'center', gap: 0.5 },
  '&:focus': {
    outline: `2px solid ${color}`,
    outlineOffset: 2,
  },
});

export const TechnologyFilters: React.FC<TechnologyFiltersProps> = ({
  data,
  onFilterChange
}) => {
  const { t } = useTranslation();
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('md'));
  
  const [selectedQuadrants, setSelectedQuadrants] = useState<string[]>([]);
  const [selectedRings, setSelectedRings] = useState<string[]>([]);
  const [searchTerm, setSearchTerm] = useState<string>('');

  // Farben für Quadranten und Ringe
  const quadrantColor = '#6366f1'; // Indigo
  const ringColor = '#ec4899'; // Pink
  const searchColor = '#3b82f6'; // Blue
  const borderColor = 'rgba(255,255,255,0.2)';

  const handleFilterChange = () => {
    let filteredItems = data.items;

    // Filter by quadrants
    if (selectedQuadrants.length > 0) {
      filteredItems = filteredItems.filter(item => selectedQuadrants.includes(item.quadrant));
    }

    // Filter by rings
    if (selectedRings.length > 0) {
      filteredItems = filteredItems.filter(item => selectedRings.includes(item.ring));
    }

    // Filter by search term
    if (searchTerm.trim()) {
      const term = searchTerm.toLowerCase();
      filteredItems = filteredItems.filter(item =>
        item.name.toLowerCase().includes(term) ||
        item.description.toLowerCase().includes(term) ||
        item.quadrant.toLowerCase().includes(term) ||
        item.ring.toLowerCase().includes(term)
      );
    }

    onFilterChange(filteredItems);
  };

  const clearFilters = () => {
    setSelectedQuadrants([]);
    setSelectedRings([]);
    setSearchTerm('');
    onFilterChange(data.items);
  };

  // Update filters when state changes
  useEffect(() => {
    handleFilterChange();
  }, [selectedQuadrants, selectedRings, searchTerm]);

  const hasActiveFilters = selectedQuadrants.length > 0 || selectedRings.length > 0 || searchTerm.length > 0;

  return (
    <Fade in timeout={800}>
      <Paper 
        elevation={0}
        sx={{ 
          p: isMobile ? 2 : 4, 
          m: isMobile ? 1 : 2,
          background: 'rgba(255, 255, 255, 0.08)',
          backdropFilter: 'blur(20px)',
          border: '1px solid rgba(255, 255, 255, 0.1)',
          borderRadius: 4,
          position: 'relative',
          overflow: 'hidden',
          '&::before': {
            content: '""',
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            height: '2px',
            background: 'linear-gradient(90deg, #6366f1 0%, #ec4899 100%)',
          }
        }}
      >
        {/* Header */}
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 3 }}>
          <Box
            sx={{
              width: isMobile ? 40 : 48,
              height: isMobile ? 40 : 48,
              borderRadius: '12px',
              background: 'linear-gradient(135deg, #6366f1 0%, #ec4899 100%)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: 'white',
            }}
          >
            <FilterIcon sx={{ fontSize: isMobile ? '1.2rem' : '1.5rem' }} />
          </Box>
          <Box>
            <Typography variant={isMobile ? "h6" : "h5"} sx={{ fontWeight: 700, mb: 0.5 }}>
              {t('filters.title') || 'Filter'}
            </Typography>
            <Typography variant="body2" sx={{ opacity: 0.7 }}>
              {t('filters.subtitle') || 'Technologien nach verschiedenen Kriterien filtern'}
            </Typography>
          </Box>
        </Box>
        
        {/* Filter Controls */}
        <Box sx={{ 
          display: 'flex', 
          flexDirection: isMobile ? 'column' : 'row',
          flexWrap: 'wrap', 
          gap: isMobile ? 2 : 3, 
          mb: 3 
        }}>
          {/* Quadrant Multi-Select */}
          <Grow in timeout={1000}>
            <Box sx={{ flex: isMobile ? '1 1 100%' : '1 1 200px', minWidth: isMobile ? '100%' : '200px' }}>
              <FormControl fullWidth size={isMobile ? "small" : "medium"}>
                <InputLabel sx={{ color: 'rgba(255, 255, 255, 0.7)' }}>
                  {t('filters.quadrant') || 'Quadrant'}
                </InputLabel>
                <Select
                  multiple
                  value={selectedQuadrants}
                  onChange={(e) => setSelectedQuadrants(e.target.value as string[])}
                  input={<OutlinedInput label={t('filters.quadrant') || 'Quadrant'} />}
                  renderValue={(selected) => (
                    <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                      {selected.map((value) => (
                        <Chip
                          key={value}
                          label={<><CheckIcon sx={{ fontSize: 16, mr: 0.5 }} />{value}</>}
                          size="small"
                          sx={getChipSx(true, quadrantColor, borderColor)}
                          tabIndex={0}
                          aria-checked={true}
                          role="option"
                        />
                      ))}
                    </Box>
                  )}
                  MenuProps={{
                    PaperProps: {
                      sx: {
                        backdropFilter: 'blur(20px)',
                        backgroundColor: 'rgba(30, 30, 30, 0.8)',
                      },
                    },
                  }}
                  sx={{
                    '& .MuiOutlinedInput-notchedOutline': {
                      borderColor: 'rgba(255, 255, 255, 0.2)',
                    },
                  }}
                >
                  {data.quadrants.map((quadrant) => (
                    <MenuItem key={quadrant.name} value={quadrant.name}>
                      <Checkbox checked={selectedQuadrants.indexOf(quadrant.name) > -1} color="default" />
                      <ListItemText primary={quadrant.name} />
                      {selectedQuadrants.indexOf(quadrant.name) > -1 && (
                        <CheckIcon sx={{ color: quadrantColor, ml: 1, fontSize: 18 }} />
                      )}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Box>
          </Grow>

          {/* Ring Multi-Select */}
          <Grow in timeout={1200}>
            <Box sx={{ flex: isMobile ? '1 1 100%' : '1 1 200px', minWidth: isMobile ? '100%' : '200px' }}>
              <FormControl fullWidth size={isMobile ? "small" : "medium"}>
                <InputLabel sx={{ color: 'rgba(255, 255, 255, 0.7)' }}>
                  {t('filters.ring') || 'Ring'}
                </InputLabel>
                <Select
                  multiple
                  value={selectedRings}
                  onChange={(e) => setSelectedRings(e.target.value as string[])}
                  input={<OutlinedInput label={t('filters.ring') || 'Ring'} />}
                  renderValue={(selected) => (
                    <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                      {selected.map((value) => (
                        <Chip
                          key={value}
                          label={<><CheckIcon sx={{ fontSize: 16, mr: 0.5 }} />{value}</>}
                          size="small"
                          sx={getChipSx(true, ringColor, borderColor)}
                          tabIndex={0}
                          aria-checked={true}
                          role="option"
                        />
                      ))}
                    </Box>
                  )}
                  MenuProps={{
                    PaperProps: {
                      sx: {
                        backdropFilter: 'blur(20px)',
                        backgroundColor: 'rgba(30, 30, 30, 0.8)',
                      },
                    },
                  }}
                  sx={{
                    '& .MuiOutlinedInput-notchedOutline': {
                      borderColor: 'rgba(255, 255, 255, 0.2)',
                    },
                  }}
                >
                  {data.rings.map((ring) => (
                    <MenuItem key={ring.name} value={ring.name}>
                      <Checkbox checked={selectedRings.indexOf(ring.name) > -1} color="default" />
                      <ListItemText primary={ring.name} />
                      {selectedRings.indexOf(ring.name) > -1 && (
                        <CheckIcon sx={{ color: ringColor, ml: 1, fontSize: 18 }} />
                      )}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Box>
          </Grow>

          {/* Search Field */}
          <Grow in timeout={1400}>
            <Box sx={{ flex: isMobile ? '1 1 100%' : '2 1 300px', minWidth: isMobile ? '100%' : '300px' }}>
              <TextField
                fullWidth
                size={isMobile ? "small" : "medium"}
                label={t('filters.search') || 'Suche'}
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder={t('filters.searchPlaceholder') || 'Technologien durchsuchen...'}
                InputProps={{
                  startAdornment: <SearchIcon sx={{ mr: 1, opacity: 0.7 }} />,
                }}
                sx={{
                  '& .MuiOutlinedInput-root': { '& fieldset': { borderColor: 'rgba(255, 255, 255, 0.2)' } },
                  '& .MuiInputLabel-root': { color: 'rgba(255, 255, 255, 0.7)' },
                }}
              />
            </Box>
          </Grow>
          
          {/* Clear Button */}
          <Grow in timeout={1600}>
            <Box sx={{ flex: '0 1 auto', alignSelf: isMobile ? 'center' : 'flex-end' }}>
              <Tooltip title={t('filters.clearFilters') || 'Filter löschen'}>
                <IconButton
                  onClick={clearFilters}
                  disabled={!hasActiveFilters}
                  sx={{
                    width: isMobile ? 48 : 56,
                    height: isMobile ? 48 : 56,
                    background: hasActiveFilters 
                      ? 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)'
                      : 'rgba(255, 255, 255, 0.1)',
                    color: 'white',
                    opacity: hasActiveFilters ? 1 : 0.5,
                  }}
                >
                  <ClearIcon />
                </IconButton>
              </Tooltip>
            </Box>
          </Grow>
        </Box>

        {/* Active filters display */}
        {hasActiveFilters && (
          <Fade in timeout={500}>
            <Box sx={{ mt: 3 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                <TrendingIcon sx={{ color: '#6366f1' }} />
                <Typography variant="body2" sx={{ fontWeight: 600, color: '#6366f1' }}>
                  {t('filters.activeFilters') || 'Aktive Filter'}
                </Typography>
              </Box>
              <Stack 
                direction="row" 
                spacing={1} 
                flexWrap="wrap" 
                useFlexGap
                sx={{ gap: 1 }}
              >
                {selectedQuadrants.map((quadrant) => (
                  <Chip
                    key={quadrant}
                    label={<><CheckIcon sx={{ fontSize: 16, mr: 0.5 }} />{t('filters.quadrant') || 'Quadrant'}: {quadrant}</>}
                    size="small"
                    onDelete={() => setSelectedQuadrants(selectedQuadrants.filter(q => q !== quadrant))}
                    sx={getChipSx(true, quadrantColor, borderColor)}
                    tabIndex={0}
                    aria-checked={true}
                    role="option"
                  />
                ))}
                {selectedRings.map((ring) => (
                  <Chip
                    key={ring}
                    label={<><CheckIcon sx={{ fontSize: 16, mr: 0.5 }} />{t('filters.ring') || 'Ring'}: {ring}</>}
                    size="small"
                    onDelete={() => setSelectedRings(selectedRings.filter(r => r !== ring))}
                    sx={getChipSx(true, ringColor, borderColor)}
                    tabIndex={0}
                    aria-checked={true}
                    role="option"
                  />
                ))}
                {searchTerm && (
                  <Chip
                    label={<>{t('filters.search') || 'Suche'}: "{searchTerm}"</>}
                    size="small"
                    onDelete={() => setSearchTerm('')}
                    sx={getChipSx(true, searchColor, borderColor)}
                    tabIndex={0}
                    aria-checked={true}
                    role="option"
                  />
                )}
              </Stack>
            </Box>
          </Fade>
        )}
      </Paper>
    </Fade>
  );
}; 