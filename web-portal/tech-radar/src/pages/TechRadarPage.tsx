import React, { useState, useMemo, Suspense, lazy } from 'react';
import { useTranslation } from 'react-i18next';
import { FaCheckDouble } from "react-icons/fa6";
import SkeletonLoader from '../components/layout/SkeletonLoader'; // Import SkeletonLoader
import { FaTrash } from "react-icons/fa";

// import TechRadar from '../components/TechRadar';
// import MatrixView from '../components/MatrixView';
import { techRadarData } from '../data/techRadarData';
import { TechItem } from '../data/techRadarData';

const TechRadar = lazy(() => import('../components/TechRadar'));
const MatrixView = lazy(() => import('../components/MatrixView'));

type ViewType = 'radar' | 'matrix';

const normalizeString = (s: string) => s.toLowerCase().replace(/ & /g, '-and-').replace(/ /g, '-');

const TechRadarPage: React.FC = () => {
  const { t } = useTranslation();
  const [currentView, setCurrentView] = useState<ViewType>('radar');
  const [selectedQuadrants, setSelectedQuadrants] = useState<string[]>([]);
  const [selectedRings, setSelectedRings] = useState<string[]>([]);
  const [selectedCategories, setSelectedCategories] = useState<string[]>([]);

  const normalizedTechData = useMemo(() => {
    return techRadarData.items.map((item: TechItem) => ({
      ...item,
      quadrant: normalizeString(item.quadrant),
      ring: normalizeString(item.ring),
    }));
  }, []);
  
  const availableCategories = useMemo(() => {
    const categories = new Set(techRadarData.items.map((item: TechItem) => item.category));
    return Array.from(categories).sort();
  }, []);
  
  const availableQuadrants = useMemo(() => {
    return Array.from(new Set(techRadarData.items.map((item: TechItem) => normalizeString(item.quadrant))));
  }, []);

  const availableRings = useMemo(() => {
    return Array.from(new Set(techRadarData.items.map((item: TechItem) => normalizeString(item.ring))));
  }, []);

  const filteredData = useMemo(() => {
    return normalizedTechData.filter((item: TechItem) => {
      const quadrantMatch = selectedQuadrants.length === 0 || selectedQuadrants.includes(item.quadrant);
      const ringMatch = selectedRings.length === 0 || selectedRings.includes(item.ring);
      const categoryMatch = selectedCategories.length === 0 || selectedCategories.includes(item.category);
      
      return quadrantMatch && ringMatch && categoryMatch;
    });
  }, [normalizedTechData, selectedQuadrants, selectedRings, selectedCategories]);

  return (
    <>
      <div className="view-toggle">
        <button
          className={`toggle-btn ${currentView === 'radar' ? 'active' : ''}`}
          onClick={() => setCurrentView('radar')}
        >
          {t('techradar.viewToggle.radar')}
        </button>
        <button
          className={`toggle-btn ${currentView === 'matrix' ? 'active' : ''}`}
          onClick={() => setCurrentView('matrix')}
        >
          {t('techradar.viewToggle.matrix')}
        </button>
      </div>

      <div className="filters-section glass">
        <h2>{t('filters.title')}</h2>
        
        <div className="filter-group">
            <div className="filter-group-header">
            <h3>{t('filters.categories') || 'Kategorien'}</h3>
            <div className="filter-actions">
              <button onClick={() => setSelectedCategories(availableCategories)} title={t('filters.selectAll') || 'Alle auswählen'}><FaCheckDouble /></button>
              <button onClick={() => setSelectedCategories([])} title={t('filters.clearAll') || 'Alle löschen'}><FaTrash /></button>
            </div>
          </div>
            <div className="filter-options category-options">
            {availableCategories.map(category => (
              <label key={category} className="filter-chip">
                <input
                  type="checkbox"
                  checked={selectedCategories.includes(category)}
                  onChange={(e) => {
                    const newSelection = e.target.checked
                      ? [...selectedCategories, category]
                      : selectedCategories.filter(c => c !== category);
                    setSelectedCategories(newSelection);
                  }}
                />
                <span>{t(`categories.${category}`, category)}</span>
              </label>
            ))}
          </div>
        </div>

        <div className="filter-group">
          <div className="filter-group-header">
            <h3>{t('filters.quadrants') || 'Quadranten'}</h3>
            <div className="filter-actions">
              <button onClick={() => setSelectedQuadrants(availableQuadrants)} title={t('filters.selectAll') || 'Alle auswählen'}><FaCheckDouble /></button>
              <button onClick={() => setSelectedQuadrants([])} title={t('filters.clearAll') || 'Alle löschen'}><FaTrash /></button>
            </div>
          </div>
          <div className="filter-options">
            {availableQuadrants.map(quadrant => (
              <label key={quadrant} className="filter-chip">
                <input
                  type="checkbox"
                  checked={selectedQuadrants.includes(quadrant)}
                  onChange={(e) => {
                    const newSelection = e.target.checked
                      ? [...selectedQuadrants, quadrant]
                      : selectedQuadrants.filter(q => q !== quadrant);
                    setSelectedQuadrants(newSelection);
                  }}
                />
                <span>{t(`quadrants.${quadrant}`)}</span>
              </label>
            ))}
          </div>
        </div>

        <div className="filter-group">
            <div className="filter-group-header">
              <h3>{t('filters.rings') || 'Ringe'}</h3>
              <div className="filter-actions">
                <button onClick={() => setSelectedRings(availableRings)} title={t('filters.selectAll') || 'Alle auswählen'}><FaCheckDouble /></button>
                <button onClick={() => setSelectedRings([])} title={t('filters.clearAll') || 'Alle löschen'}><FaTrash /></button>
              </div>
            </div>
          <div className="filter-options">
            {availableRings.map(ring => (
              <label key={ring} className="filter-chip">
                <input
                  type="checkbox"
                  checked={selectedRings.includes(ring)}
                  onChange={(e) => {
                    const newSelection = e.target.checked
                      ? [...selectedRings, ring]
                      : selectedRings.filter(r => r !== ring);
                    setSelectedRings(newSelection);
                  }}
                />
                <span>{t(`rings.${ring}`)}</span>
              </label>
            ))}
          </div>
        </div>

        <div className="results-info">
          {t('filters.showing', { count: filteredData.length, total: techRadarData.items.length }) || 
           `Zeige ${filteredData.length} von ${techRadarData.items.length} Technologien`}
        </div>
      </div>

      <div className="content-section">
        <Suspense fallback={<SkeletonLoader type="card" height="400px" />}>
          {currentView === 'radar' && <TechRadar data={filteredData} />}
          {currentView === 'matrix' && <MatrixView data={filteredData} />}
        </Suspense>
      </div>
    </>
  );
}

export default TechRadarPage; 