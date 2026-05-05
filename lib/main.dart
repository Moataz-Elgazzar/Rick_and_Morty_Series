import 'package:flutter/material.dart';
import 'package:rick_and_morty_series/core/routes/routs.dart';
import 'package:rick_and_morty_series/core/service/dio_provider.dart';

void main() {
  DioProvider.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: Routs.route, debugShowCheckedModeBanner: false);
  }
}
