// src/app/projects/[slug]/page.tsx
import projects from '@/data/projects.json';
import { notFound } from 'next/navigation';
import ProjectPageClient from './ProjectPageClient';

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

  return <ProjectPageClient project={project} />;
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
