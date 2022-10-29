import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String text;

  const TextDivider(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(
          child: Divider(
        thickness: 2,
      )),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black38),
        ),
      ),
      const Expanded(
          child: Divider(
        thickness: 2,
      )),
    ]);
  }
}
