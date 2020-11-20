import 'package:calendar_views/day_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class Event {
  Event({
    this.startMinuteOfDay,
    this.duration,
    this.boCompleted = false,
    @required this.title,
  });

  final int startMinuteOfDay;
  final int duration;
  bool boCompleted;
  final String title;
}

List<Event> eventsOfDay0 = <Event>[
  new Event(
      startMinuteOfDay: 0,
      duration: 60,
      title: "Midnight Party",
      boCompleted: true),
  new Event(
      startMinuteOfDay: 6 * 60, duration: 2 * 60, title: "Morning Routine"),
  new Event(startMinuteOfDay: 8 * 60, duration: 60, title: "Get Dressed"),
  new Event(startMinuteOfDay: 9 * 60, duration: 60, title: "Get Dressed"),
  new Event(startMinuteOfDay: 10 * 60, duration: 60, title: "Get Dressed"),
  new Event(startMinuteOfDay: 11 * 60, duration: 60, title: "Get Dressed"),
  new Event(startMinuteOfDay: 12 * 60, duration: 60, title: "Get Dressed"),
  new Event(
      startMinuteOfDay: 18 * 60, duration: 60, title: "Take Dog For A Walk"),
];

List<Event> eventsOfDay1 = <Event>[
  new Event(startMinuteOfDay: 1 * 60, duration: 90, title: "Sleep Walking"),
  new Event(startMinuteOfDay: 7 * 60, duration: 60, title: "Drive To Work"),
  new Event(startMinuteOfDay: 8 * 60, duration: 20, title: "A"),
  new Event(startMinuteOfDay: 8 * 60, duration: 30, title: "B"),
  new Event(startMinuteOfDay: 8 * 60, duration: 60, title: "C"),
  new Event(startMinuteOfDay: 8 * 60 + 10, duration: 20, title: "D"),
  new Event(startMinuteOfDay: 8 * 60 + 30, duration: 30, title: "E"),
  new Event(startMinuteOfDay: 23 * 60, duration: 60, title: "Midnight Snack"),
];

class DayViewExample extends StatefulWidget {
  @override
  State createState() => new _DayViewExampleState();
}

class _DayViewExampleState extends State<DayViewExample> {
  DateTime _day0;
  DateTime _day1;
  DateTime startTime;
  List<String> userIds;
  ScrollController _mycontroller1 =
      new ScrollController(); // make seperate controllers
  ScrollController _mycontroller2 =
      new ScrollController(); // for each scrollables
  ScrollController _mycontroller3 =
      new ScrollController(); // for each scrollables
  SyncScrollController _syncScroller;

  List<DateTime> get dayList => userIds.map((e) => DateTime.now()).toList();

  @override
  void initState() {
    super.initState();
    _syncScroller = new SyncScrollController([_mycontroller1, _mycontroller2]);

    _day0 = new DateTime.now();
    _day1 = _day0.toUtc().add(new Duration(days: 1)).toLocal();
    userIds = [
      'Ronaldo',
      'Nazario',
      'De',
      'Lima',
      'Ronaldo',
      'Nazario',
      'De',
      'Lima',
      'Ronaldo',
      'Nazario',
      'Nazario',
      'De',
      'Lima',
      'Ronaldo',
      'Nazario',
      'Nazario',
      'De',
      'Lima',
      'Ronaldo',
      'Nazario',
      'Nazario',
      'De',
      'Lima',
      'Ronaldo',
      'Nazario',
      'Nazario',
      'De',
      'Lima',
      'Ronaldo',
      'Nazario',
      'Nazario',
      'De',
      'Lima',
      'Ronaldo',
      'Nazario',
    ];
    startTime = DateTime.now();
  }

