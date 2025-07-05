import { Metadata } from 'next';
import { notFound } from 'next/navigation';
import games from '@/data/games.json';
import GamePageClient from './GamePageClient';

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
  difficulty?: string;
}

// Definiere die Props für die Page-Komponente (params ist jetzt ein Promise)
type PageProps = {
  params: Promise<{ slug: string }>;
};

// Helper function to fetch game data
const getGameData = (slug: string): Game | undefined => {
  // The type assertion is necessary because `find` can return a different type from the json
  return games.find((g) => g.slug === slug) as Game | undefined;
};

// Passe generateMetadata an das Promise-Pattern an
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const game = getGameData(slug);

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

// Die Page-Komponente erhält params als Promise
export default async function GamePage({ params }: PageProps) {
  const { slug } = await params;
  const game = getGameData(slug);

  if (!game) {
    notFound();
  }

  return <GamePageClient game={game} />;
}