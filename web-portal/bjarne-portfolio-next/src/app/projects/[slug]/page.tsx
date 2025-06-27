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

// Define the props for the page component, including params and searchParams
type Props = {
  params: { slug: string };
  searchParams: { [key: string]: string | string[] | undefined };
};

// Helper function to fetch project data
const getProjectData = (slug: string): Project | undefined => {
  return projects.find((p) => p.slug === slug);
};

// Generate metadata for the page
export async function generateMetadata({ params }: Props): Promise<Metadata> {
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

// Generate static paths for all projects
export async function generateStaticParams() {
  return projects.map((project) => ({
    slug: project.slug,
  }));
}

// The page component
export default function ProjectPage({ params }: Props) {
  const project = getProjectData(params.slug);

  if (!project) {
    notFound();
  }

  return <ProjectPageClient project={project} />;
}
