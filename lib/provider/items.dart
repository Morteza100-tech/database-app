import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './item.dart';

class Items with ChangeNotifier {
  List<Item> _items = [];
  List<Item> get items {
    return [..._items];
  }

  Item findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetItems() async {
    const url = 'https://shaparak-732ff.firebaseio.com/items.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Item> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Item(
          id: prodId,
          title: prodData['title'],
          content: prodData['content'],
          author: prodData['author'],
          category: prodData['category'],
          startColor: prodData['startColor'],
          endColor: prodData['endColor'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }





  // Future<void> addItem(Item item) async {
  //   const url = 'https://shaparak-732ff.firebaseio.com/items.json';
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: json.encode({
  //         'title': item.title,
  //         'content': item.content,
  //         'author': item.author,
  //         'category': item.category,
  //         'startColor': item.startColor,
  //         'endColor': item.endColor,
  //       }),
  //     );
  //     // final newItem = Item(
  //     //   title: item.title,
  //     //   content: item.content,
  //     //   author: item.author,
  //     //   category: item.category,
  //     //   startColor: item.startColor,
  //     //   endColor: item.endColor,
  //     //   id: json.decode(response.body)['name'],
  //     // );
  //     // _items.add(newItem);
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  Future<void> updateItem(String id, Item newItem) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      final url = 'https://shaparak-732ff.firebaseio.com/items/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newItem.title,
            'content': newItem.content,
            'author': newItem.author,
            'category': newItem.category,
            'startColor': newItem.startColor,
            'endColor': newItem.endColor,
          }));
      _items[itemIndex] = newItem;
      notifyListeners();
    } else {
      print('...');
    }
  }

  // Future<void> updateItem(String id, Item newItem) async {
  //   final itemIndex = _items.indexWhere((element) => element.id == id);
  //   if (itemIndex >= 0) {
  //     final url = 'https://shaparak-732ff.firebaseio.com/items/$id.json';
  //     await http.patch(
  //       Uri.parse(url),
  //       body: json.encode({
  //         'title': newItem.title,
  //         'content': newItem.content,
  //         'author': newItem.author,
  //         'category': newItem.category,
  //       }),
  //     );
  //     _items[itemIndex] = newItem;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }

  Future<void> deleteItem(String id) async {
    final url = 'https://shaparak-732ff.firebaseio.com/items/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Item? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  // void deleteItem(String id) {
  //   final url = 'https://shaparak-732ff.firebaseio.com/items/$id.json';
  //   http.delete(Uri.parse(url));
  //   _items.removeWhere((element) => element.id == id);
  //   notifyListeners();
  // }

  // Future<void> fetchItems() async {
  //   const url = 'https://shaparak-732ff.firebaseio.com/items.json';
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Item> loadedItems = [];
  //     extractedData.forEach((itemId, itemData) {
  //       loadedItems.add(Item(
  //         id: itemId,
  //         title: itemData['title'],
  //         author: itemData['author'],
  //         category: itemData['category'],
  //         content: itemData['content'],
  //         startColor: itemData['startColor'],
  //         endColor: itemData['endColor'],
  //         // imagePath: itemData['imagePath'],
  //         // isChildish: itemData['isChildish'],
  //         // isJuveline: itemData['isJuveline'],
  //       ));
  //     });
  //     _items = loadedItems;
  //     notifyListeners();
  //   } catch (e) {
  //     rethrow;
  //     print(e);
  //   }
  // }
}
