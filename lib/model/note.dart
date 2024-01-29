import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });

  factory Note.fromMap(Map<String, dynamic> map, {required int id}) {
    return Note(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      modifiedTime: (map['modifiedTime'] as Timestamp).toDate(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'modifiedTime': modifiedTime,
    };
  }
}
