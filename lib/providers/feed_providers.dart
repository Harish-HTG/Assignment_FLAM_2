import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/models/posts.dart';
import 'package:twitter/viewmodel/feed_view_model.dart';
import '../services/feed_service.dart';

final feedViewModelProvider =
    StateNotifierProvider<FeedViewModel, List<Post>>((ref) {
  return FeedViewModel(FeedService());
});
