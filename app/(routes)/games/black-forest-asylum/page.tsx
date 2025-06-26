// app/(routes)/games/black-forest-asylum/page.tsx
import React from 'react';

const BlackForestAsylumPage = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">Black Forest Asylum</h1>
      <p className="text-xl text-muted-foreground mb-6">
        Uncover the chilling secrets of a forgotten institution. A Community-Developed Psychological Horror.
      </p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Game Overview</h2>
        <p className="mb-4">
          Black Forest Asylum is a community-driven psychological horror and mystery game.
          Set in an abandoned, isolated asylum deep within Germany's Black Forest, the game invites
          players to explore a place with a dark past, filled with unethical experiments and whispered legends
          of strange occurrences.
        </p>
        <p>
          This project emphasizes immersive exploration, detailed environmental storytelling, and
          challenging puzzles, all while building a pervasive sense of dread and vulnerability.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Setting & Atmosphere</h2>
        <p className="mb-4">
          The asylum itself is a key character – a historical, imposing structure now decaying and
          haunted by its history. Players might take on roles such as an urban explorer, a paranormal
          investigator, or someone with a personal tie to the asylum's past.
        </p>
        <p>
          The horror is primarily psychological, relying on atmosphere, unsettling sound design
          (creaking structures, distant whispers), and the unfolding narrative rather than frequent jump scares.
          A potential supernatural element, the psychic residue of past trauma, may manifest in various unsettling ways.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Gameplay Focus</h2>
        <ul className="list-disc list-inside space-y-2">
          <li>
            <strong>Immersive Exploration:</strong> Discover the asylum's secrets by navigating its decaying halls,
            wards, and hidden areas.
          </li>
          <li>
            <strong>Environmental Storytelling:</strong> Piece together the narrative through scattered notes,
            patient diaries, staff logs, medical records, audio recordings, and environmental clues.
          </li>
          <li>
            <strong>Challenging Puzzles:</strong> Solve puzzles that often require understanding the asylum's
            history or the tormented minds of its former inhabitants.
          </li>
          <li>
            <strong>Limited Resources:</strong> Players may often rely on limited light sources like flashlights
            or candles, enhancing the sense of vulnerability.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Visual & Audio Style</h2>
        <ul className="list-disc list-inside space-y-2">
          <li>
            <strong>Visuals:</strong> Dark, oppressive, and highly detailed environments. A realistic art style
            focusing on decay and the passage of time. Dynamic lighting will be crucial.
          </li>
          <li>
            <strong>Audio:</strong> Critical immersive sound design featuring ambient sounds of the old building,
            subtle unsettling noises, and a potentially adaptive soundtrack. Voice acting for audio logs
            will enhance immersion.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">A Community-Developed Project</h2>
        <p className="mb-4">
          Black Forest Asylum is envisioned as a collaborative effort, inviting contributions from
          game developers, writers, artists, and sound designers. The asylum's modular design
          (distinct wings like administrative, patient wards, labs) lends itself well to this approach.
        </p>
        <p className="font-semibold mb-2">Contribution Opportunities Include:</p>
        <ul className="list-disc list-inside space-y-1">
          <li>Designing individual rooms or entire sections with unique stories and puzzles.</li>
          <li>Writing narrative fragments (case files, journals, letters).</li>
          <li>Developing logic puzzles and environmental riddles.</li>
          <li>Creating 2D and 3D assets.</li>
          <li>Contributing ambient soundscapes or musical pieces.</li>
          <li>Developing optional side narratives and character backstories.</li>
        </ul>
        <p className="mt-3">
          The goal is to create a rich, multi-layered horror experience where the main narrative is
          enhanced by diverse community contributions, making the asylum feel vast and filled with
          countless tragic stories.
        </p>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-3">Join the Development</h2>
        <p>
          If you are passionate about psychological horror, narrative design, or any aspect of game
          development, consider contributing to Black Forest Asylum. Help bring this chilling world to life!
          The project also touches upon themes like "rethinking the value of money," which might influence
          its narrative or in-game economy in unique ways.
        </p>
      </section>
    </div>
  );
};

export default BlackForestAsylumPage;
