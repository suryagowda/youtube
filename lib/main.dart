// main.dart - This is entry point of this app. Sets up the YouTubeShortsApp widget as the main application widget.

import 'package:flutter/material.dart';
import 'screens/video_list_screen.dart';

void main() {
  runApp(YouTubeShortsApp());
}

class YouTubeShortsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Shorts Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: VideoListScreen(),
    );
  }
}
