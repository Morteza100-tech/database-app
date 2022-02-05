import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/item.dart';
import '../provider/items.dart';
import '../screen/add_new_story_screen.dart';

// TODO : I've this file name from ItemCard.dart to item_card.dart
// TODO : reason : https://dart-lang.github.io/linter/lints/file_names.html
// TODO : more info on best practises : https://dart.dev/guides/language/effective-dart
// TODO : https://iiro.dev/putting-build-methods-on-a-diet/
// TODO : https://iiro.dev/splitting-widgets-to-methods-performance-antipattern/

//import 'package:cached_network_image/cached_network_image.dart';

// ignore: must_be_immutable
class ItemCard extends StatefulWidget {
  ValueKey key;
  ItemCard(this.key) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late SharedPreferences pref;
  List<String> favs = [];

  getPref() async {
    // TODO: Extract this code to a separate class. Because it being call base on the Item cards size.
    // TODO: if you have 10 cards, then it's called 10x.
    pref = await SharedPreferences.getInstance();
    setState(() {
      favs = pref.getStringList('favorited') ?? [];
    });
    // TODO: Hard Reload your app an see the output.
    print('FAV list : $favs');
  }

  @override
  void didChangeDependencies() {
    // preferences.prefs;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getPref(); // TODO: Get the Favs list. Must be don't somewhere else.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Item>(context);
    bool isFav = favs.any((element) => element == item.id);

    // TODO : This will help you see the what is happening when you
    // TODO : the Favorite icon.
    print(favs);
    print(item.id);
    print('IS fav $isFav');
    print('********');

    // TODO: I am not sure why this code
    // TODO: Its throw an error. Un comment and see the log output.
    // TODO: you can't mark a widget as to be build when it's being build.
    // if (isFav && item.isFavorite == false) {
    //   item.toggleFavoriteStatus();
    // }
    //Start Color
    String startColorValueString =
        item.startColor!.split('(0x')[1].split(')')[0];
    int startColorValue = int.parse(startColorValueString, radix: 16);
    Color _startColor = Color(startColorValue);
    //End Color
    String endColorValueString = item.endColor!.split('(0x')[1].split(')')[0];
    int endColorValue = int.parse(endColorValueString, radix: 16);
    Color _endColor = Color(endColorValue);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              _endColor,
              _startColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _endColor,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title as String,
              textAlign: ui.TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Bahijj',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              item.author as String,
              textAlign: ui.TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Samim',
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white60,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<Items>(context, listen: false)
                          .deleteItem(item.id as String);
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white60,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          AddNewStoryScreen.routeName,
                          arguments: item.id);
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Consumer<Item>(
                  builder: (ctx, item, child) => InkWell(
                    onTap: () async {
                      List<String> favoritedItems = [];
                      favoritedItems
                          .addAll(pref.getStringList('favorited') ?? []);
                      if (isFav == true) {
                        favoritedItems
                            .removeWhere((element) => element == item.id);
                        await pref.setStringList('favorited', favoritedItems);
                        print('item.id: ${item.id}');
                      } else {
                        final _itemId = item.id ?? '';

                        if (_itemId.isNotEmpty &&
                            !favoritedItems.contains(_itemId)) {
                          // TODO : You can remvove this check. Did it to prevent double ID in the list.
                          favoritedItems.add(_itemId);

                          await pref.setStringList('favorited', favoritedItems);
                          print('FAVS : ${pref.get('favorited')}');
                        }
                      }
                      item.toggleFavoriteStatus();

                      // TODO: get the new Favs list.
                      await getPref();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white60,
                      ),
                      child: Center(
                        child: Icon(
                          // TODO: Use the [[isFav]] variable instead of
                          // TODO: checking on the item because you've already
                          // TODO: do the work above
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
