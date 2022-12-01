// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprovider/src/modules/user/notifiers/counter_notifier.dart';

class Count extends StatelessWidget {
  const Count({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
      '${context.watch<Counter>().count}',
      key: const Key('counterState'),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
