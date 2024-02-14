import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class CommodityRecord {
  final String state;
  final String district;
  final String market;
  final String commodity;
  final String variety;
  final String grade;
  final String arrivalDate;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;

  CommodityRecord({
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.variety,
    required this.grade,
    required this.arrivalDate,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
  });

  factory CommodityRecord.fromJson(Map<String, dynamic> json) {
    return CommodityRecord(
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      market: json['market'] ?? '',
      commodity: json['commodity'] ?? '',
      variety: json['variety'] ?? '',
      grade: json['grade'] ?? '',
      arrivalDate: json['arrival_date'] ?? '',
      minPrice: double.parse(json['min_price'] ?? '0'),
      maxPrice: double.parse(json['max_price'] ?? '0'),
      modalPrice: double.parse(json['modal_price'] ?? '0'),
    );
  }
}

class MarketProvider extends ChangeNotifier {
  List<CommodityRecord> _statewizeRecords = [];

  List<CommodityRecord> get statewizeRecords => _statewizeRecords;

  void setstateRecords(List<CommodityRecord> newCommodityRecords) {
    _statewizeRecords = newCommodityRecords;
    notifyListeners();
  }

  Future<void> getCommodityRecords(String state) async {
    try {
      String url =
          "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd000001547a36a140de4067711fb30413dbcf8f&format=json&limit=100&filters%5Bstate%5D=$state";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['records'];
        final commodityRecords = records
            .map<CommodityRecord>((record) => CommodityRecord.fromJson(record))
            .toList();
        setstateRecords(commodityRecords);
      } else {
        throw Exception('Failed to load commodity records');
      }
    } catch (e) {
      throw Exception('Failed to load commodity records');
    }
  }
}

enum FarmActivity {
  sowing,
  picking,
  growingAndHarvesting,
  cattleHospitality,
  soilTesting,
  equipmentBuying,
  equipmentServicing,
  feedingLivestock,
  other,
}

class Meeting {

  Meeting({
    required this.startTime,
    required this.subject,
    required this.endTime,
    required this.color,
    this.otherTask,
  });

  DateTime startTime;
  DateTime endTime;
  FarmActivity subject;
  Color color;
  String? otherTask; // This field is optional based on your schema
}

class TodoProvider extends ChangeNotifier {
  List<Meeting> _meetings = [
    Meeting(
      startTime: DateTime.now(),
      subject: FarmActivity.sowing,
      endTime: DateTime.now().add(const Duration(hours: 1)),
      color: Colors.blue,
      otherTask: 'Additional details',
    ),
  ];

  List<Meeting> get meetings => _meetings;

  void setMeetings(List<Meeting> newMeetings) {
    _meetings = newMeetings;
    notifyListeners();
  }

  void addMeeting(Meeting meeting) {
    print("add meeting called" + meeting.startTime.toString());
    _meetings.add(meeting);
    // then upload the meetings list to the server
    uploadMeetingsToServer(_meetings);
    notifyListeners();
  }

  // remove the meeting from the list
  void removeMeeting(Meeting meeting) {
    _meetings.remove(meeting);
    notifyListeners();
  }

  // Add a method to convert Meeting object to Map
  Map<String, dynamic> _convertMeetingToMap(Meeting meeting) {
    return {
      'startTime': meeting.startTime.toIso8601String(),
      'subject':
          meeting.subject.toString().split('.').last, // Convert enum to string
      'otherTask':
          meeting.otherTask ?? '', // If otherTask is null, set an empty string
    };
  }

  // Modify the method to convert List<Meeting> to List<Map<String, dynamic>>
  List<Map<String, dynamic>> _convertMeetingsToMapList(List<Meeting> meetings) {
    return meetings.map((meeting) => _convertMeetingToMap(meeting)).toList();
  }

  // Modify the method to convert received data from server to List<Meeting>
  List<Meeting> _convertMapListToMeetings(List<dynamic> data) {
    return data.map((item) {
      return Meeting(
        startTime: DateTime.parse(item['startTime']),
        endTime: DateTime.parse(item['startTime'])
            .add(const Duration(hours: 1)), // Add 1 hour duration to startTime
        color: Colors.blue,
        subject: FarmActivity.values.firstWhere(
          (e) => e.toString().split('.').last == item['subject'],
          orElse: () => FarmActivity.other,
        ),
        otherTask: item['otherTask'],
      );
    }).toList();
  }

  // Fetching todo list from server and update meetings list using setMeetings method
  // You need to implement this method to interact with your server
  Future<void> fetchMeetingsFromServer() async {
    // Simulated fetch from server
    final List<Map<String, dynamic>> dataFromServer = [
      {
        'dateTime': DateTime.now().toIso8601String(),
        'task': 'picking',
        'otherTask':
            'Additional details', // Optional, if applicable in your schema
      },
      // Add more data items if needed
    ];

    // Simulated delay for network request (replace with actual API call)
    await Future.delayed(const Duration(seconds: 2));

    // Convert server data to List<Meeting>
    final List<Meeting> fetchedMeetings =
        _convertMapListToMeetings(dataFromServer);

    // Update the local meetings list using setMeetings method
    setMeetings(fetchedMeetings);
  }

  Future<void> uploadMeetingsToServer(List<Meeting> newMeetings) async {
    // Convert newMeetings to a format suitable for sending to the server
    final List<Map<String, dynamic>> meetingsData =
        _convertMeetingsToMapList(newMeetings);

    // Simulated API call to send meetingsData to the server
    try {
      // Simulated server upload delay (replace with actual API call)
      await Future.delayed(const Duration(seconds: 2));

      // Assuming you are using an HTTP POST request to send data to the server
      // Replace 'YourServerEndpoint' with your actual API endpoint
      // Replace 'YourAuthToken' with any authorization token needed
      final response = await http.post(
        Uri.parse('YourServerEndpoint'), // Replace with your server endpoint
        headers: {
          'Authorization':
              'YourAuthToken', // Replace with your authorization token if required
          'Content-Type': 'application/json', // Set the content type as JSON
        },
        body: json.encode(meetingsData), // Encode meetingsData to JSON
      );

      // Check the response status code and handle accordingly
      if (response.statusCode == 200) {
        // Success: Todo items uploaded to the server
        print('Todos uploaded successfully');
        // You might want to perform additional actions here if needed
      } else {
        // Error: Handle server errors or failed uploads
        print('Failed to upload todos. Status code: ${response.statusCode}');
        // You might want to throw an error or handle the failure scenario
      }
    } catch (e) {
      // Exception: Handle exceptions during the API call
      print('Error uploading todos: $e');
      // You might want to throw an error or handle the exception scenario
    }
  }
}
