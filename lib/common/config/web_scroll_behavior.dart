import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Permite arrastar com mouse no PageView no Flutter Web
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}
