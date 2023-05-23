// api_service.dart - This code Handles API requests to fetch videos. Implements the fetchVideos() method to retrieve video data from the specified API endpoint.

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/video_list_screen.dart';

class APIService {
  Future<List<Short>> fetchVideos(int page) async {
    try {
      final response = await http.get(Uri.parse(
          'https://internship-service.onrender.com/videos?page=${page + 1}'));
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        final List<dynamic>? data = responseData['data']['posts'];
        if (data != null) {
          final List<Short> fetchedShorts = data
              .map((video) => Short(
                    title: video['submission']['title'],
                    description: video['submission']['description'],
                    mediaUrl: video['submission']['mediaUrl'],
                    thumbnail: video['submission']['thumbnail'],
                    hyperlink: video['submission']['hyperlink'],
                  ))
              .toList();
          return fetchedShorts;
        } else {
          throw Exception('Failed to fetch videos');
        }
      } else {
        throw Exception('Failed to fetch videos');
      }
    } catch (e) {
      // Handle error
      print(e);
      throw Exception('Failed to fetch videos');
    }
  }
}
