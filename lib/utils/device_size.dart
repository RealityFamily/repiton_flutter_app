import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DeviceSize {
  static bool isTinyScreen(BuildContext context) => MediaQuery.of(context).size.width < 1300;

  static bool get isWeb => kIsWeb;
}
