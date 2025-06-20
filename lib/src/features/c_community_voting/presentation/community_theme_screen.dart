import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_jambam/src/features/c_community_voting/presentation/community_theme_controller.dart';
import 'package:project_jambam/src/features/c_community_voting/presentation/submit_theme_dialog.dart';

class CommunityThemeScreen extends ConsumerWidget {
  const CommunityThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themesAsync = ref.watch(communityThemeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Voting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const SubmitThemeDialog(),
              );
            },
          ),
        ],
      ),
      body: themesAsync.when(
        data: (themes) {
          if (themes.isEmpty) {
            return const Center(
                child: Text('No themes submitted yet. Be the first!'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(communityThemeControllerProvider.future),
            child: ListView.builder(
              itemCount: themes.length,
              itemBuilder: (context, index) {
                final theme = themes[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () {
                        ref
                            .read(communityThemeControllerProvider.notifier)
                            .voteForTheme(theme.id);
                      },
                    ),
                    title: Text(theme.title),
                    subtitle: Text(theme.description),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(theme.voteCount.toString(),
                            style: Theme.of(context).textTheme.headlineSmall),
                        const Text('Votes'),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
} 