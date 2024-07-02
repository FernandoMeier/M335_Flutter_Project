import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopinglist_app/pages/home_list_view.dart';
import 'package:shopinglist_app/providers/item_list_provider.dart';
import 'package:shopinglist_app/services/item_service.dart';

void main() async {
  var itemService = ItemService();
  await itemService.load();
  var itemListProvider = ItemListProvider(itemService);

  //runApp(const ShopApp());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => itemListProvider),
    ],
    child: const ShopApp(),
  ));
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shoping List App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeListView(),
    );
  }
}
