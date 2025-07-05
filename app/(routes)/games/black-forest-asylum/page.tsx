// app/(routes)/games/black-forest-asylum/page.tsx
import React from 'react';
import { FaEnvelope, FaUsers, FaCodeBranch, FaBolt, FaPuzzlePiece, FaMicrophone, FaPalette, FaLightbulb, FaEye, FaTheaterMasks } from 'react-icons/fa'; // Replace lucide-react with react-icons

// --- Reusable Components (can be moved to a components/ folder later) ---

interface SectionProps {
  title?: string;
  subtitle?: string;
  className?: string;
  children: React.ReactNode;
  id?: string;
}

const Section: React.FC<SectionProps> = ({ title, subtitle, className, children, id }) => (
  <section id={id} className={`py-12 md:py-20 ${className || ''}`}>
    <div className="container mx-auto px-4">
      {title && <h2 className="text-3xl md:text-4xl font-bold text-center mb-4 text-red-500">{title}</h2>}
      {subtitle && <p className="text-xl text-center text-gray-400 mb-10 md:mb-12 max-w-3xl mx-auto">{subtitle}</p>}
      {children}
    </div>
  </section>
);

interface HeroProps {
  title: string;
  subtitle: string;
  ctaText: string;
  ctaLink: string;
  imageUrl?: string; // Placeholder for now
}

const HeroSection: React.FC<HeroProps> = ({ title, subtitle, ctaText, ctaLink, imageUrl }) => (
  <div
    className="relative min-h-[70vh] md:min-h-screen flex items-center justify-center text-center bg-gray-900 text-white px-4 py-16"
    style={{
      backgroundImage: `linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), url(${imageUrl || 'https://placehold.co/1920x1080/1a202c/718096?text=Asylum+Corridor'})`,
      backgroundSize: 'cover',
      backgroundPosition: 'center',
    }}
  >
    <div>
      <h1 className="text-5xl md:text-7xl font-bold mb-6 drop-shadow-lg font-creepster">
        {title}
      </h1>
      <p className="text-xl md:text-2xl text-gray-300 mb-8 max-w-2xl mx-auto drop-shadow-md">
        {subtitle}
      </p>
      <a
        href={ctaLink}
        target="_blank" // Assuming external link for Discord
        rel="noopener noreferrer"
        className="bg-red-600 hover:bg-red-700 text-white font-semibold py-3 px-8 rounded-lg text-lg transition duration-300 ease-in-out transform hover:scale-105 shadow-lg"
      >
        {ctaText}
      </a>
    </div>
  </div>
);

interface FeatureCardProps {
  icon?: React.ReactNode;
  title: string;
  description: string;
}

const FeatureCard: React.FC<FeatureCardProps> = ({ icon, title, description }) => (
  <div className="bg-gray-800 p-6 rounded-lg shadow-xl hover:shadow-2xl transition-shadow duration-300 h-full">
    {icon && <div className="text-red-500 mb-4 w-12 h-12 flex items-center justify-center">{icon}</div>}
    <h3 className="text-xl font-semibold text-white mb-2">{title}</h3>
    <p className="text-gray-400 text-sm">{description}</p>
  </div>
);

interface ImageCarouselProps {
  images: { src: string; alt: string; caption?: string }[];
}

const ImageCarousel: React.FC<ImageCarouselProps> = ({ images }) => {
  // Basic carousel, can be enhanced with libraries later
  const [currentIndex, setCurrentIndex] = React.useState(0);

  const nextSlide = () => setCurrentIndex((prev) => (prev === images.length - 1 ? 0 : prev + 1));
  const prevSlide = () => setCurrentIndex((prev) => (prev === 0 ? images.length - 1 : prev - 1));

  if (!images || images.length === 0) return null;

  return (
    <div className="relative w-full max-w-2xl mx-auto shadow-2xl rounded-lg overflow-hidden">
      <img src={images[currentIndex].src} alt={images[currentIndex].alt} className="w-full h-auto object-cover aspect-video" />
      {images[currentIndex].caption && (
        <div className="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white p-2 text-center text-sm">
          {images[currentIndex].caption}
        </div>
      )}
      {images.length > 1 && (
        <>
          <button onClick={prevSlide} className="absolute top-1/2 left-2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75 transition-opacity">‹</button>
          <button onClick={nextSlide} className="absolute top-1/2 right-2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75 transition-opacity">›</button>
        </>
      )}
    </div>
  );
};

// --- Page Content ---

