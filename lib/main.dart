import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const App());
}
