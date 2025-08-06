import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/posts.dart';

class VideoFeedWidget extends StatefulWidget {
  final List<Post> posts;
  final int initialIndex;

  const VideoFeedWidget({
    super.key,
    required this.posts,
    this.initialIndex = 0,
  });

  @override
  State<VideoFeedWidget> createState() => _VideoFeedWidgetState();
}

class _VideoFeedWidgetState extends State<VideoFeedWidget> {
  VideoPlayerController? _videoController;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isInitialized = false;

  final List<String> sampleVideos = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    await _videoController?.dispose();

    final currentPost = widget.posts[_currentIndex % 2];
    final videoUrl = currentPost.videoUrl ??
        sampleVideos[_currentIndex % sampleVideos.length];

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize();
      controller.setLooping(true);
      
      setState(() {
        _videoController = controller;
        _isInitialized = true;
        _isPlaying = true;
      });
      if (mounted) {
        controller.play();
      }
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _swipeTo(int newIndex) {
    // Ensure index stays within 0-1 range
    if (newIndex < 0) {
      newIndex = 1; // Wrap around to last video
    } else if (newIndex >= 2) {
      newIndex = 0; // Wrap around to first video
    }

    setState(() {
      _currentIndex = newIndex;
      _isInitialized = false;
      _isPlaying = false;
    });
    _initializeVideoController();
  }

  void _onSwipeUp() {
    _swipeTo(_currentIndex + 1);
  }

  void _onSwipeDown() {
    _swipeTo(_currentIndex - 1);
  }

  void _refreshFeed() async {
    setState(() {
      _isInitialized = false;
      _isPlaying = false;
    });

    await _initializeVideoController();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.posts[_currentIndex % 2]; 

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _onSwipeDown();
        } else if (details.primaryVelocity! < 0) {
          _onSwipeUp();
        }
      },
      behavior: HitTestBehavior.opaque, 
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_isInitialized && _videoController != null)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          Align(
            alignment: const Alignment(-1, 0.7),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    post.user,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 20,
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                if (_videoController == null) return;
                setState(() {
                  _isPlaying = !_isPlaying;
                  _isPlaying
                      ? _videoController?.play()
                      : _videoController?.pause();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
