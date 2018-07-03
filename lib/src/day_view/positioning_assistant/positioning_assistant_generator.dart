import 'package:flutter/material.dart';

import 'package:calendar_views/src/day_view/properties/all.dart';

import 'positioning_assistant.dart';

class PositioningAssistantGenerator extends InheritedWidget {
  const PositioningAssistantGenerator({
    @required Widget child,
  }) : super(child: child);

  PositioningAssistant generatePositioningAssistant(BuildContext context) {
    return new PositioningAssistant(
      days: _getDays(context),
      dimensions: _getDimensions(context),
      restrictions: _getRestrictions(context),
      sizeConstraints: _getSizeConstraints(context),
    );
  }

  Days _getDays(BuildContext context) => DaysProvider.of(context);

  Dimensions _getDimensions(BuildContext context) =>
      DimensionsProvider.of(context);

  Restrictions _getRestrictions(BuildContext context) =>
      RestrictionsProvider.of(context);

  SizeConstraints _getSizeConstraints(BuildContext context) =>
      SizeConstraintsProvider.of(context);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static PositioningAssistantGenerator of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(PositioningAssistantGenerator);
  }
}
