import 'package:flutter/material.dart';
import 'package:nairy_hub/entities/thingy.dart';

class ThingFormDialogResult {
  final OperationType operationType;
  final Thingy thingy;
  const ThingFormDialogResult(
      {required this.operationType, required this.thingy});
}

enum OperationType { added, updated, deleted }
