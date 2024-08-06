import 'package:flutter_test/flutter_test.dart';
import 'package:insta_stories/views/feed_screen.dart';
import 'package:insta_stories/views/story_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:insta_stories/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  enableFlutterDriverExtension();

  group('App Integration Tests', () {
    testWidgets('Load feed screen and display users with stories',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that the FeedScreen is displayed
      expect(find.byType(FeedScreen), findsOneWidget);

      // Verify that users with stories are displayed
      expect(find.byType(UserAvatar), findsWidgets);
    });

    testWidgets('Tap on user to view stories', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap on the first user in the feed
      await tester.tap(find.byType(UserAvatar).first);
      await tester.pumpAndSettle();

      // Verify that the StoryScreen is displayed
      expect(find.byType(StoryScreen), findsOneWidget);

      // Verify that the first story is displayed
      expect(find.byType(CustomCacheImage), findsOneWidget);
    });

    testWidgets('Navigate through stories', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap on the first user in the feed
      await tester.tap(find.byType(UserAvatar).first);
      await tester.pumpAndSettle();

      // Verify that the first story is displayed
      expect(find.byType(CustomCacheImage), findsOneWidget);

      // Tap on the right side of the screen to go to the next story
      await tester.tapAt(
          const Offset(300, 300)); // Adjust coordinates based on your screen
      await tester.pumpAndSettle();

      // Verify that the second story is displayed
      expect(find.byType(CustomCacheImage), findsWidgets);
    });
  });
}
