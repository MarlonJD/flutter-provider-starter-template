// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprovider/src/services/theme_service.dart';
import 'package:url_launcher/link.dart';

import '../data.dart';
import 'author_details.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book? book;

  const BookDetailsScreen({
    super.key,
    this.book,
  });

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      return const Scaffold(
        body: Center(
          child: Text('No book found.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(book!.title),
      ),
      body: Center(
        child: Column(
          children: [
            // Consumer<TranslationService>(builder: (context, translationNotifier, child) {
            //   return ElevatedButton(onPressed: () {
            //     if (context.locale.toString() == 'en') {
            //       translationNotifier.setLang('tr');
            //     } else {
            //       translationNotifier.setLang('en');
            //     }

            //   }, child: Text('Change Language')
            // },
            // ),
            ElevatedButton(
              onPressed: () {
                if (context.locale.toString() == 'en_US') {
                  context.setLocale(Locale('tr', 'TR'));
                  print("TR");
                } else {
                  context.setLocale(Locale('en', 'US'));
                  print("EN");
                  print(context.locale.toString());
                }
              },
              child: Text('Change Language'),
            ),
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
            Text("Hello").tr(),
            Text(
              book!.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              book!.author.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              child: const Text('View author (Push)'),
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) =>
                        AuthorDetailsScreen(author: book!.author),
                  ),
                );
              },
            ),
            Link(
              uri: Uri.parse('/author/${book!.author.id}'),
              builder: (context, followLink) => TextButton(
                onPressed: followLink,
                child: const Text('View author (Link)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
