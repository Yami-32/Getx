import 'package:notex/modules/constants.dart';
import 'package:flutter/material.dart';
import 'package:notex/services/services.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';

class EditNote extends StatefulWidget {
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  String imageUrldat = Get.arguments[2].toString();
  String docId = Get.arguments[3].toString();

  TextEditingController _titleController =
      TextEditingController(text: Get.arguments[0].toString());
  TextEditingController _descriptionController =
      TextEditingController(text: Get.arguments[1].toString());

  Services services = new Services();
  File selectedImage;
  bool _isLoading = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void uploadBlog(BuildContext ctx) async {
    String imageUrlt = imageUrldat;

    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      Reference _storage = FirebaseStorage.instance
          .ref()
          .child("notesImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      Services().deleteImage(imageUrlt);
      final UploadTask task = _storage.putFile(selectedImage);

      var imageUrl = await (await task).ref.getDownloadURL();
      imageUrlt = imageUrl;
      print("this is the usl $imageUrl           the url");
    }
    await Services().updateData(
        imageUrl: imageUrlt,
        title: _titleController.text,
        data: _descriptionController.text,
        id: docId);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: selectedImage != null
                              ? Container(
                                  height: 160,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.file(
                                    selectedImage,
                                    //fit: BoxFit.cover,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 160,
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(imageUrldat)),
                                ),
                        ),
                        TextField(
                          controller: _titleController,
                          decoration: kBlogTextFileDecuration,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 60,
                          indent: 40,
                          endIndent: 40,
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 10,
                          decoration: kBlogTextFileDecuration.copyWith(
                              hintText: 'Descritption'),
                        ),
                        Builder(
                          builder: (ctx) => TextButton(
                            onPressed: () {
                              uploadBlog(ctx);
                            },
                            child: Text(
                              'Upload',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
