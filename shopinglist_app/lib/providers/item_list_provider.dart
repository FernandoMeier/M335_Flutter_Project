import 'package:flutter/material.dart';
import 'package:shopinglist_app/models/shoping_list_item.dart';
import 'package:shopinglist_app/services/item_service.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class ItemListProvider extends ChangeNotifier {
  ItemListProvider(this._itemService) {
    _initAccelerometerListener();
  }

  final ItemService _itemService;
  ShopingListItem? _lastDeletedItem;
  int? _lastDeletedItemIndex;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  List<ShopingListItem> get shopingListItems {
    return _itemService.readAll();
  }

  void _initAccelerometerListener() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      // Check if the phone is face down
      if (event.z < -9.5) {
        // Adjusted condition for face down orientation
        addItemWithDelay("empty", 0.0, "Added automatically");
      }
    });
  }

  void addItem(String itemName, double quantity, String notes) {
    _itemService
        .create(ShopingListItem(itemName, quantity, notes: notes))
        .then((_) => notifyListeners());
  }

  void addItemWithDelay(String itemName, double quantity, String notes) {
    _itemService
        .create(ShopingListItem(itemName, quantity, notes: notes))
        .then((_) {
      notifyListeners();
      // Adding a delay of 1 second before allowing another item to be added
      Future.delayed(Duration(seconds: 1));
    });
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
      Vibration.vibrate();
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

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
