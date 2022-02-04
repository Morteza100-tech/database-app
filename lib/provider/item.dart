import 'package:flutter/material.dart';

class Item with ChangeNotifier {
  final String? title;
  final String? author;
  final String? id;
  final String? category;
  final String? content;
  final String? startColor;
  final String? endColor;
  bool isFavorite;
  Item({
    @required this.title,
    @required this.author,
    @required this.id,
    @required this.category,
    @required this.content,
    @required this.startColor,
    @required this.endColor,
    this.isFavorite = false,
  });
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