const BlackForestAsylumPage = () => {
  const gameFeatures = [
    {
      icon: <FaEye size={32} />,
      title: 'Immersive Exploration',
      description: "Discover the asylum's secrets by navigating its decaying halls, wards, and hidden areas.",
    },
    {
      icon: <FaTheaterMasks size={32} />, // Using Drama icon for storytelling
      title: 'Environmental Storytelling',
      description: 'Piece together the narrative through scattered notes, patient diaries, staff logs, and environmental clues.',
    },
    {
      icon: <FaPuzzlePiece size={32} />,
      title: 'Challenging Puzzles',
      description: "Solve puzzles that often require understanding the asylum's history or the tormented minds of its former inhabitants.",
    },
    {
      icon: <FaBolt size={32} />, // Using Zap for limited resources/vulnerability
      title: 'Limited Resources & Vulnerability',
      description: 'Rely on limited light sources like flashlights or candles, enhancing the sense of vulnerability.',
    },
  ];

  const overviewImages = [
    { src: 'https://placehold.co/800x450/2d3748/a0aec0?text=Asylum+Exterior+Concept', alt: 'Concept art of the asylum exterior', caption: "The imposing facade of Black Forest Asylum" },
    { src: 'https://placehold.co/800x450/2d3748/a0aec0?text=Decaying+Patient+Room', alt: 'Atmospheric interior shot of a patient room', caption: "Echoes of tormented souls" },
    { src: 'https://placehold.co/800x450/2d3748/a0aec0?text=Old+Medical+Equipment', alt: 'Old, unsettling medical equipment', caption: "Relics of unethical experiments" },
  ];

  const visualAudioImages = [
    { src: 'https://placehold.co/800x450/1a202c/4a5568?text=Dark+Oppressive+Environment', alt: 'Dark, oppressive environment concept', caption: "Decay and the passage of time" },
    { src: 'https://placehold.co/800x450/1a202c/4a5568?text=Dynamic+Lighting+Example', alt: 'Dynamic lighting example', caption: "Light as both savior and betrayer" },
  ];

  return (
    <div className="bg-gray-900 text-gray-300 min-h-screen">
      {/* Import a thematic font - e.g., from Google Fonts in your layout.tsx or global.css */}
      {/* <link href="https://fonts.googleapis.com/css2?family=Creepster&display=swap" rel="stylesheet" /> */}
      {/* Note: For Next.js, font imports are typically handled in _app.tsx or layout.tsx using next/font */}

      <HeroSection
        title="Black Forest Asylum"
        subtitle="Uncover the chilling secrets of a forgotten institution. A Community-Developed Psychological Horror."
        ctaText="Join the Development"
        ctaLink="https://discord.gg/yourserverlink" // Replace with actual Discord link
        imageUrl="https://placehold.co/1920x1080/10151d/4a5568?text=Welcome+to+the+Asylum"
      />

      <Section id="overview" title="The Enigma of Black Forest Asylum" className="bg-gray-800">
        <div className="grid md:grid-cols-2 gap-8 md:gap-12 items-center">
          <div className="prose prose-invert prose-lg max-w-none text-gray-300">
            <p>
              Black Forest Asylum is a community-driven psychological horror and mystery game.
              Set in an abandoned, isolated asylum deep within Germany's Black Forest, the game invites
              players to explore a place with a dark past, filled with unethical experiments and whispered legends
              of strange occurrences.
            </p>
            <p>
              The asylum itself is a key character – a historical, imposing structure now decaying and
              haunted by its history. The horror is primarily psychological, relying on atmosphere, unsettling sound design,
              and the unfolding narrative rather than frequent jump scares.
            </p>
          </div>
          <div>
            <ImageCarousel images={overviewImages} />
          </div>
        </div>
      </Section>

      <Section id="gameplay" title="Descend into Madness: Gameplay" subtitle="Experience the core mechanics that define your terrifying journey.">
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 md:gap-8">
          {gameFeatures.map((feature) => (
            <FeatureCard key={feature.title} icon={feature.icon} title={feature.title} description={feature.description} />
          ))}
        </div>
      </Section>

      <Section id="style" title="A Feast for the Senses: Art & Sound" className="bg-gray-800">
         <div className="grid md:grid-cols-2 gap-8 md:gap-12 items-center">
          <div className="prose prose-invert prose-lg max-w-none text-gray-300">
            <h3 className="text-2xl font-semibold text-red-500 mb-3">Visuals</h3>
            <p>
              Dark, oppressive, and highly detailed environments define the asylum's chilling presence.
              A realistic art style focuses on decay and the passage of time, with dynamic lighting playing a crucial role
              in crafting moments of both terror and fleeting safety.
            </p>
            <h3 className="text-2xl font-semibold text-red-500 mt-6 mb-3">Audio</h3>
            <p>
              Critical immersive sound design features ambient sounds of the old building,
              subtle unsettling noises, and a potentially adaptive soundtrack. Voice acting for audio logs
              will further enhance the deep immersion into the asylum's haunted history.
            </p>
          </div>
          <div>
            <ImageCarousel images={visualAudioImages} />
          </div>
        </div>
      </Section>

      <Section id="community" title="Built by Shadows: A Community Endeavor">
        <div className="max-w-3xl mx-auto text-center">
          <p className="text-lg mb-6">
            Black Forest Asylum is envisioned as a collaborative effort, inviting contributions from
            game developers, writers, artists, and sound designers. The asylum's modular design
            lends itself well to this approach, allowing for diverse talents to shape its horrifying depths.
          </p>
          <div className="grid sm:grid-cols-2 gap-6 my-8 text-left">
            <div className="bg-gray-800 p-6 rounded-lg shadow-lg">
              <h3 className="text-xl font-semibold text-red-500 mb-2 flex items-center"><FaCodeBranch size={24} className="mr-2" /> Narrative & Design</h3>
              <p className="text-sm text-gray-400">Craft unique stories, puzzles, case files, journals, and environmental riddles.</p>
            </div>
            <div className="bg-gray-800 p-6 rounded-lg shadow-lg">
              <h3 className="text-xl font-semibold text-red-500 mb-2 flex items-center"><FaPalette size={24} className="mr-2" /> Art & Assets</h3>
              <p className="text-sm text-gray-400">Create 2D and 3D assets, from environmental details to character concepts.</p>
            </div>
            <div className="bg-gray-800 p-6 rounded-lg shadow-lg">
              <h3 className="text-xl font-semibold text-red-500 mb-2 flex items-center"><FaMicrophone size={24} className="mr-2" /> Sound & Music</h3>
              <p className="text-sm text-gray-400">Contribute ambient soundscapes, musical pieces, or voice acting.</p>
            </div>
            <div className="bg-gray-800 p-6 rounded-lg shadow-lg">
              <h3 className="text-xl font-semibold text-red-500 mb-2 flex items-center"><FaLightbulb size={24} className="mr-2" /> Development & Puzzles</h3>
              <p className="text-sm text-gray-400">Develop game mechanics, logic puzzles, and optional side narratives.</p>
            </div>
          </div>
          <p className="text-sm mt-4">
            The goal is to create a rich, multi-layered horror experience where the main narrative is
            enhanced by diverse community contributions, making the asylum feel vast and filled with
            countless tragic stories.
          </p>
        </div>
      </Section>

      <Section id="join" title="Become Part of the Asylum's Legacy" className="bg-red-700 text-white">
        <div className="max-w-2xl mx-auto text-center">
          <p className="text-lg mb-8">
            Passionate about psychological horror, narrative design, or game development?
            Help bring this chilling world to life! We also explore themes like "rethinking the value of money,"
            which may influence the narrative in unique ways.
          </p>
          <div className="flex flex-col sm:flex-row justify-center items-center gap-4">
            <a
              href="https://discord.gg/yourserverlink" // Replace with actual Discord link
              target="_blank"
              rel="noopener noreferrer"
              className="bg-gray-900 hover:bg-black text-white font-semibold py-3 px-8 rounded-lg text-lg transition duration-300 ease-in-out transform hover:scale-105 shadow-lg flex items-center justify-center"
            >
              <FaUsers size={20} className="mr-2" /> Join our Discord
            </a>
            <a
              href="mailto:contact@example.com" // Replace with actual contact email
              className="border-2 border-gray-900 hover:bg-gray-900 hover:text-white text-gray-900 font-semibold py-3 px-8 rounded-lg text-lg transition duration-300 ease-in-out transform hover:scale-105 shadow-lg flex items-center justify-center"
            >
              <FaEnvelope size={20} className="mr-2" /> Email Us
            </a>
          </div>
        </div>
      </Section>

      <footer className="bg-gray-950 text-center py-8 text-gray-500">
        <p>&copy; {new Date().getFullYear()} Black Forest Asylum Development Team. All rights reserved.</p>
        <p className="text-xs mt-1">Concept & Community Project</p>
      </footer>
    </div>
  );
};

export default BlackForestAsylumPage;
