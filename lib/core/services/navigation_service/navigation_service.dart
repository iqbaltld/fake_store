import 'package:flutter/material.dart';

class NavigationService extends RouteObserver<PageRoute> {
  final GlobalKey<NavigatorState> navigatorKey;
  String? _currentRouteName;
  
  NavigationService({required this.navigatorKey});

  String? get currentRoute => _currentRouteName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateCurrentRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _updateCurrentRoute(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _updateCurrentRoute(previousRoute);
    }
  }

  void _updateCurrentRoute(Route<dynamic> route) {
    if (route is PageRoute) {
      _currentRouteName = route.settings.name;
    }
  }

  Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    _currentRouteName = routeName;
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? navigateAndClearStack(String routeName, {Object? arguments}) {
    _currentRouteName = routeName;
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  Future<dynamic>? navigateToAndRemoveUntil(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil((route) {
      return route.settings.name == routeName || route.isFirst;
    });
  }

  void goBack({dynamic result}) {
    return navigatorKey.currentState?.pop(result);
  }

  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  void pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState?.pop<T>(result);
  }

  Future<dynamic>? replaceWith(String routeName, {Object? arguments}) {
    _currentRouteName = routeName;
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }
}