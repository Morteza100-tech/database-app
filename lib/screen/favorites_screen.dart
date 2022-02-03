import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../provider/items.dart';
import '../widget/itemCard.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);
  static const routeName = '/Favorites';
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  SharedPreferences? pref;
  List<String> favoriteItemsId = [];
  getPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      favoriteItemsId = pref?.getStringList('favorited') ?? [];
      print("/////////////////////ssssssssssssdddddddddddddsssssssgffgg" +
          pref!.getStringList('favorited').toString());
    });
  }

  @override
  initState() {
    
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteItems = Provider.of<Items>(context).items;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: favoriteItemsId.isEmpty
            ? const Center(
                child: Text('Favorites!'),
              )
            : GridView.builder(
                itemBuilder: (ctx, index) {
                  bool fav = favoriteItemsId
                      .any((element) => element == favoriteItems[index].id);
                  return fav
                      ? ChangeNotifierProvider.value(
                          value: favoriteItems[index],
                          child: ItemCard(
                            ValueKey(favoriteItems[index].id),
                          ),
                        )
                      : Container();
                },
                itemCount: favoriteItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
              ),
      ),
    );
  }
}
