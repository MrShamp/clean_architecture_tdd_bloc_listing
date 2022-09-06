// @dart=2.9
import 'package:clean_architecture_bloc_tdd_listing/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/core/utils/widget_helper.dart';

var test_mode = 'success';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Post List Verification', (){
   setUpAll(() async {
  });

   tearDownAll(() {
    // Services tear downs
  });

   testWidgets('Integration test: Verify Items on Listing Page',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpWidget(WidgetHelper().makeTestableWidget(childPage: const MyApp()));
    
  });
});

}