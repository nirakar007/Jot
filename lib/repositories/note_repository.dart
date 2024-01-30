import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/note.dart';

class NoteRepository {
  final CollectionReference notesCollection =
  FirebaseFirestore.instance.collection('notes');

  Future<bool> saveNoteToFirestore(Note note) async {
    try {
      final existingNote =
      await notesCollection.doc(note.id.toString()).get();

      if (existingNote.exists) {
        // Update the existing note
        await notesCollection
            .doc(note.id.toString())
            .update(note.toMap());
      } else {
        // Save a new note
        await notesCollection
            .doc(note.id.toString())
            .set(note.toMap());
      }

      return true; // Note saved successfully
    } catch (error) {
      return false; // Failed to save note
    }
  }

  Future<bool> deleteNoteFromFirestore(String noteId) async {
    try {
      await notesCollection.doc(noteId.toString()).delete();
      return true; // Note deleted successfully
    } catch (error) {
      return false; // Failed to delete note
    }
  }
}
