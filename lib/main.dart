import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krishi_sahayak/pages/Signup_page.dart';
import 'package:krishi_sahayak/pages/profile.dart';
import 'package:krishi_sahayak/pages/routes.dart';
import 'package:krishi_sahayak/providers/providers.dart';
import 'package:krishi_sahayak/providers/weather_provider.dart';
import 'package:provider/provider.dart';
import 'lang/localization_delegate.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => WeatherProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      title: "Krishi Sahayak",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lime.shade200,
            secondary: Colors.lime.shade400,
            primary: Colors.amber.shade200),
        textTheme: const TextTheme(
          titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontSize: 12.0),
          bodyMedium: TextStyle(fontSize: 16.0),
          bodyLarge: TextStyle(fontSize: 20.0),
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
      home: const SignUpPage(),
      locale: Provider.of<LocaleProvider>(context).locale,
      routes: {
        '/profile': (context) => const Profile(),
        '/home': (context) => const Routes(),
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
}
