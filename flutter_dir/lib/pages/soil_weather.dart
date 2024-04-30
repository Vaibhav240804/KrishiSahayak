import 'package:flutter/material.dart';
import 'package:krishi_sahayak/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'weather.dart';

class SoilWeather extends StatefulWidget {
  const SoilWeather({super.key});

  @override
  State<SoilWeather> createState() => _SoilWeatherState();
}

class _SoilWeatherState extends State<SoilWeather> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              elevation: 5,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeatherScreen()),
              );
            },
            child: const Text(
              'Click to view updated weather',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 50),
          Flexible(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    userProvider.predictionstr.isEmpty
                        ? FutureBuilder(
                            future: userProvider.predictCrop(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text('Error: ${snapshot.error}'),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              } else {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                        'Suitable crop for your soil is :'),
                                    Text(
                                      userProvider.predictionstr,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(snapshot.data.toString())
                                  ],
                                );
                              }
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Suitable crop for your soil is :'),
                              Text(
                                userProvider.predictionstr,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userProvider.ai_Res,
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                    ElevatedButton(
                      onPressed: () {
                        userProvider.prediction('');
                        setState(() {});
                      },
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
