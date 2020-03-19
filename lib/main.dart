import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/constants/theme_data.dart';
import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart';

Future<void> main() async {
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Triva',
      theme: themeData,
      home: NumberTrivaPage(),
    );
  }
}
