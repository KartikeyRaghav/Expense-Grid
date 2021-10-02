import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/config/showBar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:expense_tracker/config/palette.dart';
import 'package:expense_tracker/pages/root_app.dart';
import 'package:expense_tracker/screens/auth/decoration_functions.dart';
import 'package:expense_tracker/screens/auth/profile_widget.dart';
import 'package:expense_tracker/screens/auth/sign_in_up_bar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloudinary_public/cloudinary_public.dart';

class Information extends StatefulWidget {
  const Information({Key? key}) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  File? image = File(
      'https://s1.mzstatic.com/us/r30/Purple1/v4/de/ab/45/deab454d-8881-b37d-9513-b0e26424cc57/pr_source.png');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  DateTime? date;
  String useruid = FirebaseAuth.instance.currentUser.uid;
  var url;
  bool got = false;
  final cloudinary = CloudinaryPublic('djyvtvxdh', 'images', cache: false);

  String getText() {
    if (date == null) {
      return 'Date of Birth';
    } else {
      return '${date!.day}/${date!.month}/${date!.year}';
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().getImage(source: ImageSource.gallery);

      setState(() => this.image = File(image.path));
    } on PlatformException catch (e) {
      showBar(e.message!, Icons.error_outline, context);
    }
  }

  Future uploadImage() async {
    try {
      CloudinaryResponse response = await cloudinary
          .uploadFile(
        CloudinaryFile.fromFile(image!.path,
            resourceType: CloudinaryResourceType.Image),
      )
          .then((value) {
        url = value.secureUrl;
        return value;
      });
    } on CloudinaryException catch (e) {
      showBar(e.message, Icons.error_outline, context);
    }
  }

  Future pickDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(currentDate.year - 100),
        lastDate: DateTime(currentDate.year + 1));
    if (pickedDate == null) return;

    setState(() {
      date = pickedDate;
    });
  }

  addData(BuildContext context) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    try {
      collectionReference.doc(useruid).set({
        'name': nameController.text,
        'image': url ?? image!.path,
        'dateOfBirth': date,
        'mobile': phoneController.text,
        'uid': useruid
      }).then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RootApp(
                    pageIndex: 0,
                  ))));
    } on FirebaseException catch (e) {
      showBar(e.message, Icons.error_outline, context);
    }
  }

  Future getData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    await collectionReference
        .doc(useruid)
        .get()
        .then((DocumentSnapshot documentSnaphot) => {
              if (documentSnaphot.exists)
                {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RootApp(
                                pageIndex: 0,
                              )))
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    if (got == false) {
      getData().then((value) => {got = true});
    }

    return FutureBuilder<dynamic>(
        future: url,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Palette.back,
            body: SingleChildScrollView(
                child: Column(children: [
              Container(
                decoration: BoxDecoration(color: Palette.back, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3),
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, right: 20, left: 20, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Palette.text,
                        ),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 10),
                          Icon(
                            AntDesign.infocirlce,
                            color: Palette.text,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    ProfileWidget(
                        image: image!,
                        onPressed: () async {
                          // pickImage(ImageSource.gallery);
                          showBar('Feature under development',
                              Icons.developer_mode, context);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: infoInputDecoration(
                            icon: Icons.person, hintText: 'Enter Name...'),
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(color: Palette.text),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Palette.text,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  onPressed: () => pickDate(context),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      shadowColor: Colors.transparent),
                                  child: Text(getText(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Palette.text,
                                      ))),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 110,
                                child: const Divider(
                                  color: Palette.text,
                                  thickness: 1,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: infoInputDecoration(
                            icon: Icons.phone,
                            hintText: 'Enter Phone Number...'),
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(color: Palette.text),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: InfoBar(
                            label: 'Submit',
                            onPressed: () async {
                              if (nameController.text != '' &&
                                  phoneController.text != '' &&
                                  date != null &&
                                  image!.path !=
                                      'https://s1.mzstatic.com/us/r30/Purple1/v4/de/ab/45/deab454d-8881-b37d-9513-b0e26424cc57/pr_source.png') {
                                await uploadImage();
                              }
                              await addData(context);
                            })),
                  ],
                ),
              ),
            ])),
          );
        });
  }
}
