// Generated by Celest. This file should not be modified manually, but
// it can be checked into version control.
// ignore_for_file: type=lint, unused_local_variable, unnecessary_cast, unnecessary_import

library;

import 'package:celest/celest.dart';

@Deprecated('Use `env` instead.')
typedef Env = env;

abstract final class env {
  static const unsplashAccessKey =
      EnvironmentVariable(name: r'UNSPLASH_ACCESS_KEY');

  static const w = EnvironmentVariable(name: r'w');
}
