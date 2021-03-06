import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notex/modules/notesmodel.dart';
import 'package:notex/services/services.dart';

class NotesConttroller extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<List<Notesmodel>> notesList = Rx<List<Notesmodel>>();
  List<Notesmodel> get notes => notesList.value;

  @override
  void onInit() {
    super.onInit();

    notesList.bindStream(firestore
        .collection('notes')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<Notesmodel> retval = [];
      querySnapshot.docs.forEach((element) {
        retval.add(Notesmodel.fromDocumentSnapshot(element));
      });
      return retval;
    }));
  }
}
