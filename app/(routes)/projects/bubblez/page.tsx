// app/(routes)/projects/bubblez/page.tsx
import React from 'react';

const BubbleZPage = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">BubbleZ Social App</h1>
      <p className="text-xl text-muted-foreground mb-6">
        Redefining Social Interactions within the LUVY Ecosystem.
      </p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Concept Overview</h2>
        <p className="mb-4">
          BubbleZ is a next-generation social media application concept, designed to be an integral part of the
          LUVY platform. It aims to foster meaningful connections, dynamic content sharing, and innovative
          user interactions, moving beyond traditional social media paradigms.
        </p>
        <p>
          The name "BubbleZ" itself hints at personalized content spheres, interest-based communities,
          and perhaps a playful, engaging user interface.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Key Features & Ideas</h2>
        <ul className="list-disc list-inside space-y-3">
          <li>
            <strong>AI-Powered Content Clustering:</strong> Similar content will be grouped or "clustered"
            using AI, helping users discover relevant posts, discussions, and media more easily.
          </li>
          <li>
            <strong>News Prioritization & Format:</strong> Advanced system for prioritizing news and messages,
            with options for users to customize notifications. It may feature news formats inspired by
            successful platforms like ZDFheute or Funk on Instagram,مپotentially allowing businesses
            to upload their own content templates.
          </li>
          <li>
            <strong>Interest Matching & "Bubble" Minigame:</strong> A system for matching users based on
            interests (potentially visualized as interactive "bubbles" in a minigame). This concept
            could extend to job opportunities and project collaborations.
          </li>
          <li>
            <strong>Integrated Source Citations:</strong> Ability to include source citations directly within texts,
            linking to both external resources and internal LUVY platform content.
          </li>
          <li>
            <strong>Unique Social Interactions:</strong>
            <ul className="list-disc list-inside ml-6 mt-1 space-y-1">
              <li><strong>"Smash or Pass"-like Swiping:</strong> For certain types of content or interactions.</li>
              <li><strong>"Rizz" Integration:</strong> Incorporating the concept of "Rizz" (charisma/appeal),
                  perhaps as a profile attribute or an interaction mechanic.</li>
            </ul>
          </li>
          <li>
            <strong>Enhanced Profile & Social Features:</strong>
            <ul className="list-disc list-inside ml-6 mt-1 space-y-1">
              <li>Listing user blogs and controlling content visibility (e.g., hiding likes).</li>
              <li>Analysis of interaction origins (profile, discover feed, ads).</li>
              <li>Easy friend-adding functionality.</li>
              <li>Improved management of interests, skills, and knowledge (akin to LinkedIn/XING but enhanced).</li>
            </ul>
          </li>
          <li>
            <strong>Catchy Homescreen Animations:</strong> Dynamic speech bubble animations on the homescreen
            to simulate ongoing chats or discussions, potentially with humorous elements for younger audiences.
          </li>
          <li>
            <strong>Gamified Engagement:</strong> Earning "Aura Points/Coins" for positive contributions, with
            potential deductions for spreading misinformation (e.g., -10 Aura for fake news).
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Vision for BubbleZ</h2>
        <p className="mb-4">
          BubbleZ aims to be more than just another social app. It's envisioned as a vibrant, intelligent,
          and highly customizable social layer for the LUVY platform. It will connect users in novel ways,
          facilitate the spread of quality information, and provide a fun, engaging environment for
          interaction and community building.
        </p>
        <p>
          By integrating deeply with LUVY's other services, like e-learning, game worlds, and the marketplace,
          BubbleZ will offer a truly interconnected social experience.
        </p>
      </section>
    </div>
  );
};

export default BubbleZPage;
