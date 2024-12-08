// home_screen.dart
import 'package:flutter/material.dart';
import 'package:weather/models/forecast_model.dart';
import 'package:weather/screens/weekly_forecast_screen.dart';
import 'package:weather/services/weather_api.dart';
import 'package:weather/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/utils/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherApi weatherApi = WeatherApi();
  Weather? currentWeather;
  double? airQualityIndex;
  bool isLoading = true;
  String location = 'Jakarta';
  HourlyTimelinesResponse? hourlyWeather;
  bool isHourlyLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather(location);
    fetchHourlyWeather(location);
  }

  void fetchWeather(String city) async {
    setState(() {
      isLoading = true;
    });

    try {
      final weather = await weatherApi.getWeather(city);
      final airQuality =
          await weatherApi.getAirQuality(weather.lat, weather.lon);

      setState(() {
        currentWeather = weather;
        airQualityIndex = airQuality;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchWeatherByGPS() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await weatherApi.getLocation();
      final weather = await weatherApi.getWeatherByLocation(position);
      final airQuality =
          await weatherApi.getAirQuality(position.latitude, position.longitude);

      setState(() {
        currentWeather = weather;
        airQualityIndex = airQuality;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchHourlyWeather(String city) async {
    setState(() {
      isHourlyLoading = true;
    });

    try {
      final hourlyRes = await TommorowApi().fetchHourlyWeather(city);
      setState(() {
        hourlyWeather = hourlyRes;
        isHourlyLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isHourlyLoading = false;
      });
    }
  }

  List<HourlyTimeline> _getHourlyForecast(List<HourlyTimeline> hourlyData) {
    DateTime now = DateTime.now();
    List<HourlyTimeline> filteredData = [];

    // Filter untuk mendapatkan data hanya 5 elemen dengan interval 2 jam
    for (var hour in hourlyData) {
      DateTime time = DateTime.parse(hour.time);

      // Ambil data mulai 2 jam dari sekarang dengan interval 2 jam
      if (time.isAfter(now) && filteredData.length < 5) {
        if (filteredData.isEmpty ||
            time.difference(DateTime.parse(filteredData.last.time)).inHours >=
                2) {
          filteredData.add(hour);
        }
      }
    }
    return filteredData;
  }

  String formatTime(int timestamp) {
    // Convert the timestamp to UTC time
    var utcDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);

    // Add 8 hours for Asia/Makassar timezone (UTC+8)
    var localDate = utcDate.add(Duration(hours: 8));

    return DateFormat('h:mm a').format(localDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.white),
            onPressed: fetchWeatherByGPS,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : currentWeather != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80, bottom: 20),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter city name',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: const Icon(Icons.search,
                                  color: Colors.blueAccent),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                fetchWeather(value);
                                fetchHourlyWeather(location);
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                currentWeather!.location,
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${currentWeather!.temperature}°C',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Feels like ${currentWeather!.temperature}°C',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://openweathermap.org/img/wn/${currentWeather!.icon}@2x.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    currentWeather!.condition,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Air Quality Index (AQI): ${airQualityIndex ?? "N/A"}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Bagian Ramalan Cuaca per Jam
                        Container(
                          width: double.infinity, // Lebar kotak abu-abu penuh
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[850],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Hourly Forecast",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              isHourlyLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : hourlyWeather != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: _getHourlyForecast(
                                                  hourlyWeather!.hourly)
                                              .map((hour) {
                                            DateTime time =
                                                DateTime.parse(hour.time);
                                            String formattedTime =
                                                DateFormat('h a').format(time);

                                            return Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Colors.blueAccent,
                                                      Colors.lightBlueAccent
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      formattedTime,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Icon(
                                                      Utils.getWeatherIcon(hour
                                                          .values.weatherCode),
                                                      color:
                                                          Utils.getWeatherColor(
                                                              hour.values
                                                                  .weatherCode),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      "${hour.values.temperature.toStringAsFixed(1)}°C",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      : const Center(
                                          child: Text(
                                            "No hourly data available",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const WeeklyForecastScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey[850],
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Weekly Forecast",
                                  style: TextStyle(
                                    fontSize:
                                        18, // Reduce font size to save space
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Click to see the full forecast',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey[850],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sunrise and Sunset",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Text('Sunrise',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16)),
                                      const SizedBox(height: 5),
                                      Text(formatTime(currentWeather!.sunrise),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text('Sunset',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16)),
                                      const SizedBox(height: 5),
                                      Text(formatTime(currentWeather!.sunset),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'Failed to load weather data',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
    );
  }
}
