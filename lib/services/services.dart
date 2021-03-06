import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:notex/modules/notesmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Services extends GetxController {
  CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');

  Future<void> addData(notesData) {
    return notesRef.add(notesData).catchError((e) {
      print(e);
    });
  }

  Future getData() async {
    QuerySnapshot snapshot = await notesRef.get();
    return snapshot.docs;
  }

  Stream<List<Notesmodel>> notesStream() {
    return notesRef.snapshots().map((QuerySnapshot querySnapshot) {
      List<Notesmodel> retval;
      querySnapshot.docs.forEach((element) {
        retval.add(Notesmodel.fromDocumentSnapshot(element));
      });
      return retval;
    });
  }

  void delete({String id, String imageUrl}) async {
    print('delete initated');
    notesRef
        .doc(id)
        .delete()
        .then((value) => Fluttertoast.showToast(
              msg: 'deleted',
            ))
        .catchError((e) => print('$e caught error'));

    deleteImage(imageUrl);
  }

  void deleteImage(String imageUrl) {
    Reference _storage = FirebaseStorage.instance.refFromURL(imageUrl);
    _storage.delete();
  }

  Future<void> updateData(
      {String data, String title, String imageUrl, String id}) {
    return notesRef
        .doc(id)
        .update({
          "image": imageUrl,
          "title": title,
          "description": data,
        })
        .then((value) => Fluttertoast.showToast(msg: 'updated'))
        .catchError((e) => print('$e error'));
  }
}
