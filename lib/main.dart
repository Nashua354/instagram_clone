import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_stories/views/feed_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      theme: ThemeData.light(),
      home: const FeedScreen(),
    );
  }
}
