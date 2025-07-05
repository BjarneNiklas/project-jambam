'use client';
import Image from 'next/image';
import Link from 'next/link';

interface Game {
  slug: string;
  name: string;
  shortDescription: string;
  longDescription: string;
  imageUrl?: string;
  technologies: string[];
  platform: string[];
  genre: string;
  releaseDate?: string;
  trailerUrl?: string | null;
  playUrl?: string;
  difficulty?: string;
}

export default function GamePageClient({ game }: { game: Game }) {
  return (
    <div className="min-h-screen bg-[#0a0a0a]">
      <div className="flex flex-1 w-full">
        <div className="hidden md:block" style={{ width: 220, flexShrink: 0 }} />
        <div className="w-full px-8 md:px-12 lg:px-16 xl:px-20">
          <main className="flex-1 max-w-6xl mx-auto my-0 md:my-0 bg-transparent rounded-3xl shadow-none p-6 md:p-8 lg:p-12 xl:p-16 border-none min-h-[70vh] flex flex-col relative items-center">
            {/* Hero Section */}
            <div className="relative w-full h-[38vh] md:h-[52vh] flex items-end justify-center overflow-hidden rounded-b-3xl shadow-2xl border-b-4 border-primary mb-8" style={{ background: 'linear-gradient(120deg, #18181b 60%, #14b8a6 120%)' }}>
              {game.imageUrl ? (
                <Image
                  src={game.imageUrl}
                  alt={game.name}
                  fill
                  style={{ objectFit: 'cover', width: '100%', height: '100%', filter: 'brightness(0.92) blur(0.5px)' }}
                  className="transition-transform duration-700 ease-in-out hover:scale-105"
                  priority
                />
              ) : (
                <div className="flex flex-col items-center justify-center w-full h-full">
                  <div className="w-32 h-32 bg-gradient-to-r from-primary to-primary-dark rounded-2xl flex items-center justify-center shadow-2xl">
                    <span className="text-4xl">🎮</span>
                  </div>
                </div>
              )}
              {/* Animierte Headline */}
              <div className="absolute bottom-8 left-1/2 -translate-x-1/2 w-full px-4 md:px-0 flex flex-col items-center">
                <h1 className="text-4xl md:text-6xl font-extrabold text-white tracking-tight drop-shadow-lg animate-fade-in-up text-center" style={{ letterSpacing: 1.5, textShadow: '0 4px 32px #14b8a6cc' }}>{game.name}</h1>
                <p className="text-lg md:text-2xl text-primary font-semibold mt-2 animate-fade-in-up-slow text-center" style={{ textShadow: '0 2px 12px #14b8a6cc' }}>{game.shortDescription}</p>
              </div>
              {/* Zurück-Button */}
              <Link href="/" className="absolute top-6 left-6 bg-primary bg-opacity-20 text-white px-4 py-2 rounded-xl hover:bg-primary transition-all duration-300 flex items-center gap-2">
                <span>←</span> Back
              </Link>
            </div>
            {/* Premium Call-to-Action Buttons */}
            <div className="flex flex-wrap gap-6 justify-center mt-8 mb-8">
              {game.playUrl && (
                <Link href={game.playUrl} target="_blank" rel="noopener noreferrer" className="no-underline">
                  <button className="bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white font-bold py-4 px-8 rounded-2xl text-lg shadow-xl transition-all duration-300 flex items-center gap-3 animate-fade-in-up hover:scale-105 hover:shadow-2xl">
                    🎮 Play Game
                  </button>
                </Link>
              )}
              {game.trailerUrl && (
                <Link href={game.trailerUrl} target="_blank" rel="noopener noreferrer" className="no-underline">
                  <button className="bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white font-bold py-4 px-8 rounded-2xl text-lg shadow-xl transition-all duration-300 flex items-center gap-3 animate-fade-in-up hover:scale-105 hover:shadow-2xl">
                    🎬 Watch Trailer
                  </button>
                </Link>
              )}
            </div>
            {/* Premium Quickfacts Bar */}
            <div className="w-full max-w-6xl mx-auto mb-8">
              <div className="bg-gradient-to-r from-primary/10 to-primary/5 border border-primary/20 rounded-2xl p-6 backdrop-blur-sm">
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6 items-center">
                  {/* Jahr */}
                  {game.releaseDate && (
                    <div className="text-center">
                      <div className="text-xs uppercase tracking-wider text-primary-light mb-2">Jahr</div>
                      <div className="text-xl font-bold text-white">{game.releaseDate}</div>
                    </div>
                  )}
                  {/* Genre */}
                  {game.genre && (
                    <div className="text-center">
                      <div className="text-xs uppercase tracking-wider text-primary-light mb-2">Genre</div>
                      <div className="text-xl font-bold text-white">{game.genre}</div>
                    </div>
                  )}
                  {/* Plattformen */}
                  {game.platform && game.platform.length > 0 && (
                    <div className="text-center">
                      <div className="text-xs uppercase tracking-wider text-primary-light mb-2">Plattformen</div>
                      <div className="flex justify-center gap-2 mt-1">
                        {game.platform.slice(0, 2).map((platform) => (
                          <span key={platform} className="bg-primary text-white text-xs px-3 py-1 rounded-full">
                            {platform}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}
                  {/* Schwierigkeitsgrad (optional) */}
                  {game.difficulty && (
                    <div className="text-center">
                      <div className="text-xs uppercase tracking-wider text-primary-light mb-2">Schwierigkeit</div>
                      <div className="text-xl font-bold text-white">{game.difficulty}</div>
                    </div>
                  )}
                </div>
              </div>
            </div>
            {/* Premium Feature Highlights */}
            <div className="w-full max-w-6xl mx-auto mb-8">
              <h2 className="text-3xl md:text-4xl font-bold text-white mb-8 text-center tracking-tight">Game Features</h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {[
                  { icon: '🎮', title: 'Immersive Gameplay', desc: 'Deep psychological horror experience' },
                  { icon: '🔍', title: 'Exploration', desc: 'Non-linear asylum exploration' },
                  { icon: '🧠', title: 'AI Enemies', desc: 'Advanced enemy AI behavior' }
                ].map((feature, idx) => (
                  <div key={idx} className="bg-gradient-to-r from-primary/10 to-primary/5 border border-primary/20 rounded-2xl p-6 backdrop-blur-sm transition-all duration-300 hover:transform hover:scale-105 hover:shadow-2xl hover:border-primary/40">
                    <div className="text-center">
                      <div className="inline-flex items-center justify-center w-16 h-16 bg-primary rounded-full mb-4 text-2xl transition-all duration-300 hover:scale-110 hover:shadow-lg">
                        {feature.icon}
                      </div>
                      <h3 className="text-xl font-bold text-white mb-3">{feature.title}</h3>
                      <p className="text-gray-300 leading-relaxed">{feature.desc}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
            {/* Game Info Chips */}
            <div className="flex flex-wrap gap-6 items-center justify-center mb-10 mt-6 w-full animate-fade-in-up">
              {/* Release Date as elegant UI element */}
              {game.releaseDate && (
                <div className="relative group">
                  <div className="bg-gradient-to-r from-primary to-primary-dark text-white font-bold text-lg px-6 py-3 rounded-2xl shadow-lg border border-primary-light transform transition-all duration-300 group-hover:scale-105 group-hover:shadow-xl">
                    {game.releaseDate}
                  </div>
                  <div className="absolute -top-1 -right-1 w-3 h-3 bg-primary-light rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                </div>
              )}
              {/* Genre */}
              {game.genre && (
                <div className="relative group">
                  <div className="bg-gradient-to-r from-primary to-primary-dark text-white font-bold text-lg px-6 py-3 rounded-2xl shadow-lg border border-primary-light transform transition-all duration-300 group-hover:scale-105 group-hover:shadow-xl">
                    {game.genre}
                  </div>
                  <div className="absolute -top-1 -right-1 w-3 h-3 bg-primary-light rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                </div>
              )}
              {/* Technologies */}
              {game.technologies && game.technologies.length > 0 && game.technologies.map((tech) => (
                <div key={tech} className="relative group">
                  <div className="bg-gradient-to-r from-primary to-primary-dark text-white font-bold text-lg px-6 py-3 rounded-2xl shadow-lg border border-primary-light transform transition-all duration-300 group-hover:scale-105 group-hover:shadow-xl">
                    {tech}
                  </div>
                  <div className="absolute -top-1 -right-1 w-3 h-3 bg-primary-light rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                </div>
              ))}
            </div>
            {/* Long Description */}
            <div className="w-full max-w-4xl mx-auto mb-16 animate-fade-in-up">
              <h2 className="text-2xl md:text-3xl font-bold text-white mb-4">About the Game</h2>
              <p className="text-lg text-gray-300 leading-relaxed mb-4">{game.longDescription}</p>
            </div>
          </main>
        </div>
      </div>
    </div>
  );
} 