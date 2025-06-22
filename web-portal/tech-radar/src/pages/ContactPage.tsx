import React from 'react';
import { useTranslation } from 'react-i18next';
import './ContactPage.css'; // We'll create this CSS file next

const ContactPage: React.FC = () => {
  const { t } = useTranslation();

  const emailAddress = 'info@auravention.com'; // Replace with actual contact email
  const emailSubject = t('contact.emailSubject', 'Contact Request via JamBam Platform');

  return (
    <div className="contact-page-container">
      <header className="contact-page-header">
        <h1>{t('contact.title', 'Contact Us')}</h1>
        <p>{t('contact.subtitle', 'We are here to help and answer any questions you might have.')}</p>
      </header>

      <section className="contact-info-section">
        <h2>{t('contact.infoTitle', 'Get in Touch')}</h2>
        <p>
          {t('contact.intro', 'For any inquiries, support requests, or feedback, please feel free to reach out to us. The best way to contact us is by email.')}
        </p>
        <div className="contact-method">
          <i className="fas fa-envelope icon"></i>
          <div>
            <strong>{t('contact.emailLabel', 'Email Us:')}</strong>
            <br />
            <a href={`mailto:${emailAddress}?subject=${encodeURIComponent(emailSubject)}`} className="email-link">
              {emailAddress}
            </a>
          </div>
        </div>
        <p className="contact-response-time">
          {t('contact.responseTime', 'We aim to respond to all inquiries within 24-48 business hours.')}
        </p>
      </section>

      <section className="additional-info-section">
        <h2>{t('contact.additionalInfoTitle', 'Additional Information')}</h2>
        <p>
          {t('contact.faqInfo', 'You might also find answers to common questions in our FAQ section (link to be added) or through our community forums.')}
        </p>
        {/* Placeholder for links to FAQ or Community Hub if available */}
        {/*
        <p>
          <Link to="/faq">{t('contact.visitFaq', 'Visit FAQ')}</Link> |
          <Link to="/community">{t('contact.visitCommunity', 'Visit Community Hub')}</Link>
        </p>
        */}
      </section>
    </div>
  );
};

export default ContactPage;
