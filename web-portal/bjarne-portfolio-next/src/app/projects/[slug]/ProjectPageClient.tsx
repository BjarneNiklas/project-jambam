'use client';

import Image from 'next/image';
import Link from 'next/link';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import Footer from '@/components/Footer';
import { useLanguage } from '../../LanguageContext';

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

interface ProjectPageClientProps {
  project: Project;
}

export default function ProjectPageClient({ project }: ProjectPageClientProps) {
  const { t } = useLanguage();

  return (
    <div className="min-h-screen flex flex-col bg-[#0a0a0a]">
      <div className="flex flex-1 w-full">
        {/* Sidebar ist links, Content rechts */}
        <div className="hidden md:block" style={{ width: 220, flexShrink: 0 }} />
        <main
          className="flex-1 max-w-3xl mx-auto my-12 bg-gradient-to-br from-[#18181b] to-[#23232a] rounded-3xl shadow-2xl p-6 md:p-12 border border-[#23232a] min-h-[70vh] flex flex-col"
        >
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-blue-400 hover:bg-blue-900/30 transition px-4 py-2 rounded-lg font-semibold w-fit mb-6 shadow"
            style={{ fontSize: '1.05rem' }}
          >
            <ArrowBackIcon fontSize="small" />
            {t('navigation.back')}
          </Link>
          <h1 className="text-4xl md:text-5xl font-extrabold mb-4 text-white tracking-tight drop-shadow-lg">
            {project.name}
          </h1>
          {project.imageUrl && (
            <div className="mb-8 w-full aspect-[16/7] relative rounded-2xl overflow-hidden shadow-lg border border-[#23232a]">
              <Image
                src={project.imageUrl}
                alt={project.name}
                fill
                style={{ objectFit: 'cover' }}
                className="rounded-2xl"
                priority
              />
            </div>
          )}
          <p className="text-lg md:text-xl text-gray-300 mb-8 leading-relaxed max-w-2xl">
            {project.longDescription}
          </p>
          <div className="mb-8">
            <h2 className="text-2xl font-bold mb-2 text-white">Technologies Used</h2>
            <div className="flex flex-wrap gap-4 text-base font-medium text-[#b3b3b3]">
              {project.technologies.map((tech) => (
                <span key={tech} className="inline-block px-0 py-0">
                  {tech}
                </span>
              ))}
            </div>
          </div>
          <div className="flex flex-wrap gap-4 mt-6">
            {project.url && (
              <Link href={project.url} target="_blank" rel="noopener noreferrer" className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-5 rounded-lg transition duration-300 shadow">
                Projekt ansehen
              </Link>
            )}
            {project.githubUrl && (
              <Link href={project.githubUrl} target="_blank" rel="noopener noreferrer" className="bg-gray-700 hover:bg-gray-800 text-white font-bold py-2 px-5 rounded-lg transition duration-300 shadow">
                Auf GitHub
              </Link>
            )}
          </div>
        </main>
        <div className="hidden md:block flex-1" />
      </div>
      {/* Footer immer am unteren Rand */}
      <Footer />
    </div>
  );
} 