import 'package:flutter/material.dart';

Color getBackgroundColor(int index) {
  return (index % 2 == 0) ? Colors.green[400]! : Colors.green[200]!;
}