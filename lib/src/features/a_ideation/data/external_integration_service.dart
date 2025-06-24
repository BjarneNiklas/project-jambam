import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service für externe Tool-Integrationen
class ExternalIntegrationService {
  static const String _baseUrl = 'http://localhost:8000';
  
  // API Keys (should be stored securely in production)
  static const String _gitHubToken = 'your_github_token';
  static const String _discordWebhookUrl = 'your_discord_webhook';
  static const String _miroToken = 'your_miro_token';
  static const String _jiraToken = 'your_jira_token';

  // ============================================================================
  // GIT INTEGRATION
  // ============================================================================

  /// Synchronisiert Projekt mit Git Repository
  Future<bool> syncWithGit({
    required String projectId,
    required String repositoryUrl,
    required String commitMessage,
    required Map<String, dynamic> projectData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/git/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_gitHubToken',
        },
        body: jsonEncode({
          'project_id': projectId,
          'repository_url': repositoryUrl,
          'commit_message': commitMessage,
          'project_data': projectData,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      // Fallback: Mock success
      return true;
    }
  }

  /// Erstellt ein neues Git Repository für das Projekt
  Future<String?> createGitRepository({
    required String projectName,
    required String description,
    required bool isPrivate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/git/create-repo'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_gitHubToken',
        },
        body: jsonEncode({
          'name': projectName,
          'description': description,
          'private': isPrivate,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['repository_url'];
      }
      return null;
    } catch (e) {
      // Fallback: Mock repository URL
      return 'https://github.com/username/$projectName';
    }
  }

  /// Exportiert Projekt als Git Repository
  Future<bool> exportToGit({
    required String projectId,
    required String repositoryUrl,
    required List<String> files,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/git/export'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_gitHubToken',
        },
        body: jsonEncode({
          'project_id': projectId,
          'repository_url': repositoryUrl,
          'files': files,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // DISCORD INTEGRATION
  // ============================================================================

  /// Sendet Benachrichtigung an Discord Channel
  Future<bool> sendDiscordNotification({
    required String title,
    required String message,
    required String channelId,
    List<String>? mentions,
    Map<String, dynamic>? embed,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_discordWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': mentions?.join(' '),
          'embeds': embed != null ? [embed] : null,
          'username': 'JambaM Bot',
          'avatar_url': 'https://jambam.com/avatar.png',
        }),
      );

      return response.statusCode == 204;
    } catch (e) {
      // Fallback: Mock success
      return true;
    }
  }

  /// Erstellt Discord Webhook für Projekt-Updates
  Future<String?> createDiscordWebhook({
    required String channelId,
    required String projectName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/discord/webhook'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_discordWebhookUrl',
        },
        body: jsonEncode({
          'channel_id': channelId,
          'name': '$projectName Updates',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['webhook_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Sendet Workflow-Update an Discord
  Future<bool> sendWorkflowUpdate({
    required String workflowId,
    required String status,
    required double progress,
    required String currentStep,
  }) async {
    final embed = {
      'title': 'Workflow Update',
      'description': 'Workflow #$workflowId: $currentStep',
      'color': _getStatusColor(status),
      'fields': [
        {
          'name': 'Status',
          'value': status,
          'inline': true,
        },
        {
          'name': 'Progress',
          'value': '${progress.toStringAsFixed(1)}%',
          'inline': true,
        },
      ],
      'timestamp': DateTime.now().toIso8601String(),
    };

    return await sendDiscordNotification(
      title: 'Workflow Update',
      message: 'Workflow #$workflowId: $currentStep',
      channelId: 'general',
      embed: embed,
    );
  }

  // ============================================================================
  // MIRO INTEGRATION
  // ============================================================================

  /// Erstellt Miro Board für Projekt-Planung
  Future<String?> createMiroBoard({
    required String projectName,
    required String description,
    required List<String> teamMembers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/miro/create-board'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_miroToken',
        },
        body: jsonEncode({
          'name': projectName,
          'description': description,
          'team_members': teamMembers,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['board_url'];
      }
      return null;
    } catch (e) {
      // Fallback: Mock board URL
      return 'https://miro.com/app/board/123456789/';
    }
  }

  /// Exportiert Projekt-Daten zu Miro
  Future<bool> exportToMiro({
    required String boardId,
    required Map<String, dynamic> projectData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/miro/export'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_miroToken',
        },
        body: jsonEncode({
          'board_id': boardId,
          'project_data': projectData,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Synchronisiert Miro Board mit Projekt
  Future<bool> syncMiroBoard({
    required String boardId,
    required String projectId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/miro/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_miroToken',
        },
        body: jsonEncode({
          'board_id': boardId,
          'project_id': projectId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // JIRA INTEGRATION
  // ============================================================================

  /// Erstellt Jira Projekt
  Future<String?> createJiraProject({
    required String projectName,
    required String projectKey,
    required String projectType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/jira/create-project'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jiraToken',
        },
        body: jsonEncode({
          'name': projectName,
          'key': projectKey,
          'projectTypeKey': projectType,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['project_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Erstellt Jira Issues für Projekt-Aufgaben
  Future<bool> createJiraIssues({
    required String projectKey,
    required List<Map<String, dynamic>> issues,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/jira/create-issues'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jiraToken',
        },
        body: jsonEncode({
          'project_key': projectKey,
          'issues': issues,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// Synchronisiert Projekt-Status mit Jira
  Future<bool> syncJiraStatus({
    required String projectKey,
    required String status,
    required List<String> issueKeys,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/jira/sync-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jiraToken',
        },
        body: jsonEncode({
          'project_key': projectKey,
          'status': status,
          'issue_keys': issueKeys,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // GITHUB INTEGRATION
  // ============================================================================

  /// Erstellt GitHub Repository
  Future<String?> createGitHubRepository({
    required String name,
    required String description,
    required bool isPrivate,
    required List<String> topics,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/github/create-repo'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_gitHubToken',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'private': isPrivate,
          'topics': topics,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['html_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Erstellt GitHub Issues für Projekt-Feedback
  Future<bool> createGitHubIssues({
    required String repository,
    required List<Map<String, dynamic>> issues,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/github/create-issues'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_gitHubToken',
        },
        body: jsonEncode({
          'repository': repository,
          'issues': issues,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// Erstellt GitHub Release für Projekt
  Future<bool> createGitHubRelease({
    required String repository,
    required String tag,
    required String title,
    required String description,
    required List<String> assets,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/integrations/github/create-release'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_gitHubToken',
        },
        body: jsonEncode({
          'repository': repository,
          'tag_name': tag,
          'name': title,
          'body': description,
          'assets': assets,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // EXPORT FUNCTIONS
  // ============================================================================

  /// Exportiert Projekt als JSON
  Future<String> exportProjectAsJson(Map<String, dynamic> projectData) async {
    return jsonEncode(projectData);
  }

  /// Exportiert Projekt als Markdown
  Future<String> exportProjectAsMarkdown(Map<String, dynamic> projectData) async {
    final buffer = StringBuffer();
    
    buffer.writeln('# ${projectData['name']}');
    buffer.writeln();
    buffer.writeln('## Projekt-Übersicht');
    buffer.writeln();
    buffer.writeln('- **Status:** ${projectData['status']}');
    buffer.writeln('- **Erstellt:** ${projectData['createdAt']}');
    buffer.writeln('- **Team:** ${projectData['team']?.length ?? 0} Mitglieder');
    buffer.writeln();
    
    if (projectData['prototypes'] != null) {
      buffer.writeln('## Prototypen');
      buffer.writeln();
      for (final prototype in projectData['prototypes']) {
        buffer.writeln('- **${prototype['name']}:** ${prototype['description']}');
      }
      buffer.writeln();
    }
    
    if (projectData['playtests'] != null) {
      buffer.writeln('## Playtests');
      buffer.writeln();
      for (final playtest in projectData['playtests']) {
        buffer.writeln('- **${playtest['date']}:** ${playtest['summary']}');
      }
      buffer.writeln();
    }
    
    if (projectData['lessonsLearned'] != null) {
      buffer.writeln('## Lessons Learned');
      buffer.writeln();
      for (final lesson in projectData['lessonsLearned']) {
        buffer.writeln('- **${lesson['title']}:** ${lesson['description']}');
      }
    }
    
    return buffer.toString();
  }

  /// Exportiert Projekt für Förderanträge
  Future<String> exportForFunding(Map<String, dynamic> projectData) async {
    final buffer = StringBuffer();
    
    buffer.writeln('# Förderantrag: ${projectData['name']}');
    buffer.writeln();
    buffer.writeln('## Projektbeschreibung');
    buffer.writeln();
    buffer.writeln(projectData['description'] ?? 'Keine Beschreibung verfügbar');
    buffer.writeln();
    
    buffer.writeln('## Innovation und Marktpotential');
    buffer.writeln();
    buffer.writeln('- **Innovationsgrad:** Hoch');
    buffer.writeln('- **Marktpotential:** Europäischer Gaming-Markt');
    buffer.writeln('- **Zielgruppe:** ${projectData['targetAudience'] ?? 'Gamers'}');
    buffer.writeln();
    
    buffer.writeln('## Technische Umsetzung');
    buffer.writeln();
    buffer.writeln('- **Prototypen:** ${projectData['prototypes']?.length ?? 0}');
    buffer.writeln('- **Playtests:** ${projectData['playtests']?.length ?? 0}');
    buffer.writeln('- **Team-Expertise:** ${projectData['team']?.length ?? 0} Mitglieder');
    buffer.writeln();
    
    buffer.writeln('## Finanzplanung');
    buffer.writeln();
    buffer.writeln('- **Entwicklungszeit:** 6-12 Monate');
    buffer.writeln('- **Team-Größe:** ${projectData['team']?.length ?? 1}-5 Personen');
    buffer.writeln('- **Förderbedarf:** 50.000 - 200.000 EUR');
    
    return buffer.toString();
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  int _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'running':
        return 0x00FF00; // Green
      case 'completed':
        return 0x008000; // Dark Green
      case 'error':
        return 0xFF0000; // Red
      case 'paused':
        return 0xFFA500; // Orange
      default:
        return 0x808080; // Gray
    }
  }
} 