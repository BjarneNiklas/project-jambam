import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'invite_code_controller.dart';
import 'package:project_jambam/src/features/b_authentication/data/auth_repository_provider.dart';

class InviteCodeScreen extends ConsumerStatefulWidget {
  const InviteCodeScreen({super.key});

  @override
  ConsumerState<InviteCodeScreen> createState() => _InviteCodeScreenState();
}

class _InviteCodeScreenState extends ConsumerState<InviteCodeScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inviteCodeControllerProvider);
    final controller = ref.read(inviteCodeControllerProvider.notifier);
    final currentUser = ref.read(currentUserSyncProvider);
    final userId = currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Einladungscode')), 
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Hast du einen Einladungscode?', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Einladungscode',
                border: OutlineInputBorder(),
                errorText: state.isValid == false ? 'Ungültiger oder bereits verwendeter Code' : null,
              ),
              enabled: !state.isLoading,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      await controller.validate(codeController.text.trim());
                      if (ref.read(inviteCodeControllerProvider).isValid == true) {
                        await controller.activate(codeController.text.trim(), userId);
                        await controller.checkInviteStatus(userId);
                      }
                    },
              child: state.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Code prüfen & aktivieren'),
            ),
            const SizedBox(height: 24),
            if (state.isActivated == true)
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('Code erfolgreich aktiviert!', style: TextStyle(color: Colors.green)),
                ],
              ),
            if (state.error != null)
              Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.error!, style: TextStyle(color: Colors.red))),
                ],
              ),
            const SizedBox(height: 24),
            FutureBuilder(
              future: controller.checkInviteStatus(userId),
              builder: (context, snapshot) {
                if (state.hasValidInvite == true) {
                  return Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('Du hast bereits einen gültigen Einladungscode aktiviert.', style: TextStyle(color: Colors.blue)),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
} 