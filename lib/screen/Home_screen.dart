// ignore_for_file: must_be_immutable

import './favorites_screen.dart';
import 'package:flutter/material.dart';
import './add_new_story_screen.dart';
import '../provider/items.dart';

import 'package:provider/provider.dart';

import '../widget/items_grid.dart';

class HomeScreen extends StatefulWidget {
  String title;
  HomeScreen(this.title, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('state updated');
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Items>(context).fetchAndSetItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final List<Item> stories = Provider.of<Items>(context).items.toList();
    return Scaffold(
      backgroundColor: const Color(0xFFFDEBF7),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewStoryScreen.routeName);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(FavoritesScreen.routeName);
            },
            icon: const Icon(
              Icons.favorite,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const ItemsGrid(),
    );
  }
}
