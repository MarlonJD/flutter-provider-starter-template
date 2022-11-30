// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:testprovider/src/common/models/auth_model.dart';
import 'package:testprovider/src/modules/books/screens/sign_in.dart';
import '../../modules/books/data.dart';
import '../../modules/books/data/book.dart';
import '../../modules/books/screens/author_details.dart';
import '../../modules/books/screens/authors.dart';
import '../../modules/books/screens/book_details.dart';
import '../../modules/books/screens/books.dart';
import '../../modules/books/screens/scaffold.dart';
import '../../modules/books/screens/settings.dart';
import '../models/theme_model.dart';
import 'transition.dart';

part 'pages.dart';

final AuthModel _auth = AuthModel();

String? _guard(BuildContext context, GoRouterState state) {
  final bool? signedIn = _auth.signedIn;
  final bool signingIn = state.subloc == '/login';

  // Go to /signin if the user is not signed in
  if ((signedIn == false || signedIn == null) && !signingIn) {
    return '/login';
  }
  // Go to /books if the user is signed in and tries to go to /signin.
  else if (signedIn == true && signingIn) {
    return '/books';
  }

  // no redirect
  return null;
}

class MainRouter extends StatelessWidget {
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
              theme: themeNotifier.isDark
                  ? ThemeService().darkTheme
                  : ThemeService().lightTheme);
        }),
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
          child: SignInScreen(),
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
              final String bookId = state.params['bookId']!;
              final Book? selectedBook = libraryInstance.allBooks
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
              final int authorId = int.parse(state.params['authorId']!);
              final Author? selectedAuthor = libraryInstance.allAuthors
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
