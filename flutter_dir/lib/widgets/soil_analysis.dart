import 'package:flutter/material.dart';
import 'package:krishi_sahayak/lang/abs_lan.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SoilAnalysisCard extends StatefulWidget {
  const SoilAnalysisCard({Key? key}) : super(key: key);

  @override
  State<SoilAnalysisCard> createState() => _SoilAnalysisCardState();
}

class _SoilAnalysisCardState extends State<SoilAnalysisCard> {
  bool isEditing = false;
  // late Map<String, double> analysisData;
  late Map<String, double> analysisData;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Consumer<UserProvider>(builder: (context, provider, _) {
              analysisData = provider.user.soil;
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              Languages.of(context)!.soilAnalysis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: () => {
                              isEditing = true,
                              showDialog(
                                context: context,
                                builder: (context) => _buildEditPopup(context),
                              )
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        Languages.of(context)!.lastUpdatedDate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("pH",
                              style: Theme.of(context).textTheme.titleSmall),
                          Text("6.5",
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const Divider(height: 20),
                      _buildAnalysisGrid(),
                    ],
                  ),
                ),
              );
            })),
      );
    });
  }

  Widget _buildEditPopup(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Soil Analysis"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: Provider.of<UserProvider>(context)
              .user
              .soil
              .entries
              .map((entry) => _buildAnalysisGridItem(entry.key, entry.value))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            Languages.of(context)!.cancel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _saveChanges(context);
          },
          child: Text(Languages.of(context)!.save,
              style: const TextStyle(
                color: Colors.lightGreen,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }

  Widget _buildAnalysisGridItem(String label, double value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          isEditing
              ? TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController(text: value.toString()),
                  onChanged: (newValue) {
                    // Validate if the entered value is a valid double
                    if (double.tryParse(newValue) != null) {
                      value = double.parse(newValue);
                      analysisData[label] = value;
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )
              : Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }

  Widget _buildAnalysisGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 2,
      children: analysisData.entries
          .map((entry) => _buildAnalysisGridItem(entry.key, entry.value))
          .toList(),
    );
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveChanges(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: Provider.of<UserProvider>(context, listen: false)
              .updateSoil(analysisData),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return AlertDialog(
                  title: Text("Error+${snapshot.error}"),
                  content: Text(snapshot.error.toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              } else {
                // Assuming that 'updateSoil' returns a String on success
                // Modify this block based on the returned value if different
                return AlertDialog(
                  title: const Text("Success"),
                  content: const Text("Soil data updated successfully"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context); // Pop the edit popup
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              }
            }
          },
        );
      },
    );
  }
}
