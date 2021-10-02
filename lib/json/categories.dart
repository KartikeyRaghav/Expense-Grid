import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';

const List categories = [
  [
    'Education',
    FontAwesome.graduation_cap,
    Color(0xffffeb3b),
    {'name': 'School Fee', 'icon': 'assets/images/icons/fee.jpg', 'id': 1},
    {'name': 'Books', 'icon': 'assets/images/icons/book.png', 'id': 2},
    {
      'name': 'Stationary',
      'icon': 'assets/images/icons/stationary.png',
      'id': 3
    },
    {'name': 'Uniform', 'icon': 'assets/images/icons/uniform.png', 'id': 4},
    {'name': 'Others', 'icon': 'assets/images/icons/other.png', 'id': 5},
  ],
  [
    'Food',
    Icons.fastfood,
    Color(0xffFF3378),
    {
      'name': 'Vegetable',
      'icon': 'assets/images/icons/vegetables.png',
      'id': 6
    },
    {'name': 'Fruits', 'icon': 'assets/images/icons/fruits.png', 'id': 7},
    {'name': 'Other', 'icon': 'assets/images/icons/other.png', 'id': 8}
  ],
  [
    'Bills',
    Icons.payments,
    Color(0xff00ccff),
    {'name': 'Water', 'icon': 'assets/images/icons/water.png', 'id': 9},
    {'name': 'Cable', 'icon': 'assets/images/icons/cable.png', 'id': 10},
    {
      'name': 'Electricity',
      'icon': 'assets/images/icons/electricity.png',
      'id': 11
    },
    {'name': 'Phone', 'icon': 'assets/images/icons/phone.png', 'id': 12},
    {'name': 'LPG Gas', 'icon': 'assets/images/icons/lpg.png', 'id': 13},
    {
      'name': 'Home Rent',
      'icon': 'assets/images/icons/home rent.png',
      'id': 14
    },
    {
      'name': 'Shop Rent',
      'icon': 'assets/images/icons/shop rent.png',
      'id': 15
    },
    {
      'name': 'Maintainence',
      'icon': 'assets/images/icons/maintainence.png',
      'id': 16
    },
    {'name': 'Other', 'icon': 'assets/images/icons/other.png', 'id': 17},
  ],
  [
    'Beauty & Care',
    Icons.health_and_safety,
    Color(0xffff00ff),
    {'name': 'Skin Care', 'icon': 'assets/images/icons/skin care.png', 'id': 18},
    {'name': 'Health Care', 'icon': 'assets/images/icons/health care.png', 'id': 19},
    {'name': 'Other', 'icon': 'assets/images/icons/other.png', 'id': 20},
  ],
  [
    'Clothing',
    FontAwesome.shirtsinbulk,
    Color(0xffff3300),
    {'name': 'Clothes', 'icon': 'assets/images/icons/clothes.png', 'id': 21},
    {'name': 'Bedsheets', 'icon': 'assets/images/icons/bedsheet.png', 'id': 22},
    {'name': 'Curtains', 'icon': 'assets/images/icons/curtain.png', 'id': 23},
    {'name': 'Other', 'icon': 'assets/images/icons/other.png', 'id': 24},
  ],
  [
    'Entertainment',
    Icons.movie_filter_sharp,
    Color(0xff00cc00),
    {'name': 'Movie', 'icon': 'assets/images/icons/movie.png', 'id': 25},
    {'name': 'Outing', 'icon': 'assets/images/icons/outing.png', 'id': 26},
    {'name': 'Restaurant', 'icon': 'assets/images/icons/restaurant.png', 'id': 27},
    {'name': 'Other', 'icon': 'assets/images/icons/other.png', 'id': 28},
  ],
  [
    'Sports',
    Icons.sports,
    Color(0xff339966),
    {'name': 'Gym', 'icon': 'assets/images/icons/gym.png', 'id': 29},
    {'name': 'Equipment', 'icon': 'assets/images/icons/equipment.jpg', 'id': 30},
    {'name': 'Other', 'icon': 'assets/images/icons/other.png', 'id': 31},
  ],
  [
    'Miscellaneous',
    Icons.list_alt,
    Colors.purple,
    {'name': 'Fuel', 'icon': 'assets/images/icons/fuel.png', 'id': 32},
    {'name': 'Home Appliances', 'icon': 'assets/images/icons/home appliances.png', 'id': 33},
    {'name': 'Kitchen', 'icon': 'assets/images/icons/kitchen.png', 'id': 34},
    {'name': 'Furniture', 'icon': 'assets/images/icons/furniture.png', 'id': 35},
    {'name': 'Donation', 'icon': 'assets/images/icons/donation.png', 'id': 36},
    {'name': 'Other', 'icon': 'assets/images/icons/other.png', 'id': 37},
  ]
];
