// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

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
import 'package:expense_tracker/config/palette.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int activeDay = 6;
  bool darkTheme = true;
  List dayList = [];
  Map dayData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.back,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    List data = [];
    var total;

    Future getDayList() async {
      dayList = [];
      var now = DateTime.now();
      for (var i = 6; i > -1; i--) {
        var previous = DateTime(now.year, now.month, now.day - i);
        dayData = {
          'date': DateFormat('dd').format(previous),
          'day': DateFormat('EEE').format(previous),
          'month': DateFormat('MMM').format(previous),
          'year': previous.year
        };
        dayList.add(dayData);
      }
    }

    getDayList();

    Future getExpense() async {
      User user = FirebaseAuth.instance.currentUser;
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('expense');
      var fetchDate =
          '${dayList[activeDay]['date']}-${dayList[activeDay]['month']}-${dayList[activeDay]['year']}';
      await collectionReference
          .where('uid', isEqualTo: user.uid)
          .where('date', isEqualTo: fetchDate)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                data = [],
                querySnapshot.docs.forEach((element) {
                  if (element != null) {
                    data.add(element.data());
                  }
                })
              });
      total = 0;
      for (var i = 0; i < data.length; i++) {
        total = total + int.parse(data[i]['expenseCost']);
      }
    }

    getExpense();

    return FutureBuilder<dynamic>(
        future: getExpense(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  elevation: 0,
                  title: const Text(
                    'Daily Transaction',
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
                              onTap: () async {
                                await getExpense();
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.refresh,
                                color: Palette.text,
                              )),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              showBar('Feature under Development',
                                  Icons.developer_mode, context);
                            },
                            child: const Icon(
                              AntDesign.search1,
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
                  automaticallyImplyLeading: false,
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
                        top: 30, bottom: 25, right: 20, left: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            dayList.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    activeDay = index;
                                  });
                                },
                                child: SizedBox(
                                  width: (size.width - 40) / 7,
                                  child: Column(
                                    children: [
                                      Text(
                                        dayList[index]['day'],
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: activeDay == index
                                                ? Palette.text
                                                : Palette.secondary
                                                    .withOpacity(0.5),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: activeDay == index
                                                    ? Palette.text
                                                    : Palette.secondary
                                                        .withOpacity(0.5))),
                                        child: Center(
                                            child: Text(
                                          dayList[index]['date'],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                total != 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  children: List.generate(data.length, (index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: (size.width - 40) * 0.7,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                    child: Image.asset(
                                                  data[index]['icon'],
                                                  color: Color(int.parse(
                                                      data[index]['color']
                                                          .split('(0x')[1]
                                                          .split(')')[0],
                                                      radix: 16)),
                                                  width: 30,
                                                  height: 30,
                                                )),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              SizedBox(
                                                width: (size.width - 90) * 0.5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[index]
                                                          ['expenseName'],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Palette.text,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      '${DateFormat('EEE').format(data[index]['time'].toDate())} ${DateFormat.jm().format(data[index]['time'].toDate())}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Palette.text
                                                              .withOpacity(0.5),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: (size.width - 40) * 0.3,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                    '₹${data[index]['expenseCost']}',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.green))
                                              ]),
                                        )
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 65.0, top: 8.0),
                                      child: Divider(
                                        thickness: 0.8,
                                        color: Palette.text,
                                      ),
                                    )
                                  ],
                                );
                              })),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 80.0),
                                    child: Text(
                                      'Total',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Palette.text.withOpacity(0.4),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '₹${total.toString()}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Palette.text,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                            'No Expense found on ${dayList[activeDay]['date']}-${dayList[activeDay]['month']}',
                            style: const TextStyle(
                              fontSize: 23,
                              color: Palette.text,
                            )),
                      ))
              ],
            ),
          );
        });
  }
}
