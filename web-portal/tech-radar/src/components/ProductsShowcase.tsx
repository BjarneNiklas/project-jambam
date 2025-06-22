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
  Code as TechIcon,
  Group as AudienceIcon,
} from '@mui/icons-material';
import { productsData, ProductCategory } from '../data/productsData';

const getStatusIcon = (status: string) => {
  switch (status) {
    case 'active':
      return <ActiveIcon color="success" />;
    case 'development':
      return <DevelopmentIcon color="warning" />;
    case 'planned':
      return <PlannedIcon color="info" />;
    case 'deprecated':
      return <DeprecatedIcon color="error" />;
    default:
      return <PlannedIcon color="info" />;
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

const ProductsShowcase: React.FC = () => {
    
    return (
    <Fade in timeout={1000}>
      <Box sx={{ p: { xs: 2, md: 4 } }}>
        <Grow in timeout={1200}>
          <Box sx={{ textAlign: 'center', mb: 4 }}>
            <Typography variant="h3" gutterBottom sx={{ fontWeight: 800 }}>
              🚀 Our Products & Services
            </Typography>
            <Typography variant="h6" sx={{ opacity: 0.8, mb: 3 }}>
              Discover our innovative solutions and proprietary technologies
            </Typography>
          </Box>
        </Grow>

        {productsData.map((category: ProductCategory, categoryIndex: number) => (
          <Fade in timeout={1400 + categoryIndex * 200} key={category.name}>
            <Box sx={{ mb: 6 }}>
              <Typography variant="h4" gutterBottom sx={{ fontWeight: 700, mb: 2 }}>
                {category.name}
              </Typography>
              <Typography variant="body1" sx={{ opacity: 0.8, mb: 3 }}>
                {category.description}
              </Typography>

              <Box sx={{ 
                display: 'grid', 
                gridTemplateColumns: { xs: '1fr', md: 'repeat(2, 1fr)', lg: 'repeat(3, 1fr)' },
                gap: 3 
              }}>
                {category.products.map((product, productIndex) => (
                  <Grow in timeout={1600 + productIndex * 100} key={product.name}>
                    <Card
                      sx={{
                        height: '100%',
                        background: 'rgba(255, 255, 255, 0.05)',
                        backdropFilter: 'blur(20px)',
                        border: '1px solid rgba(255, 255, 255, 0.1)',
                        transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                        '&:hover': {
                          transform: 'translateY(-8px)',
                          boxShadow: '0 20px 40px rgba(0, 0, 0, 0.3)',
                          borderColor: 'rgba(255, 255, 255, 0.2)',
                        },
                      }}
                    >
                      <CardContent sx={{ p: 3 }}>
                        {/* Header */}
                        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                          {getStatusIcon(product.status)}
                          <Box sx={{ ml: 1, flexGrow: 1 }}>
                            <Typography variant="h6" sx={{ fontWeight: 700 }}>
                              {product.name}
                            </Typography>
                            <Typography variant="body2" sx={{ opacity: 0.7 }}>
                              {product.category}
                            </Typography>
                          </Box>
                          <Chip
                            label={product.status.toUpperCase()}
                            color={getStatusColor(product.status) as any}
                            size="small"
                            sx={{ fontWeight: 600 }}
                          />
                        </Box>

                        {/* Description */}
                        <Typography variant="body2" sx={{ mb: 3, opacity: 0.9 }}>
                          {product.description}
                        </Typography>

                        <Divider sx={{ my: 2, opacity: 0.3 }} />

                        {/* Features */}
                        <Box sx={{ mb: 3 }}>
                          <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 1, display: 'flex', alignItems: 'center' }}>
                            <FeatureIcon sx={{ mr: 1, fontSize: 16 }} />
                            Key Features
                          </Typography>
                          <List dense sx={{ py: 0 }}>
                            {product.features.slice(0, 3).map((feature, index) => (
                              <ListItem key={index} sx={{ py: 0.5, px: 0 }}>
                                <ListItemIcon sx={{ minWidth: 20 }}>
                                  <Box
                                    sx={{
                                      width: 4,
                                      height: 4,
                                      borderRadius: '50%',
                                      bgcolor: 'primary.main',
                                    }}
                                  />
                                </ListItemIcon>
                                <ListItemText
                                  primary={feature}
                                  primaryTypographyProps={{
                                    variant: 'body2',
                                    sx: { opacity: 0.8, fontSize: '0.85rem' }
                                  }}
                                />
                              </ListItem>
                            ))}
                            {product.features.length > 3 && (
                              <ListItem sx={{ py: 0.5, px: 0 }}>
                                <ListItemText
                                  primary={`+${product.features.length - 3} more features`}
                                  primaryTypographyProps={{
                                    variant: 'body2',
                                    sx: { opacity: 0.6, fontSize: '0.8rem', fontStyle: 'italic' }
                                  }}
                                />
                              </ListItem>
                            )}
                          </List>
                        </Box>

                        {/* Technologies */}
                        <Box sx={{ mb: 3 }}>
                          <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 1, display: 'flex', alignItems: 'center' }}>
                            <TechIcon sx={{ mr: 1, fontSize: 16 }} />
                            Technologies
                          </Typography>
                          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                            {product.technologies.slice(0, 4).map((tech, index) => (
                              <Chip
                                key={index}
                                label={tech}
                                size="small"
                                variant="outlined"
                                sx={{
                                  fontSize: '0.7rem',
                                  borderColor: 'rgba(255, 255, 255, 0.3)',
                                  color: 'rgba(255, 255, 255, 0.8)',
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
                                  color: 'rgba(255, 255, 255, 0.6)',
                                }}
                              />
                            )}
                          </Box>
                        </Box>

                        {/* Target Audience */}
                        <Box>
                          <Typography variant="subtitle2" sx={{ fontWeight: 600, mb: 1, display: 'flex', alignItems: 'center' }}>
                            <AudienceIcon sx={{ mr: 1, fontSize: 16 }} />
                            Target Audience
                          </Typography>
                          <Typography variant="body2" sx={{ opacity: 0.8, fontSize: '0.85rem' }}>
                            {product.targetAudience}
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