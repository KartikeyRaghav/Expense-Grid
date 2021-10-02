// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/pages/root_app.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:expense_tracker/config/palette.dart';
import 'package:expense_tracker/config/showBar.dart';
import 'package:expense_tracker/json/categories.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

class CreateBudgetPage extends StatefulWidget {
  const CreateBudgetPage({Key? key}) : super(key: key);

  @override
  _CreateBudgetPageState createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  int activeCategory = 0;
  int activeSubCategory = 0;
  bool darkTheme = true;
  final TextEditingController _expenseName = TextEditingController(text: '');
  final TextEditingController _expenseCost = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.back,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    Future submitData() async {
      User user = FirebaseAuth.instance.currentUser;
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('expense');
      final currentDate = DateTime.now();
      await collectionReference.add({
        'uid': user.uid,
        'expenseName': _expenseName.text,
        'expenseCost': _expenseCost.text,
        'id': categories[activeCategory][activeSubCategory + 3]['id'],
        'time': currentDate,
        'date':
            '${DateFormat('dd').format(currentDate)}-${DateFormat('MMM').format(currentDate)}-${currentDate.year}',
        'month': '${DateFormat('MMM').format(currentDate)}-${currentDate.year}',
        'icon': categories[activeCategory][activeSubCategory + 3]['icon'],
        'color': categories[activeCategory][2].toString(),
        'category': categories[activeCategory][0]
      });
      showBar(
          '${_expenseName.text} has been added to ${categories[activeCategory][activeSubCategory + 3]['name']} of ${categories[activeCategory][0]}',
          Icons.error_outline,
          context);
      _expenseCost.text = '';
      _expenseName.text = '';
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RootApp(
                    pageIndex: 4,
                  )));
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBar(
            backgroundColor: Colors.black.withOpacity(0.7),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Create Expense',
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
          ),
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Choose a Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.text.withOpacity(0.5),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: List.generate(categories.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            activeCategory = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 20),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: activeCategory == index
                                        ? Palette.text
                                        : Colors.transparent,
                                    width: activeCategory == index ? 2 : 0),
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Palette.back,
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Icon(
                                      categories[index][1],
                                      color: categories[index][2],
                                      size: 30,
                                    )),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    categories[index][0],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: categories[index][2]),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Choose a Sub Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.text.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: List.generate(
                        categories[activeCategory].length - 3, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            activeSubCategory = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 20),
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            constraints: BoxConstraints(
                              minWidth: (size.width - 60) * 0.5,
                            ),
                            height: 170,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: activeSubCategory == index
                                        ? Palette.text
                                        : Colors.transparent,
                                    width: activeSubCategory == index ? 2 : 0),
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.01),
                                      spreadRadius: 10,
                                      blurRadius: 3)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Palette.back,
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Image.asset(
                                            categories[activeCategory]
                                                [index + 3]['icon'],
                                            color: categories[activeCategory]
                                                [2],
                                            width: 30,
                                            height: 30)),
                                  ),
                                  Text(
                                    categories[activeCategory][index + 3]
                                        ['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: categories[activeCategory][2]),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense Name',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Palette.text.withOpacity(0.5)),
                    ),
                    TextField(
                      controller: _expenseName,
                      cursorColor: Palette.text,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Palette.text),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Expense Name',
                          hintStyle: TextStyle(color: Palette.text)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width - 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Expense',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Palette.text.withOpacity(0.5)),
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: _expenseCost,
                                cursorColor: Palette.text,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.text),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Palette.text),
                                    hintText: 'Enter Expense Cost'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_expenseCost.text != '' &&
                                _expenseName.text != '') {
                              await submitData();
                            } else {
                              showBar(
                                  'Please fill the fields to add an expense.',
                                  Icons.error_outline,
                                  context);
                            }
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Palette.text,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.arrow_forward,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
