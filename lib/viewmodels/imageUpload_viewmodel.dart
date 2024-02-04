import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadViewModel {
  final _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(file);

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      String imageUrl = await reference.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print("Image upload error: $error");
      return null;
    }
  }

}
