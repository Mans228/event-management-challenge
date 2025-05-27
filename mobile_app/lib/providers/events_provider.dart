import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/event.dart';
import '../models/event_registration.dart';

class EventsProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Event> _events = [];
  List<EventRegistration> _userRegistrations = [];
  bool _isLoading = false;
  String? _error;

  EventsProvider(this._apiService);

  List<Event> get events => _events;
  List<EventRegistration> get userRegistrations => _userRegistrations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _apiService.getEvents();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Event?> getEventById(int id) async {
    try {
      return await _apiService.getEvent(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> createEvent(Event event) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newEvent = await _apiService.createEvent(event);
      _events.add(newEvent);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(int id) async {
    _error = null;
    try {
      await _apiService.deleteEvent(id);
      _events.removeWhere((event) => event.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> registerForEvent(int eventId) async {
    _error = null;
    try {
      await _apiService.registerForEvent(eventId);
      // Refresh both events and user registrations
      await Future.wait([
        fetchEvents(),
        fetchUserRegistrations(),
      ]);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchUserRegistrations() async {
    if (_apiService.currentUser == null) return;

    _error = null;
    try {
      _userRegistrations = await _apiService.getUserRegistrations(
        _apiService.currentUser!.id,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  bool isUserRegistered(int eventId) {
    return _userRegistrations.any((reg) => reg.event.id == eventId);
  }

  List<Event> getRegisteredEvents() {
    return _userRegistrations.map((reg) => reg.event).toList();
  }

  List<Event> getOrganizedEvents() {
    if (_apiService.currentUser == null) return [];
    return _events
        .where((event) => event.organizer.id == _apiService.currentUser!.id)
        .toList();
  }
} 