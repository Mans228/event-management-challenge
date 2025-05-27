import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/user.dart';
import '../models/event_registration.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator, localhost for web, or your machine's IP for real devices
  static const String baseUrl = String.fromEnvironment('API_BASE_URL', 
    defaultValue: 'http://10.0.2.2:8080/api');
  User? _currentUser;

  User? get currentUser => _currentUser;

  // Authentication
  Future<User> register(String email, String username) async {
    final user = User.forRegistration(email: email, username: username);

    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      _currentUser = User.fromJson(jsonDecode(response.body));
      return _currentUser!;
    }
    throw Exception('Failed to register: ${response.body}');
  }

  Future<User> login(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': userId}),
    );

    if (response.statusCode == 200) {
      _currentUser = User.fromJson(jsonDecode(response.body));
      return _currentUser!;
    }
    throw Exception('Failed to login: ${response.body}');
  }

  // Events
  Future<List<Event>> getEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> eventsJson = jsonDecode(response.body);
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    }
    throw Exception('Failed to load events: ${response.body}');
  }

  Future<Event> getEvent(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/$id'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load event: ${response.body}');
  }

  Future<Event> createEvent(Event event) async {
    if (_currentUser == null) {
      throw Exception('Must be logged in to create event');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: _getAuthHeaders(),
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 201) {
      return Event.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create event: ${response.body}');
  }

  Future<void> deleteEvent(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$id'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete event: ${response.body}');
    }
  }

  Future<void> registerForEvent(int eventId) async {
    if (_currentUser == null) {
      throw Exception('Must be logged in to register for event');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/events/$eventId/register'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register for event: ${response.body}');
    }
  }

  Future<List<EventRegistration>> getUserRegistrations(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/registrations'),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> registrationsJson = jsonDecode(response.body);
      return registrationsJson
          .map((json) => EventRegistration.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load user registrations: ${response.body}');
  }

  Map<String, String> _getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }
}