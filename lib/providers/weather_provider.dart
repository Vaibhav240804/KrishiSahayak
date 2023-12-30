import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherProvider extends ChangeNotifier {
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
