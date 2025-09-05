
import 'package:flutter/cupertino.dart';


class GlobalState {
  final Map<dynamic, dynamic> _data = <dynamic, dynamic>{};

  static GlobalState instance = GlobalState._();
  GlobalState._();

  final ValueNotifier<bool> isDarkMode = ValueNotifier(false);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
