import '../domain/multi_agent_system.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Service für das zentrale Projekt-/Jam-Management
class ProjectMasterAgentService {
  static const String _baseUrl = 'http://localhost:8000';
  ProjectMasterAgent? _currentProject;

  /// Lädt ein Projekt anhand der ID
  Future<ProjectMasterAgent> loadProject(String id) async {
    try {
      // Try API call first
      final response = await http.get(
        Uri.parse('$_baseUrl/projects/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProjectMasterAgent.fromJson(data);
      } else {
        throw Exception('Failed to load project: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to local database or mock
      return _loadFromLocalDatabase(id);
    }
  }

  /// Loads project from local database
  Future<ProjectMasterAgent> _loadFromLocalDatabase(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectJson = prefs.getString('project_$id');
      
      if (projectJson != null) {
        final projectData = jsonDecode(projectJson) as Map<String, dynamic>;
        return ProjectMasterAgent.fromJson(projectData);
      }
    } catch (e) {
      debugPrint('Error loading project from local database: $e');
    }
    
    // Return demo project if no local data found
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

  /// Speichert das aktuelle Projekt
  Future<void> saveProject(ProjectMasterAgent project) async {
    try {
      // Try API call first
      final response = await http.post(
        Uri.parse('$_baseUrl/projects'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(project.toJson()),
      );
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to save project: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to local storage
      await _saveToLocalDatabase(project);
    }
    
    _currentProject = project;
  }

  /// Saves project to local database
  Future<void> _saveToLocalDatabase(ProjectMasterAgent project) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectJson = jsonEncode(project.toJson());
      await prefs.setString('project_${project.id}', projectJson);
      
      // Also save as current project
      await prefs.setString('current_project', projectJson);
      
      debugPrint('Project saved to local database: ${project.id}');
    } catch (e) {
      debugPrint('Error saving project to local database: $e');
      throw Exception('Failed to save project locally: $e');
    }
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

  /// Synchronisiert mit externen Tools
  Future<void> syncWithExternal(String tool) async {
    switch (tool.toLowerCase()) {
      case 'git':
        await _syncWithGit();
        break;
      case 'discord':
        await _syncWithDiscord();
        break;
      case 'miro':
        await _syncWithMiro();
        break;
      case 'slack':
        await _syncWithSlack();
        break;
      case 'trello':
        await _syncWithTrello();
        break;
      default:
        throw Exception('Unsupported external tool: $tool');
    }
  }

  /// Sync with Git repository
  Future<void> _syncWithGit() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sync/git'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'project_id': _currentProject?.id,
          'action': 'sync',
          'data': _currentProject?.toJson(),
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Git sync failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Git sync error: $e');
    }
  }

  /// Sync with Discord
  Future<void> _syncWithDiscord() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sync/discord'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'project_id': _currentProject?.id,
          'action': 'update_status',
          'data': {
            'name': _currentProject?.name,
            'status': _currentProject?.status.name,
            'team_size': _currentProject?.team.length,
          },
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Discord sync failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Discord sync error: $e');
    }
  }

  /// Sync with Miro
  Future<void> _syncWithMiro() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sync/miro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'project_id': _currentProject?.id,
          'action': 'update_board',
          'data': {
            'prototypes': _currentProject?.prototypes.map((p) => p.toJson()).toList(),
            'decisions': _currentProject?.decisions.map((d) => d.toJson()).toList(),
          },
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Miro sync failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Miro sync error: $e');
    }
  }

  /// Sync with Slack
  Future<void> _syncWithSlack() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sync/slack'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'project_id': _currentProject?.id,
          'action': 'send_update',
          'data': {
            'message': 'Project ${_currentProject?.name} status: ${_currentProject?.status.name}',
            'team_size': _currentProject?.team.length,
          },
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Slack sync failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Slack sync error: $e');
    }
  }

  /// Sync with Trello
  Future<void> _syncWithTrello() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sync/trello'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'project_id': _currentProject?.id,
          'action': 'update_board',
          'data': {
            'prototypes': _currentProject?.prototypes.map((p) => p.toJson()).toList(),
            'playtests': _currentProject?.playtests.map((p) => p.toJson()).toList(),
            'decisions': _currentProject?.decisions.map((d) => d.toJson()).toList(),
          },
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Trello sync failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Trello sync error: $e');
    }
  }

  /// Gibt das aktuelle Projekt zurück
  ProjectMasterAgent? get currentProject => _currentProject;
} 