import 'dart:io';
import 'package:flutter/material.dart';
import '../repositories/image_repository.dart';


class ImageUploadViewModel with ChangeNotifier{
  final ImageRepository _imageRepository = ImageRepository();

  String? _uploadImageUrl;
  String? get uploadedImageUrl => _uploadImageUrl;

  Future<String?> uploadImage(File imageFile) async {
    try{
      _uploadImageUrl = await _imageRepository.uploadImage(imageFile);
      notifyListeners();
    }
    catch(e){
      print('Error uploading image: $e');
    }
  }
}