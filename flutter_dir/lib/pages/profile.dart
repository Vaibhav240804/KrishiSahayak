import 'package:flutter/material.dart';
import 'package:krishi_sahayak/lang/abs_lan.dart';
import 'package:krishi_sahayak/providers/user_provider.dart';
import 'package:krishi_sahayak/widgets/soil_analysis.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly, // Distribute content evenly
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Stretch child to fit width
      children: [
        Expanded(
          // Allow Card to occupy available space
          child: Card(
            child: Padding(
              // Add padding within the Card
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    Languages.of(context)!.profile,
                    // "Profile",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 1),
                  const CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        "https://www.w3schools.com/howto/img_avatar.png"),
                  ),
                  const Spacer(flex: 1),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "${Languages.of(context)!.email} :  ${Provider.of<UserProvider>(context).user.email}",
                            // "Email :  ${Provider.of<UserProvider>(context).user.email}",
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${Languages.of(context)!.location} :  ${Provider.of<UserProvider>(context).user.state}",
                            // "Location :  ${Provider.of<UserProvider>(context).user.state}",
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // an flex so it takes up remaining space
                  const Spacer(flex: 1),
                  Text(
                    Languages.of(context)!.soilAnalysis,
                    // "Soil Analysis",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SoilAnalysisCard(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
