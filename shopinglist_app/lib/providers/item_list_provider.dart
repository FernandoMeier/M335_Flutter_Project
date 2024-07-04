import 'package:flutter/material.dart';
import 'package:shopinglist_app/models/shoping_list_item.dart';
import 'package:shopinglist_app/services/item_service.dart';

class ItemListProvider extends ChangeNotifier {
  ItemListProvider(this._itemService);

  final ItemService _itemService;
  ShopingListItem? _lastDeletedItem;
  int? _lastDeletedItemIndex;

  List<ShopingListItem> get shopingListItems {
    return _itemService.readAll();
  }

  void addItem(String itemName, double quantity, String notes) {
    _itemService
        .create(ShopingListItem(itemName, quantity, notes: notes))
        .then((_) => notifyListeners());
  }

  void deleteShopingItem(String id) {
    var item = shopingListItems.firstWhere((item) => item.id == id);
    _lastDeletedItemIndex = shopingListItems.indexOf(item);
    if (_lastDeletedItemIndex != -1) {
      _lastDeletedItem = item;
      _itemService.delete(id).then((_) => notifyListeners());
    }
  }

  void undoDelete() {
    if (_lastDeletedItem != null && _lastDeletedItemIndex != null) {
      _itemService
          .createAtIndex(_lastDeletedItem!, _lastDeletedItemIndex!)
          .then((_) {
        _lastDeletedItem = null;
        _lastDeletedItemIndex = null;
        notifyListeners();
      });
    }
  }

  void editShoppingItem(
      String id, String itemName, double quantity, String notes) {
    _itemService
        .update(id, itemName, quantity, notes)
        .then((_) => notifyListeners());
  }
}
