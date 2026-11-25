class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      precipitation: (json['precipitation'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final int rainChance;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.rainChance,
    required this.weatherCode,
  });
}

class WeatherData {
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherData({required this.current, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>;
    final dailyJson = json['daily'] as Map<String, dynamic>;

    final dates = dailyJson['time'] as List<dynamic>;
    final maxTemps = dailyJson['temperature_2m_max'] as List<dynamic>;
    final minTemps = dailyJson['temperature_2m_min'] as List<dynamic>;
    final rains = dailyJson['precipitation_probability_max'] as List<dynamic>;
    final codes = dailyJson['weather_code'] as List<dynamic>;

    final List<DailyForecast> daily = [];
    for (int i = 0; i < dates.length; i++) {
      daily.add(
        DailyForecast(
          date: dates[i] as String,
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          rainChance: ((rains[i] as num?) ?? 0).toInt(),
          weatherCode: (codes[i] as num).toInt(),
        ),
      );
    }

    return WeatherData(
      current: CurrentWeather.fromJson(currentJson),
      daily: daily,
    );
  }
}
