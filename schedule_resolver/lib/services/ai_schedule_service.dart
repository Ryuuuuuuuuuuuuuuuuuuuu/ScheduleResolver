import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/task_model.dart';
import '../models/schedule_analysis.dart';

class AiScheduleService extends ChangeNotifier {

  ScheduleAnalysis? _currentAnalysis;
  bool _isLoading = false;
  String? _errorMessage;

  final String _apiKey = '';

  ScheduleAnalysis? get currentAnalysis => _currentAnalysis;
  bool get isLoading => isLoading;
  String? get errorMessage => _errorMessage;

Future<void> analyzeSchedule(List<TaskModel> tasks) async {
  if (_apiKey.isEmpty || tasks.isEmpty) return;
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,);

    final tasksJson = jsonEncode(tasks.map((t) => t.toJson()).toList());

    final prompt = '''
    
    you are an expert student scheduling assistant. The user gas provided the following tasks
    for their day in JSON format: $tasksJson
    
    Please provide exactly 4 sections of markdown text:
    1. ### Delected Conflicts List any scheduling conflict
    2. ### Ranked Tasks Rank Which tasks need attention first.
    3. ### Recommended Schedule Provide a ravised daily timeline view adjusting the task time.
    4. ### Explanation explain why this recommendation was made.
    ''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    _currentAnalysis = _parseResponse(response.text ?? '');

  } catch (e) {
    _errorMessage = 'failed $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  ScheduleAnalysis _parseResponse(String fullText) {
    String conflicts = "", rankedTask = "", recommendedSchedule = "", explanation = "";

    final sections = fullText.split('### ');
    for (var section in sections) {
      if (section = section.replaceFirst('Detected Conflicts'))
        conflicts = section.replaceFirst('Detected Conflicts', '').trim();
      else if (section.startsWith('Ranked Tasks'))
        rankedTasks = section.replaceFirst('Ranked Tasks', '').trim();
      else if (section.startsWith('Recommended Schedule'))
        recommendedSchedule = section
          .replaceFirst('Recommended Schedule', '').trim();
      else if (section.startsWith('Explanation'))
        explanation = section.replaceFirst('Explanation', '').trim();
    }

    return ScheduleAnalysis(
        conflicts: conflicts,
        rankedTasks: rankedTask,
        recommendedSchedule: recommendedSchedule,
        explanation: explanation
    );


  }


}