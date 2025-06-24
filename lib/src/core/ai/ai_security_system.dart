import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_architecture_system.dart';

// AI Security and Privacy System
class AISecuritySystem {
  static const String _securityConfigKey = 'ai_security_config';
  static const String _privacySettingsKey = 'ai_privacy_settings';
  static const String _auditLogKey = 'ai_audit_log';
  
  // Security configuration
  Map<String, dynamic> _securityConfig = {};
  Map<String, dynamic> _privacySettings = {};
  List<Map<String, dynamic>> _auditLog = [];
  
  // Privacy controls
  bool _dataRetentionEnabled = true;
  int _dataRetentionDays = 30;
  bool _anonymizationEnabled = true;
  bool _auditLoggingEnabled = true;
  
  AISecuritySystem() {
    // Initialize with default settings
  }
  
  // Secure AI request processing
  Future<AIRequest> secureRequest(AIRequest request) async {
    try {
      // Log request for audit
      await _logAuditEvent('request_received', {
        'request_id': request.id,
        'task_type': request.taskType.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      // Apply security policies
      final securedRequest = await _applySecurityPolicies(request);
      
      // Encrypt sensitive data
      final encryptedRequest = await _encryptSensitiveData(securedRequest);
      
      // Log successful security processing
      await _logAuditEvent('request_secured', {
        'request_id': request.id,
        'security_applied': true,
      });
      
      return encryptedRequest;
    } catch (e) {
      await _logAuditEvent('security_error', {
        'request_id': request.id,
        'error': e.toString(),
      });
      rethrow;
    }
  }
  
  // Secure AI response processing
  Future<AIResponse> secureResponse(AIResponse response) async {
    try {
      // Decrypt response if needed
      final decryptedResponse = await _decryptResponse(response);
      
      // Apply privacy controls
      final privacyControlledResponse = await _applyPrivacyControls(decryptedResponse);
      
      // Log response for audit
      await _logAuditEvent('response_processed', {
        'response_id': response.id,
        'model_used': response.usedModel.modelId,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      return privacyControlledResponse;
    } catch (e) {
      await _logAuditEvent('response_security_error', {
        'response_id': response.id,
        'error': e.toString(),
      });
      rethrow;
    }
  }
  
  // Apply security policies to request
  Future<AIRequest> _applySecurityPolicies(AIRequest request) async {
    AIRequest securedRequest = request;
    
    // Check data classification
    if (_containsPersonalData(request.prompt)) {
      securedRequest = await _applyDataClassificationPolicy(securedRequest);
    }
    
    // Check access control
    if (!_hasValidAccess(request.context)) {
      throw SecurityException('Access denied: insufficient permissions');
    }
    
    // Check data retention
    await _applyDataRetentionPolicy();
    
    return securedRequest;
  }
  
  // Apply data classification policy
  Future<AIRequest> _applyDataClassificationPolicy(AIRequest request) async {
    final enhancedContext = Map<String, dynamic>.from(request.context);
    enhancedContext['data_classification'] = 'personal_data';
    enhancedContext['encryption_required'] = true;
    
    return AIRequest(
      id: request.id,
      taskType: request.taskType,
      prompt: request.prompt,
      context: enhancedContext,
      preferredModel: request.preferredModel,
      parameters: request.parameters,
    );
  }
  
  // Apply privacy controls to response
  Future<AIResponse> _applyPrivacyControls(AIResponse response) async {
    String processedContent = response.content;
    
    // Anonymize personal data if enabled
    if (_anonymizationEnabled) {
      processedContent = await _anonymizeContent(processedContent);
    }
    
    // Remove sensitive information
    processedContent = await _removeSensitiveData(processedContent);
    
    return AIResponse(
      id: response.id,
      content: processedContent,
      usedModel: response.usedModel,
      metadata: response.metadata,
      confidence: response.confidence,
      sources: response.sources,
      isSuccess: response.isSuccess,
      error: response.error,
    );
  }
  
  // Encrypt sensitive data
  Future<AIRequest> _encryptSensitiveData(AIRequest request) async {
    if (!_requiresEncryption(request)) {
      return request;
    }
    
    final encryptedPrompt = await _encryptText(request.prompt);
    final encryptedContext = await _encryptMap(request.context);
    
    return AIRequest(
      id: request.id,
      taskType: request.taskType,
      prompt: encryptedPrompt,
      context: encryptedContext,
      preferredModel: request.preferredModel,
      parameters: request.parameters,
    );
  }
  
  // Decrypt response
  Future<AIResponse> _decryptResponse(AIResponse response) async {
    if (!_isEncrypted(response.content)) {
      return response;
    }
    
    final decryptedContent = await _decryptText(response.content);
    
    return AIResponse(
      id: response.id,
      content: decryptedContent,
      usedModel: response.usedModel,
      metadata: response.metadata,
      confidence: response.confidence,
      sources: response.sources,
      isSuccess: response.isSuccess,
      error: response.error,
    );
  }
  
  // Anonymize content
  Future<String> _anonymizeContent(String content) async {
    // Simple anonymization (in production, use proper NLP)
    String anonymized = content;
    
    // Replace email patterns
    anonymized = anonymized.replaceAll(
      RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),
      '[EMAIL]',
    );
    
    // Replace phone patterns
    anonymized = anonymized.replaceAll(
      RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b'),
      '[PHONE]',
    );
    
    // Replace names (simple pattern)
    anonymized = anonymized.replaceAll(
      RegExp(r'\b[A-Z][a-z]+ [A-Z][a-z]+\b'),
      '[NAME]',
    );
    
    return anonymized;
  }
  
  // Remove sensitive data
  Future<String> _removeSensitiveData(String content) async {
    // Remove API keys, tokens, etc.
    String cleaned = content;
    
    // Remove API key patterns
    cleaned = cleaned.replaceAll(
      RegExp(r'sk-[a-zA-Z0-9]{32,}'),
      '[API_KEY]',
    );
    
    // Remove access tokens
    cleaned = cleaned.replaceAll(
      RegExp(r'Bearer [a-zA-Z0-9._-]+'),
      '[ACCESS_TOKEN]',
    );
    
    return cleaned;
  }
  
  // Check if content contains personal data
  bool _containsPersonalData(String content) {
    final emailPattern = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final phonePattern = RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b');
    final namePattern = RegExp(r'\b[A-Z][a-z]+ [A-Z][a-z]+\b');
    
    return emailPattern.hasMatch(content) ||
           phonePattern.hasMatch(content) ||
           namePattern.hasMatch(content);
  }
  
  // Check if user has valid access
  bool _hasValidAccess(Map<String, dynamic> context) {
    // Simple access control (in production, use proper authentication)
    return context['user_authenticated'] == true &&
           context['permissions'] != null;
  }
  
  // Check if encryption is required
  bool _requiresEncryption(AIRequest request) {
    return request.context['encryption_required'] == true ||
           _containsPersonalData(request.prompt);
  }
  
  // Check if content is encrypted
  bool _isEncrypted(String content) {
    return content.startsWith('ENCRYPTED:');
  }
  
  // Apply data retention policy
  Future<void> _applyDataRetentionPolicy() async {
    if (!_dataRetentionEnabled) return;
    
    final cutoffDate = DateTime.now().subtract(Duration(days: _dataRetentionDays));
    
    // Remove old audit logs
    _auditLog.removeWhere((log) {
      final timestamp = DateTime.parse(log['timestamp']);
      return timestamp.isBefore(cutoffDate);
    });
    
    await _saveAuditLog();
  }
  
  // Log audit event
  Future<void> _logAuditEvent(String eventType, Map<String, dynamic> data) async {
    if (!_auditLoggingEnabled) return;
    
    final auditEntry = {
      'event_type': eventType,
      'timestamp': DateTime.now().toIso8601String(),
      'data': data,
    };
    
    _auditLog.add(auditEntry);
    
    // Keep audit log size manageable
    if (_auditLog.length > 10000) {
      _auditLog = _auditLog.skip(5000).toList();
    }
    
    await _saveAuditLog();
  }
  
  // Encryption/Decryption methods
  Future<String> _encryptText(String text) async {
    // Simple encryption (in production, use proper encryption)
    final bytes = utf8.encode(text);
    final encrypted = base64.encode(bytes);
    return 'ENCRYPTED:$encrypted';
  }
  
  Future<String> _decryptText(String encryptedText) async {
    if (!encryptedText.startsWith('ENCRYPTED:')) {
      return encryptedText;
    }
    
    final encrypted = encryptedText.substring(10);
    final bytes = base64.decode(encrypted);
    return utf8.decode(bytes);
  }
  
  Future<Map<String, dynamic>> _encryptMap(Map<String, dynamic> map) async {
    final encryptedMap = <String, dynamic>{};
    
    for (final entry in map.entries) {
      if (entry.value is String) {
        encryptedMap[entry.key] = await _encryptText(entry.value as String);
      } else {
        encryptedMap[entry.key] = entry.value;
      }
    }
    
    return encryptedMap;
  }
  
  // Security settings management
  Future<void> updateSecuritySettings(Map<String, dynamic> settings) async {
    _securityConfig.addAll(settings);
    await _saveSecurityConfig();
  }
  
  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    _privacySettings.addAll(settings);
    
    // Update privacy controls
    _dataRetentionEnabled = settings['data_retention_enabled'] ?? _dataRetentionEnabled;
    _dataRetentionDays = settings['data_retention_days'] ?? _dataRetentionDays;
    _anonymizationEnabled = settings['anonymization_enabled'] ?? _anonymizationEnabled;
    _auditLoggingEnabled = settings['audit_logging_enabled'] ?? _auditLoggingEnabled;
    
    await _savePrivacySettings();
  }
  
  // Get security report
  Map<String, dynamic> getSecurityReport() {
    return {
      'security_config': _securityConfig,
      'privacy_settings': _privacySettings,
      'audit_log_summary': {
        'total_events': _auditLog.length,
        'recent_events': _auditLog.take(10).toList(),
        'security_events': _auditLog.where((log) => 
            log['event_type'].toString().contains('security')).toList(),
      },
      'data_retention_status': {
        'enabled': _dataRetentionEnabled,
        'retention_days': _dataRetentionDays,
        'oldest_data': _auditLog.isNotEmpty 
            ? _auditLog.first['timestamp'] 
            : null,
      },
      'privacy_controls': {
        'anonymization_enabled': _anonymizationEnabled,
        'audit_logging_enabled': _auditLoggingEnabled,
      },
    };
  }
  
  // Export audit log
  Future<String> exportAuditLog() async {
    return jsonEncode(_auditLog);
  }
  
  // Clear audit log
  Future<void> clearAuditLog() async {
    _auditLog.clear();
    await _saveAuditLog();
  }
  
  // Persistence methods
  Future<void> _saveSecurityConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_securityConfigKey, jsonEncode(_securityConfig));
  }
  
