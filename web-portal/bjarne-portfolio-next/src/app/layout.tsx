import './globals.css';
import type { Metadata } from 'next';
import ThemeRegistry from '../components/ThemeRegistry';
import Sidebar from '../components/Sidebar';
import ProgressBar from '../components/ProgressBar';
import Footer from '../components/Footer';

export const metadata: Metadata = {
  title: 'Bjarne Niklas Luttermann - Media Informatics Portfolio',
  description: 'Portfolio von Bjarne Niklas Luttermann. Spezialisierung: Flutter, Unity, Next-Gen Media Platforms.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="de" className="scroll-smooth">
      <head>
        <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/css/font-awesome/6.4.0/css/all.min.css" />
      </head>
      <body>
        <ThemeRegistry>
          <ProgressBar />
          <div style={{ display: 'flex', minHeight: '100vh', width: '100%' }}>
            <Sidebar />
            <div style={{ 
              flex: 1, 
              minWidth: 0, 
              background: 'none'
            }}>
              {children}
            </div>
          </div>
        </ThemeRegistry>
      </body>
    </html>
  );
}
