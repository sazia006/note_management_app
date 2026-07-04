import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/firestore_service.dart';

class NoteProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  final List<Note> _notes = [];

  bool _isLoading = false;

  String _searchQuery = '';

  String? _errorMessage;

  List<Note> get notes {
    if (_searchQuery.isEmpty) {
      return List.unmodifiable(_notes);
    }

    return _notes.where((note) {
      final query = _searchQuery.toLowerCase();

      return note.title.toLowerCase().contains(query) ||
          note.description.toLowerCase().contains(query);
    }).toList();
  }

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadNotes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final data = await _service.fetchNotes();

      _notes
        ..clear()
        ..addAll(data);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addNote({
    required String title,
    required String description,
  }) async {
    try {
      await _service.addNote(title: title, description: description);

      await loadNotes();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateNote(Note note) async {
    try {
      await _service.updateNote(note);

      await loadNotes();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteNote(String id) async {
    try {
      await _service.deleteNote(id);

      await loadNotes();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void updateSearch(String value) {
_searchQuery = value.trim().toLowerCase();

    notifyListeners();
  }
}
