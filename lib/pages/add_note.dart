import 'package:notex/modules/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notex/services/services.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBlog extends StatefulWidget {
  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

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
    String messgae;
    if (selectedImage == null) {
      messgae = 'add Image';
    } else if (_titleController.text.length == 0) {
      messgae = 'add title';
    } else if (_descriptionController.text.length == 0) {
      messgae = 'add description';
    }

    if (selectedImage != null &&
        _titleController.text.length != 0 &&
        _descriptionController.text.length != 0) {
      setState(() {
        _isLoading = true;
      });

      Reference _storage = FirebaseStorage.instance
          .ref()
          .child("notesImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      final UploadTask task = _storage.putFile(selectedImage);

      var imageUrl = await (await task).ref.getDownloadURL();
      print("this is the usl $imageUrl           the url");
      Map<String, dynamic> dataMap = {
        "image": imageUrl,
        "title": _titleController.text,
        "description": _descriptionController.text,
      };

      await services.addData(dataMap);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: messgae,
      );
    }
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
                                  child: Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black,
                                    ),
                                  )),
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
