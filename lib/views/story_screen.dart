import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:insta_stories/models/story_model.dart';
import 'package:insta_stories/models/user_model.dart';
import 'package:insta_stories/views/widgets/animated_bar.dart';
import 'package:insta_stories/views/widgets/user_info.dart';

class StoryScreen extends StatefulWidget {
  final User user;

  const StoryScreen({super.key, required this.user});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  AnimationController? _animController;
  CachedVideoPlayerController? _videoController;
  int _currentIndex = 0;

  Future<void> preLoadStories() async {
    final cache = DefaultCacheManager();
    for (final story in widget.user.stories) {
      await cache.getSingleFile(story.url);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    final Story firstStory = widget.user.stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController?.stop();
        _animController?.reset();
        setState(() {
          if (_currentIndex + 1 < widget.user.stories.length) {
            _currentIndex += 1;
            _loadStory(story: widget.user.stories[_currentIndex]);
          } else {
            _currentIndex = 0;
            // _loadStory(story: widget.user.stories[_currentIndex]);
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  Future<List<Story>> mockApiData() async {
    //make api call and then
    await preLoadStories();
    return widget.user.stories;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController?.dispose();
    // _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.user.stories[_currentIndex];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTapDown: (details) => _onTapDown(details, story),
          child: FutureBuilder(
              future: mockApiData(),
              builder: (context, snapshot) {
                return Stack(
                  children: <Widget>[
                    PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.user.stories.length,
                      itemBuilder: (context, i) {
                        final Story story = widget.user.stories[i];
                        switch (story.media) {
                          case MediaType.image:
                            return CachedNetworkImage(
                              imageUrl: story.url,
                              fit: BoxFit.cover,
                            );
                          case MediaType.video:
                            if (_videoController != null &&
                                (_videoController?.value.isInitialized ??
                                    false)) {
                              return FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _videoController?.value.size.width,
                                  height: _videoController?.value.size.height,
                                  child: CachedVideoPlayer(
                                    _videoController!,
                                  ),
                                ),
                              );
                            }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Positioned(
                      top: 40.0,
                      left: 10.0,
                      right: 10.0,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: widget.user.stories
                                .asMap()
                                .map((i, e) {
                                  return MapEntry(
                                    i,
                                    AnimatedBar(
                                      animController: _animController!,
                                      position: i,
                                      currentIndex: _currentIndex,
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 1.5,
                              vertical: 10.0,
                            ),
                            child: UserInfo(user: widget.user),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: widget.user.stories[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.user.stories.length) {
          _currentIndex += 1;
          _loadStory(story: widget.user.stories[_currentIndex]);
        } else {
          _currentIndex = 0;
          // _loadStory(story: widget.user.stories[_currentIndex]);
          Navigator.of(context).pop();
        }
      });
    } else {
      if (story.media == MediaType.video) {
        if (_videoController?.value.isPlaying ?? false) {
          _videoController?.pause();
          _animController?.stop();
        } else {
          _videoController?.play();
          _animController?.forward();
        }
      }
    }
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animController?.stop();
    _animController?.reset();
    switch (story.media) {
      case MediaType.image:
        _animController?.duration = story.duration;
        _animController?.forward();
        break;
      case MediaType.video:
        _videoController = null;
        _videoController?.dispose();
        _videoController = CachedVideoPlayerController.network(story.url)
          ..initialize().then((_) {
            setState(() {});
            if (_videoController?.value.isInitialized ?? false) {
              _animController?.duration = _videoController?.value.duration;
              _videoController?.play();
              _animController?.forward();
            }
          });
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}
