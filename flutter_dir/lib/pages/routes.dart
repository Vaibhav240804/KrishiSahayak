// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:krishi_sahayak/lang/abs_lan.dart';
import 'package:krishi_sahayak/pages/home_page.dart';
import 'package:krishi_sahayak/pages/market_page.dart';
import 'package:krishi_sahayak/pages/personal_calendar.dart';
import 'package:krishi_sahayak/pages/soil_weather.dart';
import 'package:krishi_sahayak/pages/disease_pred.dart';
import 'package:krishi_sahayak/providers/providers.dart';
import 'package:provider/provider.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  int _currentIndex = 0;

  Map<String, String> langs = {
    'en': 'English',
    'hi': 'हिंदी',
    'mr': 'मराठी',
    'kn': 'ಕನ್ನಡ',
    'ta': 'தமிழ்',
    'bn': 'বাংলা'
  };
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          Languages.of(context)!.appName,
          // "Krishi Sahayak",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 30.0,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              // we have provider
              LocaleProvider localeProvider =
                  Provider.of<LocaleProvider>(context, listen: false);
              localeProvider.setLocale(locale);
            },
            itemBuilder: (BuildContext context) {
              return [
                const Locale('en'),
                const Locale('hi'),
                const Locale('mr'),
                const Locale('kn'),
                const Locale('ta'),
                const Locale('bn')
              ]
                  .map<PopupMenuItem<Locale>>(
                    (Locale locale) => PopupMenuItem<Locale>(
                      value: locale,
                      child: Text(langs[locale.languageCode]!),
                    ),
                  )
                  .toList();
            },
          ),
        ],
      ),
      body: Center(
        child: _buildPageContent(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: Languages.of(context)!.home,
            // label: "Home",
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.yard),
            label: Languages.of(context)!.marketsNearby,
            // label: "Markets Nearby",
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.water_drop),
            label: Languages.of(context)!.weatherSoil,
            // label: "Weather n Soil",
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: Languages.of(context)!.personalCal,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.eco),
            label: Languages.of(context)!.cropDisease,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const MarketPlace();
      case 2:
        return const SoilWeather();
      case 3:
        return const PersonalCalendar();
      case 4:
        return const CropDiseasePredictionPage();
      default:
        return Container();
    }
  }
}
