// app/(routes)/projects/broxel-engine/page.tsx
import React from 'react';

const BroxelEnginePage = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">Broxel Engine</h1>
      <p className="text-xl text-muted-foreground mb-6">
        Powering next-generation block-based creative experiences.
      </p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Overview</h2>
        <p className="mb-4">
          The Broxel Engine is a specialized game engine being developed as part of the LUVY Platform,
          designed to facilitate the creation of immersive and highly customizable block-based worlds
          and games. It emphasizes intuitive building tools, performance, and flexibility for creators.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Core Features</h2>
        <ul className="list-disc list-inside space-y-3">
          <li>
            <strong>Blueprint System:</strong> A sophisticated system allowing players to define block sizes
            and utilize pre-defined or custom blueprints for constructing complex structures.
            It shows required components and offers step-by-step guidance.
          </li>
          <li>
            <strong>LEGO-like Fine-Granular Modules:</strong> Enables the easy addition of objects (like tables, chairs)
            using modular components, much like building with LEGO bricks. This simplifies the creation
            of detailed environments.
          </li>
          <li>
            <strong>Style Transformation:</strong> Integrated tools to transform models between various artistic styles,
            such as low-poly, cartoon, or realistic, providing creators with aesthetic flexibility.
          </li>
          <li>
            <strong>Collaborative Building:</strong> Designed to support multiple users working together on the same
            world or chunk, with mechanisms for managing contributions and ensuring a cohesive final product.
          </li>
          <li>
            <strong>Optimized Building Processes:</strong> Features like recording build processes to optimize instructions
            and tools for rapid placement of blocks (e.g., a "laser beam" builder).
          </li>
          <li>
            <strong>Custom Block Creation:</strong> Potential integration with tools like "LegoGPT" to allow users
            to design and define their own custom blocks, offering near-limitless creative possibilities.
            Blocks can be filled and assembled with various editor tools.
          </li>
          <li>
            <strong>Performance Focus:</strong> Emphasis on optimizing performance to support large, detailed worlds
            and many concurrent players. This includes considerations for voxel structures where blocks
            can be composed of smaller voxels for detailed destruction animations.
          </li>
          <li>
            <strong>Snap Tool with Flexibility:</strong> A snap tool for precise alignment, with the option to disable it
            for more freeform building.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Showcase: "Block World" Game</h2>
        <p className="mb-4">
          The Broxel Engine's capabilities are planned to be showcased in the "Block World" game. This game
          will feature:
        </p>
        <ul className="list-disc list-inside space-y-2">
          <li>Dynamic elements like trees growing from saplings over time.</li>
          <li>Interesting creature genetics (e.g., color and size inheritance).</li>
          <li>Multiple game modes, including exploration, building, and family-friendly challenges.</li>
          <li>Support for a large number of players in shared worlds.</li>
          <li>A "Vanilla" mode where players might be simple shapes, navigating a destructible environment.</li>
        </ul>
        <p className="mt-4">
          "Block World" aims to be a simpler, more accessible take on Minecraft-like experiences,
          potentially explaining complex mechanics through integrated learning modules or tutorials.
        </p>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-3">Vision for Broxel Engine</h2>
        <p>
          The Broxel Engine is envisioned as a cornerstone of the LUVY co-creation ecosystem.
          It will provide a powerful yet user-friendly foundation for developers and players alike
          to build, share, and enjoy unique block-based games and experiences. It also serves as a
          sandbox for "game within a game" scenarios, such as the "LEGION BLOX" concept.
        </p>
      </section>
    </div>
  );
};

export default BroxelEnginePage;
