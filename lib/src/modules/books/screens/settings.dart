// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Flutter imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:testprovider/src/common/models/auth_model.dart';
import 'package:testprovider/src/common/models/theme_model.dart';
import 'package:url_launcher/link.dart';

/// The settings screen.
class SettingsScreen extends StatefulWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    child: SettingsContent(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

/// The content of a [SettingsScreen].
class SettingsContent extends StatelessWidget {
  /// Creates a [SettingsContent].
  const SettingsContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          ...<Widget>[
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                AuthModelScope.of(context).signOut();
              },
              child: const Text('Sign out'),
            ),
            Link(
              uri: Uri.parse('/book/0'),
              builder: (BuildContext context, FollowLink? followLink) =>
                  TextButton(
                onPressed: followLink,
                child: const Text('Go directly to /book/0 (Link)'),
              ),
            ),
            TextButton(
              onPressed: () {
                context.go('/book/0');
              },
              child: const Text('Go directly to /book/0 (GoRouter)'),
            ),
          ].map<Widget>((Widget w) =>
              Padding(padding: const EdgeInsets.all(8), child: w)),
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Alert!'),
                content: const Text('The alert description goes here.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            child: const Text('Show Dialog'),
          ),
          ElevatedButton(
            onPressed: () {
              if (context.locale.toString() == 'en_US') {
                context.setLocale(const Locale('tr', 'TR'));
                print("TR");
              } else {
                context.setLocale(const Locale('en', 'US'));
                print("EN");
                print(context.locale.toString());
              }
            },
            child: Text('Change Language'),
          ),
          Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
              return ElevatedButton(
                  child: Row(
                    children: [
                      Icon(themeNotifier.isDark
                          ? Icons.nightlight_round
                          : Icons.wb_sunny),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Change Theme').tr(),
                    ],
                  ),
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  });
            },
          ),
          Text("Hello").tr(),
        ],
      );
}
