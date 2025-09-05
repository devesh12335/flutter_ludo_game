import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ludo_game/global_state/globalState.dart';
import '../../global_state/app_global.dart';

enum ToastType { success, error, normal }

class ToastHelper {
  static void showToast(
    String message, {
    ToastType type = ToastType.normal,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int duration = 3,
  }) {
    Color bgColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        bgColor = Colors.green.shade600;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        bgColor = Colors.red.shade600;
        icon = Icons.error;
        break;
      case ToastType.normal:
      default:
        bgColor = Colors.grey.shade800;
        icon = Icons.info;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      toastLength: duration == 1
          ? Toast.LENGTH_SHORT
          : Toast.LENGTH_LONG, // auto map duration
      backgroundColor: Colors.transparent, // we’ll make it fancy
      textColor: Colors.white,
      fontSize: 16,
      webPosition: "center",
      webBgColor: "transparent",
    );

    // For custom widget style, we can override the default with FToast
    _showCustomToast(message, bgColor, icon, gravity, duration);
  }

  static void _showCustomToast(
    String message,
    Color bgColor,
    IconData icon,
    ToastGravity gravity,
    int duration,
  ) {
    FToast fToast = FToast();
    fToast.init(GlobalState.instance.navigatorKey.currentContext!); // Use your global context

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: Duration(seconds: duration),
    );
  }
}
