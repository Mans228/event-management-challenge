import 'event.dart';
import 'user.dart';

class EventRegistration {
  final int id;
  final User user;
  final Event event;
  final DateTime registrationDate;

  EventRegistration({
    required this.id,
    required this.user,
    required this.event,
    required this.registrationDate,
  });

  factory EventRegistration.fromJson(Map<String, dynamic> json) {
    return EventRegistration(
      id: json['id'],
      user: User.fromJson(json['user']),
      event: Event.fromJson(json['event']),
      registrationDate: DateTime.parse(json['registrationDate']), // Backend sends YYYY-MM-DD
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'event': event.toJson(),
      'registrationDate': registrationDate.toIso8601String().split('T')[0], // Send as YYYY-MM-DD
    };
  }
} 