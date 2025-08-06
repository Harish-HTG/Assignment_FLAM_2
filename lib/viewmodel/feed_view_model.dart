import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/posts.dart';
import '../services/feed_service.dart';

class FeedViewModel extends StateNotifier<List<Post>> {
  final FeedService _service;
  FeedType _currentType = FeedType.post;
  int _currentPage = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;

  FeedType get currentType => _currentType;

  FeedViewModel(this._service) : super([]) {
    loadFeed();
  }

  void loadFeed() async {
    _currentPage = 0;
    final posts = await _service.fetchPosts(_currentType, page: _currentPage);
    state = posts;
  }

  Future<void> refreshFeed() async {
    _isLoading = true;
    
    try {
      final newPosts = await _service.fetchPosts(_currentType);
      
      if (_currentType == FeedType.video) {
        state = newPosts;
      } else {
        state = [...state, ...newPosts];
      }
    } catch (e) {
      print('Error refreshing feed: $e');
    } finally {
      _isLoading = false;
    }
  }

  void switchFeedType() {
    _currentPage = 0;
    _currentType = _currentType == FeedType.post ? FeedType.video : FeedType.post;
    state = [];
    loadFeed();
  }

  Future<void> loadMorePosts() async {
    if (_isLoadingMore) return;
    
    _isLoadingMore = true;
    
    try {
      final newPosts = await _service.fetchPosts(_currentType);
      
      if (_currentType == FeedType.video) {
        state = newPosts;
      } else {
        state = [...state, ...newPosts];
      }
    } catch (e) {
      print('Error loading more posts: $e');
    } finally {
      _isLoadingMore = false;
    }
  }
}
