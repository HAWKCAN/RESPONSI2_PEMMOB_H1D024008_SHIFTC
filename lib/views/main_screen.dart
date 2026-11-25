import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city_location.dart';
import '../viewmodels/weather_viewmodel.dart';
import 'home_screen.dart';
import 'search_screen.dart';

// Halaman utama yang berisi dua layar: Cuaca dan Cari Lokasi
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  // Dipanggil saat user memilih kota di layar pencarian
  void _onCitySelected(CityLocation city) {
    context.read<WeatherViewModel>().loadWeather(city);
    setState(() => _index = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreen(),
          SearchScreen(onCitySelected: _onCitySelected),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: 'Cuaca',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Cari Lokasi',
          ),
        ],
      ),
    );
  }
}
