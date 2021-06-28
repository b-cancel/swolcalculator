import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
      theme: ThemeData.dark().copyWith(
        accentColor: ThemeData.light().accentColor,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: ThemeData.dark().primaryColorDark,
        ),
      ),
      home: Home(),
    );
  }
}
