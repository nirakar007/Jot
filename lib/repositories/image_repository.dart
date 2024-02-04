import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile) async {
    try {
      final String imagePath = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageReference = _storage.ref().child(imagePath);
      final UploadTask uploadTask = storageReference.putFile(imageFile);

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      final String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      throw e;
    }
  }
}
