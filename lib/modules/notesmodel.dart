import 'package:cloud_firestore/cloud_firestore.dart';

class Notesmodel {
  String description;
  String title;
  String imageurl;
  String noteId;

  Notesmodel(this.description, this.title, this.imageurl, this.noteId);

  Notesmodel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    imageurl = documentSnapshot.data()['image'];
    title = documentSnapshot.data()['title'];
    description = documentSnapshot.data()['description'];
    noteId = documentSnapshot.id;
  }
}
