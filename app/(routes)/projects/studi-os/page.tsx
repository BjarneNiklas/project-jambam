// app/(routes)/projects/studi-os/page.tsx
import React from 'react';

const StudiOsPage = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">Studi.OS</h1>
      <p className="text-xl text-muted-foreground mb-6">
        A Collaborative Operating System for Modern Education.
      </p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Concept</h2>
        <p className="mb-4">
          Studi.OS is envisioned as a revolutionary "operating system" tailored for students and educators.
          It aims to provide a unified and collaborative environment for project-based learning,
          knowledge sharing, and skill development, deeply integrated within the LUVY platform's
          broader e-learning ecosystem.
        </p>
        <p>
          The core idea is to move beyond traditional learning management systems by offering dynamic tools
          and a framework that supports real-world project development cycles, from ideation to execution.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Key Objectives & Features</h2>
        <ul className="list-disc list-inside space-y-3">
          <li>
            <strong>Collaborative Project Development:</strong> Facilitate seamless teamwork on academic and
            creative projects, allowing students from various institutions or disciplines to collaborate effectively.
          </li>
          <li>
            <strong>Cross-Organizational Collaboration:</strong> Break down silos between educational institutions,
            enabling shared learning experiences and projects.
          </li>
          <li>
            <strong>Integrated E-Learning Modules:</strong> Direct access to LUVY's extensive e-learning content,
            covering subjects from history and mathematics to coding and game development. Studi.OS would
            provide context and application for these learning materials.
          </li>
          <li>
            <strong>Personalized Learning Paths:</strong> Potential for AI-driven suggestions for projects,
            courses, and skill development based on a student's progress, interests, and goals.
          </li>
          <li>
            <strong>Gamified Learning Experiences:</strong> Integration of gamification elements, such as
            project-based "Jams," quizzes with leaderboards, and achievement systems for mastering
            academic concepts and practical skills.
          </li>
          <li>
            <strong>SkillShowcasing & Portfolio Building:</strong> Tools for students to document their work,
            showcase completed projects, and build a portfolio that reflects their skills and knowledge.
          </li>
          <li>
            <strong>"Informatics Study of the Future":</strong> Aims to embody a forward-thinking approach
            to education, particularly in tech fields, by emphasizing practical application,
            continuous learning, and adaptability.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Learning Content Examples</h2>
        <p className="mb-4">
          Studi.OS will connect learners with a diverse range of educational content, including:
        </p>
        <ul className="list-disc list-inside space-y-2">
          <li>Simplified explanations of complex subjects like history, economics, and mathematics.</li>
          <li>Step-by-step logic explanations and problem-solving guides.</li>
          <li>Courses on "What makes good code?" covering maintainability, scalability, performance, and security.</li>
          <li>Tutorials on various technologies and their practical applications.</li>
          <li>AI-generated quizzes from e-learning texts, covering topics from Voxel graphics to Quantum Computing.</li>
          <li>Interactive onboarding tutorials for new concepts and tools.</li>
        </ul>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-3">The Vision for Studi.OS</h2>
        <p>
          Studi.OS aspires to be more than just software; it aims to be a catalyst for transforming
          education. By fostering collaboration, integrating cutting-edge learning tools, and focusing
          on practical, project-based learning, Studi.OS seeks to prepare students for the challenges
          and opportunities of the future, promoting a culture of "Free Open Learning."
        </p>
      </section>
    </div>
  );
};

export default StudiOsPage;
