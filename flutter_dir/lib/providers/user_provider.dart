import 'dart:convert';
import 'package:krishi_sahayak/providers/providers.dart';
import 'package:krishi_sahayak/providers/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

final translator = GoogleTranslator();
Future<String> _translate(String text) async {
  var translation = await translator.translate(text,
      to: LocaleProvider().locale.languageCode);
  return translation.text;
}

class ChatProvider extends ChangeNotifier {
  final List<List<dynamic>> _messages = [];
  String _location = '';
  String _weather = '';
  String _cropName = '';
  String _soilAnalysis = '';
  String _weatherForecast = '';

  List<List<dynamic>> get messages => _messages;

  void setDetails(String location, String weather, String cropName,
      String soilAnalysis, String weatherForecast) {
    _location = location;
    _weather = weather;
    _cropName = cropName;
    _soilAnalysis = soilAnalysis;
    _weatherForecast = weatherForecast;
    notifyListeners();
  }

  Future<String> sendUserInput(String text) async {
    // 0 - user, 1 - bot
    try {
      print("sending user input");
      _messages.add([0, text]);
      notifyListeners();
      print("past 1st notifyListeners()");
      // fetchLlmResponse(text,).then((response) {
      //   _messages.add([1, response]);
      //   notifyListeners();
      //   return response;
      // }
      // ).catchError((error) {
      //   _messages.add([1, 'Error: $error']);
      //   notifyListeners();
      //   return error;
      // });
    } catch (e) {
      return Future.error(e);
    }
    return "";
  }

  Future<void> fetchLlmResponse(String text, String lang) async {
    try {
      
      print("fetching response");
      notifyListeners();
      String host = "cd12-103-104-226-58";
      final url = Uri.parse('https://$host.ngrok-free.app/chat');
      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({
        'txt': text,
        'location': _location,
        'curr_weather': _weather,
        'weather_forecast': _weatherForecast,
        'crop_name': "maize",
        'soil_analysis': _soilAnalysis,
        'lang': lang,
      });

      messages.add([1, 'responding...']);
      notifyListeners();

      final response = await http.post(url, headers: headers, body: body);
      print(response.body);

      messages.removeLast();
      notifyListeners();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['response']);
        messages.add([1, data['response'].toString()]);
        notifyListeners();
      } else {
        messages.add([1, 'Error: ${response.statusCode}']);
        notifyListeners();
      }
    } catch (e) {
      messages.add([1, 'Error: $e']);
      notifyListeners();
    }
  }
}

class User {
  String name;
  String email;
  String password;
  String city;
  String state;
  int pincode;
  double lat;
  double lon;

  Map<String, double> soil;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.city,
    required this.state,
    required this.pincode,
    required this.lat,
    required this.lon,
    required this.soil,
  });
}

class UserProvider extends ChangeNotifier {
  User _user = User(
    email: '',
    password: '',
    name: '',
    city: '',
    state: '',
    pincode: 0,
    lat: 0.0,
    lon: 0.0,
    soil: {
      'N': 0.0,
      'P': 0.0,
      'K': 0.0,
      'temperature': 0.0,
      'humidity': 0.0,
      'phLevel': 0.0,
      'rainfall': 0.0,
    },
  );

  User get user => _user;

  String _lastPrediction = '';
  String _ai_Res = '';

  String get ai_Res => _ai_Res;

  void prediction(String prediction) {
    _lastPrediction = prediction;
    notifyListeners();
  }

  String get predictionstr => _lastPrediction;

  void updateAddress(String city, String state, String area, int pincode) {
    _user.city = city;
    _user.state = state;
    _user.pincode = pincode;
    notifyListeners();
  }

  void updateLocation(double lat, double lon) {
    _user.lat = lat;
    _user.lon = lon;
    notifyListeners();
  }

  void clearUser() {
    _user = User(
      email: '',
      password: '',
      name: '',
      city: '',
      state: '',
      pincode: 0,
      lat: 0.0,
      lon: 0.0,
      soil: {},
    );
    notifyListeners();
  }

