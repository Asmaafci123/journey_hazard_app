import 'package:flutter/material.dart';

class NavigationService {
  final _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  pop() {
    return _navigationKey.currentState.pop();
  }

  Future<T> pushNamed<T>(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T> pushReplacementNamed<T>(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<T> pushNamedAndRemoveUntil<T>(String routeName) {
    return navigationKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  Future<T> push<T>(Route<T> route) {
    return _navigationKey.currentState.push<T>(route);
  }

  Future<dynamic> goToLoginPage() {
//    return navigationKey.currentState.pushNamedAndRemoveUntil(LoginPage.routeName, (Route<dynamic> route) => false);
  }

  Future<dynamic> goToErrorPage() {
    /// TODO
    return null;
  }

  Route onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    return MaterialPageRoute(builder: (context) {
      switch (settings.name) {
        // case DashboardPage.routeName:
        //   return DashboardPage(
        //       // args: args,
        //       );
        // break;

        // case LoginPage.routeName:
        //   return LoginPage(
        //     args: args,
        //   );
        // break;

        // case SessionDetailsPage.routeName:
        //   return SessionDetailsPage(args);
        //   break;

        // case UserDetailsPage.routeName:
        //   return UserDetailsPage(
        //     args: args,
        //   );
        //   break;

        default:
          return null;
      }
    });
  }
}

NavigationService gNavigationService = NavigationService();
