import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/models/forecast_model.dart';
import 'package:weather/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';

class WeatherApi {
  final String apiKey = 'a800ffc323220f2937e8555fd54912ae';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

// Fungsi untuk mendapatkan cuaca berdasarkan nama kota
  Future<Weather> getWeather(String location) async {
    final url =
        Uri.parse('$baseUrl/weather?q=$location&appid=$apiKey&units=metric');
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data for city $location');
    }
  }

// Fungsi untuk mendapatkan cuaca berdasarkan lokasi GPS (latitude & longitude)
  Future<Weather> getWeatherByLocation(Position position) async {
    final url = Uri.parse(
        '$baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric');
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data for GPS location');
    }
  }

// Fungsi untuk mendapatkan kualitas udara berdasarkan lokasi GPS
  Future<double> getAirQuality(double lat, double lon) async {
    final url =
        Uri.parse('$baseUrl/air_pollution?lat=$lat&lon=$lon&appid=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['list'][0]['main']['aqi'].toDouble();
    } else {
      throw Exception('Failed to load air quality data');
    }
  }

// Fungsi untuk mendapatkan lokasi GPS pengguna
  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
// Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
// Cek izin akses lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
// Dapatkan posisi GPS pengguna
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

class TommorowApi {
  final String apiKey = "oVcqR1nhIjbCcx8eRGcwgj3r0M5cLjJO";
  final String baseUrl = "https://api.tomorrow.io/v4/weather/forecast";

  // Method to fetch weather data for a given location
  Future<TimelinesResponse> fetchWeatherData(String place) async {
    final url =
        Uri.parse('$baseUrl?location=$place&apikey=$apiKey&timesteps=1d');
    // ignore: avoid_print
    print(url);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response body and convert it into a TimelinesResponse object
        final jsonData = json.decode(response.body);
        return TimelinesResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather data: $e");
    }
  }

  Future<HourlyTimelinesResponse> fetchHourlyWeather(String place) async {
    final url =
        Uri.parse('$baseUrl?location=$place&apikey=$apiKey&timesteps=1h');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response body and convert it into a HourlyTimelinesResponse object
        final jsonData = json.decode(response.body);
        return HourlyTimelinesResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to load hourly weather data");
      }
    } catch (e) {
      throw Exception("Error fetching hourly weather data: $e");
    }
  }
}
