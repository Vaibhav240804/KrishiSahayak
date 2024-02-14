import 'package:flutter/material.dart';
import 'package:krishi_sahayak/providers/providers.dart';

Widget buildTodoDropdown(
  FarmActivity selectedActivity,
  Function(FarmActivity) onChanged,
) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Task',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<FarmActivity>(
          value: selectedActivity,
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          items: FarmActivity.values.map((activity) {
            return DropdownMenuItem<FarmActivity>(
              value: activity,
              child: Text(activity.toString().split('.').last),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