  Future<String> predictCrop() async {
    String host = "cd12-103-104-226-58";
    try {
      //  https://cd12-103-104-226-58.ngrok-free.app
      var url = Uri.parse('https://$host.ngrok-free.app/predict');
      Map<String, dynamic> soilData = {
        'N': _user.soil['N'],
        'P': _user.soil['P'],
        'K': _user.soil['K'],
        'temperature': _user.soil['temperature'],
        'humidity': _user.soil['humidity'],
        'ph': _user.soil['phLevel'],
        'rainfall': _user.soil['rainfall'],
      };

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(soilData),
      );
      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData['prediction']);
        String prediction = responseData['prediction'] ?? '';
        String aiRes = responseData['res'] ?? '';
        _lastPrediction = prediction;
        _ai_Res = aiRes;
        notifyListeners();
        return prediction;
      } else {
        throw 'Failed to get prediction: ${response.statusCode}';
      }
    } catch (error) {
      print('Error: $error');
      return Future.error(error);
    }
  }

  Future<String> getSoidDetails() async {
    try {
      final cookie = await getStoredCookie();
      var url = Uri.parse('http://192.168.51.84:5000/api/getsoildetails');
      var response = await http.get(
        url,
        headers: {
          'Cookie': cookie!,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> soilCompositionList =
            jsonDecode(response.body)['soilComposition'];

        if (soilCompositionList.isNotEmpty) {
          Map<String, dynamic> soilComposition =
              soilCompositionList[0]; // Assuming it's a single element

          print(soilComposition);
          _user.soil = {
            'N': soilComposition['nLevel'].toDouble(),
            'P': soilComposition['pLevel'].toDouble(),
            'K': soilComposition['kLevel'].toDouble(),
            'temperature': soilComposition['temperature'].toDouble(),
            'humidity': soilComposition['humidity'].toDouble(),
            'phLevel': soilComposition['phLevel'].toDouble(),
            'rainfall': soilComposition['rainfall'].toDouble(),
          };
          print(_user.soil);
          notifyListeners();
          return "success";
        } else {
          throw 'No soil composition data available';
        }
      } else {
        throw 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (error) {
      print('Exception: $error');
      rethrow;
    }
  }

  Future<String> updateSoil(Map<String, double> soil) {
    _user.soil = soil;
    if (_user.soil.isEmpty) {
      throw "Soil data cannot be empty";
    }
    try {
      getStoredCookie().then((cookie) async {
        print(cookie.toString());
        try {
          var url = Uri.parse('http://192.168.51.84:5000/api/soildetails');
          var response = await http.post(
            url,
            headers: {
              'Cookie': cookie!,
            },
            body: {
              'N': _user.soil['N'].toString(),
              'P': _user.soil['P'].toString(),
              'K': _user.soil['K'].toString(),
              'temperature': _user.soil['temperature'].toString(),
              'humidity': _user.soil['humidity'].toString(),
              'phLevel': _user.soil['phLevel'].toString(),
              'rainfall': _user.soil['rainfall'].toString(),
            },
          );
          if (response.statusCode == 200) {
            notifyListeners();
            return Future(() => "success");
          } else {
            throw '${response.statusCode}';
          }
        } catch (error) {
          rethrow;
        }
      });
    } catch (e) {
      rethrow;
    }
    notifyListeners();
    return Future.value("success");
  }

  Future<String> signUp(User user) async {
    _user = user;
    if (_user.name.isEmpty) {
      return "Name cannot be empty";
    }
    if (_user.email.isEmpty) {
      return "Email cannot be empty";
    }
    if (_user.password.isEmpty) {
      return "Password cannot be empty";
    }
    if (_user.lat == 0.0 || _user.lon == 0.0) {
      return "Location cannot be empty";
    }
    if (_user.city.isEmpty) {
      return "City cannot be empty";
    }
    if (_user.state.isEmpty) {
      return "State cannot be empty";
    }
    if (_user.pincode == 0) {
      return "Pincode cannot be empty";
    }

    try {
      var url = Uri.parse('http://192.168.51.84:5000/api/register');
      var response = await http.post(
        url,
        body: {
          'name': _user.name,
          'email': _user.email,
          'latitude': user.lat.toString(),
          'longitude': user.lon.toString(),
          'statename': user.state,
          'cityname': user.city,
          'pincode': user.pincode.toString(),
          'password': user.password,
          'address': '${_user.city} ,${_user.state} ,${_user.pincode}',
        },
      );
      if (response.statusCode == 201) {
        notifyListeners();
        return Future(() => 'success');
      } else {
        throw '${response.statusCode}';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> logIn(User user) async {
    final email = user.email;
    final password = user.password;
    try {
      var url = Uri.parse('http://192.168.51.84:5000/api/login');
      var response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.headers['set-cookie'];
        print(response.headers['set-cookie']);
        if (token == null) {
          throw "Something went wrong, got no token";
        }
        _user.city = user.city;
        _user.state = user.state;
        _user.pincode = user.pincode;
        _user.lat = user.lat;
        _user.lon = user.lon;
        _user.email = user.email;
        _user.password = user.password;
        await storeCookie(token);
        notifyListeners();
        return Future(() => 'success');
      } else {
        throw "Something went wrong";
      }
    } catch (error) {
      rethrow;
    }
  }
}

Future<void> storeCookie(String cookieValue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('myCookie', cookieValue);
}

Future<String?> getStoredCookie() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('myCookie');
}
