import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_management_app/providers/theme_provider.dart';
import 'package:note_management_app/screens/notes/add_edit_note_screen.dart';
import 'package:provider/provider.dart';

import '../../models/note_model.dart';
import '../../providers/note_provider.dart';
import '../../widgets/empty_notes_widget.dart';
import '../../widgets/note_card.dart';
import '../../widgets/search_bar_widget.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditNoteScreen()),
    );

    if (!mounted) return;

    context.read<NoteProvider>().loadNotes();
  }

  Future<void> _openEdit(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditNoteScreen(note: note)),
    );

    if (!mounted) return;

    context.read<NoteProvider>().loadNotes();
  }

  Future<void> _deleteNote(Note note) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 42),
          title: const Text("Delete Note"),
          content: const Text(
            "Are you sure you want to permanently delete this note?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final success = await context.read<NoteProvider>().deleteNote(note.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          success ? "🗑️ Note deleted successfully" : "Unable to delete note",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NoteX",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  "Organize your thoughts",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: "Refresh",
                onPressed: provider.loadNotes,
                icon: const Icon(Icons.refresh_rounded),
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return IconButton(
                    tooltip: "Toggle Theme",
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          RotationTransition(turns: animation, child: child),
                      child: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        key: ValueKey(themeProvider.isDarkMode),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openAddNote,
            icon: const Icon(Icons.add),
            label: const Text(""),
          ),

          body: Column(
            children: [
              const SizedBox(height: 8),

              SearchBarWidget(
                controller: _searchController,
                onChanged: provider.updateSearch,
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.errorMessage != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.cloud_off_rounded,
                                color: Colors.red,
                                size: 70,
                              ),

                              const SizedBox(height: 20),

                              Text(
                                provider.errorMessage!,
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 20),

                              FilledButton.icon(
                                onPressed: provider.loadNotes,
                                icon: const Icon(Icons.refresh),
                                label: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final notes = provider.notes;

                    if (notes.isEmpty) {
                      return EmptyNotesWidget(onCreateNote: _openAddNote);
                    }
                    return RefreshIndicator(
                      onRefresh: provider.loadNotes,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 2;

                          if (constraints.maxWidth >= 1200) {
                            crossAxisCount = 4;
                          } else if (constraints.maxWidth >= 900) {
                            crossAxisCount = 3;
                          }

                          return MasonryGridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                ),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];

                              return NoteCard(
                                note: note,
                                onEdit: () => _openEdit(note),
                                onDelete: () => _deleteNote(note),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
