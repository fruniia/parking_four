import 'package:flutter/material.dart';

const Color successColor = Colors.green;
const Color neutralColor = Colors.grey;
const Color errorColor = Colors.red;

void showCustomSnackBar(BuildContext context, String message,
    {String type = 'neutral'}) {
  Color backgroundColor;

  switch (type) {
    case 'success':
      backgroundColor = successColor;
      break;
    case 'error':
      backgroundColor = errorColor;
      break;
    case 'neutral':
    default:
      backgroundColor = neutralColor;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 80.0),
    ),
  );
}
