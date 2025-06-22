/** @jsxImportSource @emotion/react */
import React from 'react';
import { css } from '@emotion/react';
import LogoHexSpark from './LogoHexSpark';

const demoStyle = css`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
  color: white;
  font-family: 'Inter', sans-serif;
  padding: 20px;
  
  .demo-container {
    text-align: center;
    max-width: 600px;
  }
  
  .title {
    font-size: 2.5rem;
    font-weight: bold;
    margin-bottom: 1rem;
    background: linear-gradient(135deg, #00d4aa, #8b5cf6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  
  .subtitle {
    font-size: 1.2rem;
    color: #a1a1aa;
    margin-bottom: 3rem;
    line-height: 1.6;
  }
  
  .logo-section {
    margin-bottom: 3rem;
  }
  
  .instruction {
    font-size: 1rem;
    color: #71717a;
    margin-top: 1rem;
    font-style: italic;
  }
  
  .animation-description {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    padding: 1.5rem;
    margin-top: 2rem;
    text-align: left;
  }
  
  .animation-description h3 {
    color: #00d4aa;
    margin-bottom: 1rem;
    font-size: 1.3rem;
  }
  
  .animation-step {
    display: flex;
    align-items: center;
    margin-bottom: 0.8rem;
    padding: 0.5rem;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.02);
  }
  
  .step-number {
    background: linear-gradient(135deg, #8b5cf6, #ec4899);
    color: white;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.8rem;
    font-weight: bold;
    margin-right: 1rem;
    flex-shrink: 0;
  }
  
  .step-text {
    color: #d1d5db;
    font-size: 0.95rem;
  }
  
  .features {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
    margin-top: 2rem;
  }
  
  .feature {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 12px;
    padding: 1.5rem;
    text-align: center;
  }
  
  .feature-icon {
    font-size: 2rem;
    margin-bottom: 1rem;
  }
  
  .feature-title {
    font-size: 1.1rem;
    font-weight: 600;
    color: #00d4aa;
    margin-bottom: 0.5rem;
  }
  
  .feature-description {
    color: #a1a1aa;
    font-size: 0.9rem;
    line-height: 1.5;
  }
`;

const LogoDemo: React.FC = () => {
  const handleLogoClick = () => {
    console.log('Logo clicked! Animation sequence started.');
  };

  return (
    <div css={demoStyle}>
      <div className="demo-container">
        <h1 className="title">JamBam Interactive Logo</h1>
        <p className="subtitle">
          Ein begeisterungsvolles, interaktives Logo mit einer magischen Animation: 
          Samen → Baum → Blitz
        </p>
        
        <div className="logo-section">
          <LogoHexSpark onClick={handleLogoClick} />
          <p className="instruction">
            Klicke auf das Logo, um die Animation zu starten!
          </p>
        </div>
        
        <div className="animation-description">
          <h3>🎬 Animation Sequence</h3>
          <div className="animation-step">
            <div className="step-number">1</div>
            <div className="step-text">
              <strong>Samen-Phase (0.8s):</strong> Ein kleiner Samen erscheint und hüpft begeistert
            </div>
          </div>
          <div className="animation-step">
            <div className="step-number">2</div>
            <div className="step-text">
              <strong>Wachstums-Phase (2s):</strong> Der Samen wächst in mehreren Stufen zu einem prächtigen Baum
            </div>
          </div>
          <div className="animation-step">
            <div className="step-number">3</div>
            <div className="step-text">
              <strong>Blitz-Phase (1.5s):</strong> Ein goldener Blitz schlägt ein und erleuchtet das Hexagon
            </div>
          </div>
        </div>
        
        <div className="features">
          <div className="feature">
            <div className="feature-icon">⚡</div>
            <div className="feature-title">Blitz-Symbol</div>
            <div className="feature-description">
              Das Hexagon enthält jetzt ein goldenes Blitz-Symbol, das die Energie und Innovation symbolisiert
            </div>
          </div>
          <div className="feature">
            <div className="feature-icon">🌱</div>
            <div className="feature-title">Wachstum & Entwicklung</div>
            <div className="feature-description">
              Die Samen-zu-Baum Animation zeigt den natürlichen Entwicklungsprozess und das Potenzial
            </div>
          </div>
          <div className="feature">
            <div className="feature-icon">🎯</div>
            <div className="feature-title">Interaktiv & Responsiv</div>
            <div className="feature-description">
              Klickbare Animation mit Hover-Effekten und sanften Übergängen für beste UX
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LogoDemo; 