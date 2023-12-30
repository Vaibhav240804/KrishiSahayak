import 'package:flutter/material.dart';
import 'weather.dart';

class SoilWeather extends StatefulWidget {
  const SoilWeather({super.key});

  @override
  State<SoilWeather> createState() => _SoilWeatherState();
}

class _SoilWeatherState extends State<SoilWeather> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil and Weather'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen()),
                );
              },
              child: const Text('Weather'),
            ),
            const Text('Soil'),
          ],
        ),
      ),
    );
  }
}
