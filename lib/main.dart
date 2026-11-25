import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/main_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationViewModel()..loadFavorites(),
        ),
      ],
      child: MaterialApp(
        title: 'Cuaca',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        home: const MainScreen(),
      ),
    );
  }
}
