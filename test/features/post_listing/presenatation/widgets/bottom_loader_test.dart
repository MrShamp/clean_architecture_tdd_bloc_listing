import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/presentation/widgets/bottom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Post listing Screen widget test', () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
    });
    testWidgets('Bottom Loader widget test', (WidgetTester tester) async {
      // await tester.pumpWidget(const BottomLoader());
      // expect(const CircularProgressIndicator(), findsOneWidget);
    });
  });
}
