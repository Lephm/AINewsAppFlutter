import 'package:centranews/pages/home_page.dart';
import 'package:centranews/pages/sign_in.dart';
import 'package:flutter/material.dart';

var customNavigator = CustomNavigator();

class CustomNavigator {
  CustomNavigator();

  Map<String, Widget Function(BuildContext context)> allRoutes = {
    "/": (context) => SignIn(),
    "/home": (context) => HomePage(),
    "sign_in": (context) => SignIn(),
  };

  String initialRoute = '/';
}
