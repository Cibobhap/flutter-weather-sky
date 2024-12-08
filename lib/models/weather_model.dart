class Weather {
  final String location;
  final double temperature;
  final String condition;
  final String icon;
  final double lat;
  final double lon;
  final int sunrise;
  final int sunset;
  final List<DailyWeather> weeklyForecast;

  Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.lat,
    required this.lon,
    required this.sunrise,
    required this.sunset,
    required this.weeklyForecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<DailyWeather> parseWeeklyForecast(List<dynamic> jsonList) {
      return jsonList.map((day) => DailyWeather.fromJson(day)).toList();
    }

    return Weather(
      location: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      lat: json['coord']['lat'].toDouble(),
      lon: json['coord']['lon'].toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      weeklyForecast: parseWeeklyForecast(json['daily'] ?? []),
    );
  }
}

class DailyWeather {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String icon;

  DailyWeather({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.icon,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: json['temp']['max'].toDouble(),
      tempMin: json['temp']['min'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}
