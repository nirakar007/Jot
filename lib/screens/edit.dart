import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/note.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({Key? key, this.note}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }

    super.initState();
  }

  Future<void> _saveNoteToFirestore(Note note) async {
    try {
      final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

      // Check if the note already exists in Firestore
      final existingNote = await notesCollection.doc(note.id.toString()).get();

      if (existingNote.exists) {
        // Update the existing note
        await notesCollection.doc(note.id.toString()).update(note.toMap());
      } else {
        // Save a new note
        await notesCollection.doc(note.id.toString()).set(note.toMap());
      }

      // Show a success message (you can customize this part)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note saved successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Handle the error (you can customize this part)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save note. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: const EdgeInsets.all(0),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'SyneMono',
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontFamily: 'SyneMono',
                    ),
                  ),
                ),
                TextField(
                  controller: _contentController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'SyneMono',
                    height: 1.5,
                  ),
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something here ...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SyneMono',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final updatedNote = Note(
            id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch,
            title: _titleController.text,
            content: _contentController.text,
            modifiedTime: DateTime.now(),
          );
          _saveNoteToFirestore(updatedNote);
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),
    );
  }
}
