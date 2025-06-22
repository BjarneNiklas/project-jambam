export interface Product {
  name: string;
  category: string;
  status: 'active' | 'development' | 'planned' | 'deprecated';
  description: string;
  features: string[];
  technologies: string[];
  targetAudience: string;
}

export interface ProductCategory {
  name: string;
  description: string;
  products: Product[];
}

export const productsData: ProductCategory[] = [
  {
    name: "Engines & Core Technology",
    description: "Our proprietary game engines and core technology platforms.",
    products: [
      {
        name: "Broxel Engine",
        category: "Voxel Engine",
        status: "development",
        description: "Our custom voxel-based game engine designed for infinite worlds and procedural generation.",
        features: [
          "Infinite voxel world generation",
          "Real-time procedural content creation",
          "Multi-threaded rendering",
          "Modular architecture",
          "Cross-platform support"
        ],
        technologies: ["Rust", "C++", "Vulkan", "Procedural Generation"],
        targetAudience: "Game developers, content creators, educational institutions"
      },
      {
        name: "LUVY Engine",
        category: "3D/XR Engine",
        status: "planned",
        description: "Next-generation 3D and XR engine for immersive experiences and content creation.",
        features: [
          "Real-time 3D rendering",
          "XR support (VR/AR)",
          "AI-powered content generation",
          "Cross-platform deployment",
          "Community-driven development"
        ],
        technologies: ["Rust", "Vulkan", "OpenXR", "AI/ML", "WebXR"],
        targetAudience: "3D artists, XR developers, content creators"
      }
    ]
  },
  {
    name: "AI & Content Generation",
    description: "AI-powered tools and services for content creation.",
    products: [
      {
        name: "JamBam AI Studio",
        category: "AI Content Platform",
        status: "planned",
        description: "Integrated AI platform for generating game assets, worlds, and interactive content.",
        features: [
          "Multi-modal AI generation",
          "Asset pipeline integration",
          "Community-driven training",
          "Real-time collaboration",
          "Quality assurance tools"
        ],
        technologies: ["Python", "TensorFlow", "Stable Diffusion", "OpenAI API", "Gemini API"],
        targetAudience: "Game developers, content creators, educators"
      },
      {
        name: "AURAX Platform",
        category: "AI Co-Creation Platform",
        status: "development",
        description: "Advanced AI co-creation platform for collaborative content generation and 3D world building.",
        features: [
          "AI-powered co-creation",
          "3D model generation",
          "Photogrammetry integration",
          "Real-time collaboration",
          "Community-driven AI training"
        ],
        technologies: ["Python", "AI/ML", "3D Graphics", "Photogrammetrie", "Meshroom"],
        targetAudience: "3D artists, game developers, educators, researchers"
      }
    ]
  },
  {
    name: "Community & Collaboration",
    description: "Platforms and tools for community engagement and collaboration.",
    products: [
      {
        name: "JamBam Community Hub",
        category: "Social Platform",
        status: "active",
        description: "Central hub for our community to collaborate, share content, and participate in development.",
        features: [
          "User-generated content",
          "Collaborative projects",
          "Voting and feedback systems",
          "Integration with development tools",
          "Gamification elements"
        ],
        technologies: ["Flutter", "Supabase", "Rust", "Material 3"],
        targetAudience: "Community members, developers, content creators"
      },
      {
        name: "Game Jam Platform",
        category: "Event Platform",
        status: "planned",
        description: "Comprehensive platform for hosting and participating in game jams and creative competitions.",
        features: [
          "Jam creation and management",
          "Real-time collaboration",
          "Asset sharing",
          "Judging and voting",
          "Community feedback"
        ],
        technologies: ["Flutter", "Real-time", "WebRTC", "WebSockets"],
        targetAudience: "Game developers, students, educators, hobbyists"
      }
    ]
  },
  {
    name: "Development Tools",
    description: "Tools and utilities to support development workflows.",
    products: [
      {
        name: "Engine Adapter Framework",
        category: "Integration Tool",
        status: "development",
        description: "Universal framework for integrating various game engines with our platform.",
        features: [
          "Multi-engine support",
          "Standardized APIs",
          "Plugin architecture",
          "Performance optimization",
          "Cross-platform compatibility"
        ],
        technologies: ["Rust", "FFI", "gRPC", "Unity", "Godot", "Unreal"],
        targetAudience: "Game developers, engine developers"
      },
      {
        name: "JamBam IDE",
        category: "Development Environment",
        status: "planned",
        description: "Integrated development environment optimized for our technology stack and workflows.",
        features: [
          "Multi-language support",
          "AI-assisted coding",
          "Integrated testing",
          "Deployment tools",
          "Community integration"
        ],
        technologies: ["Electron", "TypeScript", "Rust", "Python"],
        targetAudience: "Developers, students, hobbyists"
      },
      {
        name: "Asset Pipeline",
        category: "Content Management",
        status: "development",
        description: "Comprehensive asset management and processing pipeline for 3D content and game assets.",
        features: [
          "Automated processing",
          "Format conversion",
          "Quality optimization",
          "Version control",
          "Collaborative editing"
        ],
        technologies: ["Python", "Blender", "OpenUSD", "glTF", "OpenImageIO"],
        targetAudience: "3D artists, game developers, content creators"
      }
    ]
  },
  {
    name: "Educational & Training",
    description: "Educational tools and platforms for learning game development.",
    products: [
      {
        name: "JamBam Learning Platform",
        category: "Educational Platform",
        status: "planned",
        description: "Comprehensive learning platform for game development, AI, and creative technologies.",
        features: [
          "Interactive tutorials",
          "Project-based learning",
          "AI-powered feedback",
          "Community mentoring",
          "Certification programs"
        ],
        technologies: ["Flutter", "Python", "AI/ML", "Video streaming"],
        targetAudience: "Students, educators, career changers"
      },
      {
        name: "Studi.OS",
        category: "Educational OS",
        status: "planned",
        description: "Operating system for education focused on collaborative project development and learning.",
        features: [
          "Collaborative workspaces",
          "Integrated learning tools",
          "Project management",
          "Cross-organizational collaboration",
          "AI-powered assistance"
        ],
        technologies: ["Flutter", "Rust", "AI/ML", "Real-time", "Cloud"],
        targetAudience: "Students, educators, educational institutions"
      },
      {
        name: "Quiz & E-Learning System",
        category: "Learning Tools",
        status: "development",
        description: "Advanced quiz and e-learning system with AI-generated content and adaptive learning.",
        features: [
          "AI-generated quizzes",
          "Adaptive learning paths",
          "Progress tracking",
          "Multi-subject support",
          "Interactive 3D content"
        ],
        technologies: ["Flutter", "AI/ML", "3D Graphics", "Analytics"],
        targetAudience: "Students, educators, self-learners"
      }
    ]
  },
  {
    name: "Entertainment & Gaming",
    description: "Gaming and entertainment platforms for interactive experiences.",
    products: [
      {
        name: "BubbleZ Interest Minigame",
        category: "Social Game",
        status: "development",
        description: "Interactive bubble-based minigame for matching interests and connecting users.",
        features: [
          "Interest matching",
          "Interactive bubbles",
          "Social connections",
          "Export functionality",
          "Customizable themes"
        ],
        technologies: ["Flutter", "Game Engine", "Social APIs", "Analytics"],
        targetAudience: "Social users, community members, educators"
      },
      {
        name: "Home Café Module",
        category: "Local Community",
        status: "planned",
        description: "Local community module for organizing events, sharing recipes, and building local connections.",
        features: [
          "Event organization",
          "Recipe sharing",
          "Local networking",
          "Community building",
          "Gamification elements"
        ],
        technologies: ["Flutter", "Location Services", "Social Features", "Real-time"],
        targetAudience: "Local communities, food enthusiasts, event organizers"
      }
    ]
  }
]; 