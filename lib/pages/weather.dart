import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_sahayak/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/current_weather.dart';
import '../widgets/weather_card.dart';
import '../providers/weather_provider.dart'; // Import your WeatherProvider

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                weatherProvider.fetchWeather(
                    userProvider.user.lat, userProvider.user.lon);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: _fetchWeather(context, userProvider.user.lat,
            userProvider.user.lon), // Update with actual lat, lon
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error} '));
          }

          final data = weatherProvider.foreCast;
          final currentTempInKelvin = data["list"][0]["main"]["temp"];
          final currentTemp =
              (currentTempInKelvin - 273.15).toString().substring(0, 4);

          final currentSky = data["list"][0]["weather"][0]["main"];
          final hourlyPrediction = data["list"].sublist(1, 31);

          final Map<int, Map> additionalInfo = {
            1: {
              "icon": Icons.water_drop,
              "label": "Humidity",
              "value": data["list"][0]["main"]["humidity"]
            },
            2: {
              "icon": Icons.beach_access,
              "label": "pressure",
              "value": data["list"][0]["main"]["pressure"]
            },
            3: {
              "icon": Icons.air,
              "label": "Wind Speed",
              "value": data["list"][0]["wind"]["speed"]
            },
          };

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // mainCard
                CurrentWeather(
                    currentTemp: currentTemp, currentSky: currentSky),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: const Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),

                SizedBox(
                  height: 130,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        final currentTempInKelvin =
                            hourlyPrediction[index]["main"]["temp"];
                        final temp = (currentTempInKelvin - 273.15)
                            .toString()
                            .substring(0, 4);
                        final sky =
                            hourlyPrediction[index]["weather"][0]["main"];
                        final desc = hourlyPrediction[index]["weather"][0]
                            ["description"];
                        final time =
                            DateTime.parse(hourlyPrediction[index]["dt_txt"]);
                        return HourlyForeCastItem(
                          temp: temp.toString(),
                          time:
                              "${DateFormat.j().format(time)} ${DateFormat.MMMd().format(time)} ",
                          desc: desc,
                          icon: sky == "Clouds" || sky == "Rain"
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      }),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInformation(
                        icon: additionalInfo[1]!["icon"],
                        label: additionalInfo[1]!["label"].toString(),
                        value: additionalInfo[1]!["value"].toString()),
                    AdditionalInformation(
                        icon: additionalInfo[2]!["icon"],
                        label: additionalInfo[2]!["label"].toString(),
                        value: additionalInfo[2]!["value"].toString()),
                    AdditionalInformation(
                        icon: additionalInfo[3]!["icon"],
                        label: additionalInfo[3]!["label"].toString(),
                        value: additionalInfo[3]!["value"].toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _fetchWeather(
      BuildContext context, double lat, double lon) async {
    // Access the MarketProvider using Provider.of
    WeatherProvider weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    if (weatherProvider.currentWeather.isEmpty) {
      try {
        await weatherProvider.fetchWeather(lat, lon);
      } catch (e) {
        SnackBar(content: Text('Error fetching current weather: $e'));
      }
    }
    if (weatherProvider.foreCast.isEmpty) {
      try {
        await weatherProvider.fetchWeather(lat, lon);
      } catch (e) {
        SnackBar(content: Text('Error fetching forecast: $e'));
      }
    }
  }
}
