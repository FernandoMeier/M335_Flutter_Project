import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shopinglist_app/models/shoping_list_item.dart';
import 'package:shopinglist_app/services/item_service.dart';

class ItemListProvider extends ChangeNotifier {
  ItemListProvider(this._itemService);

  List<ShopingListItem> get shopingListItems {
    return _itemService.readAll();
  }

  void addItem(String itemName, double quantity, String notes) {
    _itemService
        .create(ShopingListItem(itemName, quantity))
        .then((_) => {notifyListeners()});
  }

  final ItemService _itemService;

  void deleteShopingItem(String id) {
    _itemService.delete(id).then((_) => {notifyListeners()});
  }

  void editShoppingItem(String id, String itemName, double quantity, String notes) {
    _itemService.update(id, itemName, quantity as Double, notes).then((_) => {notifyListeners()});
  }
}
