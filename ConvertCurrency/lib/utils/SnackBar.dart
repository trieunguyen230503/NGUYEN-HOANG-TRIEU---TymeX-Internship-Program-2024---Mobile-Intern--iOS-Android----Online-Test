import 'package:flutter/material.dart';

void openSnackbar(context, snackMessgae, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
        textColor: Colors.white,
      ),
      content: Text(
        snackMessgae,
        style: const TextStyle(fontSize: 14),
      )));
}
