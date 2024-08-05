import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insta_stories/main.dart';

void main() {
  testWidgets('Story Viewer Integration Test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify that the story list is displayed
    expect(find.byType(CircleAvatar), findsWidgets);

    // Tap on the first story
    await tester.tap(find.byType(CircleAvatar).first);
    await tester.pumpAndSettle();

    // Verify that the story viewer is displayed
    expect(find.byType(PageView), findsOneWidget);

    // Manually navigate to the next story
    final width = tester.getSize(find.byType(PageView)).width;
    await tester.tapAt(Offset(width * 0.75, 200));
    await tester.pumpAndSettle();

    // Verify that the next story is displayed
    expect(find.byType(GestureDetector), findsOneWidget);
  });
}
