# Responsi 2 Praktikum Mobile: Aplikasi Cuaca Flutter

| | |
|---|---|
| **Nama** | Fariz Rahman Syahida |
| **NIM** | H1D024008 |
| **Shift Awal** | F |
| **Shift Akhir** | C |
| **Mata Kuliah** | Praktikum Pemrograman Mobile |
| **Tugas** | Responsi 2: Aplikasi Cuaca dengan Flutter dan Open-Meteo API |

## Perkenalan

Aplikasi ini saya buat untuk memenuhi Responsi 2 Praktikum Mobile. Aplikasi menampilkan informasi cuaca untuk kota yang dipilih pengguna. Data cuaca diambil langsung dari **Open-Meteo API**, sehingga tidak ada data yang ditulis manual atau hardcoded.

Pengguna bisa mencari kota berdasarkan nama, melihat cuaca saat ini, melihat perkiraan 7 hari ke depan, dan menyimpan kota favorit. Kota favorit dan kota terakhir yang dibuka tetap tersimpan meskipun aplikasi ditutup.

## Fitur

- Pencarian kota berdasarkan nama (Geocoding API, HTTP GET).
- Cuaca saat ini: suhu, kondisi, suhu terasa seperti, kelembapan, kecepatan angin, curah hujan, dan peluang hujan.
- Perkiraan cuaca 7 hari ke depan: suhu minimum dan maksimum, peluang hujan, dan kondisi.
- Favorit kota yang disimpan dengan SharedPreferences.
- Data terakhir tampil kembali saat aplikasi dibuka.
- Penanganan loading, data kosong, dan error, termasuk tombol coba lagi.
- Navigasi bawah dengan dua layar: Cuaca dan Cari Lokasi.

## Teknologi

| Komponen | Keterangan |
|---|---|
| Bahasa | Dart |
| Framework | Flutter (Material 3) |
| State management | Provider (`ChangeNotifier`) |
| Networking | `http` (HTTP GET) |
| Penyimpanan lokal | `shared_preferences` |
| API | Open-Meteo Forecast API dan Geocoding API |
| Arsitektur | MVVM (Model-View-ViewModel) |

## Struktur Aplikasi

```
lib/
├── main.dart                      # Entry point, setup Provider dan halaman awal
├── models/                        # Model data (JSON menjadi objek Dart)
│   ├── city_location.dart         # Data kota dan lokasi
│   └── weather_model.dart         # Data cuaca saat ini dan harian
├── services/                      # Komunikasi dengan API dan penyimpanan lokal
│   ├── api_service.dart           # HTTP GET ke Open-Meteo
│   └── storage_service.dart       # Simpan dan baca favorit serta kota terakhir
├── viewmodels/                    # Logika dan state aplikasi
│   ├── weather_viewmodel.dart     # State halaman cuaca
│   └── location_viewmodel.dart    # State halaman pencarian dan favorit
├── views/                         # Tampilan (UI)
│   ├── main_screen.dart           # Navigasi bawah (dua tab)
│   ├── home_screen.dart           # Layar Cuaca
│   └── search_screen.dart         # Layar Cari Lokasi
├── theme/                         # Warna dan tema
│   ├── app_colors.dart            # Tiga warna utama aplikasi
│   └── app_theme.dart             # Konfigurasi ThemeData
└── utils/
    └── weather_code.dart          # Kode cuaca menjadi teks dan ikon
```

## Implementasi API

Aplikasi memakai dua endpoint Open-Meteo, keduanya dengan HTTP GET.

**1. Geocoding API** untuk mencari kota.

`https://geocoding-api.open-meteo.com/v1/search`

| Parameter | Nilai | Keterangan |
|---|---|---|
| `name` | nama kota dari input pengguna | Kata kunci pencarian |
| `count` | `10` | Maksimal 10 hasil |
| `language` | `id` | Nama kota dalam bahasa Indonesia |
| `format` | `json` | Format respons |

**2. Forecast API** untuk data cuaca.

`https://api.open-meteo.com/v1/forecast`

| Parameter | Nilai | Keterangan |
|---|---|---|
| `latitude` | dari kota yang dipilih | Koordinat lintang |
| `longitude` | dari kota yang dipilih | Koordinat bujur |
| `current` | `temperature_2m`, `relative_humidity_2m`, `apparent_temperature`, `precipitation`, `weather_code`, `wind_speed_10m` | Data cuaca saat ini |
| `daily` | `weather_code`, `temperature_2m_max`, `temperature_2m_min`, `precipitation_probability_max` | Perkiraan harian |
| `timezone` | `auto` | Zona waktu mengikuti lokasi |

Respons JSON diubah menjadi model Dart di `models/weather_model.dart` dan `models/city_location.dart`. Jika kota tidak ditemukan, Geocoding API tidak mengirim field `results`, dan aplikasi menampilkan pesan "Kota tidak ditemukan".

## Penerapan MVVM

- **Model** (`models/`): representasi data. Model membaca JSON dengan `fromJson()` dan mengubahnya kembali dengan `toJson()`.
- **View** (`views/`): hanya menampilkan data dan meneruskan aksi pengguna ke ViewModel. View tidak memanggil API secara langsung.
- **ViewModel** (`viewmodels/`): menyimpan state (loading, error, data) dan memanggil Service. Setiap perubahan diberitahukan ke View lewat `notifyListeners()`.
- **Service** (`services/`): berisi kode komunikasi dengan API dan penyimpanan lokal.

Contoh alur saat pengguna mencari kota: View memanggil `LocationViewModel.search()`, ViewModel memanggil `ApiService.searchCity()`, hasil JSON diubah menjadi `CityLocation`, lalu ViewModel memanggil `notifyListeners()` dan View menampilkan hasilnya.

## Screenshot dan Penjelasan Layar

### 1. Layar Cuaca (Home)

![Layar Cuaca](screenshots/home.png)

Layar ini menampilkan nama kota yang dipilih, ikon dan suhu saat ini, serta kondisi cuaca. Di bawahnya ada kartu informasi tambahan (kelembapan, angin, suhu terasa seperti, curah hujan, dan peluang hujan), lalu perkiraan 7 hari ke depan. Saat data dimuat, layar menampilkan indikator loading. Jika gagal, layar menampilkan pesan error dengan tombol coba lagi.

### 2. Layar Cari Lokasi (Search)

![Layar Cari Lokasi](screenshots/search.png)

Layar ini berisi kolom pencarian kota, daftar hasil, dan tombol bintang untuk menyimpan kota sebagai favorit. Jika belum pernah mencari, layar menampilkan daftar Favorit. Memilih kota akan membuka cuacanya di layar Cuaca.

## Cara Menjalankan

Persyaratan: Flutter 3.27 atau lebih baru.

```bash
flutter pub get
flutter run
```

## Video Penjelasan

Link video: [Isi link video]

## Dependensi

```yaml
dependencies:
  http: ^1.2.0
  provider: ^6.1.2
  shared_preferences: ^2.2.3
```# RESPONSI2_PEMMOB_H1D024008_SHIFTC
