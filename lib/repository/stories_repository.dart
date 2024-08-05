import 'package:insta_stories/models/user_model.dart';
import 'package:insta_stories/constants/static_data.dart';

class StoriesRepository {
  Future<List<User>> fetchStories() async {
    await Future.delayed(const Duration(seconds: 1));
    return users;
  }
}
