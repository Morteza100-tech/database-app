import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/items.dart';
import './itemCard.dart';

class ItemsGrid extends StatelessWidget {
  const ItemsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<Items>(context);
    final items = itemsData.items;
    return GridView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: items[i],
        child: ItemCard(
          ValueKey(items[i].id),
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
    );
  }
}
