import 'package:flutter/material.dart';

class TaskModel {

  final String id;
  final String title;
  final String category;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int urgency;
  final int importance;
  final double estimatedEffortsHours;
  final String energyLevel;

  TaskModel({

    required this.id, required this.title, required this.category,
    required this.date, required this.startTime, required this.endTime,
    required this.urgency, required this.importance, required this.estimatedEffortsHours,
    required this.energyLevel,
});

  Map<String, dynamic> toJson() {
    return {

      'id' : id, 'title': title, 'category': category,
      'date': date.toIso8601String().split('T').first,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'urgency': urgency, 'importance': importance,
      'estimatedEffortHours': estimatedEffortsHours, 'energyLevel':  energyLevel,
      


    };

  }

}