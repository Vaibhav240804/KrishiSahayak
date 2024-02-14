import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:krishi_sahayak/providers/weather_provider.dart';
import 'package:krishi_sahayak/widgets/current_weather.dart';
import 'package:krishi_sahayak/widgets/near_market.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);
    UserProvider userprovider = Provider.of<UserProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: weatherProvider.getForeCast(
                userprovider.user!.lat, userprovider.user!.lon),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 200,
                    width: double.infinity - 100,
                    child: Card(child: CircularProgressIndicator()),
                  ),
                );
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
              if (data!["list"] == null || data["list"].isEmpty) {
                return Center(
                  child: Text(data.toString()),
                );
              }

              final currentTempInKelvin = data["list"][0]["main"]["temp"];
              final currentSky = data["list"][0]["weather"][0]["main"];
              final currentTemp =
                  (currentTempInKelvin - 273.15).toString().substring(0, 4);

              return TextButton(
                onLongPress: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                onPressed: () {
                  Navigator.pushNamed(context, '/weather');
                },
                child: CurrentWeather(
                  currentTemp: currentTemp,
                  currentSky: currentSky,
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const CommodityPrices(),
        ],
      ),
    );
  }
}
