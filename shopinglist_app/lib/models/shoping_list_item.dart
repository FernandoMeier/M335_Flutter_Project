// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:uuid/uuid.dart';

class ShopingListItem {
  ShopingListItem(this._itemName, this._quantity, {notes = ""})
      : _notes = notes,
        _id = Uuid().v4();

  String get id => _id;
  String get itemName => _itemName;
  double get quantity => _quantity;
  String get notes => _notes;

  String _id;
  String _itemName;
  double _quantity;
  String _notes;

  void update(String itemName, double quantity, String? notes) {
    _itemName = itemName;
    _quantity = quantity;
    _notes = notes ?? _notes;
  }

  factory ShopingListItem.fromJson(Map<String, dynamic> json) {
    return ShopingListItem(
      json['itemName'],
      json['quantity'],
      notes: json['notes'],
    ).._id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'itemName': _itemName,
      'quantity': _quantity,
      'notes': _notes,
    };
  }
}
