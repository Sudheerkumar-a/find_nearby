import 'package:flutter/material.dart';

import '../errors/app_exception.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get texts => theme.textTheme;
  MediaQueryData get media => MediaQuery.of(this);

  void showSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> runAction(Future<void> Function() action) async {
    try {
      await action();
    } on AppException catch (error) {
      if (mounted) showSnack(error.userMessage);
    } catch (_) {
      if (mounted) showSnack('Something went wrong. Please try again.');
    }
  }
}
