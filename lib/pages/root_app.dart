import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:expense_tracker/config/palette.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:expense_tracker/pages/budget_page.dart';
import 'package:expense_tracker/pages/create_expense_page.dart';
import 'package:expense_tracker/pages/daily_page.dart';
import 'package:expense_tracker/pages/profile_page.dart';
import 'package:expense_tracker/pages/stats_page.dart';

class RootApp extends StatefulWidget {
  RootApp({Key? key, required this.pageIndex}) : super(key: key);
  int pageIndex;

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.back,
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setTabs(4);
        },
        child: const Icon(
          Icons.add,
          size: 25,
          color: Palette.back,
        ),
        backgroundColor: Palette.text,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: widget.pageIndex,
      children: const [
        DailyPage(),
        StatsPage(),
        BudgetPage(),
        ProfilePage(),
        CreateBudgetPage(),
      ],
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_calendar,
      Ionicons.md_stats,
      Ionicons.md_wallet,
      Ionicons.ios_person,
    ];
    return AnimatedBottomNavigationBar(
        icons: iconItems,
        backgroundColor: Colors.black.withOpacity(0.3),
        activeColor: Palette.text,
        splashColor: Palette.text,
        inactiveColor: Palette.secondary.withOpacity(0.5),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 25,
        rightCornerRadius: 10,
        activeIndex: widget.pageIndex,
        onTap: (index) {
          setTabs(index);
        });
  }

  setTabs(index) {
    setState(() {
      widget.pageIndex = index;
    });
  }
}
