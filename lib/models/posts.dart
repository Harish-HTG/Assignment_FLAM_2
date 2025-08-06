enum FeedType { post, video }

class Post {
  final String id;
  final String user;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final FeedType type;

  Post({
    required this.id,
    required this.user,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    required this.type,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      user: map['user'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      type: FeedType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => FeedType.post,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'type': type.name,
    };
  }
}
