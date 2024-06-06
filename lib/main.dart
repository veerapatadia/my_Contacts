import 'package:flutter/material.dart';
import 'package:mycontacts/provider/AppTheme_provider.dart';
import 'package:mycontacts/provider/contact_provider.dart';
import 'package:mycontacts/provider/favourite_provider.dart';
import 'package:mycontacts/provider/hide_provider.dart';
import 'package:mycontacts/provider/image_provider.dart';
import 'package:mycontacts/provider/search_provider.dart';
import 'package:mycontacts/provider/stepper_provider.dart';
import 'package:mycontacts/views/detail_page.dart';
import 'package:mycontacts/views/hide_page.dart';
import 'package:mycontacts/views/home_page.dart';
import 'package:mycontacts/views/search_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StepperProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => HideContactProvider()),
        ChangeNotifierProvider(create: (context) => imageProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: (Provider.of<ThemeProvider>(context).appTheme.isDark)
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => home_page(),
        'detail_page': (context) => detail_page(),
        'hide_page': (context) => hide_page(),
        'search_page': (context) => SearchPage(),
      },
    );
  }
}
