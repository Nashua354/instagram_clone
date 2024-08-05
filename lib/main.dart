import 'package:flutter/material.dart';
import 'package:insta_stories/repository/remote_data_source.dart';
import 'package:insta_stories/views/feed_screen.dart';
import 'package:insta_stories/views/story_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: const FeedScreen(),
    );
  }
}
