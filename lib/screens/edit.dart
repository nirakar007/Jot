import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jot_notes/services/image_upload.dart';
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
  final FileUpload _fileUpload = FileUpload();
  XFile? _pickedImage;
  late Note note;

  @override
  void initState() {
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }

    super.initState();
  }



  Future<String?> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      ImagePath? imageUrl = await _fileUpload.uploadImage(selectedPath: imageFile.path);
      print(imageUrl?.imageUrl);
      return imageUrl?.imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image')));
      return null;
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source, imageQuality: 100);
      if (pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No image selected")));
        return;
      }

      setState(() {
        _pickedImage = pickedImage;
      });

      // Upload the picked image to Firebase Storage
      await _uploadImageToFirebaseStorage(File(pickedImage.path));

    } catch (e) {
      print('Error picking/uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error picking/uploading image")));
    }
  }



  Future<void> _saveNoteToFirestore(String? imageUrl) async {
    try {
      final CollectionReference notesCollection = FirebaseFirestore.instance.collection('notes');
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('Current user is null. Aborting note save.');
        return;
      }

      // Create a new Note object
      final updatedNote = Note(
        id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        content: _contentController.text,
        modifiedTime: Timestamp.now(),
        imageUrl: imageUrl ?? '', // Use an empty string if imageUrl is null
        userId: user.uid,
      );

      // Check if the note already exists in Firestore
      final existingNote = await notesCollection.doc(updatedNote.id.toString()).get();

      if (existingNote.exists) {
        // Update the existing note
        await notesCollection.doc(updatedNote.id.toString()).update(updatedNote.toMap());
        print('Note updated successfully.');
      } else {
        // Save a new note
        await notesCollection.doc(updatedNote.id.toString()).set(updatedNote.toMap());
        print('New note saved successfully.');
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note saved successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Print the error for debugging
      print('Error saving note: $error');
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
              SizedBox(
                height: 30,
                width: 10,
              ),
              IconButton(
                onPressed: () async {
                  await _pickImage(ImageSource.gallery);
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
                    Icons.photo,
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
                if (_pickedImage != null) Image.file(File(_pickedImage!.path)),
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? imageUrl = await _uploadImageToFirebaseStorage(File(_pickedImage!.path));

          if (imageUrl != null) {
            await _saveNoteToFirestore(imageUrl);
          } else {
            // Handle the case when image upload fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image upload failed. Note will be saved without an image.')),
            );
            await _saveNoteToFirestore('');
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),

    );
  }
}