  void dispose() {
    _mycontroller1.dispose();
    _mycontroller2.dispose();
    _mycontroller3.dispose();
    super.dispose();
  }

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }

  Iterable<StartDurationItem> _getEventsOfDay(DateTime day, String userId) {
    List<Event> events;
    if (day.year == _day0.year &&
        day.month == _day0.month &&
        day.day == _day0.day) {
      events = eventsOfDay0;
    } else {
      events = eventsOfDay1;
    }

    return events.map(
      (event) => new StartDurationItem(
        startMinuteOfDay: event.startMinuteOfDay,
        duration: event.duration,
        builder: (context, itemPosition, itemSize) => _eventBuilder(
          context,
          itemPosition,
          itemSize,
          event,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("DayView Example"),
      ),
      body: new DayViewEssentials(
        properties: new DayViewProperties(days: dayList, userIds: userIds),
        child: Row(
          children: <Widget>[
            NotificationListener<ScrollNotification>(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                width: 60.0,
                child: ListView(
                  controller: _mycontroller2,
                  children: [
                    new DayViewSchedule(
                      topExtensionHeight: 25,
                      heightPerMinute: 1.5,
                      components: <ScheduleComponent>[
                        new TimeIndicationComponent.intervalGenerated(
                          generatedTimeIndicatorBuilder:
                              _generatedTimeIndicatorBuilder,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onNotification: (ScrollNotification scrollInfo) {
                _syncScroller.processNotification(scrollInfo, _mycontroller2);
                return true;
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 60.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _mycontroller3,
                children: [
                  Column(
                    children: <Widget>[
                      //Flex(direction: Axis.vertical, children: <Widget>[
                      Container(
                        color: Colors.grey[200],
                        child: new DayViewDaysHeader(
                          headerItemBuilder: _headerItemBuilder,
                        ),
                      ),
                      NotificationListener<ScrollNotification>(
                        child: Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            controller: _mycontroller1,
                            child: DayViewSchedule(
                              heightPerMinute: 1.5,
                              bottomExtensionHeight: 0,
                              topExtensionHeight: 0,
                              components: <ScheduleComponent>[
                                SupportLineComponent.intervalGenerated(
                                  generatedSupportLineBuilder:
                                      _generatedSupportLineBuilder,
                                ),
                                DaySeparationComponent(
                                  generatedDaySeparatorBuilder:
                                      _generatedDaySeparatorBuilder,
                                ),
                                new EventViewComponent(
                                  getEventsOfDay: _getEventsOfDay,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onNotification: (ScrollNotification scrollInfo) {
                          _syncScroller.processNotification(
                            scrollInfo,
                            _mycontroller1,
                          );

                          return true;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day, String userId) {
    return new Container(
      color: Colors.grey[300],
      padding: new EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Text(
          userId,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }

  Positioned _generatedTimeIndicatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: 0,
      width: itemSize.width + 60.0,
      height: itemSize.height,
      child: new Container(
        child: new Center(
          child: new Text(
            _minuteOfDayToHourMinuteString(minuteOfDay),
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemWidth * userIds.length,
      child: new Container(
        height: 1.5,
        color: (minuteOfDay % 60 == 0) ? Colors.grey[600] : Colors.grey[300],
      ),
    );
  }

  Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Center(
        child: new Container(
          width: 0.7,
          color: Colors.black,
        ),
      ),
    );
  }

  Positioned _eventBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    Event event,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(child: Text(event.title)),
      ),
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }
Future<ConfirmAction> _asyncConfirmDialog(
    BuildContext context, String title) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$title'),
        content: Text('$title selected.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

class SyncScrollController {
  List<ScrollController> _registeredScrollControllers =
      new List<ScrollController>();

  ScrollController _scrollingController;
  bool _scrollingActive = false;

  SyncScrollController(List<ScrollController> controllers) {
    controllers.forEach((controller) => registerScrollController(controller));
  }

  void registerScrollController(ScrollController controller) {
    _registeredScrollControllers.add(controller);
  }

  void processNotification(
      ScrollNotification notification, ScrollController sender) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = sender;
      _scrollingActive = true;
      return;
    }

    if (identical(sender, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return;
      }

      if (notification is ScrollUpdateNotification) {
        _registeredScrollControllers.forEach(
          (controller) => {
            if (!identical(_scrollingController, controller))
              controller..jumpTo(_scrollingController.offset)
          },
        );
        return;
      }
    }
  }
}
