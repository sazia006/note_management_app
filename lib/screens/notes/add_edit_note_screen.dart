import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note_model.dart';
import '../../providers/note_provider.dart';
import '../../utils/validators.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note?.title ?? '');

    _descriptionController = TextEditingController(
      text: widget.note?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final provider = context.read<NoteProvider>();

    bool success = false;

    if (widget.note == null) {
      success = await provider.addNote(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
    } else {
      success = await provider.updateNote(
        widget.note!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          success
              ? widget.note == null
                    ? "✅ Note created successfully"
                    : "✅ Note updated successfully"
              : "❌ Failed to save note",
        ),
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Note" : "New Note")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: Validators.validateTitle,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    hintText: "Enter note title",
                  ),
                  autofocus: widget.note == null,
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: TextFormField(
                    controller: _descriptionController,
                    validator: Validators.validateDescription,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Write your note here...",
                      alignLabelWithHint: true,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _saveNote,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            isEditing
                                ? Icons.save_outlined
                                : Icons.add_circle_outline,
                          ),
                    label: Text(isEditing ? "Update Note" : "Save Note"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
