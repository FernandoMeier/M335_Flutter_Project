// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            children: [Expanded(child: _ItemListWidget())],
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
            onPressed: () {
              Provider.of<ItemListProvider>(context, listen: false)
                  .deleteShopingItem(shopingItem.id);
            },
          ),
        );
      },
    );
  }
}
