import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nairy_hub/entities/thingFormDialogResult.dart';
import 'package:nairy_hub/entities/thingy.dart';
import 'package:nairy_hub/services/dataStore.dart';
import 'package:nairy_hub/ui/dialog.dart';
import 'package:nairy_hub/widgets/base/actionButton.dart';

class ThingyFormPage extends StatefulWidget {
  final Thingy? thingy;

  const ThingyFormPage({super.key, this.thingy});

  @override
  State<StatefulWidget> createState() => _ThingyFormPageState();
}

class _ThingyFormPageState extends State<ThingyFormPage> {
  bool saving = false;
  Thingy thingy =
      Thingy(id: 0, type: ThingyType.todoItem, summary: "", content: "");
  bool get isNew {
    return widget.thingy == null;
  }

  @override
  void initState() {
    super.initState();
    widget.thingy?.copyTo(thingy, includeId: true);
  }

  void saveClick(BuildContext context) async {
    // setState(() => saving = true);
    // await Future.delayed(const Duration(milliseconds: 1000));
    // setState(() => saving = false);
    setState(() => saving = true);
    if (isNew) {
      await DataStoreService.addThingy(thingy);
    } else {
      await DataStoreService.saveThingy(thingy);
    }
    setState(() => saving = false);
    var result = ThingFormDialogResult(
        operationType: isNew ? OperationType.added : OperationType.updated,
        thingy: thingy);
    // ignore: use_build_context_synchronously
    Navigator.pop(context, result);
  }

  void markAsCompleted() async {
    var msg =
        thingy.isCompleted ? "Mark as NOT Completed?" : "Mark as Completed?";
    if (await confirm(context, msg)) {
      thingy.status =
          thingy.isCompleted ? ThingyStatus.initial : ThingyStatus.completed;
      await DataStoreService.saveThingy(thingy);
      // ignore: use_build_context_synchronously
      Navigator.pop(
          context,
          ThingFormDialogResult(
              operationType: OperationType.updated, thingy: thingy));
    }
  }

  void deleteItem() async {
    if (await confirm(context, "Delete this Thingy?")) {
      await DataStoreService.deleteItem(widget.thingy?.id ?? 0);
      var result = ThingFormDialogResult(
          operationType: OperationType.deleted,
          thingy: widget.thingy as Thingy);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.thingy == null ? "Add Thingy" : "Edit Thingy"),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white10,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          if (!isNew)
            ActionButton(
              thingy.isCompleted
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              color: thingy.isCompleted ? Colors.green.shade200 : null,
              onTap: markAsCompleted,
            ),
          if (!isNew)
            ActionButton(
              Icons.delete_outline,
              onTap: deleteItem,
            ),
          ActionButton(
            Icons.check,
            loading: saving,
            onTap: () {
              saveClick(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              initialValue: thingy.summary,
              decoration: InputDecoration(
                  labelText: "Summary",
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8))),
              onChanged: (v) => thingy.summary = v,
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: thingy.content,
              decoration: InputDecoration(
                  labelText: "Content",
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8))),
              minLines: 5,
              maxLines: null,
              onChanged: (v) => thingy.content = v,
            ),
          ],
        ),
      ),
    );
  }
}
