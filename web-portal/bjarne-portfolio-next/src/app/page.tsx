import Hero from '../components/Hero';
import ExperienceEducation from '../components/ExperienceEducation';
import About from '../components/About';
import Skills from '../components/Skills';
import Projects from '../components/Projects';
import Contact from '../components/Contact';

export default function Home() {
  return (
    <main className="min-h-screen pt-[56px] sm:pt-[64px]">
      <Hero />
      <About />
      <ExperienceEducation />
      <Skills />
      <Projects />
      <Contact />
    </main>
  );
}
