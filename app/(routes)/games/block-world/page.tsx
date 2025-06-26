// app/(routes)/games/block-world/page.tsx
import React from 'react';

const BlockWorldPage = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">Block World (Working Title)</h1>
      <p className="text-xl text-muted-foreground mb-6">
        A Broxel Engine Showcase: Build, Explore, and Discover.
      </p>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Game Concept</h2>
        <p className="mb-4">
          "Block World" is the working title for a game designed to showcase the capabilities of the
          proprietary Broxel Engine. It aims to be an engaging block-based experience with a focus
          on dynamic environments, creative gameplay, and multiplayer interaction.
        </p>
        <p>
          The game will serve as a practical demonstration of the Broxel Engine's features, including
          its performance, building systems, and potential for diverse game modes.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-2xl font-semibold mb-3">Planned Features & Ideas</h2>
        <ul className="list-disc list-inside space-y-3">
          <li>
            <strong>Dynamic Environments:</strong>
            <ul className="list-disc list-inside ml-6 mt-1 space-y-1">
              <li><strong>Growing Flora:</strong> Witness trees develop from saplings to full maturity over time.</li>
              <li><strong>Destructible Terrain:</strong> Many elements in the world will be destructible, with blocks potentially composed of smaller voxels for detailed breakdown animations.</li>
            </ul>
          </li>
          <li>
            <strong>Creature Systems:</strong>
            <ul className="list-disc list-inside ml-6 mt-1 space-y-1">
              <li><strong>Interesting Genetics:</strong> Explore mechanics for color and size inheritance in creatures (e.g., rabbits inspired by Google Gemini's capabilities).</li>
            </ul>
          </li>
          <li>
            <strong>Diverse Game Modes:</strong>
            <ul className="list-disc list-inside ml-6 mt-1 space-y-1">
              <li><strong>Exploration & Building:</strong> Core gameplay will revolve around exploring vast worlds and constructing imaginative creations.</li>
              <li><strong>Labyrinths in Space:</strong> A potential mode featuring challenging mazes in a space setting, possibly without building mechanics.</li>
              <li><strong>Family-Friendly Ball Game:</strong> A concept for an accessible and fun Kugelspiel (ball game).</li>
              <li><strong>Vanilla Mode:</strong> Players might start as simple spherical characters, where size affects accessibility to certain areas based on block material.</li>
            </ul>
          </li>
          <li>
            <strong>Multiplayer Focus:</strong> Designed to support a large number of players interacting within the same world across various game modes.
          </li>
          <li>
            <strong>Simplified Mechanics (Minecraft-inspired):</strong> The game may offer a streamlined version of Minecraft-like experiences, avoiding overly complex mechanisms. More intricate concepts (like Redstone or advanced crafting) could be explained via integrated quizzes or tutorials as "knowledge packets."
          </li>
          <li>
            <strong>Performance Optimization:</strong> A key development goal is to ensure smooth performance even in large, detailed, and populated worlds.
          </li>
          <li>
            <strong>LEGO Minecraft Inspirations:</strong> Drawing conceptual inspiration from LEGO Minecraft and Minecraft LEGO aesthetics or building paradigms.
          </li>
          <li>
            <strong>Integrated Learning:</strong> Inclusion of blueprints, instructions, and tutorials for more complex game mechanics.
          </li>
        </ul>
      </section>

      <section>
        <h2 className="text-2xl font-semibold mb-3">Powered by Broxel Engine</h2>
        <p>
          "Block World" will leverage the full potential of the Broxel Engine, demonstrating its
          Blueprint System, fine-granular building modules, style transformation capabilities,
          and collaborative building tools. It serves as a living testament to the engine's
          power and flexibility in creating engaging block-based virtual worlds.
        </p>
      </section>
    </div>
  );
};

export default BlockWorldPage;
