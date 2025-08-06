import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:twitter/views/post_widget.dart';
import 'package:twitter/views/video_feed_widget.dart';
import 'package:twitter/providers/feed_providers.dart';
import 'package:twitter/models/posts.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  late final ScrollController _scrollController;
  bool _isLoading = false;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(_onScroll)
      ..addListener(_onScrollTopRefresh);
    _refreshController = RefreshController(initialRefresh: false);
  }

  void _onScroll() {
    if (_isLoading) return;
    
    final viewModel = ref.read(feedViewModelProvider.notifier);
    final posts = ref.watch(feedViewModelProvider);
    
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      viewModel.loadMorePosts();
      setState(() => _isLoading = true);
    }
  }

  void _onScrollTopRefresh() {
    if (_scrollController.position.pixels <= 0) {
      _onRefresh();
    }
  }

  void _onRefresh() async {
    setState(() => _isLoading = true);
    try {
      final viewModel = ref.read(feedViewModelProvider.notifier);
      await viewModel.refreshFeed();
      if (mounted) {
        _refreshController.refreshCompleted();
      }
    } catch (e) {
      print('Error refreshing feed: $e');
      if (mounted) {
        _refreshController.refreshFailed();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(feedViewModelProvider.notifier);
    final posts = ref.watch(feedViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Feed'),
        actions: [
          IconButton(
            icon: Icon(viewModel.currentType == FeedType.post 
                ? Icons.video_library 
                : Icons.photo_library),
            onPressed: () {
              viewModel.switchFeedType();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          if (posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.currentType == FeedType.video) {
            return VideoFeedWidget(posts: posts);
          }

          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            enablePullUp: true,
            header: const WaterDropHeader(),
            footer: const ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              loadingText: 'Loading new posts...',
              idleText: 'Pull up to refresh',
            ),
            onLoading: () async {
              await Future.delayed(const Duration(milliseconds: 1000));
              final viewModel = ref.read(feedViewModelProvider.notifier);
              await viewModel.loadMorePosts();
              if (mounted) {
                _refreshController.loadComplete();
              }
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                
                return PostWidget(post: post);
              },
            ),
          );
        },
      ),
    );
  }
}
