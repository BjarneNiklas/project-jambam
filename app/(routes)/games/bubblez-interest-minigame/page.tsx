// app/(routes)/games/bubblez-interest-minigame/page.tsx
import React from 'react';

const BubbleZInterestMinigamePage = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">BubbleZ Interest Minigame</h1>
      <p className="text-xl text-muted-foreground mb-6">
        Connect, Match, and Discover Through Playful Bubbles.
      </p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Game Concept</h2>
        <p className="mb-4">
          The BubbleZ Interest Minigame is a unique concept designed to facilitate connections
          based on shared interests in a fun and interactive way. Initially conceived as part of the
          BubbleZ social app, this minigame has the potential to be an exportable feature,
          usable even on external websites.
        </p>
        <p>
          Imagine interests visually represented as "bubbles." Users could interact with these bubbles,
          perhaps popping, collecting, or connecting them to signify matches with other users,
          projects, or even job opportunities.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Core Mechanics & Ideas</h2>
        <ul className="list-disc list-inside space-y-2">
          <li>
            <strong>Visual Interest Matching:</strong> Users' interests (e.g., "game development," "AI research,"
            "mental health," "anti-aging," "animal communication") are displayed as interactive bubbles.
          </li>
          <li>
            <strong>Interactive Gameplay:</strong> Matched interests could appear as floating bubbles that users
            can interact with. The exact mechanics could vary – perhaps a fast-paced matching game,
            a calm discovery process, or a collaborative bubble-sorting activity.
          </li>
          <li>
            <strong>Connection to Opportunities:</strong> Successfully matched interests could link users to
            relevant projects within the LUVY platform, job listings in the integrated database,
            or other users with similar passions.
          </li>
          <li>
            <strong>Exportable & Embeddable:</strong> A key idea is to make this minigame exportable,
            allowing it to be featured on external websites,مپotentially with leaderboards or
            additional idea showcases.
          </li>
          <li>
            <strong>Expanded Interest Categories:</strong> The system would support a wide and expandable range of
            interest categories, covering professional fields, hobbies, social causes, and more,
            available in multiple languages.
          </li>
          <li>
            <strong>Integration with "Fun Facts":</strong> The minigame or surrounding features could incorporate
            "Fun Facts" to make the experience more engaging and informative.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Purpose & Potential</h2>
        <p className="mb-4">
          The BubbleZ Interest Minigame aims to:
        </p>
        <ul className="list-disc list-inside space-y-2">
          <li>Make the process of finding like-minded individuals or relevant opportunities more engaging.</li>
          <li>Serve as a novel interface for navigating a database of interests, projects, and jobs.</li>
          <li>Act as a shareable, viral component to draw users to the LUVY platform and its features.</li>
          <li>Provide a lighthearted yet effective way to foster community and collaboration.</li>
        </ul>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-3">Part of a Bigger Picture</h2>
        <p>
          While potentially a standalone experience, the BubbleZ Interest Minigame is deeply connected
          to the vision of the BubbleZ social app and the LUVY platform's goal of creating a
          comprehensive ecosystem for creators, learners, and collaborators. It's an example of
          how gamification can be applied to enhance networking and discovery.
        </p>
      </section>
    </div>
  );
};

export default BubbleZInterestMinigamePage;
