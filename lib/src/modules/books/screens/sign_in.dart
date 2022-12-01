// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:testprovider/src/common/models/auth_model.dart';

/// The sign-in screen.
class SignInScreen extends StatefulWidget {
  /// Creates a sign-in screen.
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Sign in',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Username'),
                    controller: _usernameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () async {
                        await AuthModelScope.of(context).signIn(
                          _usernameController.text,
                          _passwordController.text,
                        );
                      },
                      child: const Text('Sign in'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
