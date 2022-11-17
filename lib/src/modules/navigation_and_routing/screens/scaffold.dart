// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:testprovider/src/services/routing_service.dart';

import 'scaffold_body.dart';

class BookstoreScaffold extends StatelessWidget {
  const BookstoreScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);

    return Scaffold(
      body: const BookstoreScaffoldBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (idx) {
          if (idx == 0) routeState.go('/books/popular');
          if (idx == 1) routeState.go('/authors');
          if (idx == 2) routeState.go('/settings');
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

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate.startsWith('/books')) return 0;
    if (pathTemplate == '/authors') return 1;
    if (pathTemplate == '/settings') return 2;
    return 0;
  }
}
