import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/c_community_voting/presentation/community_theme_controller.dart';

class SubmitThemeDialog extends ConsumerStatefulWidget {
  const SubmitThemeDialog({super.key});

  @override
  ConsumerState<SubmitThemeDialog> createState() => _SubmitThemeDialogState();
}

class _SubmitThemeDialogState extends ConsumerState<SubmitThemeDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      ref.read(communityThemeControllerProvider.notifier).submitTheme(
            title: _titleController.text,
            description: _descriptionController.text,
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Submit a New Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
} 