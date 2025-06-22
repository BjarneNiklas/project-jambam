import React from 'react';
import {
  Box,
  Typography,
  Card,
  CardContent,
  Chip,
  Fade,
  Grow,
  Divider,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
} from '@mui/material';
import {
  CheckCircle as ActiveIcon,
  Build as DevelopmentIcon,
  Schedule as PlannedIcon,
  Block as DeprecatedIcon,
  Star as FeatureIcon,
  Code,
  Group,
  Category as CategoryIcon,
  NewReleases as NewReleasesIcon,
  TrendingUp as TrendingUpIcon,
  BuildCircle as BuildCircleIcon,
  School as SchoolIcon,
  SportsEsports as SportsEsportsIcon,
} from '@mui/icons-material';
import { productsData, ProductCategory } from '../data/productsData';
import { useTranslation } from 'react-i18next';
import { Theme, Palette, PaletteColor } from '@mui/material/styles';

const getStatusIcon = (status: string) => {
  switch (status) {
    case 'active':
      return <ActiveIcon color="success" sx={{ fontSize: '1.2rem' }} />;
    case 'development':
      return <DevelopmentIcon color="warning" sx={{ fontSize: '1.2rem' }} />;
    case 'planned':
      return <PlannedIcon color="info" sx={{ fontSize: '1.2rem' }} />;
    case 'deprecated':
      return <DeprecatedIcon color="error" sx={{ fontSize: '1.2rem' }} />;
    default:
      return <PlannedIcon color="info" sx={{ fontSize: '1.2rem' }} />;
  }
};

const getStatusColor = (status: string) => {
  switch (status) {
    case 'active':
      return 'success';
    case 'development':
      return 'warning';
    case 'planned':
      return 'info';
    case 'deprecated':
      return 'error';
    default:
      return 'info';
  }
};

const getCategoryIcon = (categoryName: string) => {
  if (categoryName.includes("Engines") || categoryName.includes("Engine")) return <BuildCircleIcon sx={{ mr: 1.5, color: 'primary.main' }} />;
  if (categoryName.includes("AI") || categoryName.includes("KI")) return <NewReleasesIcon sx={{ mr: 1.5, color: 'secondary.main' }} />;
  if (categoryName.includes("Community")) return <Group sx={{ mr: 1.5, color: 'success.main' }} />;
  if (categoryName.includes("Development Tools")) return <Code sx={{ mr: 1.5, color: 'warning.main' }} />;
  if (categoryName.includes("Educational") || categoryName.includes("Training")) return <SchoolIcon sx={{ mr: 1.5, color: 'info.main' }} />;
  if (categoryName.includes("Entertainment") || categoryName.includes("Gaming")) return <SportsEsportsIcon sx={{ mr: 1.5, color: 'error.main' }} />;
  return <CategoryIcon sx={{ mr: 1.5, color: 'grey.500' }} />;
};


