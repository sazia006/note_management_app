import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collection = 'notes';

  Stream<List<Note>> getNotes() {
    return _firestore
        .collection(collection)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Note.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addNote(Note note) async {
    await _firestore.collection(collection).add(note.toMap());
  }

  Future<void> updateNote(Note note) async {
    await _firestore.collection(collection).doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }
}
