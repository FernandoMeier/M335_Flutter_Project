// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopinglist_app/pages/list_item_editor.dart';
import 'package:shopinglist_app/providers/item_list_provider.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Shopping List"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _ItemListWidget()),
              _CreateNewItemWidget(),
            ],
          )),
    );
  }
}

class _ItemListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemList = Provider.of<ItemListProvider>(context).shopingListItems;

    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (BuildContext context, int index) {
        var shopingItem = itemList[index];

        return ListTile(
          key: Key(shopingItem.id),
          title: Text(shopingItem.itemName),
          subtitle: Column(
            children: [
              Text("Quantity: ${shopingItem.quantity}"),
              Text("Notes: ${shopingItem.notes}")
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            /*onPressed: () {
              Provider.of<ItemListProvider>(context, listen: false)
                  .editShoppingItem(shopingItem.id, "this is a test",
                      2.0, "seems to work i guess (yippie!!!)");
            },*/
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListItemEditor(item: shopingItem),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CreateNewItemWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateItemState();
}

class _CreateItemState extends State<_CreateNewItemWidget> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(
                  hintText: "Name for new item",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a name for the item'),
                      ),
                    );
                    return "A name is needed";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  hintText: "Quantity of new item",
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid quantity'),
                      ),
                    );
                    return "A number is needed";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: "Additional information",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double quantity;
                    try {
                      quantity = double.parse(_quantityController.text);
                    } catch (e) {
                      // Handle the error, e.g., show a message to the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Please enter a valid number for quantity'),
                        ),
                      );
                      return;
                    }
                    Provider.of<ItemListProvider>(context, listen: false)
                        .addItem(
                      _itemNameController.text,
                      quantity,
                      _notesController.text,
                    );
                    _itemNameController.clear();
                    _quantityController.clear();
                    _notesController.clear();
                  }
                },
                child: Text('Create a new item'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
