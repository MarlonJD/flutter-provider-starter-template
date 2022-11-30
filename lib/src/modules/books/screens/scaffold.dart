// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

/// The enum for scaffold tab.
enum ScaffoldTab {
  /// The books tab.
  books,

  /// The authors tab.
  authors,

  /// The settings tab.
  settings
}

/// The scaffold for the book store.
class BookstoreScaffold extends StatelessWidget {
  /// Creates a [BookstoreScaffold].
  const BookstoreScaffold({
    required this.selectedTab,
    required this.child,
    Key? key,
  }) : super(key: key);

  /// Which tab of the scaffold to display.
  final ScaffoldTab selectedTab;

  /// The scaffold body.
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedTab.index,
          onDestinationSelected: (int idx) {
            switch (ScaffoldTab.values[idx]) {
              case ScaffoldTab.books:
                context.go('/books');
                break;
              case ScaffoldTab.authors:
                context.go('/authors');
                break;
              case ScaffoldTab.settings:
                context.go('/settings');
                break;
            }
          },
          destinations: const [
            NavigationDestination(
              label: 'Books',
              icon: Icon(Icons.book),
            ),
            NavigationDestination(
              label: 'Authors',
              icon: Icon(Icons.person),
            ),
            NavigationDestination(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      );
}
