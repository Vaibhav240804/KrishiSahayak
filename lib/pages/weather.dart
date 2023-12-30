import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/weather_card.dart';
import '../providers/weather_provider.dart'; // Import your WeatherProvider

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve WeatherProvider instance
    WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);

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
                // Refresh data by fetching again from the provider
                weatherProvider.getForeCast( 0, 0); // Update with actual lat, lon
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: FutureBuilder(
          future:
              weatherProvider.getForeCast(0, 0), // Update with actual lat, lon
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text(
                  snapshot.error?.toString() ??
                      "An unexpected error has occurred",
                ),
              );
            }

            final data = snapshot.data;
            final currentTemp = data!["list"][0]["main"]["temp"];
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
                          final temp = hourlyPrediction[index]["main"]["temp"];
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
        ));
  }
}

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({
    super.key,
    required this.currentTemp,
    required this.currentSky,
  });

  final currentTemp;
  final currentSky;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$currentTemp k",
                  style: const TextStyle(fontSize: 32),
                ),
                Icon(
                  currentSky == "Clouds" || currentSky == "Rain"
                      ? Icons.cloud
                      : Icons.sunny,
                  size: 64,
                ),
                Text(
                  "$currentSky",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
