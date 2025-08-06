import 'package:twitter/models/posts.dart';

class FeedService {
  final List<String> sampleVideos = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];

  final List<String> sampleImages = [
    'https://picsum.photos/seed/100/300',
    'https://picsum.photos/seed/200/300',
    'https://picsum.photos/seed/300/300',
    'https://picsum.photos/seed/400/300',
    'https://picsum.photos/seed/500/300',
  ];

  Future<List<Post>> fetchPosts(FeedType type, {int page = 0}) async {
    if (type == FeedType.video) {
      return [
        Post(
          id: 'video-0',
          user: 'Video User 1',
          content: 'Video post #1',
          videoUrl: sampleVideos[0],
          type: type,
        ),
        Post(
          id: 'video-1',
          user: 'Video User 2',
          content: 'Video post #2',
          videoUrl: sampleVideos[1],
          type: type,
        ),
      ];
    }

    final samplePosts = [
      Post(
        id: 'post-0',
        user: 'Regular User 1',
        content: 'Regular post #1',
        imageUrl: sampleImages[0],
        type: type,
      ),
      Post(
        id: 'post-1',
        user: 'Regular User 2',
        content: 'Regular post #2',
        imageUrl: sampleImages[1],
        type: type,
      ),
      Post(
        id: 'post-2',
        user: 'Regular User 3',
        content: 'Regular post #3',
        imageUrl: sampleImages[2],
        type: type,
      ),
      Post(
        id: 'post-3',
        user: 'Regular User 4',
        content: 'Regular post #4',
        imageUrl: sampleImages[3],
        type: type,
      ),
      Post(
        id: 'post-4',
        user: 'Regular User 5',
        content: 'Regular post #5',
        imageUrl: sampleImages[4],
        type: type,
      ),
    ];

    return samplePosts;
  }
}
