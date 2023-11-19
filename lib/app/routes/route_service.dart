import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RouteServices {
  static Route<dynamic> gerateRoute(RouteSettings routeSettings){
    final agrs=routeSettings.arguments;
    switch (routeSettings.name) {
      case "value":
        return _errorRoute();
      default:
      return _errorRoute();
    }
  }
  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold();
    });
  }
}