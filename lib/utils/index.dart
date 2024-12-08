import 'package:flutter/material.dart';

class Utils {
  static IconData getWeatherIcon(int weatherCode) {
    print(weatherCode);
    switch (weatherCode) {
      case 1000: // Clear sky
        return Icons.wb_sunny;
      case 1100: // Mostly clear
        return Icons.wb_sunny_outlined;
      case 1001: // Partly cloudy
        return Icons.cloud;
      case 1102: // Mostly cloudy
        return Icons.cloud_queue;
      case 2000: // Fog
        return Icons.foggy;
      case 2100: // Light fog
        return Icons.blur_on;
      case 3000: // Light wind
        return Icons.air;
      case 3100: // Wind
        return Icons.air_outlined;
      case 4000: // Drizzle
        return Icons.grain;
      case 4001: //rain
        return Icons.waves;
      case 4200: // Light rain
        return Icons.umbrella;
      case 5000: // Snow
        return Icons.ac_unit;
      case 5100: // Light snow
        return Icons.snowing;
      case 6000: // Freezing drizzle
        return Icons.ac_unit;
      case 6200: // Light freezing rain
        return Icons.umbrella;
      case 7000: // Ice pellets
        return Icons.ice_skating;
      case 7100: // Light ice pellets
        return Icons.ice_skating_outlined;
      case 8000: // Thunderstorm
        return Icons.flash_on;
      default:
        return Icons.help_outline; // Default for unsupported weather codes
    }
  }

  static Color getWeatherColor(int weatherCode) {
    // Example mapping based on the weather code
    switch (weatherCode) {
      case 1000: // Clear sky
      case 1100: // Clear sky
        return Colors.white;
      case 1002: // Partly cloudy
      case 1100: // Partly cloudy
      case 1002: // Partly cloudy
      case 1002: // Partly cloudy
      case 1002: // Partly cloudy
      case 1002: // Partly cloudy
      case 1002: // Partly cloudy
      case 100: // Partly cloudy
        return Colors.white;
      case 1003: // Cloudy
      case 2000: // Cloudy
      case 2100: // Cloudy
      case 3100: // Cloudy
      case 1003: // Cloudy
      case 1003: // Cloudy
      case 1003: // Cloudy
      case 1001: // Cloudy
        return const Color.fromARGB(255, 250, 247, 247);
      // case 1004: // Overcast
      //   return Colors.grey[800];
      // Add more cases based on your weather codes
      case 4200: // Light Rain
      case 4000: // Light Rain
      case 4001: // Light Rain
      case 4200: // Light Rain
      case 4200: // Light Rain
      case 4200: // Light Rain
      case 4200: // Light Rain
      case 4200: // Light Rain
      case 4200: // Light Rain
      case 4200: // Light Rain
      case 4200: // Light Rain
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}
