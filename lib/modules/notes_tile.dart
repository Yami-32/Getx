import 'package:flutter/material.dart';
import 'package:notex/modules/editdata_controller.dart';
import 'package:notex/pages/description.dart';
import 'package:notex/pages/edit_note.dart';
import 'package:notex/services/services.dart';
import 'package:get/get.dart';

class NotesTile extends StatelessWidget {
  final imageUrl;
  final dynamic title;
  final String notesData;
  final String noteID;

  final EditController c = Get.put(EditController());

  NotesTile(
      {@required this.noteID,
      @required this.imageUrl,
      @required this.title,
      @required this.notesData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Description(
                              title: title,
                              data: notesData,
                            )));
              },
              child: Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '$title',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Services().delete(id: noteID, imageUrl: imageUrl);
                    },
                    child: Text('delete')),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      c.addData(title);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNote(),
                          ));
                    },
                    child: Text('edit')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
