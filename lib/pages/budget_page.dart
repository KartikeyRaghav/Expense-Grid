// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/config/palette.dart';
import 'package:expense_tracker/config/showBar.dart';
import 'package:expense_tracker/json/categories.dart';
import 'package:expense_tracker/pages/root_app.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int activeMonth = 5;
  bool darkTheme = true;
  String _budgetName = 'Select Category';
  final TextEditingController _budget = TextEditingController(text: '');
  Color color = Palette.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.back,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    User user = FirebaseAuth.instance.currentUser;
    CollectionReference budgetReference =
        FirebaseFirestore.instance.collection('budget');

    List<String> pickerData = [
      'Select Category',
      'Education',
      'Food',
      'Bills',
      'Beauty',
      'Clothing',
      'Entertainment',
      'Sports',
      'Miscellaneous',
    ];
    List data = [];
    Map budget = {};
    List monthList = [];
    Map monthData = {};
    List expense = [];
    List total = [
      {
        'label': 'Education',
        'total': 0,
        'budget': 0,
        'color': null,
        'percentage': null
      },
      {
        'label': 'Food',
        'total': 0,
        'budget': 0,
        'color': null,
        'percentage': null
      },
      {
        'label': 'Bills',
        'total': 0,
        'budget': 0,
        'color': null,
        'percentage': null
      },
      {
        'label': 'Beauty',
        'total': 0,
        'budget': 0,
        'color': null,
        'percentage': null
      },
      {
        'label': 'Clothing',
        'total': 0,
        'budget': 0,
        'color': null,
        'percentage': null
      },
      {
        'label': 'Entertainment',
        'total': 0,
        'budget': 0,
        'color': null,
        'percentage': null
      },
      {
        'label': 'Sports',
        'total': 0,
        'budget': 0,
        'color': null,
        'percentage': null
      },
      {
        'label': 'Miscellaneous',
        'total': 0,
        'budget': 0,
        'color': null,
        'percentage': null
      },
    ];

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

    Future getColor() async {
      for (var k = 0; k < categories.length; k++) {
        if (categories[k][0] == _budgetName) {
          color = categories[k][2];
        }
      }
    }

    Future<void> getBudget() async {
      var month = monthList[activeMonth]['month'];
      await budgetReference
          .where('uid', isEqualTo: user.uid)
          .where('month', isEqualTo: month)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                data = [],
                querySnapshot.docs.forEach((element) {
                  if (element != null) {
                    data.add(element.data());
                  }
                })
              });
      for (var z = 0; z < data.length; z++) {
        for (var a = 0; a < total.length; a++) {
          if (total[a]['label'] == data[z]['category']) {
            total[a]['budget'] = int.parse(data[z]['budget']);
            total[a]['color'] = data[z]['color'];
            total[a]['percentage'] =
                (total[a]['total'] / total[a]['budget']) * 100;
          }
        }
      }
    }

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
                total[x]['total'] + int.parse(expense[i]['expenseCost']);
          }
        }
      }
    }

    getExpense();

    Future addBudget() async {
      if (_budgetName != '' && _budget.text != '') {
        getColor();
        budget = {
          'category': _budgetName,
          'budget': _budget.text,
          'color': color.toString()
        };
        await budgetReference
            .doc(user.uid +
                budget['category'].toString() +
                DateFormat('MMM').format(DateTime.now()).toString())
            .set({
          'category': budget['category'],
          'budget': budget['budget'],
          'color': budget['color'],
          'uid': user.uid,
          'month': DateFormat('MMM').format(DateTime.now()).toString()
        }).then((value) async {
          activeMonth = 5;
          await getBudget();
          showBar('$_budgetName has been added to the budget list.',
              Icons.assignment_turned_in_outlined, context);
        });
      } else {
        return showBar('Fill the budget name and budget cost.',
            Icons.error_outline, context);
      }
      _budgetName = '';
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RootApp(
                    pageIndex: 2,
                  )));
    }

    getBudget();

    Future dialog() async {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 16,
                backgroundColor: Palette.darkBlue,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      height: size.height * 0.5,
                      width: size.width - 80,
                      child: ListView(children: <Widget>[
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "Add Budget",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category Name',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Palette.text.withOpacity(0.5)),
                                ),
                                Row(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DropdownButton(
                                            value: _budgetName,
                                            dropdownColor: Palette.back,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Palette.text),
                                            items:
                                                pickerData.map((String items) {
                                              return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items,
                                                      style: const TextStyle(
                                                          color:
                                                              Palette.text)));
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                _budgetName = newValue!;
                                              });
                                              dialog();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Budget',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Palette.text.withOpacity(0.5)),
                                ),
                                TextField(
                                  controller: _budget,
                                  cursorColor: Palette.text,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.text),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Budget',
                                      hintStyle:
                                          TextStyle(color: Palette.text)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            GestureDetector(
                              onTap: () async {
                                await addBudget();
                                await getBudget();
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  width: size.width - 100,
                                  decoration: BoxDecoration(
                                      color: Palette.text,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Center(
                                      child: Text(
                                        'Create Budget',
                                        style: TextStyle(
                                            color: Palette.back,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ])),
                ));
          });
    }

    return FutureBuilder<dynamic>(
        future: getBudget(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(children: [
              AppBar(
                backgroundColor: Colors.black.withOpacity(0.7),
                elevation: 0,
                title: const Text(
                  'Budget',
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
                              await getBudget();
                              await getExpense();
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.refresh,
                              color: Palette.text,
                            )),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            await dialog();
                          },
                          child: const Icon(
                            AntDesign.plus,
                            color: Palette.text,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
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
                                    getBudget();
                                    getExpense();
                                  },
                                  child: SizedBox(
                                    width: (size.width - 40) / 7,
                                    child: Column(
                                      children: [
                                        Text(
                                          monthList[index]['year'],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
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
                                                vertical: 7.0,
                                                horizontal: 10.0),
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
                      ))),
              const SizedBox(
                height: 20,
              ),
              data != []
                  ? SingleChildScrollView(
                      child: Column(
                        children: List.generate(total.length, (index) {
                          return total[index]['budget'] != 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.01),
                                              spreadRadius: 10,
                                              blurRadius: 3)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              total[index]['label'],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Palette.text
                                                      .withOpacity(0.7),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '₹${total[index]['budget'].toString()}',
                                                        style: const TextStyle(
                                                            color: Palette.text,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 3.0),
                                                        child: Text(
                                                          total[index][
                                                                      'percentage']
                                                                  .toStringAsFixed(
                                                                      2) +
                                                              '%',
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Palette
                                                                  .text
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3.0),
                                                    child: Text(
                                                      '₹${total[index]['total'].toString()}',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Palette.text
                                                              .withOpacity(0.7),
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ]),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                      color: Color(int.parse(
                                                              total[index]
                                                                      ['color']
                                                                  .split(
                                                                      '(0x')[1]
                                                                  .split(
                                                                      ')')[0],
                                                              radix: 16))
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                ),
                                                Container(
                                                  width: (size.width - 90) *
                                                      (total[index]
                                                              ['percentage'] /
                                                          100),
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                      color: Color(int.parse(
                                                          total[index]['color']
                                                              .split('(0x')[1]
                                                              .split(')')[0],
                                                          radix: 16)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                )
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
                                )
                              : Container();
                        }),
                      ),
                    )
                  : SizedBox(
                      height: size.height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No budget created till yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Palette.text,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await dialog();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Palette.text),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  'Create Budget',
                                  style: TextStyle(
                                      color: Palette.back, fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
            ]),
          );
        });
  }
}
