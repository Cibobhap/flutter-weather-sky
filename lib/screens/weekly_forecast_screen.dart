// weekly_forecast_screen.dart
import 'package:flutter/material.dart';
import 'package:weather/models/forecast_model.dart';
import 'package:weather/services/weather_api.dart';
import 'package:weather/utils/index.dart';

class WeeklyForecastScreen extends StatefulWidget {
  const WeeklyForecastScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeeklyForecastScreen createState() => _WeeklyForecastScreen();
}

class _WeeklyForecastScreen extends State<WeeklyForecastScreen> {
  TommorowApi tommorowApi = TommorowApi();
  TimelinesResponse? timelineRespone;
  String location = 'Jakarta';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather(location);
  }

  void fetchWeather(String city) async {
    setState(() {
      isLoading = true;
    });

    try {
      final tommorowRes = await tommorowApi.fetchWeatherData(location);

      setState(() {
        timelineRespone = tommorowRes;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  String getWeekdayFromDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    // List of short weekday names
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Return the corresponding day name based on the parsedDate's weekday.
    return weekDays[parsedDate.weekday %
        7]; // Weekday is 1-based, so use % 7 to get the correct day.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[900], // Set background to dark color
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : timelineRespone != null
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        // Center the text
                        child: Text(
                          "Weekly Forecast",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: timelineRespone!.daily.map((day) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [Colors.blueGrey, Colors.blueAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Display date (time)
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    getWeekdayFromDate(day.time),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Display weather icon
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Icon(
                                      Utils.getWeatherIcon(
                                          day.values.weatherCodeMax),
                                      color: Utils.getWeatherColor(
                                          day.values.weatherCodeMax),
                                      size: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Display temperature range
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${day.values.temperatureMin.toStringAsFixed(2)}° - ${day.values.temperatureMax.toStringAsFixed(2)}°",
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
