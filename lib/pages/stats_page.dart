// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/config/showBar.dart';
import 'package:expense_tracker/json/categories.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:expense_tracker/config/palette.dart';
import 'package:pie_chart/pie_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeMonth = 5;
  bool darkTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.back,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    List expense = [];
    List monthList = [];
    Map monthData = {};
    List total = [
      {
        'label': 'Education',
        'total': 0,
        'color': null,
      },
      {
        'label': 'Food',
        'total': 0,
        'color': null,
      },
      {
        'label': 'Bills',
        'total': 0,
        'color': null,
      },
      {
        'label': 'Beauty',
        'total': 0,
        'color': null,
      },
      {
        'label': 'Clothing',
        'total': 0,
        'color': null,
      },
      {
        'label': 'Entertainment',
        'total': 0,
        'color': null,
      },
      {
        'label': 'Sports',
        'total': 0,
        'color': null,
      },
      {
        'label': 'Miscellaneous',
        'total': 0,
        'color': null,
      },
    ];
    Map<String, double> totalData = {
      'Education': 0.0,
      'Food': 0.0,
      'Bills': 0.0,
      'Beauty': 0.0,
      'Clothing': 0.0,
      'Entertainment': 0.0,
      'Sports': 0.0,
      'Miscellaneous': 0.0,
    };

    int totalExpense = 0;

    Future setData() async {
      for (var a = 0; a < total.length; a++) {
        if (total[a]['total'] != 0) {
          totalData[total[a]['label']] = (total[a]['total']*0.5).toDouble();
        }
      }
    }

    Future getMonthList() async {
      monthList = [];
      var now = DateTime.now();
      for (var i = 5; i > -1; i--) {
        var previous = DateTime(now.year, now.month - i, now.day);
        monthData = {
          'year': DateFormat('yyyy').format(previous),
          'month': DateFormat('MMM').format(previous)
        };
        monthList.add(monthData);
      }
    }

    getMonthList();

    Future getExpense() async {
      User user = FirebaseAuth.instance.currentUser;
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('expense');
      var fetchMonth =
          '${monthList[activeMonth]['month']}-${monthList[activeMonth]['year']}';
      await collectionReference
          .where('uid', isEqualTo: user.uid)
          .where('month', isEqualTo: fetchMonth)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                expense = [],
                querySnapshot.docs.forEach((element) {
                  if (element != null) {
                    expense.add(element.data());
                  }
                })
              });
      for (var i = 0; i < expense.length; i++) {
        for (var x = 0; x < total.length; x++) {
          if (expense[i]['category'] == total[x]['label']) {
            total[x]['total'] =
                total[x]['total'] + (int.parse(expense[i]['expenseCost']))*0.5;
            total[x]['color'] = Color(int.parse(
                expense[i]['color'].split('(0x')[1].split(')')[0],
                radix: 16));
            totalExpense = totalExpense + int.parse(expense[i]['expenseCost']);
            setData();
          }
        }
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
                    'Stats',
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
                        top: 30.0, right: 20, left: 20, bottom: 25),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            monthList.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    activeMonth = index;
                                  });
                                },
                                child: SizedBox(
                                  width: (size.width - 40) / 7,
                                  child: Column(
                                    children: [
                                      Text(
                                        monthList[index]['year'],
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: activeMonth == index
                                                ? Palette.text
                                                : Palette.secondary
                                                    .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: activeMonth == index
                                                    ? Palette.text
                                                    : Palette.secondary
                                                        .withOpacity(0.5))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0, horizontal: 10.0),
                                          child: Text(
                                            monthList[index]['month'],
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
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
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                totalExpense != 0
                    ? Column(
                        children: [
                          PieChart(
                            dataMap: totalData,
                            colorList: const [
                              Color(0xffffeb3b),
                              Color(0xffFF3378),
                              Color(0xff00ccff),
                              Color(0xffff00ff),
                              Color(0xffff3300),
                              Color(0xff00cc00),
                              Color(0xff339966),
                              Colors.purple,
                            ],
                            centerText:
                                'Total Expense:\n${(totalExpense*0.5).toString()}',
                            centerTextStyle: const TextStyle(
                                color: Palette.text,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                            animationDuration: const Duration(seconds: 2),
                            legendOptions: const LegendOptions(
                              showLegends: false,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              chartValueStyle: TextStyle(
                                  fontSize: 15,
                                  color: Palette.back,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.grey),
                              showChartValuesOutside: true,
                            ),
                            chartRadius:
                                MediaQuery.of(context).size.width - 100,
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth:
                                MediaQuery.of(context).size.width / 6,
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              children: List.generate(
                                  total.length,
                                  (index) => total[index]['total'] != 0
                                      ? Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black26),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          categories[index][1],
                                                          color:
                                                              categories[index]
                                                                  [2],
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Text(
                                                            total[index]
                                                                ['label'],
                                                            style: const TextStyle(
                                                                color: Palette
                                                                    .text,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                      ],
                                                    ),
                                                    Text(
                                                        '₹${total[index]['total'].toString()}',
                                                        style: const TextStyle(
                                                            color: Palette.text,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        )
                                      : Container()),
                            ),
                          )
                        ],
                      )
                    : SizedBox(
                        height: size.height * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No expense till now in ${monthList[activeMonth]['month']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Palette.text,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          );
        });
  }
}
