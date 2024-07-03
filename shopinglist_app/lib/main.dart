import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopinglist_app/pages/home_list_view.dart';
import 'package:shopinglist_app/providers/item_list_provider.dart';
import 'package:shopinglist_app/services/item_service.dart';

/// Note to self: If the debug build is not finishing on emulator after a few minutes just quit and it should finish.
/// If it complains about ABS or sth. that sounded like that: flutter clean --> flutter pub get --> delete on phone --> debug mode run again

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var itemService = ItemService();
  await itemService.load();
  var itemListProvider = ItemListProvider(itemService);

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
      title: "Shoping List",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeListView(),
      //home: const ListItemEditor()
    );
  }
}
