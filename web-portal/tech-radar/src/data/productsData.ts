export interface Product {
  nameKey: string; // Key for translation
  categoryKey: string; // Key for translation
  status: 'active' | 'development' | 'planned' | 'deprecated';
  descriptionKey: string; // Key for translation
  featureKeys: string[]; // Keys for translation
  technologies: string[];
  targetAudienceKey: string; // Key for translation
  icon?: string; // Optional: For a specific product icon
}

export interface ProductCategory {
  nameKey: string; // Key for translation
  descriptionKey: string; // Key for translation
  products: Product[];
  icon?: string; // Optional: For a category icon (e.g., MUI icon name)
}

export const productsData: ProductCategory[] = [
  {
    nameKey: "products.categories.enginesCore.name",
    descriptionKey: "products.categories.enginesCore.description",
    icon: "BuildCircle",
    products: [
      {
        nameKey: "products.broxelEngine.name",
        categoryKey: "products.broxelEngine.category",
        status: "development",
        descriptionKey: "products.broxelEngine.description",
        featureKeys: [
          "products.broxelEngine.features.infiniteWorlds",
          "products.broxelEngine.features.realtimeProcedural",
          "products.broxelEngine.features.multiThreaded",
          "products.broxelEngine.features.modularArchitecture",
          "products.broxelEngine.features.crossPlatform"
        ],
        technologies: ["Rust", "C++", "Vulkan", "ECS", "Procedural Generation"],
        targetAudienceKey: "products.broxelEngine.targetAudience",
        icon: "Extension"
      },
      {
        nameKey: "products.luvyEngine.name",
        categoryKey: "products.luvyEngine.category",
        status: "planned",
        descriptionKey: "products.luvyEngine.description",
        featureKeys: [
          "products.luvyEngine.features.realtime3D",
          "products.luvyEngine.features.xrSupport",
          "products.luvyEngine.features.aiContent",
          "products.luvyEngine.features.crossPlatform",
          "products.luvyEngine.features.communityDriven"
        ],
        technologies: ["Rust", "WGPU", "OpenXR", "AI/ML", "WebAssembly"],
        targetAudienceKey: "products.luvyEngine.targetAudience",
        icon: "ThreeDRotation"
      }
    ]
  },
  {
    nameKey: "products.categories.aiContent.name",
    descriptionKey: "products.categories.aiContent.description",
    icon: "AutoAwesome",
    products: [
      {
        nameKey: "products.jambamAiStudio.name",
        categoryKey: "products.jambamAiStudio.category",
        status: "active",
        descriptionKey: "products.jambamAiStudio.description",
        featureKeys: [
          "products.jambamAiStudio.features.multimodalAi",
          "products.jambamAiStudio.features.assetPipeline",
          "products.jambamAiStudio.features.communityTraining",
          "products.jambamAiStudio.features.realtimeCollab",
          "products.jambamAiStudio.features.qualityAssurance"
        ],
        technologies: ["Python", "PyTorch", "FastAPI", "Docker", "Kubernetes", "Stable Diffusion XL"],
        targetAudienceKey: "products.jambamAiStudio.targetAudience",
        icon: "Adb"
      },
      {
        nameKey: "products.auraxPlatform.name",
        categoryKey: "products.auraxPlatform.category",
        status: "development",
        descriptionKey: "products.auraxPlatform.description",
        featureKeys: [
          "products.auraxPlatform.features.aiCoCreation",
          "products.auraxPlatform.features.generative3D",
          "products.auraxPlatform.features.photogrammetry",
          "products.auraxPlatform.features.realtimeCollab",
          "products.auraxPlatform.features.communityAiTraining"
        ],
        technologies: ["Python", "AI/ML", "ThreeJS", "Blender API", "Gaussian Splatting"],
        targetAudienceKey: "products.auraxPlatform.targetAudience",
        icon: "Camera"
      }
    ]
  },
  {
    nameKey: "products.categories.communityCollab.name",
    descriptionKey: "products.categories.communityCollab.description",
    icon: "Groups",
    products: [
      {
        nameKey: "products.jambamCommunityHub.name",
        categoryKey: "products.jambamCommunityHub.category",
        status: "active",
        descriptionKey: "products.jambamCommunityHub.description",
        featureKeys: [
          "products.jambamCommunityHub.features.userContent",
          "products.jambamCommunityHub.features.collabProjects",
          "products.jambamCommunityHub.features.votingFeedback",
          "products.jambamCommunityHub.features.devToolsIntegration",
          "products.jambamCommunityHub.features.gamification"
        ],
        technologies: ["Flutter", "Supabase", "PostgreSQL", "Dart Frog", "Material You"],
        targetAudienceKey: "products.jambamCommunityHub.targetAudience",
        icon: "Hub"
      },
      {
        nameKey: "products.gameJamPlatform.name",
        categoryKey: "products.gameJamPlatform.category",
        status: "planned",
        descriptionKey: "products.gameJamPlatform.description",
        featureKeys: [
          "products.gameJamPlatform.features.jamManagement",
          "products.gameJamPlatform.features.realtimeCollab",
          "products.gameJamPlatform.features.assetSharing",
          "products.gameJamPlatform.features.judgingVoting",
          "products.gameJamPlatform.features.communityFeedback"
        ],
        technologies: ["Next.js", "Supabase Realtime", "WebRTC", "GraphQL"],
        targetAudienceKey: "products.gameJamPlatform.targetAudience",
        icon: "EmojiEvents"
      }
    ]
  },
  {
    nameKey: "products.categories.devTools.name",
    descriptionKey: "products.categories.devTools.description",
    icon: "Construction",
    products: [
      {
        nameKey: "products.engineAdapterFramework.name",
        categoryKey: "products.engineAdapterFramework.category",
        status: "development",
        descriptionKey: "products.engineAdapterFramework.description",
        featureKeys: [
          "products.engineAdapterFramework.features.multiEngine",
          "products.engineAdapterFramework.features.standardApi",
          "products.engineAdapterFramework.features.pluginArchitecture",
          "products.engineAdapterFramework.features.performanceOpt",
          "products.engineAdapterFramework.features.crossPlatform"
        ],
        technologies: ["Rust", "FFI", "gRPC", "WebAssembly", "Unity", "Godot", "Unreal Engine"],
        targetAudienceKey: "products.engineAdapterFramework.targetAudience",
        icon: "SettingsInputComponent"
      },
      {
        nameKey: "products.jambamIde.name",
        categoryKey: "products.jambamIde.category",
        status: "planned",
        descriptionKey: "products.jambamIde.description",
        featureKeys: [
          "products.jambamIde.features.multiLanguage",
          "products.jambamIde.features.aiCoding",
          "products.jambamIde.features.integratedTesting",
          "products.jambamIde.features.deploymentTools",
          "products.jambamIde.features.communityIntegration"
        ],
        technologies: ["VS Code Extension API", "TypeScript", "Rust Language Server", "WASM"],
        targetAudienceKey: "products.jambamIde.targetAudience",
        icon: "Terminal"
      },
      {
        nameKey: "products.assetPipeline.name",
        categoryKey: "products.assetPipeline.category",
        status: "development",
        descriptionKey: "products.assetPipeline.description",
        featureKeys: [
          "products.assetPipeline.features.automatedProcessing",
          "products.assetPipeline.features.formatConversion",
          "products.assetPipeline.features.qualityOptimization",
          "products.assetPipeline.features.versionControl",
          "products.assetPipeline.features.collabEditing"
        ],
        technologies: ["Python", "Celery", "RabbitMQ", "OpenUSD", "glTF", "Blender Scripting"],
        targetAudienceKey: "products.assetPipeline.targetAudience",
        icon: "DynamicFeed"
      }
    ]
  },
  {
    nameKey: "products.categories.educationalTraining.name",
    descriptionKey: "products.categories.educationalTraining.description",
    icon: "School",
    products: [
      {
        nameKey: "products.jambamLearningPlatform.name",
        categoryKey: "products.jambamLearningPlatform.category",
        status: "planned",
        descriptionKey: "products.jambamLearningPlatform.description",
        featureKeys: [
          "products.jambamLearningPlatform.features.interactiveTutorials",
          "products.jambamLearningPlatform.features.projectBasedLearning",
          "products.jambamLearningPlatform.features.aiFeedback",
          "products.jambamLearningPlatform.features.communityMentoring",
          "products.jambamLearningPlatform.features.certification"
        ],
        technologies: ["Flutter Web", "Firebase", "AI/ML (NLP)", "H5P"],
        targetAudienceKey: "products.jambamLearningPlatform.targetAudience",
        icon: "MenuBook"
      },
      {
        nameKey: "products.studios.name",
        categoryKey: "products.studios.category",
        status: "development",
        descriptionKey: "products.studios.description",
        featureKeys: [
          "products.studios.features.collabWorkspaces",
          "products.studios.features.integratedLearning",
          "products.studios.features.projectManagement",
          "products.studios.features.crossOrgCollab",
          "products.studios.features.aiAssistance"
        ],
        technologies: ["Flutter", "Rust", "WebSockets", "CRDTs", "AI/ML"],
        targetAudienceKey: "products.studios.targetAudience",
        icon: "CastForEducation"
      },
      {
        nameKey: "products.quizELearning.name",
        categoryKey: "products.quizELearning.category",
        status: "development",
        descriptionKey: "products.quizELearning.description",
        featureKeys: [
          "products.quizELearning.features.aiQuizzes",
          "products.quizELearning.features.adaptiveLearning",
          "products.quizELearning.features.progressTracking",
          "products.quizELearning.features.multiSubject",
          "products.quizELearning.features.interactive3d"
        ],
        technologies: ["Flutter", "OpenAI API", "ThreeJS", "Analytics Engine"],
        targetAudienceKey: "products.quizELearning.targetAudience",
        icon: "Quiz"
      }
    ]
  },
  {
    nameKey: "products.categories.entertainmentGaming.name",
    descriptionKey: "products.categories.entertainmentGaming.description",
    icon: "SportsEsports",
    products: [
      {
        nameKey: "products.bubblezMinigame.name",
        categoryKey: "products.bubblezMinigame.category",
        status: "active",
        descriptionKey: "products.bubblezMinigame.description",
        featureKeys: [
          "products.bubblezMinigame.features.interestMatching",
          "products.bubblezMinigame.features.interactiveBubbles",
          "products.bubblezMinigame.features.socialConnections",
          "products.bubblezMinigame.features.exportFunctionality",
          "products.bubblezMinigame.features.customThemes"
        ],
        technologies: ["Flutter", "Flame Engine", "Supabase Auth", "Firebase Analytics"],
        targetAudienceKey: "products.bubblezMinigame.targetAudience",
        icon: "BubbleChart"
      },
      {
        nameKey: "products.homeCafeModule.name",
        categoryKey: "products.homeCafeModule.category",
        status: "planned",
        descriptionKey: "products.homeCafeModule.description",
        featureKeys: [
          "products.homeCafeModule.features.eventOrganization",
          "products.homeCafeModule.features.recipeSharing",
          "products.homeCafeModule.features.localNetworking",
          "products.homeCafeModule.features.communityBuilding",
          "products.homeCafeModule.features.gamification"
        ],
        technologies: ["Flutter", "Firebase Firestore", "Geolocation API", "Algolia Search"],
        targetAudienceKey: "products.homeCafeModule.targetAudience",
        icon: "Coffee"
      }
    ]
  }
]; 