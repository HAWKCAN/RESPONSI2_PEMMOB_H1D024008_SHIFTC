import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city_location.dart';
import '../models/weather_model.dart';
import '../theme/app_colors.dart';
import '../utils/weather_code.dart';
import '../viewmodels/weather_viewmodel.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _openSearch(context),
          ),
        ],
      ),
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    // Kondisi loading
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Kondisi error
    if (vm.error != null) {
      return _MessageView(
        icon: Icons.error_outline,
        message: vm.error!,
        buttonText: 'Coba Lagi',
        onPressed: () {
          if (vm.city != null) {
            vm.loadWeather(vm.city!);
          }
        },
      );
    }

    final weather = vm.weather;

    // Kondisi data kosong
    if (weather == null || weather.daily.isEmpty) {
      return _MessageView(
        icon: Icons.cloud_off,
        message: 'Belum ada data cuaca. Cari kota untuk melihat cuacanya.',
        buttonText: 'Cari Kota',
        onPressed: () => _openSearch(context),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMainCard(vm.city!.displayName, weather.current),
          const SizedBox(height: 16),
          _buildDetailCard(weather),
          const SizedBox(height: 16),
          _buildForecastCard(weather.daily),
        ],
      ),
    );
  }

  // Membuka halaman pencarian, lalu memuat cuaca kota yang dipilih
  Future<void> _openSearch(BuildContext context) async {
    final picked = await Navigator.push<CityLocation>(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
    if (picked != null && context.mounted) {
      context.read<WeatherViewModel>().loadWeather(picked);
    }
  }

  // Kartu utama: nama kota, ikon, suhu, dan kondisi
  Widget _buildMainCard(String cityName, CurrentWeather current) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            cityName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            WeatherCode.icon(current.weatherCode),
            size: 72,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            '${current.temperature.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            WeatherCode.label(current.weatherCode),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Kartu informasi tambahan
  Widget _buildDetailCard(WeatherData weather) {
    final current = weather.current;
    final todayRain = weather.daily.first.rainChance;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.4,
          children: [
            _InfoTile(
              icon: Icons.water_drop_outlined,
              label: 'Kelembapan',
              value: '${current.humidity}%',
            ),
            _InfoTile(
              icon: Icons.air,
              label: 'Angin',
              value: '${current.windSpeed.round()} km/j',
            ),
            _InfoTile(
              icon: Icons.thermostat,
              label: 'Terasa seperti',
              value: '${current.apparentTemperature.round()}°',
            ),
            _InfoTile(
              icon: Icons.grain,
              label: 'Curah hujan',
              value: '${current.precipitation.toStringAsFixed(1)} mm',
            ),
            _InfoTile(
              icon: Icons.umbrella_outlined,
              label: 'Peluang hujan',
              value: '$todayRain%',
            ),
          ],
        ),
      ),
    );
  }

  // Perkiraan cuaca beberapa hari ke depan
  Widget _buildForecastCard(List<DailyForecast> daily) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Perkiraan 7 Hari',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            for (int i = 0; i < daily.length; i++) ...[
              _ForecastRow(
                dayName: i == 0 ? 'Hari ini' : _dayName(daily[i].date),
                icon: WeatherCode.icon(daily[i].weatherCode),
                rainChance: daily[i].rainChance,
                minTemp: daily[i].minTemp,
                maxTemp: daily[i].maxTemp,
              ),
              if (i < daily.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }

  String _dayName(String isoDate) {
    const names = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
    ];
    final date = DateTime.parse(isoDate);
    return names[date.weekday - 1];
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.secondary),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final String dayName;
  final IconData icon;
  final int rainChance;
  final double minTemp;
  final double maxTemp;

  const _ForecastRow({
    required this.dayName,
    required this.icon,
    required this.rainChance,
    required this.minTemp,
    required this.maxTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              dayName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Icon(icon, color: AppColors.secondary, size: 22),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(
              '$rainChance%',
              style: const TextStyle(fontSize: 12, color: AppColors.secondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${minTemp.round()}° / ${maxTemp.round()}°',
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const _MessageView({
    required this.icon,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.secondary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
