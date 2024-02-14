import 'dart:ui';

import 'package:flutter/material.dart';

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
                  "$currentTemp °C",
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
