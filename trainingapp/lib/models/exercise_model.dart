import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:json_annotation/json_annotation.dart';

//part 'exercise.g.dart';


class Exercise {
  final String? id;
  final String? name;
  final String? bodyPart;
  final String? equipment;
  final String? target;
  final String? gifUrl;
  final String? description;

  Exercise(
    this.id,
    this.name,
    this.bodyPart,
    this.equipment,
    this.target,
    this.gifUrl,
    this.description,
  );

  factory Exercise.fromJson(Map<String, dynamic> json){
    return Exercise(json['id'], json['name'], json['bodyPart'],json['equipment'],json['target'],json['gifUrl'],json['description']);
  }

/*
  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  */
}
  Future<List<Exercise>> searchExercisesByName(String name) async {
    final String apiKey = dotenv.env['EXERCISE_API_KEY'] ?? '';
    final String baseUrl = dotenv.env['EXERCISE_BASE_URL'] ?? '';
    final url = Uri.parse('$baseUrl/exercises/name/$name');
    try {
      final response = await http.get(url, headers: _headers(apiKey));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Exercise.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search exercises by name: $name');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Helper method to set headers
Map<String, String> _headers(String apiKey) {
    return {
      'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
      'x-rapidapi-key': apiKey,
      'Content-Type': 'application/json',
    };
  }

