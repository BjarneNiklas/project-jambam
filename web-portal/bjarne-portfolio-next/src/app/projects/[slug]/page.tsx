import { Metadata } from 'next';
import { notFound } from 'next/navigation';
import projects from '@/data/projects.json';
import ProjectPageClient from './ProjectPageClient';

// Define the Project type based on your data structure
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

// Definiere die Props für die Page-Komponente (params ist jetzt ein Promise)
type PageProps = {
  params: Promise<{ slug: string }>;
};

// Helper function to fetch project data
const getProjectData = (slug: string): Project | undefined => {
  return projects.find((p) => p.slug === slug);
};

// Passe generateMetadata an das Promise-Pattern an
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const project = getProjectData(slug);

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

// Generate static paths for all projects
export async function generateStaticParams() {
  return projects.map((project) => ({
    slug: project.slug,
  }));
}

// Die Page-Komponente erhält params als Promise
export default async function ProjectPage({ params }: PageProps) {
  const { slug } = await params;
  const project = getProjectData(slug);

  if (!project) {
    notFound();
  }

  return <ProjectPageClient project={project} />;
}
