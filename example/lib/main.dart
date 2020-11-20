import 'package:flutter/material.dart';

import 'day_view_example.dart';

void main() => runApp(new MyApp());

/// Screen for picking different examples of this library.
///
/// Examples:
/// * [DayView example](day_view_example.dart)
/// * [DaysPageView example](days_page_view_example.dart)
/// * [MonthPageView example](month_page_view_example.dart)
/// * [MonthView example](month_view_example.dart)
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "calendar_views example",
      home: DayViewExample(),
    );
  }
}
