import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:krishi_sahayak/lang/abs_lan.dart';
import 'package:krishi_sahayak/providers/providers.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  loc.Location location = loc.Location();

  Locale chooseLang = const Locale('en');

  Map<String, String> lang = {
    'English': 'en',
    'हिन्दी': 'hi', // Hindi
    'मराठी': 'mr', // Marathi
    'বাংলা': 'bn', // Bengali
    'தமிழ்': 'ta', // Tamil
    'ಕನ್ನಡ': 'kn', // Kannada
  };

  double? lat, long;
  String? area, city, state, pincode;

  late User _user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAddressFromLocation();
  }

  Future<void> getAddressFromLocation() async {
    try {
      loc.LocationData currentLocation = await location.getLocation();
      setState(() {
        lat = currentLocation.latitude;
        long = currentLocation.longitude;
      });
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          area = place.subLocality;
          city = place.locality;
          state = place.administrativeArea;
          pincode = place.postalCode;
        });
      }
    } catch (e) {
      SnackBar(content: Text(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 50),
              Text(
                Languages.of(context)!.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 50),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                elevation: 1,
                child: Wrap(
                  spacing: 5,
                  children: lang.entries
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(6),
                            child: ChoiceChip(
                              label: Text(
                                e.key,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              onSelected: (value) =>
                                  Provider.of<LocaleProvider>(context,
                                          listen: false)
                                      .setLocale(Locale(e.value)),
                              selected: Locale(e.value) ==
                                  Provider.of<LocaleProvider>(context).locale,
                              selectedColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: Languages.of(context)!.name,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: Languages.of(context)!.email,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: Languages.of(context)!.password,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    _user = User(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      city: city ?? "",
                      state: state ?? "",
                      pincode: int.parse(pincode ?? "0"),
                      lat: lat ?? 0.0,
                      lon: long ?? 0.0,
                      soil: {
                        'ph': 0.0,
                        'nitrogen': 0.0,
                        'potassium': 0.0,
                        'phosphorus': 0.0,
                        'ec': 0.0,
                        'oc': 0.0,
                      },
                    );

                    Future<String> response =
                        Provider.of<UserProvider>(context, listen: false)
                            .signUp(_user);
                    response
                        .then((value) => {
                              {Navigator.pushReplacementNamed(context, '/home')}
                            })
                        .catchError(
                      (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error.toString(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    Languages.of(context)!.signup,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    Languages.of(context)!.login,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
