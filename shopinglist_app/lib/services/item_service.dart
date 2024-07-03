import 'dart:async';

import 'package:shopinglist_app/models/shoping_list_item.dart';

class ItemService {
  // Create
  Future<void> create(ShopingListItem shopingListItem) async {
    _shopingListItems.insert(0, shopingListItem);
    return _save();
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
  }

  // Delete
  Future<void> delete(String id) async {
    _shopingListItems.removeWhere((element) => element.id == id);
    return _save();
  }

  // Call load() once before using the service
  Future<void> load() async {
    // todo : load data from a server or DB
    _shopingListItems = _fakeData;
    return Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _save() async {
    // todo: add saving to file or sth.
  }

  List<ShopingListItem> _shopingListItems = [];
}

List<ShopingListItem> _fakeData = [
  ShopingListItem("Bread", 2.0, notes: "Gluten Free"),
  ShopingListItem("Milk", 3.0, notes: "Lactose Free"),
  ShopingListItem("Tomatoes", 2.0),
  ShopingListItem("Salami", 6.0, notes: "Big Bois"),
  ShopingListItem("Thing", 2.0),
];
