import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoCategory {
  late String id;
  late String categoryName;
  late Color primaryColor;
  late Color secondaryColor;
  late IconData icon;

  TodoCategory({
    required this.id,
    required this.categoryName,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  });
}