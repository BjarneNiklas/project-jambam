// app/(routes)/games/home-cafe-module/page.tsx
import React from 'react';

const HomeCafeModulePage = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">"Home Café" Game Jam Module</h1>
      <p className="text-xl text-muted-foreground mb-6">
        Brewing Creativity: A Culinary-Themed Module for Local Game Jams and Beyond.
      </p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Concept Overview</h2>
        <p className="mb-4">
          The "Home Café" module is a creative project concept designed primarily for local game jams,
          but with potential applications for broader creative endeavors. It aims to tap into contemporary
          trends (especially among GenZ) related to home-based creativity, culinary arts, and sharing.
        </p>
        <p>
          The core idea is to provide a framework or a set of tools that allow participants to design
          and showcase their own "Home Café" – whether it's a collection of recipes, a designed menu,
          or even a simulated café experience.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Key Features & Ideas</h2>
        <ul className="list-disc list-inside space-y-2">
          <li>
            <strong>Recipe Sharing:</strong> Users can upload their own recipes, complete with ingredients,
            instructions, and perhaps even photos or videos.
          </li>
          <li>
            <strong>Menu Creation:</strong> Tools to design custom menus, including adding images, descriptions,
            and prices (even for free items like "tap water"). This encourages creativity in presentation.
          </li>
          <li>
            <strong>Themed Content:</strong> Focus on popular café items like bagels, croissants, mini-pancakes,
            and a variety of beverages (e.g., espresso martinis, artisanal coffees), catering to current trends.
          </li>
          <li>
            <strong>Local Game Jam Focus:</strong> Intended as a theme or toolset for game jams, encouraging
            quick, creative projects around the "Home Café" concept.
          </li>
          <li>
            <strong>Broader Applications:</strong> While culinary-themed, the underlying concept of creating,
            designing, and sharing could be adapted for other crafts – e.g., a "Home Studio" for artists,
            a "Home Workshop" for crafters, etc. The document mentions extending game jams to
            professions like tile layers and architects.
          </li>
          <li>
            <strong>Community and Sharing:</strong> Built around the idea of sharing creations with others,
            getting feedback, and potentially collaborating.
          </li>
          <li>
            <strong>GenZ Appeal:</strong> The name and concept are designed to resonate with younger audiences
            who are active in creating and sharing content online, particularly around lifestyle and food.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Purpose & Goals</h2>
        <p className="mb-4">
          The "Home Café" module aims to:
        </p>
        <ul className="list-disc list-inside space-y-2">
          <li>Provide an engaging and accessible theme for game jams and creative workshops.</li>
          <li>Encourage creativity in non-traditional game development areas (like culinary arts).</li>
          <li>Offer a platform for users to express themselves and share their passions.</li>
          <li>Explore how game-like interfaces can be used for diverse creative outputs.</li>
          <li>Foster community interaction around shared interests and creations.</li>
        </ul>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-3">Part of LUVY's E-Learning & Jam Ecosystem</h2>
        <p>
          This module aligns with the LUVY platform's broader goals of integrating e-learning,
          fostering creativity through game jams, and extending these concepts to various fields.
          It represents a playful yet practical approach to "gamifying" creative expression and skill-sharing.
        </p>
      </section>
    </div>
  );
};

export default HomeCafeModulePage;
