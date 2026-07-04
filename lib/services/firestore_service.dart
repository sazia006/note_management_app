import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'notes';

  CollectionReference<Map<String, dynamic>> get _notesCollection =>
      _firestore.collection(_collection);

  /// Get all notes ordered by latest updated
  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList(),
        );
  }

  /// Add a new note
  Future<void> addNote({
    required String title,
    required String description,
  }) async {
    try {
      final now = DateTime.now();

      final note = Note(
        id: '',
        title: title,
        description: description,
        createdAt: now,
        updatedAt: now,
      );

      await _notesCollection.add(note.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to add note.');
    } catch (_) {
      throw Exception('Something went wrong while adding the note.');
    }
  }

  /// Update an existing note
  Future<void> updateNote(Note note) async {
    try {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());

      await _notesCollection.doc(note.id).update(updatedNote.toFirestore());
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to update note.');
    } catch (_) {
      throw Exception('Something went wrong while updating the note.');
    }
  }

  /// Delete note
  Future<void> deleteNote(String id) async {
    try {
      await _notesCollection.doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to delete note.');
    } catch (_) {
      throw Exception('Something went wrong while deleting the note.');
    }
  }

  /// Fetch all notes once
  Future<List<Note>> fetchNotes() async {
    try {
      final snapshot = await _notesCollection
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch notes.');
    } catch (_) {
      throw Exception('Something went wrong while fetching notes.');
    }
  }
}
