import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/note.dart';

class FirestoreService {
  final CollectionReference notesCollection = FirebaseFirestore.instance.collection('notes');

  Future<List<Note>> getNotes() async {
    QuerySnapshot<Object?> snapshot = await notesCollection.get();
    List<Note> notes = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Note.fromMap(data, id: int.parse(doc.id));
    }).toList();
    return notes;
  }
}
