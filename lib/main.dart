import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nairy_hub/entities/thingFormDialogResult.dart';
import 'package:nairy_hub/entities/thingy.dart';
import 'package:nairy_hub/logger.dart';
import 'package:nairy_hub/services/dataStore.dart';
import 'package:nairy_hub/widgets/base/textDivider.dart';
import 'package:nairy_hub/widgets/thingyCard.dart';
import 'package:nairy_hub/widgets/thingyFormPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialLoad();
  runApp(const MyApp());
}

List<Thingy>? thingies;
Future<void> initialLoad() async {
  await DataStoreService.init();
  thingies = await DataStoreService.getItems();
  Logger.debug("loaded ${thingies?.length} items");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nairy Hub',
      theme: ThemeData(
        backgroundColor: Colors.white10,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Thingy> items = List.empty();
  List<Thingy> normalItems = List.empty();
  List<Thingy> archivedItems = List.empty();
  void splitItems() {
    normalItems = List.empty(growable: true);
    archivedItems = List.empty(growable: true);
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      if (item.isCompleted) {
        archivedItems.add(item);
      } else {
        normalItems.add(item);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (thingies != null) {
      items = thingies as List<Thingy>;
      splitItems();
    }
  }

  void patchList(ThingFormDialogResult update) {
    var uThingy = update.thingy;
    setState(() {
      if (update.operationType == OperationType.added) {
        items.insert(0, uThingy);
      } else if (update.operationType == OperationType.updated) {
        var src = items.firstWhere((e) => e.id == uThingy.id);
        uThingy.copyTo(src);
      } else if (update.operationType == OperationType.deleted) {
        items.removeWhere((element) => element.id == uThingy.id);
      }
      splitItems();
    });
  }

  Future<void> loadItems() async {
    var loadedItems = await DataStoreService.getItems();
    var count = loadedItems.length;
    Logger.debug('loaded $count items');
    setState(() {
      items = loadedItems;
      splitItems();
    });
  }

  void viewItem(Thingy? item) async {
    var result = await showGeneralDialog<ThingFormDialogResult>(
        context: context,
        pageBuilder: (BuildContext context, Animation n1, Animation n2) =>
            ThingyFormPage(thingy: item));
    if (result != null) {
      patchList(result);
    }
  }

  void itemLongPress(Thingy item) async {
    setState(() {
      item.status = ThingyStatus.completed;
    });
    await DataStoreService.saveThingy(item);
    await Future.delayed(const Duration(milliseconds: 1600));
    setState(() {
      splitItems();
    });
  }

  List<Widget> itemsToCards(List<Thingy> items, bool archived) {
    return items
        .map((e) => ThingyCard(
              data: e,
              isArchived: archived,
              onLongPress: () => itemLongPress(e),
              onTap: () => viewItem(e),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white10,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(5.0),
        children: [
          ...itemsToCards(normalItems, false),
          if (archivedItems.isNotEmpty) const TextDivider("Archived"),
          ...itemsToCards(archivedItems, true),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Refresh Items'),
              onTap: () {
                loadItems();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewItem(null),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