const ProductsShowcase: React.FC = () => {
  const { t } = useTranslation();

  return (
    <Fade in timeout={1000}>
      <Box sx={{ p: { xs: 2, md: 4 }, background: 'linear-gradient(to bottom, rgba(0,0,0,0.1), rgba(0,0,0,0.3))', borderRadius: 2, mt: 2 }}>
        <Grow in timeout={1200}>
          <Box sx={{ textAlign: 'center', mb: {xs: 4, md: 6} }}>
            <Typography variant="h2" gutterBottom sx={{ fontWeight: 800, color: 'primary.contrastText', textShadow: '1px 1px 3px rgba(0,0,0,0.5)' }}>
              {t('products.mainTitle')}
            </Typography>
            <Typography variant="h5" sx={{ opacity: 0.9, color: 'primary.contrastText', mb: 3 }}>
              {t('products.mainSubtitle')}
            </Typography>
          </Box>
        </Grow>

        {productsData.map((category: ProductCategory, categoryIndex: number) => (
          <Fade in timeout={1400 + categoryIndex * 200} key={t(category.nameKey)}>
            <Box sx={{ mb: 6, p: {xs: 2, md:3}, background: 'rgba(0, 0, 0, 0.2)', borderRadius: 2, boxShadow: 'inset 0 0 10px rgba(0,0,0,0.5)' }}>
              <Box sx={{display: 'flex', alignItems: 'center', mb: 2}}>
                {getCategoryIcon(t(category.nameKey))}
                <Typography variant="h4" gutterBottom sx={{ fontWeight: 700, color: 'primary.contrastText', mb: 0 }}>
                  {t(category.nameKey)}
                </Typography>
              </Box>
              <Typography variant="body1" sx={{ opacity: 0.8, color: 'primary.contrastText', mb: 4, ml: 5 }}>
                {t(category.descriptionKey)}
              </Typography>

              <Box sx={{
                display: 'grid',
                gridTemplateColumns: { xs: '1fr', sm: 'repeat(auto-fit, minmax(340px, 1fr))' },
                gap: {xs: 2, md: 3}
              }}>
                {category.products.map((product, productIndex) => (
                  <Grow in timeout={1600 + productIndex * 100} key={t(product.nameKey)}>
                    <Card
                      sx={{
                        height: '100%',
                        display: 'flex',
                        flexDirection: 'column',
                        background: 'rgba(255, 255, 255, 0.08)', // Slightly more opaque for better readability
                        backdropFilter: 'blur(15px)', // Reduced blur for performance
                        border: '1px solid rgba(255, 255, 255, 0.15)',
                        transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                        '&:hover': {
                          transform: 'translateY(-10px) scale(1.02)', // Enhanced hover effect
                          boxShadow: '0 25px 50px rgba(0, 0, 0, 0.4)',
                          borderColor: 'rgba(255, 255, 255, 0.3)',
                        },
                         boxShadow: '0 8px 16px rgba(0,0,0,0.2)', // Initial shadow
                      }}
                    >
                      <CardContent sx={{ p: {xs: 2, md:3}, flexGrow: 1, display: 'flex', flexDirection: 'column' }}>
                        {/* Header */}
                        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2.5 }}>
                          {getStatusIcon(product.status)}
                          <Box sx={{ ml: 1.5, flexGrow: 1 }}>
                            <Typography variant="h6" sx={{ fontWeight: 700, color: 'common.white' }}>
                              {t(product.nameKey)}
                            </Typography>
                            <Typography variant="caption" sx={{ opacity: 0.7, color: 'grey.300', display: 'block' }}>
                              {t(product.categoryKey)}
                            </Typography>
                          </Box>
                          <Chip
                            label={t(`products.status.${product.status}`)}
                            color={getStatusColor(product.status) as any}
                            size="small"
                            sx={{ fontWeight: 600, color: 'common.white', background: (theme: Theme) => {
                              const palette = theme.palette as Palette;
                              const colorKey = getStatusColor(product.status) as keyof Palette;
                              const colorObj = palette[colorKey];
                              if (colorObj && typeof colorObj === 'object' && 'dark' in colorObj) {
                                return (colorObj as PaletteColor).dark;
                              }
                              return palette.primary.dark;
                            } }}
                          />
                        </Box>

                        {/* Description */}
                        <Typography variant="body2" sx={{ mb: 2.5, opacity: 0.9, color: 'grey.200', flexGrow: 1, minHeight: '60px' }}>
                          {t(product.descriptionKey)}
                        </Typography>

                        <Divider sx={{ my: 2, borderColor: 'rgba(255, 255, 255, 0.2)' }} />

                        {/* Features */}
                        <Box sx={{ mb: 2.5 }}>
                          <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 1, display: 'flex', alignItems: 'center', color: 'grey.100' }}>
                            <FeatureIcon sx={{ mr: 1, fontSize: '1rem', color: 'primary.light' }} />
                            {t('products.keyFeatures')}
                          </Typography>
                          <List dense sx={{ py: 0 }}>
                            {product.featureKeys.slice(0, 3).map((featureKey, index) => (
                              <ListItem key={index} sx={{ py: 0.2, px: 0 }}>
                                <ListItemIcon sx={{ minWidth: 20 }}>
                                  <Box
                                    sx={{
                                      width: 6,
                                      height: 6,
                                      borderRadius: '50%',
                                      bgcolor: 'primary.light',
                                      opacity: 0.8
                                    }}
                                  />
                                </ListItemIcon>
                                <ListItemText
                                  primary={t(featureKey)}
                                  primaryTypographyProps={{
                                    variant: 'body2',
                                    sx: { opacity: 0.85, color: 'grey.300', fontSize: '0.8rem' }
                                  }}
                                />
                              </ListItem>
                            ))}
                            {product.featureKeys.length > 3 && (
                              <ListItem sx={{ py: 0.2, px: 0 }}>
                                 <ListItemIcon sx={{ minWidth: 20 }} />
                                <ListItemText
                                  primary={`+${product.featureKeys.length - 3} ${t('products.moreFeatures')}`}
                                  primaryTypographyProps={{
                                    variant: 'caption',
                                    sx: { opacity: 0.7, color: 'grey.400', fontStyle: 'italic' }
                                  }}
                                />
                              </ListItem>
                            )}
                          </List>
                        </Box>

                        {/* Technologies */}
                        <Box sx={{ mb: 2.5 }}>
                          <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 1, display: 'flex', alignItems: 'center', color: 'grey.100' }}>
                            <Code sx={{ mr: 1, fontSize: '1rem', color: 'secondary.light' }} />
                            {t('products.technologies')}
                          </Typography>
                          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.75 }}>
                            {product.technologies.slice(0, 4).map((tech, index) => (
                              <Chip
                                key={index}
                                label={tech}
                                size="small"
                                variant="outlined"
                                sx={{
                                  fontSize: '0.7rem',
                                  borderColor: 'rgba(255, 255, 255, 0.4)',
                                  color: 'rgba(255, 255, 255, 0.85)',
                                  backgroundColor: 'rgba(255,255,255,0.05)'
                                }}
                              />
                            ))}
                            {product.technologies.length > 4 && (
                              <Chip
                                label={`+${product.technologies.length - 4}`}
                                size="small"
                                variant="outlined"
                                sx={{
                                  fontSize: '0.7rem',
                                  borderColor: 'rgba(255, 255, 255, 0.3)',
                                  color: 'rgba(255, 255, 255, 0.7)',
                                   backgroundColor: 'rgba(255,255,255,0.05)'
                                }}
                              />
                            )}
                          </Box>
                        </Box>

                        {/* Target Audience */}
                        <Box>
                          <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 0.5, display: 'flex', alignItems: 'center', color: 'grey.100' }}>
                            <Group sx={{ mr: 1, fontSize: '1rem', color: 'success.light' }} />
                            {t('products.targetAudience')}
                          </Typography>
                          <Typography variant="body2" sx={{ opacity: 0.85, color: 'grey.300', fontSize: '0.8rem' }}>
                            {t(product.targetAudienceKey)}
                          </Typography>
                        </Box>
                      </CardContent>
                    </Card>
                  </Grow>
                ))}
              </Box>
            </Box>
          </Fade>
        ))}
      </Box>
    </Fade>
  );
};

export default ProductsShowcase; 