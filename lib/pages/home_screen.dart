import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notex/modules/notes_controller.dart';
import 'package:notex/modules/notes_tile.dart';
import 'package:notex/pages/add_note.dart';
import 'package:notex/services/services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String s = 'get';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Text('Drawer')),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddBlog()));
                },
                child: Text('add data')),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Notx'),
      ),
      body: GetX<NotesConttroller>(
        init: Get.put(NotesConttroller()),
        builder: (NotesConttroller controller) {
          if (controller != null && controller.notes != null) {
            return ListView.builder(
                itemCount: controller.notes.length,
                itemBuilder: (context, index) {
                  return NotesTile(
                      noteID: controller.notes[index].noteId,
                      imageUrl: controller.notes[index].imageurl,
                      title: controller.notes[index].title,
                      notesData: controller.notes[index].description);
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
