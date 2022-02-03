import 'dart:convert';

import 'package:flutter/material.dart';
import './screen/Home_screen.dart';
import './screen/add_new_story_screen.dart';
import 'package:provider/provider.dart';
import './provider/items.dart';
import './provider/item.dart';
import './screen/favorites_screen.dart';

//import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

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
        ChangeNotifierProvider.value(
          value: Items(),
        ),
        ChangeNotifierProvider.value(
          value: Item(),
        ),
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

