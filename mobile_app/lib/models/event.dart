import 'package:flutter/material.dart';
import 'user.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int maxParticipants;
  final User organizer;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.maxParticipants,
    required this.organizer,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']), // Backend sends YYYY-MM-DD
      location: json['location'],
      maxParticipants: json['maxParticipants'],
      organizer: User.fromJson(json['organizer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String().split('T')[0], // Send as YYYY-MM-DD
      'location': location,
      'maxParticipants': maxParticipants,
      'organizer': organizer.toJson(),
    };
  }

  // For creating a new event
  factory Event.create({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required int maxParticipants,
    required User organizer,
  }) {
    return Event(
      id: 0, // Will be set by backend
      title: title,
      description: description,
      date: date,
      location: location,
      maxParticipants: maxParticipants,
      organizer: organizer,
    );
  }

  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    int? maxParticipants,
    User? organizer,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      organizer: organizer ?? this.organizer,
    );
  }

  // Validation method to match backend constraints
  String? validate() {
    if (title.isEmpty) {
      return 'Title is required';
    }
    if (description.length > 500) {
      return 'Description is too long (max 500 characters)';
    }
    if (date.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      return 'Date must be today or in the future';
    }
    if (location.isEmpty) {
      return 'Location is required';
    }
    if (maxParticipants < 1) {
      return 'Max participants must be at least 1';
    }
    if (organizer.id == 0) {
      return 'Organizer must be specified';
    }
    return null;
  }
} 