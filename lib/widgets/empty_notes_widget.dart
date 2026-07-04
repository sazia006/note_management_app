import 'package:flutter/material.dart';

class EmptyNotesWidget extends StatelessWidget {
  final VoidCallback onCreateNote;

  const EmptyNotesWidget({super.key, required this.onCreateNote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sticky_note_2_outlined,
                size: 70,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "No Notes Yet",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Create your first note to keep your ideas, tasks, and reminders organized.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 30),

            FilledButton.icon(
              onPressed: onCreateNote,
              icon: const Icon(Icons.add),
              label: const Text("Create Note"),
            ),
          ],
        ),
      ),
    );
  }
}
