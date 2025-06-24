import '../domain/multi_agent_system.dart';

/// Service für das zentrale Projekt-/Jam-Management
class ProjectMasterAgentService {
  ProjectMasterAgent? _currentProject;

  /// Lädt ein Projekt anhand der ID (Mock)
  Future<ProjectMasterAgent> loadProject(String id) async {
    return ProjectMasterAgent(
      id: id,
      name: 'Demo Game Jam',
      description: 'A demo project for Game Jam management',
      type: AgentType.orchestrator,
      status: AgentStatus.active,
      capabilities: {},
      skills: [],
      preferences: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      prototypes: [],
      playtests: [],
      team: [],
      assets: [],
      decisions: [],
    );
  }

  /// Speichert das aktuelle Projekt (Mock)
  Future<void> saveProject(ProjectMasterAgent project) async {
    _currentProject = project;
  }

  /// Fügt einen neuen Prototypen hinzu
  Future<void> addPrototype(Prototype prototype) async {
    _currentProject = _currentProject?.copyWith(
      prototypes: [...?_currentProject?.prototypes, prototype],
    );
  }

  /// Fügt ein Playtest-Ergebnis hinzu
  Future<void> addPlaytest(PlaytestResult playtest) async {
    _currentProject = _currentProject?.copyWith(
      playtests: [...?_currentProject?.playtests, playtest],
    );
  }

  /// Fügt Feedback hinzu
  Future<void> addFeedback(FeedbackEntry feedback) async {
    // _currentProject = _currentProject?.copyWith(
    //   feedback: [...?_currentProject?.feedback, feedback],
    // );
  }

  /// Fügt ein Teammitglied hinzu
  Future<void> addTeamMember(TeamMember member) async {
    _currentProject = _currentProject?.copyWith(
      team: [...?_currentProject?.team, member],
    );
  }

  /// Fügt eine Entscheidung hinzu
  Future<void> addDecision(ProjectDecision decision) async {
    _currentProject = _currentProject?.copyWith(
      decisions: [...?_currentProject?.decisions, decision],
    );
  }

  /// Fügt eine Lesson Learned hinzu
  Future<void> addLesson(LessonLearned lesson) async {
    // _currentProject = _currentProject?.copyWith(
    //   lessonsLearned: [...?_currentProject?.lessonsLearned, lesson],
    // );
  }

  /// Setzt den Projektstatus
  Future<void> setStatus(ProjectStatus status) async {
    // Map ProjectStatus to AgentStatus for compatibility
    final agentStatus = _mapProjectStatusToAgentStatus(status);
    _currentProject = _currentProject?.copyWith(status: agentStatus);
  }

  AgentStatus _mapProjectStatusToAgentStatus(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return AgentStatus.idle;
      case ProjectStatus.prototyping:
        return AgentStatus.processing;
      case ProjectStatus.playtesting:
        return AgentStatus.active;
      case ProjectStatus.production:
        return AgentStatus.active;
      case ProjectStatus.released:
        return AgentStatus.completed;
      case ProjectStatus.archived:
        return AgentStatus.error;
    }
  }

  /// Exportiert das Projekt als JSON
  Future<Map<String, dynamic>?> exportProject() async {
    return _currentProject?.toJson();
  }

  /// Synchronisiert mit externen Tools (Mock)
  Future<void> syncWithExternal(String tool) async {
  }

  /// Gibt das aktuelle Projekt zurück
  ProjectMasterAgent? get currentProject => _currentProject;
} 