  Future<void> _savePrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_privacySettingsKey, jsonEncode(_privacySettings));
  }
  
  Future<void> _saveAuditLog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_auditLogKey, jsonEncode(_auditLog));
  }
  
  Future<void> loadSecurityData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final securityJson = prefs.getString(_securityConfigKey);
    if (securityJson != null) {
      _securityConfig = Map<String, dynamic>.from(jsonDecode(securityJson));
    }
    
    final privacyJson = prefs.getString(_privacySettingsKey);
    if (privacyJson != null) {
      _privacySettings = Map<String, dynamic>.from(jsonDecode(privacyJson));
    }
    
    final auditJson = prefs.getString(_auditLogKey);
    if (auditJson != null) {
      _auditLog = List<Map<String, dynamic>>.from(jsonDecode(auditJson));
    }
  }
}

// Security Policy
class SecurityPolicy {
  final String name;
  final List<SecurityRule> rules;

  const SecurityPolicy({
    required this.name,
    required this.rules,
  });
}

// Security Rule
class SecurityRule {
  final String condition;
  final SecurityAction action;
  final SecurityPriority priority;

  const SecurityRule({
    required this.condition,
    required this.action,
    required this.priority,
  });
}

// Security Action
enum SecurityAction {
  allow,
  deny,
  encrypt,
  anonymize,
  delete,
  log,
}

// Security Priority
enum SecurityPriority {
  low,
  medium,
  high,
  critical,
}

// Security Exception
class SecurityException implements Exception {
  final String message;
  
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
} 