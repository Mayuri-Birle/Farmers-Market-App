import 'package:farmers_market/src/screens/edit_product.dart';
import 'package:farmers_market/src/screens/landing.dart';
import 'package:farmers_market/src/screens/login.dart';
import 'package:farmers_market/src/screens/signup.dart';
import 'package:farmers_market/src/screens/vendor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/landing":
        return MaterialPageRoute(builder: (context) => Landing());
      case "/signup":
        return MaterialPageRoute(builder: (context) => SignUp());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/vendor":
        return MaterialPageRoute(builder: (context) => Vendor());
      case "/edit_product":
        return MaterialPageRoute(builder: (context) => EditProduct());
      default:
        var routeArray = settings.name.split('/');
        if (settings.name.contains('/edit_product/')) {
          return MaterialPageRoute(
              builder: (context) => EditProduct(
                    productId: routeArray[2],
                  ));
        }
        return MaterialPageRoute(builder: (context) => Login());
    }
  }

  static CupertinoPageRoute cupertinoRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/landing":
        return CupertinoPageRoute(builder: (context) => Landing());
      case "/signup":
        return CupertinoPageRoute(builder: (context) => SignUp());
      case "/login":
        return CupertinoPageRoute(builder: (context) => Login());
      case "/vendor":
        return CupertinoPageRoute(builder: (context) => Vendor());
      case "/edit_product":
        return CupertinoPageRoute(builder: (context) => EditProduct());
      default:
        var routeArray = settings.name.split('/');
        if (settings.name.contains('/edit_product/')) {
          return CupertinoPageRoute(
              builder: (context) => EditProduct(
                    productId: routeArray[2],
                  ));
        }
        return CupertinoPageRoute(builder: (context) => Login());
        break;
    }
  }
}
