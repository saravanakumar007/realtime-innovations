import 'package:employee_list/app.dart';
import 'package:employee_list/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService().init();
  runApp(const App());
}
