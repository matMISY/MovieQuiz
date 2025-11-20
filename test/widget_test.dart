import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_quiz/main.dart';

void main() {
  testWidgets('MovieQuiz app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MovieQuizApp());

    // Verify that score widget is present
    expect(find.textContaining('Score'), findsOneWidget);
  });
}
