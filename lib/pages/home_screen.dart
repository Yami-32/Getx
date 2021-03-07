import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notex/modules/notes_controller.dart';
import 'package:notex/modules/notes_tile.dart';
import 'package:notex/pages/add_note.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //String s = 'get';
  TextEditingController searchFieldController = TextEditingController();

  List<NotesTile> searchist = [];

  NotesConttroller c = Get.put(NotesConttroller());

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
      body: Column(
        children: [
          TextField(
            controller: searchFieldController,
          ),
          Expanded(
            child: GetX<NotesConttroller>(
              init: Get.put(NotesConttroller()),
              builder: (NotesConttroller controller) {
                if (controller != null && controller.notes != null) {
                  List<NotesTile> notesList = [];

                  for (var item in controller.notes) {
                    String id = item.noteId;
                    String data = item.description;
                    String image = item.imageurl;
                    String titel = item.title;
                    NotesTile xd = NotesTile(
                      noteID: id,
                      notesData: data,
                      imageUrl: image,
                      title: titel,
                    );
                    notesList.add(xd);
                  }

                  return ListView(
                    children: notesList,
                  );

                  // return ListView.builder(
                  //     itemCount: controller.notes.length,
                  //     itemBuilder: (context, index) {
                  //       return NotesTile(
                  //           noteID: controller.notes[index].noteId,
                  //           imageUrl: controller.notes[index].imageurl,
                  //           title: controller.notes[index].title,
                  //           notesData: controller.notes[index].description);
                  //     });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
