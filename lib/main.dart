import 'package:flutter/material.dart';
import 'package:flutter_dev_test/shared/components/tokens/theme.dart';
import 'package:flutter_dev_test/shared/di/injectable_config.dart';
import 'package:flutter_dev_test/shared/navigation/router.dart';

void main() {
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dev Flutter Test',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: router,
    );
  }
}
