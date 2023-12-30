import 'package:flutter/material.dart';

class User {
  String username;
  String name;
  String email;
  String area;
  String password;
  String city;
  String state;
  int pincode;
  double lat;
  double lon;

  Map<String, double> soil = {
    'ph': 0.0,
    'nitrogen': 0.0,
    'potassium': 0.0,
    'phosphorus': 0.0,
    'ec': 0.0,
    'oc': 0.0,
  };

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.name,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    required this.lat,
    required this.lon,
    required this.soil,
  });
}

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  // map soil can be is optional to user so modify signup accordingly
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void updateSoil(Map<String, double> soil) {
    _user!.soil = soil;
    notifyListeners();
  }
}
