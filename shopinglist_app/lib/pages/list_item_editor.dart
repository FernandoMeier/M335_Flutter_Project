// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopinglist_app/models/shoping_list_item.dart';
import 'package:shopinglist_app/providers/item_list_provider.dart';

class ListItemEditor extends StatelessWidget {
  final ShopingListItem item; // Add this line

  const ListItemEditor(
      {super.key, required this.item}); // Modify the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit this item"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _EditItemForm(item: item)), // Pass item to the form
            _ExitOptions(),
          ],
        ),
      ),
    );
  }
}

class _EditItemForm extends StatefulWidget {
  final ShopingListItem item; // Add this line

  const _EditItemForm({required this.item}); // Modify the constructor

  @override
  State<StatefulWidget> createState() => _EditItemState();
}

class _EditItemState extends State<_EditItemForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _itemNameController;
  late TextEditingController _quantityController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.item.itemName);
    _quantityController =
        TextEditingController(text: widget.item.quantity.toString());
    _notesController = TextEditingController(text: widget.item.notes);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _itemNameController,
              decoration: InputDecoration(
                hintText: "Name of item",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "A name is needed";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                hintText: "Quantity of item",
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "A number is needed";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: "Additional information (optional)",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  double quantity;
                  try {
                    quantity = double.parse(_quantityController.text);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Please enter a valid number for quantity'),
                      ),
                    );
                    return;
                  }
                  Provider.of<ItemListProvider>(context, listen: false)
                      .editShoppingItem(
                    widget.item.id,
                    _itemNameController.text,
                    quantity,
                    _notesController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}

class _ExitOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel and go back
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Assuming that form validation and item update are handled within _EditItemForm
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Press Save to apply changes')),
            );
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
