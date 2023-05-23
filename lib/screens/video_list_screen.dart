// video_list_screen.dart - this displays a list of videos fetched from the API. This Allows users to tap on a video to play it in the VideoPlayerScreen.

import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'video_player_screen.dart';

class Short {
  final String title;
  final String description;
  final String mediaUrl;
  final String thumbnail;
  final String hyperlink;

  Short({
    required this.title,
    required this.description,
    required this.mediaUrl,
    required this.thumbnail,
    required this.hyperlink,
  });
}

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen>
    with SingleTickerProviderStateMixin {
  List<Short> shorts = [];
  int currentPage = 0;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final APIService _apiService = APIService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    fetchVideos(currentPage);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchVideos(int page) async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedShorts = await _apiService.fetchVideos(page);
      setState(() {
        shorts.addAll(fetchedShorts);
        currentPage = page;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToVideoPlayer(List<String> videoUrls, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoUrls: videoUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Shorts 👁‍🗨'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchVideos(currentPage + 1);
            return true;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: shorts.length + 1,
          itemBuilder: (context, index) {
            if (index < shorts.length) {
              return GestureDetector(
                onTap: () {
                  List<String> videoUrls =
                      shorts.map((short) => short.mediaUrl).toList();
                  navigateToVideoPlayer(videoUrls, index);
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(
                      children: [
                        Image.network(
                          shorts[index].thumbnail,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 500.0,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black87,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: FadeTransition(
                              opacity: _animation,
                              child: Text(
                                shorts[index].title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
