import 'package:flutter/material.dart';
import 'package:krishi_sahayak/lang/abs_lan.dart';

class SoilAnalysisCard extends StatefulWidget {
  const SoilAnalysisCard({Key? key}) : super(key: key);

  @override
  State<SoilAnalysisCard> createState() => _SoilAnalysisCardState();
}

class _SoilAnalysisCardState extends State<SoilAnalysisCard> {
  bool isEditing = false;
  Map<String, String> analysisData = {
    "pH": "6.5",
    "N": "0.2",
    "P": "0.2",
    "K": "0.2",
    "EC": "0.2",
    "OC": "0.2",
    // ... Add more analysis values
  };
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                            builder: (context) => _buildEditPopup(),
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
                      Text("pH", style: Theme.of(context).textTheme.titleSmall),
                      Text("6.5", style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildAnalysisGrid(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ... other code

  Widget _buildEditPopup() {
    return AlertDialog(
      title: const Text("Edit Soil Analysis"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: analysisData.entries
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
            _saveChanges(); // Call the _saveChanges method to save changes
            Navigator.pop(context);
          },
          child: Text(
            Languages.of(context)!.save,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisGridItem(String label, String value) {
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
                  controller: TextEditingController(
                      text: value), // Use a controller for editing
                  onChanged: (newValue) {
                    // Update the value in analysisData as the user types
                    analysisData[label] = newValue;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )
              : Text(
                  value,
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

  void _saveChanges() {
    // TODO: Implement logic to save changes to analysisData
    _toggleEditing();
  }

  void _cancelEditing() {
    // TODO: Revert any changes to analysisData
    _toggleEditing();
  }
}
