// src/app/projects/[slug]/page.tsx
import projects from '@/data/projects.json';
import Image from 'next/image';
import Link from 'next/link';
import { notFound } from 'next/navigation';

interface Project {
  slug: string;
  name: string;
  shortDescription: string;
  longDescription: string;
  imageUrl?: string;
  technologies: string[];
  url?: string;
  githubUrl?: string;
}

interface ProjectPageProps {
  params: {
    slug: string;
  };
}

// This function tells Next.js which slugs are available
// and should be pre-rendered at build time.
export async function generateStaticParams() {
  return projects.map((project) => ({
    slug: project.slug,
  }));
}

const getProjectData = (slug: string): Project | undefined => {
  return projects.find((p) => p.slug === slug);
};

export default function ProjectPage({ params }: ProjectPageProps) {
  const project = getProjectData(params.slug);

  if (!project) {
    notFound(); // Triggers a 404 page if project not found
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <Link href="/" className="text-blue-500 hover:underline mb-4 inline-block">
        &larr; Back to Home
      </Link>
      <h1 className="text-4xl font-bold mb-4">{project.name}</h1>

      {project.imageUrl && (
        <div className="mb-6 relative w-full h-96"> {/* Adjust height as needed */}
          <Image
            src={project.imageUrl}
            alt={project.name}
            layout="fill"
            objectFit="cover"
            className="rounded-lg"
          />
        </div>
      )}

      <p className="text-lg text-gray-700 mb-6">{project.longDescription}</p>

      <div className="mb-6">
        <h2 className="text-2xl font-semibold mb-2">Technologies Used</h2>
        <ul className="flex flex-wrap gap-2">
          {project.technologies.map((tech) => (
            <li key={tech} className="bg-gray-200 text-gray-800 px-3 py-1 rounded-full text-sm">
              {tech}
            </li>
          ))}
        </ul>
      </div>

      <div className="flex space-x-4">
        {project.url && (
          <Link href={project.url} target="_blank" rel="noopener noreferrer" className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition duration-300">
            View Project
          </Link>
        )}
        {project.githubUrl && (
          <Link href={project.githubUrl} target="_blank" rel="noopener noreferrer" className="bg-gray-700 hover:bg-gray-800 text-white font-bold py-2 px-4 rounded transition duration-300">
            View on GitHub
          </Link>
        )}
      </div>
    </div>
  );
}

// Optional: Add metadata for SEO
export async function generateMetadata({ params }: ProjectPageProps) {
  const project = getProjectData(params.slug);
  if (!project) {
    return {
      title: 'Project Not Found',
    };
  }
  return {
    title: `${project.name} | Project Details`,
    description: project.shortDescription,
  };
}
