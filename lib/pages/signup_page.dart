// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late List<Map<String, dynamic>> areaData = [];

  int pincode = 0;

  Future<List<Map<String, dynamic>>> fetchData(int pincode) async {
    const String apiKey = 'ad8d840d0dmsh66edbf24bd3c5ccp1e811bjsnea49a777c7ea';
    const String host =
        'india-pincode-with-latitude-and-longitude.p.rapidapi.com';
    String url =
        'https://india-pincode-with-latitude-and-longitude.p.rapidapi.com/api/v1/pincode/${pincode.toString()}';

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': host,
        },
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> result = [];
        // print(response.body.toString());
        var responseBody = json.decode(response.body);
        for (var element in responseBody) {
          Map<String, dynamic> data = {
            'lng': element['lng'],
            'district': element['district'],
            'state': element['state'],
            'pincode': element['pincode'],
            'area': element['area'],
            'lat': element['lat'],
          };
          try {
            if (data['lng'] == null ||
                data['district'] == null ||
                data['state'] == null ||
                data['pincode'] == null ||
                data['area'] == null ||
                data['lat'] == null) {
              continue;
            }
          } catch (e) {
            continue;
          }
          result.add(data);
        }

        return result;
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return []; // Return an empty list on failure
      }
    } catch (error) {
      debugPrint('Error occurred: $error');
      return []; // Return an empty list on error
    }
  }

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                  controller: pincodeController,
                  onChanged: (newValue) {
                    pincode = int.tryParse(newValue) ?? 0;
                    if (pincode.toString().length == 6) {
                      fetchData(pincode).then((value) {
                        setState(() {
                          areaData = value;
                        });
                      });
                      print(areaData);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pincode',
                    hintText: 'Enter your pincode',
                    suffixIcon: Icon(Icons.ads_click),
                  )),
              const SizedBox(width: 12.0),
              Container(
                height: 100.0,
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: areaData.isEmpty
                    ? const SizedBox(
                        height: 5,
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: FutureBuilder<List<Map<String, dynamic>>>(
                              future: fetchData(pincode),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  areaData = snapshot.data!;
                                  return Text(snapshot.data?[index]['area']);
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            subtitle: Text(areaData[index]['district'] +
                                ', ' +
                                areaData[index]['state']),
                            onTap: () {
                              setState(() {
                                pincodeController.text =
                                    areaData[index]['pincode'].toString();
                              });
                            },
                          );
                        },
                      ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: !passwordVisible,
                // to see password
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {
                  final username = usernameController.text;
                  final email = emailController.text;
                  final password = passwordController.text;
                  final pincode = pincodeController.text;

                  if (username.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      pincode.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                      ),
                    );
                    return;
                  }

                  User user = User(
                    username: username,
                    email: email,
                    password: password,
                    name:
                        '', // Add fields like name, address, city, state, pincode, lat, lon as needed
                    area: '',
                    city: '',
                    state: '',
                    pincode: int.parse(pincode),
                    lat: 0.0,
                    lon: 0.0,
                    soil: {}, // You can make this optional or initialize it with default values
                  );

                  Provider.of<UserProvider>(context, listen: false)
                      .setUser(user);

                  // Clear text fields after signup
                  usernameController.clear();
                  emailController.clear();
                  passwordController.clear();

                  Navigator.pushNamed(context, '/home');
                },
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
