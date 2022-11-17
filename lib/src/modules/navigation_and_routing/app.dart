import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprovider/src/services/auth_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:testprovider/src/services/theme_service.dart';

import '../../services/routing_service.dart';
import 'screens/navigator.dart';

class Bookstore extends StatefulWidget {
  const Bookstore({super.key});

  @override
  State<Bookstore> createState() => _BookstoreState();
}

class _BookstoreState extends State<Bookstore> {
  final _auth = AuthService();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final SimpleRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;

  @override
  void initState() {
    /// Configure the parser with all of the app's allowed path templates.
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/signin',
        '/authors',
        '/settings',
        '/books/new',
        '/books/all',
        '/books/popular',
        '/book/:bookId',
        '/author/:authorId',
      ],
      guard: _guard,
      initialRoute: '/books/popular',
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = SimpleRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => BookstoreNavigator(
        navigatorKey: _navigatorKey,
      ),
    );

    // Listen for when the user logs out and display the signin screen.
    _auth.addListener(_handleAuthStateChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => RouteStateScope(
        notifier: _routeState,
        child: AuthServiceScope(
          notifier: _auth,
          child: Consumer<ModelTheme>(
            builder: (context, ModelTheme themeNotifier, child) {
              return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerDelegate: _routerDelegate,
                  routeInformationParser: _routeParser,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  // Revert back to pre-Flutter-2.5 transition behavior:
                  // https://github.com/flutter/flutter/issues/82053
                  theme: themeNotifier.isDark
                      ? ThemeService().darkTheme
                      : ThemeService().lightTheme);
            },
          ),
        ),
      );

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = _auth.signedIn;

    final signInRoute = ParsedRoute('/signin', '/signin', {}, {});

    // Go to /signin if the user is not signed in
    if (signedIn == false && from != signInRoute) {
      return signInRoute;
    }
    // Go to /books if the user is signed in and tries to go to /signin.
    else if (signedIn == true && from == signInRoute) {
      return ParsedRoute('/books/popular', '/books/popular', {}, {});
    }
    return from;
  }

  void _handleAuthStateChanged() {
    if (_auth.signedIn == false) {
      _routeState.go('/signin');
    }
  }

  @override
  void dispose() {
    // _auth.removeListener(_handleAuthStateChanged);
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
