import 'package:flutter/material.dart';
class WidgetHelper {
  Widget makeTestableWidget({required Widget childPage, connectivity, route}) {
    return MaterialApp(
        home: childPage,
        debugShowCheckedModeBanner: true,
      );
  }
}
