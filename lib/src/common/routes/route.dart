import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:testprovider/src/common/models/auth_model.dart';
import 'package:testprovider/src/common/models/theme_model.dart';
import 'package:testprovider/src/common/routes/transition.dart';
import 'package:testprovider/src/modules/books/data.dart';
import 'package:testprovider/src/modules/books/screens/author_details.dart';
import 'package:testprovider/src/modules/books/screens/authors.dart';
import 'package:testprovider/src/modules/books/screens/book_details.dart';
import 'package:testprovider/src/modules/books/screens/books.dart';
import 'package:testprovider/src/modules/books/screens/scaffold.dart';
import 'package:testprovider/src/modules/books/screens/settings.dart';
import 'package:testprovider/src/modules/books/screens/sign_in.dart';

part 'pages.dart';

final AuthModel _auth = AuthModel();

String? _guard(BuildContext context, GoRouterState state) {
  final signedIn = _auth.signedIn;
  final signingIn = state.subloc == '/login';

  // Go to /signin if the user is not signed in
  if ((signedIn == false || signedIn == null) && !signingIn) {
    return '/login';
  }
  // Go to /books if the user is signed in and tries to go to /signin.
  else if (signedIn ?? true && signingIn) {
    return '/books';
  }

  // no redirect
  return null;
}

/// Main Router
class MainRouter extends StatelessWidget {
  // ignore: public_member_api_docs
  MainRouter({super.key});

  final ValueKey<String> _scaffoldKey = const ValueKey<String>('App scaffold');

  @override
  Widget build(BuildContext context) => AuthModelScope(
        notifier: _auth,
        child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
            return MaterialApp.router(
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: themeNotifier.isDark
                  ? ThemePreference().darkTheme
                  : ThemePreference().lightTheme,
            );
          },
        ),
      );

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    redirect: _guard,
    refreshListenable: _auth,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: Pages.home,
        path: '/',
        redirect: (_, __) => '/books',
      ),
      GoRoute(
        name: Pages.login,
        path: '/login',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            FadeTransitionPage(
          key: state.pageKey,
          child: const SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/books',
        redirect: (_, __) => '/books/popular',
      ),
      GoRoute(
        path: '/book/:bookId',
        redirect: (BuildContext context, GoRouterState state) =>
            '/books/all/${state.params['bookId']}',
      ),
      GoRoute(
        path: '/books/:kind(new|all|popular)',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            FadeTransitionPage(
          key: _scaffoldKey,
          child: BookstoreScaffold(
            selectedTab: ScaffoldTab.books,
            child: BooksScreen(state.params['kind']!),
          ),
        ),
        routes: <GoRoute>[
          GoRoute(
            path: ':bookId',
            builder: (BuildContext context, GoRouterState state) {
              final bookId = state.params['bookId']!;
              final selectedBook = libraryInstance.allBooks
                  .firstWhereOrNull((Book b) => b.id.toString() == bookId);

              return BookDetailsScreen(book: selectedBook);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/author/:authorId',
        redirect: (BuildContext context, GoRouterState state) =>
            '/authors/${state.params['authorId']}',
      ),
      GoRoute(
        path: '/authors',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            FadeTransitionPage(
          key: _scaffoldKey,
          child: const BookstoreScaffold(
            selectedTab: ScaffoldTab.authors,
            child: AuthorsScreen(),
          ),
        ),
        routes: <GoRoute>[
          GoRoute(
            path: ':authorId',
            builder: (BuildContext context, GoRouterState state) {
              final authorId = int.parse(state.params['authorId']!);
              final selectedAuthor = libraryInstance.allAuthors
                  .firstWhereOrNull((Author a) => a.id == authorId);

              return AuthorDetailsScreen(author: selectedAuthor);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            FadeTransitionPage(
          key: _scaffoldKey,
          child: const BookstoreScaffold(
            selectedTab: ScaffoldTab.settings,
            child: SettingsScreen(),
          ),
        ),
      ),
    ],
  );
}
