import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopinglist_app/pages/home_list_view.dart';
import 'package:shopinglist_app/providers/item_list_provider.dart';
import 'package:shopinglist_app/services/item_service.dart';

//! Note to self: If the debug build is not finishing on emulator after a few minutes just quit and it should finish.
//! If it complains about ABS or sth. that sounded like that: flutter clean --> flutter pub get --> delete on phone --> debug mode run again

// todo: add easteregg --> item XYZ causes phone vibration

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final itemService = ItemService();
  await itemService.load(); // Load items from storage

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ItemListProvider(itemService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeListView(),
    );
  }
}
