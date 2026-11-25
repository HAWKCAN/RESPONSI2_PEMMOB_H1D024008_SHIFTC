import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city_location.dart';
import '../theme/app_colors.dart';
import '../viewmodels/location_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.onCitySelected});

  // Dipakai saat layar ini berada di dalam tab. Jika null, layar ditutup dengan pop.
  final ValueChanged<CityLocation>? onCitySelected;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocationViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Lokasi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) =>
                  context.read<LocationViewModel>().search(value),
              decoration: InputDecoration(
                hintText: 'Nama kota, misal: Bandung',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () =>
                      context.read<LocationViewModel>().search(_controller.text),
                ),
              ),
            ),
          ),
          Expanded(child: _buildContent(vm)),
        ],
      ),
    );
  }

  Widget _buildContent(LocationViewModel vm) {
    // Kondisi loading
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Kondisi error
    if (vm.error != null) {
      return _centerText(vm.error!);
    }

    // Belum mencari: tampilkan daftar favorit
    if (!vm.hasSearched) {
      if (vm.favorites.isEmpty) {
        return _centerText(
          'Belum ada favorit. Cari kota lalu tekan ikon bintang untuk menyimpannya.',
        );
      }
      return _buildList(title: 'Favorit', cities: vm.favorites, vm: vm);
    }

    // Sudah mencari tapi hasilnya kosong
    if (vm.results.isEmpty) {
      return _centerText('Kota tidak ditemukan. Coba nama lain.');
    }

    // Menampilkan hasil pencarian
    return _buildList(title: 'Hasil Pencarian', cities: vm.results, vm: vm);
  }

  Widget _buildList({
    required String title,
    required List<CityLocation> cities,
    required LocationViewModel vm,
  }) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        for (final city in cities)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(
                city.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              subtitle: Text(
                [city.admin, city.country]
                    .where((e) => e.isNotEmpty)
                    .join(', '),
                style: const TextStyle(color: AppColors.primary),
              ),
              trailing: IconButton(
                icon: Icon(
                  vm.isFavorite(city) ? Icons.star : Icons.star_border,
                  color: AppColors.secondary,
                ),
                onPressed: () =>
                    context.read<LocationViewModel>().toggleFavorite(city),
              ),
              // Memilih lokasi dan kembali ke halaman utama
              onTap: () {
                if (widget.onCitySelected != null) {
                  widget.onCitySelected!(city);
                } else {
                  Navigator.pop(context, city);
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _centerText(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.primary),
        ),
      ),
    );
  }
}
