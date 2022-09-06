import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/presentation/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture_bloc_tdd_listing/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/widget_helper.dart';
import 'dart:io' as io;

void main() {
  group('Post listing Screen widget test', () {
    setUp(() async {
      // await di.init();
      // di.sl.allReady();
      // TestWidgetsFlutterBinding.ensureInitialized();
      // io.HttpOverrides.global = null;
      // SharedPreferences.setMockInitialValues({});
      
    });
    testWidgets('Post Page widget test', (WidgetTester tester) async {
      // await tester.pumpWidget(WidgetHelper().makeTestableWidget(childPage: const PostsPage()));

      // expect(const CircularProgressIndicator(), findsOneWidget);

      // await tester.pumpAndSettle(const Duration(seconds: 5));

      // expect( ListView, findsOneWidget);
    });

  });
}
