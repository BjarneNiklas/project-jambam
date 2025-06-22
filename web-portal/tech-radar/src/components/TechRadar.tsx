import React, { useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { TechItem } from '../data/techRadarData';

interface TechRadarProps {
  data: TechItem[];
}

interface PositionedItem extends TechItem {
  x: number;
  y: number;
}

interface PositionedItemWithBounds extends PositionedItem {
  bounds: {
    quadrant: { start: number; end: number };
    ring: { min: number; max: number };
  }
}

const quadrantConfig = [
  {
    key: 'languages-and-frameworks',
    angle: { start: 270, end: 360 }, // Top-Right
    labelPos: { x: 600, y: 180 }
  },
  {
    key: 'platforms',
    angle: { start: 180, end: 270 }, // Top-Left
    labelPos: { x: 200, y: 180 }
  },
  {
    key: 'tools',
    angle: { start: 90, end: 180 }, // Bottom-Left
    labelPos: { x: 200, y: 620 }
  },
  {
    key: 'techniques',
    angle: { start: 0, end: 90 }, // Bottom-Right
    labelPos: { x: 600, y: 620 }
  }
];

const quadrantMap = new Map(quadrantConfig.map(q => [q.key, q]));

const TechRadar: React.FC<TechRadarProps> = ({ data }) => {
  const { t } = useTranslation();
  const [hoveredItem, setHoveredItem] = useState<PositionedItem | null>(null);
  const [selectedItem, setSelectedItem] = useState<PositionedItem | null>(null);

  const positionedData = useMemo(() => {
    const centerX = 400;
    const centerY = 400;
    const rings: { [key: string]: { radius: number; band: number } } = {
      'adopt': { radius: 50, band: 60 },
      'trial': { radius: 110, band: 80 },
      'assess': { radius: 190, band: 100 },
      'hold': { radius: 290, band: 80 }
    };

    let allPlacedItems: PositionedItemWithBounds[] = [];

    // 1. Group by segment (quadrant + ring)
    const itemsBySegment: { [key: string]: TechItem[] } = {};
    data.forEach(item => {
      const key = `${item.quadrant}_${item.ring}`;
      if (!itemsBySegment[key]) itemsBySegment[key] = [];
      itemsBySegment[key].push(item);
    });

    // 2. Place items with category clustering
    Object.keys(itemsBySegment).forEach(key => {
      const [quadrantKey, ringKey] = key.split('_');
      const segmentItems = itemsBySegment[key];
      const quadrant = quadrantMap.get(quadrantKey);
      const ring = rings[ringKey];
      if (!quadrant || !ring) return;

      const itemsByCategory: { [key: string]: TechItem[] } = {};
      segmentItems.forEach(item => {
        if (!itemsByCategory[item.category]) itemsByCategory[item.category] = [];
        itemsByCategory[item.category].push(item);
      });

      const categoryKeys = Object.keys(itemsByCategory);
      const numCategories = categoryKeys.length;
      const segmentAngleRange = quadrant.angle.end - quadrant.angle.start;

      categoryKeys.forEach((categoryKey, categoryIndex) => {
        const categoryItems = itemsByCategory[categoryKey];
        const categoryAngleStart = quadrant.angle.start + (categoryIndex / numCategories) * segmentAngleRange;
        const categoryAngleRange = segmentAngleRange / numCategories;

        categoryItems.forEach((item) => {
          const angleInDegrees = categoryAngleStart + (Math.random() * 0.8 + 0.1) * categoryAngleRange;
          const angleInRadians = angleInDegrees * (Math.PI / 180);
          const randomRadius = ring.radius + Math.sqrt(Math.random()) * ring.band;
          const x = centerX + Math.cos(angleInRadians) * randomRadius;
          const y = centerY + Math.sin(angleInRadians) * randomRadius;

          allPlacedItems.push({
            ...item, x, y,
            bounds: {
              quadrant: quadrant.angle,
              ring: { min: ring.radius, max: ring.radius + ring.band }
            }
          });
        });
      });
    });

    // 3. Collision avoidance
    const minDistance = 22;
    const iterations = 30;

    const clampPosition = (p: PositionedItemWithBounds) => {
      const dx = p.x - centerX;
      const dy = p.y - centerY;
      let radius = Math.sqrt(dx * dx + dy * dy);
      let angleRad = Math.atan2(dy, dx);
      if (angleRad < 0) angleRad += 2 * Math.PI;
      let angleDeg = angleRad * (180 / Math.PI);
      
      radius = Math.max(Math.min(radius, p.bounds.ring.max), p.bounds.ring.min);

      // Clamp angle to the nearest boundary if it's outside
      const { start, end } = p.bounds.quadrant;
      if (angleDeg < start || angleDeg > end) {
        // Handle wrap-around for top-right quadrant
        if (start === 270 && angleDeg < 90) angleDeg += 360; 
        angleDeg = Math.abs(angleDeg - start) < Math.abs(angleDeg - end) ? start : end;
      }
      
      const finalAngleRad = angleDeg * (Math.PI / 180);
      p.x = centerX + Math.cos(finalAngleRad) * radius;
      p.y = centerY + Math.sin(finalAngleRad) * radius;
    };

    for (let i = 0; i < iterations; i++) {
      for (let j = 0; j < allPlacedItems.length; j++) {
        for (let k = j + 1; k < allPlacedItems.length; k++) {
          const p1 = allPlacedItems[j];
          const p2 = allPlacedItems[k];
          const dx = p2.x - p1.x;
          const dy = p2.y - p1.y;
          const distance = Math.sqrt(dx * dx + dy * dy);

          if (distance < minDistance && distance > 0) {
            const overlap = (minDistance - distance) / 2;
            const pushX = (dx / distance) * overlap;
            const pushY = (dy / distance) * overlap;

            p1.x -= pushX; p1.y -= pushY;
            p2.x += pushX; p2.y += pushY;

            clampPosition(p1);
            clampPosition(p2);
          }
        }
      }
    }
    return allPlacedItems;
  }, [data]);

  const handlePointClick = (item: PositionedItem, e: React.MouseEvent) => {
    e.stopPropagation();
    if (selectedItem && selectedItem.name === item.name) {
      setSelectedItem(null);
    } else {
      setSelectedItem(item);
    }
  };

  const handleBackgroundClick = () => {
    setSelectedItem(null);
  };

  const activeItem = selectedItem || hoveredItem;
  const isItemSelected = !!selectedItem;

  const getRingColor = (ring: string) => {
    switch (ring) {
      case 'adopt': return '#10b981';
      case 'trial': return '#3b82f6';
      case 'assess': return '#f59e0b';
      case 'hold': return '#ef4444';
      default: return '#6b7280';
    }
  };

  const getQuadrantColor = (quadrant: string) => {
    switch (quadrant) {
      case 'languages-and-frameworks': return '#ec4899';
      case 'platforms': return '#8b5cf6';
      case 'tools': return '#06b6d4';
      case 'techniques': return '#84cc16';
      default: return '#6b7280';
    }
  };


  const ringData = [
    { name: 'adopt', radius: 110 },
    { name: 'trial', radius: 190 },
    { name: 'assess', radius: 290 },
    { name: 'hold', radius: 370 },
  ];
  
  return (
    <div className="tech-radar-container" >
      <div className="radar-background" onClick={handleBackgroundClick}>
        <svg width="800" height="800" className="radar-grid">
          <defs>
            <radialGradient id="radarGradient" cx="50%" cy="50%" r="50%">
              <stop offset="0%" stopColor="rgba(99, 102, 241, 0.05)" />
              <stop offset="100%" stopColor="rgba(99, 102, 241, 0)" />
            </radialGradient>
          </defs>
          
          <circle cx="400" cy="400" r="380" fill="url(#radarGradient)" stroke="rgba(255, 255, 255, 0.1)" strokeWidth="1" />
          
          {ringData.map(({name, radius}) => (
            <g key={name} className="radar-ring-label">
              <circle cx="400" cy="400" r={radius} fill="none" stroke="rgba(255, 255, 255, 0.2)" strokeWidth="1" strokeDasharray="5,5" />
              <text x="400" y={400 - radius - 10} textAnchor="middle" >
                {t(`rings.${name}`)}
              </text>
            </g>
          ))}
          
          <line x1="20" y1="400" x2="780" y2="400" stroke="rgba(255, 255, 255, 0.2)" strokeWidth="1" />
          <line x1="400" y1="20" x2="400" y2="780" stroke="rgba(255, 255, 255, 0.2)" strokeWidth="1" />
          
          {quadrantConfig.map(({key, labelPos}) => (
             <text key={key} x={labelPos.x} y={labelPos.y} textAnchor="middle" className="radar-quadrant-label">
                {t(`quadrants.${key}`)}
            </text>
          ))}
        </svg>
        
        <div className="radar-items">
          {positionedData.map((item, index) => (
            <div
              key={index}
              className={`radar-point-wrapper ${isItemSelected && selectedItem?.name !== item.name ? 'dimmed' : ''}`}
              style={{
                left: `${item.x}px`,
                top: `${item.y}px`,
              }}
              onMouseEnter={() => !isItemSelected && setHoveredItem(item)}
              onMouseLeave={() => !isItemSelected && setHoveredItem(null)}
              onClick={(e) => handlePointClick(item, e)}
            >
              <div
                className="radar-point"
                style={{
                  backgroundColor: getRingColor(item.ring),
                  borderColor: getQuadrantColor(item.quadrant),
                  '--ring-color': getRingColor(item.ring)
                } as React.CSSProperties}
              />
            </div>
          ))}
        </div>

        {activeItem && (
          <div 
            className={`radar-tooltip glass ${isItemSelected ? 'sticky' : ''}`}
            style={{
              left: `${activeItem.x}px`,
              top: `${activeItem.y}px`,
              '--ring-color': getRingColor(activeItem.ring),
              '--quadrant-color': getQuadrantColor(activeItem.quadrant),
            } as React.CSSProperties}
          >
            <div className="tooltip-header">
                <h4 style={{ color: getQuadrantColor(activeItem.quadrant) }}>{activeItem.name}</h4>
                <span className="tooltip-ring" style={{ backgroundColor: getRingColor(activeItem.ring) }}>
                  {t(`rings.${activeItem.ring}`)}
                </span>
            </div>
            <p className="tooltip-description">{activeItem.description}</p>
            <span className="tooltip-category">{activeItem.category}</span>
          </div>
        )}
      </div>
      
      <div className="ring-descriptions glass">
        <h3>{t('radar.howToRead')}</h3>
        <div className="rings-grid">
          <div className="ring-description-card" style={{ '--ring-color': '#10b981' } as React.CSSProperties}>
            <h4 style={{ color: '#10b981' }}>{t('rings.adopt')}</h4>
            <p>{t('radar.rings.adopt')}</p>
          </div>
          <div className="ring-description-card" style={{ '--ring-color': '#3b82f6' } as React.CSSProperties}>
            <h4 style={{ color: '#3b82f6' }}>{t('rings.trial')}</h4>
            <p>{t('radar.rings.trial')}</p>
          </div>
          <div className="ring-description-card" style={{ '--ring-color': '#f59e0b' } as React.CSSProperties}>
            <h4 style={{ color: '#f59e0b' }}>{t('rings.assess')}</h4>
            <p>{t('radar.rings.assess')}</p>
          </div>
          <div className="ring-description-card" style={{ '--ring-color': '#ef4444' } as React.CSSProperties}>
            <h4 style={{ color: '#ef4444' }}>{t('rings.hold')}</h4>
            <p>{t('radar.rings.hold')}</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TechRadar; 