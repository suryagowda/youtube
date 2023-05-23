// video_player_screen.dart - Plays a list of videos. Users can swipe vertically to navigate between videos and tap to play/pause.

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<String> videoUrls;
  final int initialIndex;

  VideoPlayerScreen({
    required this.videoUrls,
    required this.initialIndex,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late PageController _pageController;
  List<VideoPlayerController> _videoPlayerControllers = [];
  List<bool> _videoLoading = [];
  bool _isPlaying = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrls.isNotEmpty) {
      _currentIndex = widget.initialIndex;
      if (_currentIndex >= widget.videoUrls.length) {
        _currentIndex = 0;
      }
      _videoPlayerControllers = List.generate(widget.videoUrls.length, (index) {
        final controller =
            VideoPlayerController.network(widget.videoUrls[index]);
        controller.initialize().then((_) {
          if (mounted) {
            setState(() {
              _videoLoading[index] = false;
            });
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _videoLoading[index] = false;
            });
          }
        });
        return controller;
      });
      _pageController = PageController(initialPage: _currentIndex);
      _isPlaying = true;
      _videoPlayerControllers[_currentIndex].play();
      _videoLoading = List.generate(widget.videoUrls.length, (_) => true);
    }
  }

  @override
  void dispose() {
    for (var controller in _videoPlayerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideoPlayers() async {
    _videoPlayerControllers
        .clear(); // Clear the list before adding new instances
    _videoLoading = List.generate(widget.videoUrls.length, (_) => true);

    for (var url in widget.videoUrls) {
      final controller = VideoPlayerController.network(url);
      await controller.initialize();
      _videoPlayerControllers.add(controller);
      controller.setLooping(true);
      controller.addListener(() {
        final bool isPlaying = controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      });
    }

    setState(() {
      _isPlaying = true;
      _currentIndex = widget.initialIndex;
      _videoPlayerControllers[_currentIndex].play();
      _videoLoading[_currentIndex] = false;
    });
  }

  void _playPauseVideo(int index) {
    final controller = _videoPlayerControllers[index];
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {
      _isPlaying = controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrls.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('No videos to play.'),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _videoPlayerControllers[_currentIndex].play();
              _videoPlayerControllers.asMap().forEach((i, controller) {
                if (i != _currentIndex) {
                  controller.pause();
                }
              });
              setState(() {
                _isPlaying =
                    _videoPlayerControllers[_currentIndex].value.isPlaying;
              });
            },
            physics: ClampingScrollPhysics(),
            children: List.generate(widget.videoUrls.length, (index) {
              final controller = _videoPlayerControllers[index];
              return GestureDetector(
                onTap: () {
                  _playPauseVideo(index);
                },
                child: Stack(
                  children: [
                    VideoPlayer(controller),
                    if (!controller.value.isPlaying && !_videoLoading[index])
                      Positioned.fill(
                        child: Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 80.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (_videoLoading[index])
                      Positioned.fill(
                        child: Center(
                          child: SpinKitCircle(
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
