import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/accessibility_system.dart';

class AccessibilityOnboardingScreen extends ConsumerStatefulWidget {
  const AccessibilityOnboardingScreen({super.key});

  @override
  ConsumerState<AccessibilityOnboardingScreen> createState() => _AccessibilityOnboardingScreenState();
}

class _AccessibilityOnboardingScreenState extends ConsumerState<AccessibilityOnboardingScreen> {
  int currentStep = 0;
  final Map<String, dynamic> userProfile = {};
  
  final List<OnboardingStep> onboardingSteps = [
    const OnboardingStep(
      id: 'welcome',
      title: 'Willkommen bei JambaM! 🎮',
      description: 'Lass uns dein perfektes Lern-Erlebnis erstellen. Wir passen JambaM an deine Bedürfnisse an.',
      type: OnboardingStepType.interests,
      helpText: 'Keine Sorge - du kannst alles später ändern!',
    ),
    const OnboardingStep(
      id: 'experience',
      title: 'Deine Erfahrung',
      description: 'Wie würdest du deine Programmier-Erfahrung einschätzen?',
      type: OnboardingStepType.experienceLevel,
      options: [
        'Absolute Anfänger - Ich habe noch nie programmiert',
        'Anfänger - Ich kenne mich mit Computern aus',
        'Fortgeschritten - Ich habe schon etwas programmiert',
        'Erfahren - Ich bin ein erfahrener Entwickler',
        'Experte - Ich bin ein professioneller Game Developer',
      ],
    ),
    const OnboardingStep(
      id: 'goals',
      title: 'Deine Ziele',
      description: 'Was möchtest du mit JambaM erreichen?',
      type: OnboardingStepType.goalSetting,
      options: [
        'Hobby - Ich will einfach Spaß haben',
        'Fähigkeiten - Ich will neue Skills lernen',
        'Karriere - Ich will Game Developer werden',
        'Portfolio - Ich will Projekte sammeln',
        'Startup - Ich will ein kommerzielles Spiel erstellen',
        'Bildung - Für akademische Zwecke',
        'Sozial - Ich will Gleichgesinnte treffen',
      ],
    ),
    const OnboardingStep(
      id: 'time',
      title: 'Deine Zeit',
      description: 'Wie viel Zeit kannst du pro Session investieren?',
      type: OnboardingStepType.timeAvailability,
      options: [
        'Sehr begrenzt - 15-30 Minuten',
        'Begrenzt - 30-60 Minuten',
        'Flexibel - 1-2 Stunden',
        'Großzügig - 2+ Stunden',
        'Unbegrenzt - Vollzeit verfügbar',
      ],
    ),
    const OnboardingStep(
      id: 'learning',
      title: 'Dein Lernstil',
      description: 'Wie lernst du am liebsten?',
      type: OnboardingStepType.learningStyle,
      options: [
        'Visuell - Ich bevorzuge Diagramme und Videos',
        'Auditiv - Ich bevorzuge Audio-Erklärungen',
        'Kinästhetisch - Ich bevorzuge praktisches Lernen',
        'Lesend - Ich bevorzuge textbasiertes Lernen',
        'Sozial - Ich bevorzuge Lernen mit anderen',
        'Experimentell - Ich bevorzuge Versuch und Irrtum',
      ],
    ),
    const OnboardingStep(
      id: 'accessibility',
      title: 'Zugänglichkeit',
      description: 'Gibt es besondere Bedürfnisse, die wir berücksichtigen sollen?',
      type: OnboardingStepType.accessibilityNeeds,
      options: [
        'Keine besonderen Bedürfnisse',
        'Sehbehinderung - Ich brauche Screen Reader',
        'Hörbehinderung - Ich brauche Untertitel',
        'Motorische Einschränkungen - Ich brauche Voice Control',
        'Kognitive Einschränkungen - Ich brauche einfache Sprache',
        'Farbenblindheit - Ich brauche Alternativen',
        'Legasthenie - Ich brauche spezielle Schriftarten',
        'Angst - Ich brauche eine ruhige UI',
        'Zeitdruck - Ich brauche Quick-Start Optionen',
        'Sprachbarriere - Ich brauche mehrsprachige Unterstützung',
      ],
      skipOption: true,
    ),
    const OnboardingStep(
      id: 'device',
      title: 'Dein Gerät',
      description: 'Welches Gerät verwendest du hauptsächlich?',
      type: OnboardingStepType.deviceCheck,
      options: [
        'Einfaches Smartphone',
        'Modernes Smartphone',
        'Tablet (iPad/Android)',
        'Laptop',
        'Desktop PC',
        'VR Headset',
        'Mehrere Geräte',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final currentOnboardingStep = onboardingSteps[currentStep];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 JambaM Setup'),
        backgroundColor: colorScheme.primaryContainer,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (currentStep + 1) / onboardingSteps.length,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Counter
                  Text(
                    'Schritt ${currentStep + 1} von ${onboardingSteps.length}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Title
                  Text(
                    currentOnboardingStep.title,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    currentOnboardingStep.description,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  
                  // Help Text
                  if (currentOnboardingStep.helpText != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              currentOnboardingStep.helpText!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Options
                  if (currentOnboardingStep.options.isNotEmpty) ...[
                    ...currentOnboardingStep.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isSelected = userProfile[currentOnboardingStep.id] == index;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              userProfile[currentOnboardingStep.id] = index;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected 
                                  ? colorScheme.primary 
                                  : Colors.transparent,
                                width: 2,
                              ),
                              color: isSelected 
                                ? colorScheme.primaryContainer 
                                : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected 
                                      ? colorScheme.primary 
                                      : colorScheme.outline,
                                  ),
                                  child: isSelected 
                                    ? Icon(
                                        Icons.check,
                                        color: colorScheme.onPrimary,
                                        size: 16,
                                      )
                                    : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: isSelected 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                  
                  // Skip Option
                  if (currentOnboardingStep.skipOption) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            userProfile[currentOnboardingStep.id] = -1; // Skip
                          });
                          _nextStep();
                        },
                        child: const Text('Überspringen'),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Zurück'),
                    ),
                  ),
                if (currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceed() ? _nextStep : null,
                    child: Text(
                      currentStep == onboardingSteps.length - 1 
                        ? 'Fertigstellen' 
                        : 'Weiter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    final currentOnboardingStep = onboardingSteps[currentStep];
    if (currentOnboardingStep.skipOption && userProfile[currentOnboardingStep.id] == -1) {
      return true; // Skip option selected
    }
    return userProfile.containsKey(currentOnboardingStep.id);
  }

  void _nextStep() {
    if (currentStep < onboardingSteps.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _completeOnboarding() {
    // Create user profile based on responses
    final profile = _createUserProfile();
    
    // Show results and recommendations
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildCompletionDialog(profile),
    );
  }

  AccessibilityProfile _createUserProfile() {
    // Map responses to profile
    final skillLevel = _mapSkillLevel(userProfile['experience'] ?? 0);
    final learningStyle = _mapLearningStyle(userProfile['learning'] ?? 0);
    final accessibilityNeeds = _mapAccessibilityNeeds(userProfile['accessibility'] ?? -1);
    final timeAvailability = _mapTimeAvailability(userProfile['time'] ?? 2);
    final deviceCapabilities = _mapDeviceCapabilities(userProfile['device'] ?? 3);
    final learningGoals = _mapLearningGoals(userProfile['goals'] ?? 0);

    return AccessibilityProfile(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: 'JambaM User',
      description: 'Personalized profile based on onboarding',
      skillLevel: skillLevel,
      learningStyle: learningStyle,
      accessibilityNeeds: accessibilityNeeds,
      timeAvailability: timeAvailability,
      deviceCapabilities: deviceCapabilities,
      learningGoals: learningGoals,
    );
  }

  SkillLevel _mapSkillLevel(int response) {
    switch (response) {
      case 0: return SkillLevel.absoluteBeginner;
      case 1: return SkillLevel.beginner;
      case 2: return SkillLevel.intermediate;
      case 3: return SkillLevel.advanced;
      case 4: return SkillLevel.expert;
      default: return SkillLevel.beginner;
    }
  }

  LearningStyle _mapLearningStyle(int response) {
    switch (response) {
      case 0: return LearningStyle.visual;
      case 1: return LearningStyle.auditory;
      case 2: return LearningStyle.kinesthetic;
      case 3: return LearningStyle.reading;
      case 4: return LearningStyle.social;
      case 5: return LearningStyle.experimental;
      default: return LearningStyle.visual;
    }
  }

  List<AccessibilityNeed> _mapAccessibilityNeeds(int response) {
    if (response == -1) return [];
    
    switch (response) {
      case 1: return [AccessibilityNeed.visualImpairment];
      case 2: return [AccessibilityNeed.hearingImpairment];
      case 3: return [AccessibilityNeed.motorImpairment];
      case 4: return [AccessibilityNeed.cognitiveImpairment];
      case 5: return [AccessibilityNeed.colorBlindness];
      case 6: return [AccessibilityNeed.dyslexia];
      case 7: return [AccessibilityNeed.anxiety];
      case 8: return [AccessibilityNeed.timeConstraints];
      case 9: return [AccessibilityNeed.languageBarrier];
      default: return [];
    }
  }

  TimeAvailability _mapTimeAvailability(int response) {
    switch (response) {
      case 0: return TimeAvailability.veryLimited;
      case 1: return TimeAvailability.limited;
      case 2: return TimeAvailability.flexible;
      case 3: return TimeAvailability.generous;
      case 4: return TimeAvailability.unlimited;
      default: return TimeAvailability.flexible;
    }
  }

  List<DeviceCapability> _mapDeviceCapabilities(int response) {
    switch (response) {
      case 0: return [DeviceCapability.lowEndMobile];
      case 1: return [DeviceCapability.modernMobile];
      case 2: return [DeviceCapability.tablet];
      case 3: return [DeviceCapability.laptop];
      case 4: return [DeviceCapability.desktop];
      case 5: return [DeviceCapability.vrHeadset];
      case 6: return [DeviceCapability.multipleDevices];
      default: return [DeviceCapability.laptop];
    }
  }

  List<LearningGoal> _mapLearningGoals(int response) {
    switch (response) {
      case 0: return [LearningGoal.hobby];
      case 1: return [LearningGoal.skillDevelopment];
      case 2: return [LearningGoal.careerChange];
      case 3: return [LearningGoal.portfolio];
      case 4: return [LearningGoal.startup];
      case 5: return [LearningGoal.education];
      case 6: return [LearningGoal.social];
      default: return [LearningGoal.skillDevelopment];
    }
  }

  Widget _buildCompletionDialog(AccessibilityProfile profile) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return AlertDialog(
      title: Text(
        '🎉 Willkommen bei JambaM!',
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dein personalisiertes Profil wurde erstellt:',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            
            _buildProfileCard(profile, textTheme, colorScheme),
            const SizedBox(height: 16),
            
            Text(
              'JambaM wird sich automatisch an deine Bedürfnisse anpassen:',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            ..._buildRecommendations(profile).map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(rec)),
                ],
              ),
            )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop(); // Return to main screen
          },
          child: const Text('Profil bearbeiten'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop(); // Return to main screen
          },
          child: const Text('Los geht\'s!'),
        ),
      ],
    );
  }

  Widget _buildProfileCard(AccessibilityProfile profile, TextTheme textTheme, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getSkillLevelColor(profile.skillLevel),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getSkillLevelText(profile.skillLevel),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getLearningStyleColor(profile.learningStyle),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getLearningStyleText(profile.learningStyle),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Zeit: ${_getTimeAvailabilityText(profile.timeAvailability)}',
              style: textTheme.bodyMedium,
            ),
            if (profile.accessibilityNeeds.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Zugänglichkeit: ${profile.accessibilityNeeds.map((n) => _getAccessibilityNeedText(n)).join(', ')}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<String> _buildRecommendations(AccessibilityProfile profile) {
    final recommendations = <String>[];
    
    // Skill level recommendations
    switch (profile.skillLevel) {
      case SkillLevel.absoluteBeginner:
        recommendations.add('Einfache Tutorials mit visuellen Anleitungen');
        recommendations.add('Step-by-step Guides ohne Vorkenntnisse');
        break;
      case SkillLevel.beginner:
        recommendations.add('Grundlagen-Tutorials mit praktischen Übungen');
        recommendations.add('Community-Support für Anfänger');
        break;
      case SkillLevel.intermediate:
        recommendations.add('Fortgeschrittene Konzepte und Best Practices');
        recommendations.add('Projekt-basiertes Lernen');
        break;
      case SkillLevel.advanced:
        recommendations.add('Experten-Workshops und Mentoring');
        recommendations.add('Innovative Technologien und Forschung');
        break;
      case SkillLevel.expert:
        recommendations.add('Cutting-edge Forschung und Entwicklung');
        recommendations.add('Mentoring-Programme für andere');
        break;
    }
    
    // Learning style recommendations
    switch (profile.learningStyle) {
      case LearningStyle.visual:
        recommendations.add('Viele Diagramme, Videos und visuelle Guides');
        break;
      case LearningStyle.auditory:
        recommendations.add('Audio-Erklärungen und Podcasts');
        break;
      case LearningStyle.kinesthetic:
        recommendations.add('Interaktive Tutorials und Hands-on Projekte');
        break;
      case LearningStyle.reading:
        recommendations.add('Detaillierte Dokumentation und Artikel');
        break;
      case LearningStyle.social:
        recommendations.add('Community-Projekte und Gruppenarbeit');
        break;
      case LearningStyle.experimental:
        recommendations.add('Sandbox-Modus für freies Experimentieren');
        break;
    }
    
    // Time availability recommendations
    switch (profile.timeAvailability) {
      case TimeAvailability.veryLimited:
        recommendations.add('Quick-Start Optionen für kurze Sessions');
        break;
      case TimeAvailability.limited:
        recommendations.add('Modulare Lerneinheiten für 30-60 Minuten');
        break;
      case TimeAvailability.flexible:
        recommendations.add('Flexible Lernpfade für 1-2 Stunden');
        break;
      case TimeAvailability.generous:
        recommendations.add('Intensive Workshops und Deep-Dive Sessions');
        break;
      case TimeAvailability.unlimited:
        recommendations.add('Vollzeit-Programme und Immersive Experiences');
        break;
    }
    
    return recommendations;
  }

  Color _getSkillLevelColor(SkillLevel level) {
    switch (level) {
      case SkillLevel.absoluteBeginner: return Colors.green;
      case SkillLevel.beginner: return Colors.blue;
      case SkillLevel.intermediate: return Colors.orange;
      case SkillLevel.advanced: return Colors.red;
      case SkillLevel.expert: return Colors.purple;
    }
  }

  String _getSkillLevelText(SkillLevel level) {
    switch (level) {
      case SkillLevel.absoluteBeginner: return 'Anfänger';
      case SkillLevel.beginner: return 'Grundlagen';
      case SkillLevel.intermediate: return 'Fortgeschritten';
      case SkillLevel.advanced: return 'Erfahren';
      case SkillLevel.expert: return 'Experte';
    }
  }

  Color _getLearningStyleColor(LearningStyle style) {
    switch (style) {
      case LearningStyle.visual: return Colors.purple;
      case LearningStyle.auditory: return Colors.blue;
      case LearningStyle.kinesthetic: return Colors.green;
      case LearningStyle.reading: return Colors.orange;
      case LearningStyle.social: return Colors.pink;
      case LearningStyle.experimental: return Colors.teal;
    }
  }

  String _getLearningStyleText(LearningStyle style) {
    switch (style) {
      case LearningStyle.visual: return 'Visuell';
      case LearningStyle.auditory: return 'Auditiv';
      case LearningStyle.kinesthetic: return 'Praktisch';
      case LearningStyle.reading: return 'Lesend';
      case LearningStyle.social: return 'Sozial';
      case LearningStyle.experimental: return 'Experimentell';
    }
  }

  String _getTimeAvailabilityText(TimeAvailability time) {
    switch (time) {
      case TimeAvailability.veryLimited: return '15-30 Min';
      case TimeAvailability.limited: return '30-60 Min';
      case TimeAvailability.flexible: return '1-2 Stunden';
      case TimeAvailability.generous: return '2+ Stunden';
      case TimeAvailability.unlimited: return 'Vollzeit';
    }
  }

  String _getAccessibilityNeedText(AccessibilityNeed need) {
    switch (need) {
      case AccessibilityNeed.visualImpairment: return 'Sehbehinderung';
      case AccessibilityNeed.hearingImpairment: return 'Hörbehinderung';
      case AccessibilityNeed.motorImpairment: return 'Motorische Einschränkungen';
      case AccessibilityNeed.cognitiveImpairment: return 'Kognitive Einschränkungen';
      case AccessibilityNeed.colorBlindness: return 'Farbenblindheit';
      case AccessibilityNeed.dyslexia: return 'Legasthenie';
      case AccessibilityNeed.anxiety: return 'Angst';
      case AccessibilityNeed.timeConstraints: return 'Zeitdruck';
      case AccessibilityNeed.languageBarrier: return 'Sprachbarriere';
    }
  }
} 