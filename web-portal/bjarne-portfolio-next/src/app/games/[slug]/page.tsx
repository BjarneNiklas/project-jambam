import { Metadata } from 'next';
import { notFound } from 'next/navigation';
import games from '@/data/games.json';
import Image from 'next/image';
import Link from 'next/link';

// Define the Game type based on your data structure
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
}

// Definiere die Props für die Page-Komponente (nur params, searchParams wird nicht genutzt)
type PageProps = {
  params: { slug: string };
};

// Helper function to fetch game data
const getGameData = (slug: string): Game | undefined => {
  // The type assertion is necessary because `find` can return a different type from the json
  return games.find((g) => g.slug === slug) as Game | undefined;
};

// Passe generateMetadata an die empfohlene Typisierung an
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const game = getGameData(params.slug);

  if (!game) {
    return {
      title: 'Game Not Found',
    };
  }

  return {
    title: `${game.name} | Game Details`,
    description: game.shortDescription,
  };
}

// Generate static paths for all games
export async function generateStaticParams() {
  return games.map((game) => ({
    slug: game.slug,
  }));
}

// Die Page-Komponente erhält nur params als Props
export default function GamePage({ params }: PageProps) {
  const game = getGameData(params.slug);

  if (!game) {
    notFound();
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <Link href="/" className="text-blue-500 hover:underline mb-4 inline-block">
        &larr; Back to Home
      </Link>
      <h1 className="text-4xl font-bold mb-4">{game.name}</h1>

      {game.imageUrl && (
        <div className="mb-6 relative w-full h-96"> {/* Adjust height as needed */}
          <Image
            src={game.imageUrl}
            alt={game.name}
            layout="fill"
            objectFit="cover"
            className="rounded-lg"
          />
        </div>
      )}

      <p className="text-lg text-gray-700 mb-6">{game.longDescription}</p>

      <div className="grid md:grid-cols-2 gap-6 mb-6">
        <div>
          <h2 className="text-2xl font-semibold mb-2">Game Details</h2>
          <ul className="space-y-1 text-gray-700">
            {game.genre && <li><strong>Genre:</strong> {game.genre}</li>}
            {game.platform && <li><strong>Platforms:</strong> {game.platform.join(', ')}</li>}
            {game.releaseDate && <li><strong>Release Date:</strong> {game.releaseDate}</li>}
          </ul>
        </div>
        <div>
          <h2 className="text-2xl font-semibold mb-2">Technologies Used</h2>
          <ul className="flex flex-wrap gap-2">
            {game.technologies.map((tech) => (
              <li key={tech} className="bg-gray-200 text-gray-800 px-3 py-1 rounded-full text-sm">
                {tech}
              </li>
            ))}
          </ul>
        </div>
      </div>

      <div className="flex space-x-4">
        {game.playUrl && (
          <Link href={game.playUrl} target="_blank" rel="noopener noreferrer" className="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded transition duration-300">
            Play Game
          </Link>
        )}
        {game.trailerUrl && (
          <Link href={game.trailerUrl} target="_blank" rel="noopener noreferrer" className="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded transition duration-300">
            Watch Trailer
          </Link>
        )}
      </div>
    </div>
  );
}