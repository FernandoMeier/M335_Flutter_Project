import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shopinglist_app/models/shoping_list_item.dart';
import 'package:path_provider/path_provider.dart';

class ItemService {
  // Create
  Future<void> create(ShopingListItem shopingListItem) async {
    _shopingListItems.insert(0, shopingListItem);
    return _save();
  }

  Future<void> createAtIndex(ShopingListItem item, int index) async {
    _shopingListItems.insert(index, item);
    return _save(); // Ensure the list is saved after the insertion
  }

  // Read
  List<ShopingListItem> readAll() {
    return List.unmodifiable(_shopingListItems);
  }

  // Update
  Future<void> update(
      String id, String itemName, double quantity, String? notes) async {
    for (var item in _shopingListItems) {
      if (item.id == id) {
        item.update(itemName, quantity, notes);
        break;
      }
    }
    return _save();
  }

  // Delete
  Future<void> delete(String id) async {
    _shopingListItems.removeWhere((element) => element.id == id);
    return _save();
  }

  //! Call load() once before using the service!
  Future<void> load() async {
    final file = await _localFile;
    if (await file.exists()) {
      String content = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(content);
      _shopingListItems =
          jsonData.map((json) => ShopingListItem.fromJson(json)).toList();
    }
  }

  Future<void> _save() async {
    final file = await _localFile;
    List<Map<String, dynamic>> jsonData =
        _shopingListItems.map((item) => item.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/shopping_list.json');
  }

  List<ShopingListItem> _shopingListItems = [];
}
