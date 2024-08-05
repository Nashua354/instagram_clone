import 'package:flutter/material.dart';
import 'package:insta_stories/constants/assets.dart';
import 'package:insta_stories/repository/stories_repository.dart';
import 'package:insta_stories/views/story_screen.dart';
import 'package:insta_stories/views/widgets/dotted_border.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    StoriesRepository().fetchStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: SizedBox(
            width: 150,
            child: Image.asset(
              logoAsset,
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              color: Colors.black,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.send),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 110,
                child: FutureBuilder(
                    future: StoriesRepository().fetchStories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final users = snapshot.data;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: users?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) =>
                                        StoryScreen(user: users![index])));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 65,
                                            height: 65,
                                            child: CustomPaint(
                                              painter: DottedBorder(
                                                  numberOfStories: users![index]
                                                      .stories
                                                      .length,
                                                  spaceLength: 4),
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                users[index].profileImageUrl),
                                          )
                                        ]),
                                    const SizedBox(height: 4),
                                    Text(users[index].name),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}
