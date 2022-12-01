// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Project imports:
import 'package:testprovider/src/modules/books/data.dart';

/// The book list view.
class BookList extends StatelessWidget {
  /// Creates an [BookList].
  const BookList({
    required this.books,
    this.onTap,
    super.key,
  });

  /// The list of books to be displayed.
  final List<Book> books;

  /// Called when the user taps a book.
  final ValueChanged<Book>? onTap;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(
            books[index].title,
          ),
          subtitle: Text(
            books[index].author.name,
          ),
          onTap: onTap != null ? () => onTap!(books[index]) : null,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<ValueChanged<Book>?>.has('onTap', onTap))
      ..add(IterableProperty<Book>('books', books));
  }
}
