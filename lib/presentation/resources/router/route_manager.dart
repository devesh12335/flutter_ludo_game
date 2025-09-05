
import 'package:flutter/material.dart';
import 'package:ludo_game/ludo_game/game.dart';
import 'package:ludo_game/presentation/screens/login/view.dart';

class Routes {
  static const String loginPage = "/loginPage";
  static const String ludoPage = "/ludoPage";
 

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {

        case Routes.loginPage:
        return MaterialPageRoute(builder: (_) =>  LoginPage());

        case Routes.ludoPage:
        return MaterialPageRoute(builder: (_) =>  Game());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(
                body: SizedBox(
              child: Center(
                child: Text("Page Not Found"),
              ),
            )));
  }
}

