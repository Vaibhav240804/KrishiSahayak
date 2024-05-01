import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:krishi_sahayak/pages/Signup_page.dart';
import 'package:krishi_sahayak/pages/chatUI.dart';
import 'package:krishi_sahayak/pages/home_page.dart';
import 'package:krishi_sahayak/pages/login_page.dart';
import 'package:krishi_sahayak/pages/profile.dart';
import 'package:krishi_sahayak/pages/routes.dart';
import 'package:krishi_sahayak/pages/weather.dart';
import 'package:krishi_sahayak/providers/providers.dart';
import 'package:krishi_sahayak/providers/user_provider.dart';
import 'package:krishi_sahayak/providers/weather_provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:provider/provider.dart';
import 'lang/localization_delegate.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => WeatherProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => MarketProvider()),
    ChangeNotifierProvider(create: (_) => TodoProvider()),
    ChangeNotifierProvider(create: (_) => ChatProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Position? _currentPosition;
  bool _isLoggingIn = false;
  @override
  void initState() {
    _getCurrentPosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      title: "Krishi Sahayak",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown.shade300,
          secondary: Colors.lime.shade400,
          primary: Colors.brown,
        ),
        textTheme: const TextTheme(
          titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontSize: 12.0),
          bodyMedium: TextStyle(fontSize: 16.0),
          bodyLarge: TextStyle(fontSize: 20.0),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.amber.shade400,
          contentTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.amber.shade400,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade500,
          selectedIconTheme: const IconThemeData(size: 30.0),
        ),
        useMaterial3: true,
      ),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      home: const LogInPage(),
      locale: Provider.of<LocaleProvider>(context).locale,
      routes: {
        '/profile': (context) => const Profile(),
        '/home': (context) => const Routes(),
        '/login': (context) => const LogInPage(),
        '/signup': (context) => const SignUpPage(),
        '/weather': (context) => const WeatherScreen(),
      },
      supportedLocales: const [
        Locale('en'),
        Locale('mr'),
        Locale('hi'),
        Locale('kn'),
        Locale('ta'),
        Locale('bn')
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied'),
          ),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.updateLocation(
          _currentPosition!.latitude, _currentPosition!.longitude);
      userProvider.updateAddress(
        place.locality.toString(),
        place.administrativeArea.toString(),
        place.subLocality.toString(),
        int.parse(
          place.postalCode.toString(),
        ),
      );
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
