import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import './provider/item.dart';
import './provider/items.dart';
import './screen/add_new_story_screen.dart';
import './screen/favorites_screen.dart';
import './screen/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // TODO: the main problem was here
        // TODO: You cannot use ChangeNotifierProvider.value to create a new Object.
        // TODO: In this case Items() and Item()
        // TODO : Resources : https://pub.dev/packages/provider#usage
        ChangeNotifierProvider(create: (_) => Items()),
        ChangeNotifierProvider(create: (_) => Item()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color(0xFF8946A6),
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen('Shaparak'),
        routes: {
          AddNewStoryScreen.routeName: (ctx) => const AddNewStoryScreen(),
          FavoritesScreen.routeName: (ctx) => const FavoritesScreen(),
        },
      ),
    );
  }
}
