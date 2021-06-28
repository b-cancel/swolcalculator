import 'package:flutter/material.dart';

void main() {
  runApp(
    Theme(
      data: ThemeData.dark().copyWith(
        accentColor: ThemeData.light().accentColor,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: ThemeData.dark().primaryColorDark,
        ),
      ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
