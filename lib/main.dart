// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:testprovider/src/modules/navigation_and_routing/app.dart';
import 'package:testprovider/src/services/theme_service.dart';
import 'package:testprovider/src/modules/user/notifiers/counter_notifier.dart';
import 'package:testprovider/src/modules/user/screens/count.dart';

/// This is a reimplementation of the default Flutter application using provider + [ChangeNotifier].
void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(
          create: (_) => ModelTheme(),
        ),
      ],
      // child: const MyApp(),
      child: EasyLocalization(
          supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR')],
          path: 'assets/translations',
          fallbackLocale: Locale('tr', 'TR'),
          child: Bookstore()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return MaterialApp(
          home: const MyHomePage(),
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.isDark
              ? ThemeService().darkTheme
              : ThemeService().lightTheme);
    });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
        actions: [
          Consumer<ModelTheme>(
            builder: (context, ModelTheme themeNotifier, child) {
              return IconButton(
                  icon: Icon(themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny),
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('You have pushed the button this many times:'),

            /// Extracted as a separate widget for performance optimization.
            /// As a separate widget, it will rebuild independently from [MyHomePage].
            ///
            /// This is totally optional (and rarely needed).
            /// Similarly, we could also use [Consumer] or [Selector].
            Count(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('increment_floatingActionButton'),

        /// Calls `context.read` instead of `context.watch` so that it does not rebuild
        /// when [Counter] changes.
        onPressed: () => context.read<Counter>().increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
