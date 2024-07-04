// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopinglist_app/pages/list_item_editor.dart';
import 'package:shopinglist_app/providers/item_list_provider.dart';

class HomeListView extends StatelessWidget {
  HomeListView({super.key});

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Shopping List"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _ItemListWidget(
                      scaffoldMessengerKey: scaffoldMessengerKey)),
              _CreateNewItemWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemListWidget extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  const _ItemListWidget({required this.scaffoldMessengerKey});

  @override
  Widget build(BuildContext context) {
    var itemList = Provider.of<ItemListProvider>(context).shopingListItems;

    if (itemList.isEmpty) {
      return Center(
        child: Text(
          "No items yet",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (BuildContext context, int index) {
        var shopingItem = itemList[index];

        return Dismissible(
          key: Key(shopingItem.id), // Unique key for each item
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.redAccent, // Customized background color
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(
              Icons.delete, // Changed icon to delete icon
              color: Colors.white,
              size: 30,
            ),
          ),
          onDismissed: (direction) {
            Provider.of<ItemListProvider>(context, listen: false)
                .deleteShopingItem(shopingItem.id);

            // Use the GlobalKey to show the SnackBar
            scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                content: Text('Item deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    Provider.of<ItemListProvider>(
                            scaffoldMessengerKey.currentContext!,
                            listen: false)
                        .undoDelete();
                  },
                ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            child: ListTile(
              key: Key(shopingItem.id),
              title: Text(shopingItem.itemName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quantity: ${shopingItem.quantity}"),
                  Text("Notes: ${shopingItem.notes}")
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListItemEditor(item: shopingItem),
                    ),
                  );
                },
              ),
            ),
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
                  hintText: "Additional information (optional)",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double quantity;
                      try {
                        quantity = double.parse(_quantityController.text);
                      } catch (e) {
                        // Handle the error, e.g., show a message to the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please enter a valid number for quantity'),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
