import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkflowDiagramScreen extends ConsumerWidget {
  const WorkflowDiagramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔄 JambaM Workflow'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '🔄 The JambaM Ecosystem',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A circular workflow that continuously evolves and improves game design',
                      style: textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Workflow Diagram
            SizedBox(
              height: 600,
              child: CustomPaint(
                size: Size.infinite,
                painter: WorkflowPainter(colorScheme),
              ),
            ),

            const SizedBox(height: 32),

            // Detailed Steps
            _buildWorkflowSteps(textTheme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowSteps(TextTheme textTheme, ColorScheme colorScheme) {
    final steps = [
      {
        'phase': '🌱 Inspiration',
        'title': 'Jam Seeds',
        'description': 'Community generates flexible, inspiring starting points',
        'color': colorScheme.primary,
        'icon': Icons.psychology,
      },
      {
        'phase': '🤝 Collaboration',
        'title': 'Community Hub',
        'description': 'Voting, contributions, and community development',
        'color': colorScheme.secondary,
        'icon': Icons.people,
      },
      {
        'phase': '🧪 Research',
        'title': 'Jam Lab',
        'description': 'Scientific experiments and game design research',
        'color': colorScheme.tertiary,
        'icon': Icons.science,
      },
      {
        'phase': '🎯 Evolution',
        'title': 'Jam Kits',
        'description': 'Concrete, actionable game concepts with research insights',
        'color': Colors.green,
        'icon': Icons.auto_awesome,
      },
      {
        'phase': '🎮 Implementation',
        'title': 'Game Development',
        'description': 'Developers create games using the evolved concepts',
        'color': Colors.orange,
        'icon': Icons.sports_esports,
      },
      {
        'phase': '📊 Feedback',
        'title': 'Learning Loop',
        'description': 'Results feed back into the ecosystem for continuous improvement',
        'color': Colors.purple,
        'icon': Icons.trending_up,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Workflow Phases',
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...steps.map((step) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: step['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    step['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['phase'] as String,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: step['color'] as Color,
                        ),
                      ),
                      Text(
                        step['title'] as String,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        step['description'] as String,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

class WorkflowPainter extends CustomPainter {
  final ColorScheme colorScheme;

  WorkflowPainter(this.colorScheme);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;
    
    // Draw the main circle
    final paint = Paint()
      ..color = colorScheme.primaryContainer
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, paint);
    
    // Draw the workflow phases around the circle
    final phases = [
      {'name': '🌱 Seeds', 'color': colorScheme.primary, 'angle': 0},
      {'name': '🤝 Community', 'color': colorScheme.secondary, 'angle': 60},
      {'name': '🧪 Research', 'color': colorScheme.tertiary, 'angle': 120},
      {'name': '🎯 Kits', 'color': Colors.green, 'angle': 180},
      {'name': '🎮 Games', 'color': Colors.orange, 'angle': 240},
      {'name': '📊 Feedback', 'color': Colors.purple, 'angle': 300},
    ];
    
    for (final phase in phases) {
      final angle = phase['angle'] as double;
      final radian = angle * 3.14159 / 180;
      final x = center.dx + (radius - 40) * cos(radian);
      final y = center.dy + (radius - 40) * sin(radian);
      
      // Draw phase circle
      final phasePaint = Paint()
        ..color = phase['color'] as Color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), 30, phasePaint);
      
      // Draw phase name
      final textPainter = TextPainter(
        text: TextSpan(
          text: phase['name'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
      
      // Draw arrows connecting phases
      if (angle < 300) {
        final nextAngle = angle + 60;
        final nextRadian = nextAngle * 3.14159 / 180;
        final nextX = center.dx + (radius - 40) * cos(nextRadian);
        final nextY = center.dy + (radius - 40) * sin(nextRadian);
        
        final arrowPaint = Paint()
          ..color = Colors.grey
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
        
        canvas.drawLine(Offset(x, y), Offset(nextX, nextY), arrowPaint);
      }
    }
    
    // Draw center text
    final centerTextPainter = TextPainter(
      text: TextSpan(
        text: 'JambaM\nEcosystem',
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    centerTextPainter.layout();
    centerTextPainter.paint(
      canvas,
      Offset(center.dx - centerTextPainter.width / 2, center.dy - centerTextPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 