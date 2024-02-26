import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final int id;
  final String title;
  final String content;
  late final Timestamp modifiedTime;
  final String? imageUrl;
  String userId;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
    required this.imageUrl,
    required this.userId,
  });

  // Factory constructor to create a Note from a Map
  factory Note.fromMap(Map<String, dynamic> map, {required int id}) {
    return Note(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      modifiedTime: (map['modifiedTime'] as Timestamp?) ?? Timestamp.now(),
      imageUrl: map['imageUrl'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  // Convert a Note to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'modifiedTime': modifiedTime,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
