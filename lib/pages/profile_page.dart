// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/config/showBar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:expense_tracker/config/palette.dart';
import 'package:expense_tracker/screens/auth/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool obsecureText = true;
  String name = '';
  num mobile = 0;
  DateTime? date;
  String imagePath = '';
  var data;
  String time = '';

  IconData icon = FontAwesome.eye;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.back,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    var total;
    List totalData = [];

    CollectionReference userReference =
        FirebaseFirestore.instance.collection('users');
    userReference.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      data = documentSnapshot.data();
      date = data['dateOfBirth'].toDate();
      time = DateFormat('dd-MMM-yyyy').format(date);
    });

    Future getTotal() async {
      var month = DateFormat('MMM-yyyy').format(DateTime.now());
      CollectionReference expenseReference =
          FirebaseFirestore.instance.collection('expense');
      await expenseReference
          .where('uid', isEqualTo: user.uid)
          .where('month', isEqualTo: month)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                totalData = [],
                querySnapshot.docs.forEach((element) {
                  if (element != null) {
                    totalData.add(element.data());
                  }
                }),
              });
      total = 0;
      for (var i = 0; i < totalData.length; i++) {
        total = total + int.parse(totalData[i]['expenseCost']);
      }
    }

    getTotal();

    return FutureBuilder<dynamic>(
        future: getTotal(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
              child: Column(children: [
            AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Palette.text,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          showBar('Feature under Development',
                              Icons.developer_mode, context);
                        },
                        child: const Icon(
                          Icons.settings,
                          color: Palette.text,
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      )
                    ])
                  ],
                ),
              ],
            ),
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: (size.width - 40) * 0.4,
                          child: Stack(children: [
                            RotatedBox(
                              quarterTurns: -2,
                              child: CircularPercentIndicator(
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor: Colors.black.withOpacity(0.2),
                                radius: 110.0,
                                lineWidth: 6.0,
                                percent: 0.5,
                                progressColor: Palette.text,
                              ),
                            ),
                            Positioned(
                              top: 13,
                              left: 13,
                              child: Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: data != null
                                            ? NetworkImage(data['image'])
                                            : const NetworkImage(''),
                                        fit: BoxFit.cover)),
                              ),
                            )
                          ]),
                        ),
                        SizedBox(
                            width: (size.width - 40) * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data != null ? data['name'] : 'Fetching...',
                                  style: const TextStyle(
                                      color: Palette.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Palette.text,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.01),
                                spreadRadius: 10,
                                blurRadius: 3),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Money Spent this month',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Palette.back,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '₹${total.toString()}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.back),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Palette.back, width: 2),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    'Update',
                                    style: TextStyle(color: Palette.back),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                        color: Palette.text,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'Mobile Number',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data != null ? data['mobile'] : 'Fetching...',
                    style: const TextStyle(
                        color: Palette.text,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data != null ? time : 'Fetching...',
                    style: const TextStyle(
                        color: Palette.text,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 30),
                    child: GestureDetector(
                      onTap: () async {
                        await auth.signOut();
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthScreen()));
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.logout,
                            color: Palette.text,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                                color: Palette.text,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ]));
        });
  }
}
