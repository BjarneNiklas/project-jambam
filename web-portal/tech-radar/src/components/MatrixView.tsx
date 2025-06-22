import React, { useMemo } from 'react';
import { useTranslation } from 'react-i18next';
import { TechItem } from '../data/techRadarData';

interface MatrixViewProps {
  data: TechItem[];
}

const MatrixView: React.FC<MatrixViewProps> = ({ data }) => {
  const { t } = useTranslation();

  const groupedData = useMemo(() => {
    const rings = ['adopt', 'trial', 'assess', 'hold'];
    const quadrants = ['languages', 'frameworks', 'tools', 'platforms'];
    
    const grouped: { [ring: string]: { [quadrant: string]: TechItem[] } } = {};
    
    rings.forEach(ring => {
      grouped[ring] = {};
      quadrants.forEach(quadrant => {
        grouped[ring][quadrant] = [];
      });
    });

    data.forEach(item => {
      if (grouped[item.ring] && grouped[item.ring][item.quadrant]) {
        grouped[item.ring][item.quadrant].push(item);
      }
    });

    return grouped;
  }, [data]);

  const getRingColor = (ring: string) => {
    switch (ring) {
      case 'adopt': return '#10b981';
      case 'trial': return '#3b82f6';
      case 'assess': return '#f59e0b';
      case 'hold': return '#ef4444';
      default: return '#6b7280';
    }
  };

  const getRingDescription = (ring: string) => {
    switch (ring) {
      case 'adopt': return t('radar.rings.adopt');
      case 'trial': return t('radar.rings.trial');
      case 'assess': return t('radar.rings.assess');
      case 'hold': return t('radar.rings.hold');
      default: return '';
    }
  };

  const getQuadrantColor = (quadrant: string) => {
    switch (quadrant) {
      case 'languages': return '#ec4899';
      case 'frameworks': return '#8b5cf6';
      case 'tools': return '#06b6d4';
      case 'platforms': return '#84cc16';
      default: return '#6b7280';
    }
  };

  return (
    <div className="matrix-container">
      <div className="matrix-header glass">
        <h2>{t('matrix.title')}</h2>
        <p>{t('matrix.subtitle')}</p>
      </div>

      <div className="matrix-grid">
        {Object.entries(groupedData).map(([ring, quadrants]) => (
          <div key={ring} className="matrix-ring">
            <div 
              className="ring-header"
              style={{ borderLeftColor: getRingColor(ring) }}
            >
              <h3 style={{ color: getRingColor(ring) }}>
                {t(`rings.${ring}`)}
              </h3>
              <p className="ring-description">
                {getRingDescription(ring)}
              </p>
            </div>
            
            <div className="quadrants-grid">
              {Object.entries(quadrants).map(([quadrant, items]) => (
                <div key={quadrant} className="quadrant-section">
                  <div 
                    className="quadrant-header"
                    style={{ borderBottomColor: getQuadrantColor(quadrant) }}
                  >
                    <h4 style={{ color: getQuadrantColor(quadrant) }}>
                      {t(`quadrants.${quadrant}`)}
                    </h4>
                    <span className="item-count">{items.length} {t('matrix.items')}</span>
                  </div>
                  
                  <div className="items-container">
                    {items.length > 0 ? (
                      items.map((item, index) => (
                        <div key={index} className="matrix-item glass">
                          <div className="item-header">
                            <h5>{item.name}</h5>
                            <span 
                              className="category-tag"
                              style={{ backgroundColor: getQuadrantColor(quadrant) }}
                            >
                              {item.category}
                            </span>
                          </div>
                          <p className="item-description">{item.description}</p>
                          <div className="item-meta">
                            <span className="quadrant-tag">{t(`quadrants.${item.quadrant}`)}</span>
                            <span className="ring-tag" style={{ color: getRingColor(item.ring) }}>
                              {t(`rings.${item.ring}`)}
                            </span>
                          </div>
                        </div>
                      ))
                    ) : (
                      <div className="empty-quadrant">
                        <span>{t('matrix.noItems')}</span>
                      </div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>

      <div className="matrix-legend glass">
        <h3>{t('matrix.legend.title')}</h3>
        <div className="legend-content">
          <div className="legend-section">
            <h4>{t('matrix.legend.rings')}</h4>
            <div className="legend-items">
              <div className="legend-item">
                <span className="legend-color" style={{ backgroundColor: '#10b981' }}></span>
                <span>{t('rings.adopt')}</span>
              </div>
              <div className="legend-item">
                <span className="legend-color" style={{ backgroundColor: '#3b82f6' }}></span>
                <span>{t('rings.trial')}</span>
              </div>
              <div className="legend-item">
                <span className="legend-color" style={{ backgroundColor: '#f59e0b' }}></span>
                <span>{t('rings.assess')}</span>
              </div>
              <div className="legend-item">
                <span className="legend-color" style={{ backgroundColor: '#ef4444' }}></span>
                <span>{t('rings.hold')}</span>
              </div>
            </div>
          </div>
          
          <div className="legend-section">
            <h4>{t('matrix.legend.quadrants')}</h4>
            <div className="legend-items">
              <div className="legend-item">
                <span className="legend-color" style={{ backgroundColor: '#ec4899' }}></span>
                <span>{t('quadrants.languages')}</span>
              </div>
              <div className="legend-item">
                <span className="legend-color" style={{ backgroundColor: '#8b5cf6' }}></span>
                <span>{t('quadrants.frameworks')}</span>
              </div>
              <div className="legend-item">
                <span className="legend-color" style={{ backgroundColor: '#06b6d4' }}></span>
                <span>{t('quadrants.tools')}</span>
              </div>
              <div className="legend-item">
                <span className="legend-color" style={{ backgroundColor: '#84cc16' }}></span>
                <span>{t('quadrants.platforms')}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MatrixView; 