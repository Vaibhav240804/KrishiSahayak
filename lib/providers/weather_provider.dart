import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherProvider extends ChangeNotifier {
  Map<String, dynamic> _currentWeather = {};
  Map<String, dynamic> _foreCast = {};

  Map<String, dynamic> get currentWeather => _currentWeather;
  Map<String, dynamic> get foreCast => _foreCast;

  Future<void> fetchWeather(double lat, double lon) async {
    try {
      _currentWeather = await getCurrentWeather(lat, lon);
      _foreCast = await getForeCast(lat, lon);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getForeCast(double lat, double lon) async {
    const apiKey = "f3fe096bffdbcc33181446bc7bcf0278";
    try {
      var res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey"),
      );
      final data = jsonDecode(res.body);
      if (data == null || data["cod"] != "200") {
        if (data == null) {
          throw "error";
        } else {
          throw data["message"];
        }
      }
      return data;
    } catch (e) {
      throw "An unexpected error has occurred";
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    const apiKey = "f3fe096bffdbcc33181446bc7bcf0278";
    try {
      var res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey"),
      );
      final data = jsonDecode(res.body);
      if (data == null || data["cod"] != 200) {
        if (data == null) {
          throw "error";
        } else {
          throw data["message"];
        }
      }
      return data;
    } catch (e) {
      throw "An unexpected error has occurred";
    }
  }
}
