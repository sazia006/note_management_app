import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/firestore_service.dart';

class NoteProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  Stream<List<Note>> get notes => _service.getNotes();

  Future<void> addNote(Note note) async {
    await _service.addNote(note);
  }

  Future<void> updateNote(Note note) async {
    await _service.updateNote(note);
  }

  Future<void> deleteNote(String id) async {
    await _service.deleteNote(id);
  }
}
