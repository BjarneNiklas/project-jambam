import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import './HomePage.css';

const HomePage: React.FC = () => {
  const { t } = useTranslation();
  const [email, setEmail] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState('');
  const [waitlistCount, setWaitlistCount] = useState(2330); // Startwert für Social Proof

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (!email.match(/^\S+@\S+\.\S+$/)) {
      setError('Bitte gib eine gültige E-Mail-Adresse ein.');
      return;
    }
    setSubmitted(true);
    setWaitlistCount((c) => c + 1);
    setEmail('');
  };

  return (
    <div className="home-page">
      {/* Statement ganz oben */}
      <section className="statement-section">
        <div className="statement-content">
          <h2 className="statement-title">
            <span className="statement-eyebrow">Die größte Hürde für Indie-Studios:</span><br />
            <span className="highlight-number">9 von 10</span> Spiele-Ideen scheitern, bevor sie überhaupt einen Prototypen erreichen.
          </h2>
          <p className="statement-sub">
            <span className="highlight-claim">Mit JamBam & KI von der <span className="highlight-gradient">Idee zum Prototyp</span> in <span className="highlight-gradient">Stunden statt Wochen</span>.</span><br />
            Wir demokratisieren Spieleentwicklung – für alle, die mehr wollen als nur träumen.
          </p>
        </div>
      </section>

      <section className="hero-section">
        <div className="hero-content">
          <h1 className="hero-title">{t('home.hero.titleNew')}</h1>
          <p className="hero-subtitle">{t('home.hero.subtitleNew')}</p>
          <div className="hero-actions">
            <a 
              href="/tech-radar"
              className="hero-app-button"
            >
              {t('home.hero.primaryCta')}
            </a>
            <a href="/about" className="hero-secondary-button">
              {t('home.hero.learnMore')}
            </a>
          </div>
        </div>
      </section>

      {/* Beta-Warteliste */}
      <section className="beta-signup-section">
        <div className="beta-signup-content">
          <h2>Sei Teil der Revolution!</h2>
          <p>Über <span className="waitlist-highlight">{waitlistCount.toLocaleString()}+</span> Entwickler:innen, Artists und Studios stehen schon auf der Warteliste.<br />
          Trage dich jetzt ein und sichere dir exklusiven Zugang zur JamBam-Beta – bevor alle anderen dabei sind!</p>
          {submitted ? (
            <div className="beta-success">
              <b>Danke für dein Interesse!</b> Du stehst jetzt auf der Warteliste. Wir halten dich auf dem Laufenden.
              <div className="waitlist-count">Schon <b>{waitlistCount.toLocaleString()}+</b> Anmeldungen!</div>
            </div>
          ) : (
            <form className="beta-form" onSubmit={handleSubmit}>
              <input
                type="email"
                placeholder="Deine E-Mail-Adresse"
                value={email}
                onChange={e => setEmail(e.target.value)}
                required
                className="beta-input"
              />
              <button type="submit" className="beta-submit">Jetzt eintragen</button>
              <div className="beta-dsgvo">Mit dem Eintragen stimmst du der Verarbeitung deiner Daten gemäß DSGVO zu. Kein Spam.</div>
              {error && <div className="beta-error">{error}</div>}
            </form>
          )}
        </div>
      </section>

      <section className="features-section">
        <h2>{t('home.features.titleNew')}</h2>
        <div className="features-grid">
          <div className="feature-card">
            <h3>{t('home.features.aiPowered.title')}</h3>
            <p>{t('home.features.aiPowered.description')}</p>
          </div>
          <div className="feature-card">
            <h3>{t('home.features.communityDriven.title')}</h3>
            <p>{t('home.features.communityDriven.description')}</p>
          </div>
          <div className="feature-card">
            <h3>{t('home.features.openInteroperable.title')}</h3>
            <p>{t('home.features.openInteroperable.description')}</p>
          </div>
        </div>
      </section>

      <section className="workflow-section">
        <h2 className="workflow-title">{t('home.workflow.title')}</h2>
        <div className="workflow-grid">
          <div className="workflow-step">
            <div className="workflow-step-number">1</div>
            <h3>{t('home.workflow.step1.title')}</h3>
            <p>{t('home.workflow.step1.description')}</p>
          </div>
          <div className="workflow-step">
            <div className="workflow-step-number">2</div>
            <h3>{t('home.workflow.step2.title')}</h3>
            <p>{t('home.workflow.step2.description')}</p>
          </div>
          <div className="workflow-step">
            <div className="workflow-step-number">3</div>
            <h3>{t('home.workflow.step3.title')}</h3>
            <p>{t('home.workflow.step3.description')}</p>
          </div>
        </div>
      </section>

      <section className="closing-cta-section">
        <div className="closing-cta-content">
          <h2>{t('home.cta.title')}</h2>
          <p>{t('home.cta.subtitle')}</p>
          <a href="/register" className="hero-app-button"> {/* Reusing hero-app-button style for consistency */}
            {t('home.cta.button')}
          </a>
        </div>
      </section>
    </div>
  );
};

export default HomePage;