import 'package:flutter/material.dart';
import 'package:fake_store/app.dart';
import 'package:fake_store/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  runApp(MyApp());
}