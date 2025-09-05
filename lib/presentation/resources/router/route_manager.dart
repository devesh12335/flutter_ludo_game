
import 'package:flutter/material.dart';
import 'package:ludo_game/presentation/screens/login/view.dart';

class Routes {
  static const String loginPage = "/loginPage";
 

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {

        case Routes.loginPage:
        return MaterialPageRoute(builder: (_) =>  LoginPage());

        

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

