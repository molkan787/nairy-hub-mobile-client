import 'package:flutter/material.dart';

Future<bool> confirm(BuildContext context, String text) async {
  var result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Confirm"),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ));
  return result ?? false;
}
