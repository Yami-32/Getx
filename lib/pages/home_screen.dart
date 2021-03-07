import 'package:flutter/material.dart';
import 'package:notex/modules/notes_controller.dart';
import 'package:notex/modules/notes_tile.dart';
import 'package:notex/pages/add_note.dart';
import 'package:get/get.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //String s = 'get';
  TextEditingController searchFieldController = TextEditingController();

  List<NotesTile> searchListTemp = [];
  List<NotesTile> displayList = [];

  NotesConttroller c = Get.put(NotesConttroller());
  String searchData;
  bool searchNow = false;

  searchDataList(value) {
    setState(() {
      searchData = value;
      if (searchData.length != 0) {
        searchNow = true;
      } else {
        searchNow = false;
      }
      displayList = [];
    });
    for (var item in searchListTemp) {
      String dataSearch = item.title.toLowerCase();
      if (dataSearch.contains(searchData)) {
        displayList.add(item);
      }
    }
  }

  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('My Home Page'),
        actions: [searchBar.getSearchAction(context)]);
  }

  _HomeScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (value) {
          searchDataList(value);
        },
        closeOnSubmit: false,
        clearOnSubmit: false,
        onClosed: () {
          searchDataList("");
        },
        buildDefaultAppBar: buildAppBar);
  }

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
      appBar: searchBar.build(context),
      body: GetX<NotesConttroller>(
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
              searchListTemp = notesList;
            }

            return ListView(
              children:
                  searchNow && searchData.length != 0 ? displayList : notesList,
            );
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
