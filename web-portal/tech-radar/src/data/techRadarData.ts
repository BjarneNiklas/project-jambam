export interface Quadrant {
  name: string;
  description: string;
}

export interface Ring {
  name: string;
  description: string;
}

export interface TechItem {
  name: string;
  quadrant: string;
  ring: string;
  description: string;
  category: string;
}

export interface TechRadarData {
  quadrants: Quadrant[];
  rings: Ring[];
  items: TechItem[];
}

export const techRadarData: TechRadarData = {
  quadrants: [
    {
      name: "Techniques",
      description: "Agile methodologies, architectural patterns, development practices."
    },
    {
      name: "Tools",
      description: "Software, libraries, and services that aid development."
    },
    {
      name: "Platforms",
      description: "Databases, cloud platforms, operating systems, and infrastructure."
    },
    {
      name: "Languages & Frameworks",
      description: "Programming languages and frameworks used to build software."
    }
  ],
  rings: [
    {
      name: "ADOPT",
      description: "Technologies we are actively using and recommend broadly."
    },
    {
      name: "TRIAL",
      description: "Technologies we are actively experimenting with and believe have high potential."
    },
    {
      name: "ASSESS",
      description: "Technologies we are currently exploring and evaluating for future use."
    },
    {
      name: "HOLD",
      description: "Technologies we are phasing out or do not recommend for new projects."
    }
  ],
  items: [
    // Languages & Frameworks - ADOPT
    {
      name: "Dart (Flutter)",
      quadrant: "Languages & Frameworks",
      ring: "ADOPT",
      description: "Primary framework for cross-platform UI development.",
      category: "Core Development"
    },
    {
      name: "Rust",
      quadrant: "Languages & Frameworks",
      ring: "ADOPT",
      description: "Used for middleware, engine adapters, and performance-critical backend services.",
      category: "Core Development"
    },
    {
      name: "Python",
      quadrant: "Languages & Frameworks",
      ring: "ADOPT",
      description: "For AI model integration, engine adapters via IPC, and data processing.",
      category: "AI/ML Stack"
    },
    
    // Languages & Frameworks - TRIAL
    {
      name: "C# (Unity)",
      quadrant: "Languages & Frameworks",
      ring: "TRIAL",
      description: "Supported via engine adapter for Unity Engine projects.",
      category: "Game Engines"
    },
    {
      name: "GDScript (Godot)",
      quadrant: "Languages & Frameworks",
      ring: "TRIAL",
      description: "Supported via engine adapter for Godot Engine projects.",
      category: "Game Engines"
    },
    
    // Languages & Frameworks - ASSESS
    {
      name: "C/C++",
      quadrant: "Languages & Frameworks",
      ring: "ASSESS",
      description: "Considered for engine adapters via FFI for performance critical integrations.",
      category: "Core Development"
    },
    
    // Platforms - ADOPT
    {
      name: "Supabase/PostgreSQL",
      quadrant: "Platforms",
      ring: "ADOPT",
      description: "Primary cloud data store and backend-as-a-service.",
      category: "Backend Infrastructure"
    },
    {
      name: "SQLite",
      quadrant: "Platforms",
      ring: "ADOPT",
      description: "For offline data storage and local development.",
      category: "Backend Infrastructure"
    },
    {
      name: "Web (Flutter Web)",
      quadrant: "Platforms",
      ring: "ADOPT",
      description: "Target platform for UI deployment.",
      category: "Deployment Platforms"
    },
    {
      name: "Mobile (iOS, Android)",
      quadrant: "Platforms",
      ring: "ADOPT",
      description: "Target platform for UI deployment via Flutter.",
      category: "Deployment Platforms"
    },
    {
      name: "Desktop (Windows, macOS, Linux)",
      quadrant: "Platforms",
      ring: "ADOPT",
      description: "Target platform for UI deployment via Flutter.",
      category: "Deployment Platforms"
    },
    
    // Platforms - TRIAL
    {
      name: "Unity Engine",
      quadrant: "Platforms",
      ring: "TRIAL",
      description: "Game engine supported via engine adapter for 3D content creation.",
      category: "Game Engines"
    },
    {
      name: "Godot Engine",
      quadrant: "Platforms",
      ring: "TRIAL",
      description: "Open-source game engine supported via engine adapter.",
      category: "Game Engines"
    },
    {
      name: "Bevy Engine",
      quadrant: "Platforms",
      ring: "TRIAL",
      description: "Rust-based game engine with ECS architecture for performance-critical applications.",
      category: "Game Engines"
    },
    
    // Platforms - ASSESS
    {
      name: "Unreal Engine",
      quadrant: "Platforms",
      ring: "ASSESS",
      description: "High-end game engine for photorealistic 3D content and advanced graphics.",
      category: "Game Engines"
    },
    {
      name: "O3DE Engine",
      quadrant: "Platforms",
      ring: "ASSESS",
      description: "Amazon's open-source 3D engine, being assessed for future engine adapter support.",
      category: "Game Engines"
    },
    
    // Tools - ADOPT
    {
      name: "flutter_rust_bridge",
      quadrant: "Tools",
      ring: "ADOPT",
      description: "Used for FFI between Flutter (Dart) and Rust middleware.",
      category: "Development Tools"
    },
    {
      name: "OpenAPI",
      quadrant: "Tools",
      ring: "ADOPT",
      description: "Standard for API design and specification.",
      category: "Development Tools"
    },
    {
      name: "FastAPI",
      quadrant: "Tools",
      ring: "ADOPT",
      description: "Modern Python web framework for building APIs with automatic OpenAPI documentation.",
      category: "Backend Infrastructure"
    },
    {
      name: "Git / GitHub Actions",
      quadrant: "Tools",
      ring: "ADOPT",
      description: "For version control and CI/CD pipelines.",
      category: "Development Tools"
    },
    {
      name: "Material 3",
      quadrant: "Tools",
      ring: "ADOPT",
      description: "Latest Material Design system with expressive theming and dynamic color support.",
      category: "UI/UX"
    },
    
    // Tools - TRIAL
    {
      name: "gRPC",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "Being trialed for Inter-Process Communication (IPC) with engine adapters.",
      category: "Development Tools"
    },
    {
      name: "Ollama",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "For running local AI models and inference.",
      category: "AI/ML Stack"
    },
    {
      name: "Stable Diffusion",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "For AI image generation capabilities and content creation.",
      category: "AI/ML Stack"
    },
    {
      name: "HuggingFace Models",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "For integrating various pre-trained AI models and transformers.",
      category: "AI/ML Stack"
    },
    {
      name: "OpenAI API",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "For integrating OpenAI's AI models and GPT capabilities.",
      category: "AI/ML Stack"
    },
    {
      name: "Gemini API",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "Google's multimodal AI API for text, image, and code generation.",
      category: "AI/ML Stack"
    },
    {
      name: "BrickGPT",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "AI-powered 3D model generation for procedural content creation.",
      category: "AI/ML Stack"
    },
    {
      name: "DreamFusion",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "Text-to-3D generation using neural radiance fields (NeRF).",
      category: "AI/ML Stack"
    },
    {
      name: "Gaussian Splatting",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "Real-time 3D scene representation and rendering technique.",
      category: "3D/XR"
    },
    {
      name: "OpenUSD",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "Universal Scene Description for 3D content interchange and collaboration.",
      category: "3D/XR"
    },
    {
      name: "Blender",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "Free 3D creation suite with Python API for automated content generation.",
      category: "3D/XR"
    },
    {
      name: "Riverpod",
      quadrant: "Tools",
      ring: "TRIAL",
      description: "State management solution for Flutter with dependency injection.",
      category: "Development Tools"
    },
    
    // Tools - ASSESS
    {
      name: "Docker",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "Containerization for deployment and development environments.",
      category: "Backend Infrastructure"
    },
    {
      name: "TensorFlow",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "Open-source machine learning framework for AI model development.",
      category: "AI/ML Stack"
    },
    {
      name: "PyTorch",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "Research-focused machine learning framework with dynamic computation graphs.",
      category: "AI/ML Stack"
    },
    {
      name: "ONNX",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "Open format for machine learning model interoperability and optimization.",
      category: "AI/ML Stack"
    },
    {
      name: "OpenXR",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "Open standard for VR/AR development and cross-platform XR applications.",
      category: "3D/XR"
    },
    {
      name: "WebXR",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "Web standard for VR/AR experiences in browsers.",
      category: "3D/XR"
    },
    {
      name: "Kubernetes/k3s",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "Container orchestration platform for scalable deployments.",
      category: "Backend Infrastructure"
    },
    {
      name: "Keycloak",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "Open-source identity and access management for SSO and OAuth2.",
      category: "Backend Infrastructure"
    },
    {
      name: "Docusaurus",
      quadrant: "Tools",
      ring: "ASSESS",
      description: "React-based static site generator for creating beautiful documentation websites.",
      category: "Development Tools"
    },
    
    // Techniques - ADOPT
    {
      name: "Agile Development",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Iterative and flexible project development methodology.",
      category: "Development Practices"
    },
    {
      name: "CI/CD",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Continuous Integration and Continuous Deployment for automated software delivery.",
      category: "Development Practices"
    },
    {
      name: "Clean Architecture",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Architectural principle for separation of concerns and maintainability.",
      category: "Architecture"
    },
    {
      name: "Community-Driven Development",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Involving the community in the development process and decision-making.",
      category: "Development Practices"
    },
    {
      name: "Modular Design",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Building the system from independent, interchangeable modules.",
      category: "Architecture"
    },
    {
      name: "Plug-in Architecture",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Allowing extensibility through plugins and third-party integrations.",
      category: "Architecture"
    },
    {
      name: "FFI (Foreign Function Interface)",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Used for communication between different programming languages (Dart-Rust).",
      category: "Development Tools"
    },
    {
      name: "Procedural Generation (ProcGen)",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Core technique for automated content creation and world generation.",
      category: "Game Development"
    },
    
    // Techniques - TRIAL
    {
      name: "Design Systems",
      quadrant: "Techniques",
      ring: "TRIAL",
      description: "Systematizing UI components for consistency and scalability.",
      category: "UI/UX"
    },
    {
      name: "Event Sourcing",
      quadrant: "Techniques",
      ring: "TRIAL",
      description: "Architectural pattern for capturing all changes as a sequence of events.",
      category: "Architecture"
    },
    {
      name: "Incremental ProcGen",
      quadrant: "Techniques",
      ring: "TRIAL",
      description: "Advanced procedural generation that builds upon existing content for more coherent worlds.",
      category: "Game Development"
    },
    {
      name: "Neural Rendering",
      quadrant: "Techniques",
      ring: "TRIAL",
      description: "AI-powered rendering techniques for photorealistic and stylized graphics.",
      category: "AI/ML Stack"
    },
    {
      name: "Federated Learning",
      quadrant: "Techniques",
      ring: "TRIAL",
      description: "Distributed machine learning approach for privacy-preserving AI model training.",
      category: "AI/ML Stack"
    },
    
    // Techniques - ASSESS
    {
      name: "Blockchain for Digital Assets",
      quadrant: "Techniques",
      ring: "ASSESS",
      description: "Exploring blockchain for verification and trading of digital assets.",
      category: "3D/XR"
    },
    {
      name: "Offline-First",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Ensuring core functionality is available without an internet connection.",
      category: "Architecture"
    },
    {
      name: "Mobile-First",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Prioritizing mobile user experience in UI design and development.",
      category: "UI/UX"
    },
    {
      name: "Test-First (TDD)",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Test-Driven Development practice for quality assurance.",
      category: "Development Practices"
    },
    {
      name: "Clean Architecture",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Architectural pattern for separation of concerns and maintainability.",
      category: "Architecture"
    },
    {
      name: "Modular Design",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Building the system from independent, interchangeable modules.",
      category: "Architecture"
    },
    {
      name: "Plug-in Architecture",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Allowing extensibility through plugins and third-party integrations.",
      category: "Architecture"
    },
    {
      name: "FFI (Foreign Function Interface)",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Used for communication between different programming languages (Dart-Rust).",
      category: "Development Tools"
    },
    {
      name: "Procedural Generation (ProcGen)",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Core technique for automated content creation and world generation.",
      category: "Game Development"
    },
    {
      name: "Community-Driven Development",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Involving the community in the development process and decision-making.",
      category: "Development Practices"
    },
    {
      name: "CI/CD",
      quadrant: "Techniques",
      ring: "ADOPT",
      description: "Continuous Integration and Continuous Deployment practices.",
      category: "Development Practices"
    },
    
    // Techniques - TRIAL
    {
      name: "Incremental ProcGen",
      quadrant: "Techniques",
      ring: "TRIAL",
      description: "Advanced procedural generation that builds upon existing content for more coherent worlds.",
      category: "Game Development"
    },
    {
      name: "Neural Rendering",
      quadrant: "Techniques",
      ring: "TRIAL",
      description: "AI-powered rendering techniques for photorealistic and stylized graphics.",
      category: "AI/ML Stack"
    },
    {
      name: "Federated Learning",
      quadrant: "Techniques",
      ring: "TRIAL",
      description: "Distributed machine learning approach for privacy-preserving AI model training.",
      category: "AI/ML Stack"
    }
  ]
}; 