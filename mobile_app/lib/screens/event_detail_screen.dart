import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../providers/auth_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: FutureBuilder<Event?>(
        future: Provider.of<EventsProvider>(context, listen: false)
            .getEventById(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Event not found'));
          }

          final event = snapshot.data!;
          final currentUser = Provider.of<AuthProvider>(context).currentUser;
          final isRegistered =
              event.participantIds.contains(currentUser?.id ?? -1);
          final isFull = event.participantIds.length >= event.maxParticipants;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on, event.location),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.calendar_today,
                  _formatDate(event.date),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.group,
                  '${event.participantIds.length}/${event.maxParticipants} participants',
                ),
                const SizedBox(height: 24),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(event.description),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<EventsProvider>(
                    builder: (context, eventProvider, _) {
                      return ElevatedButton(
                        onPressed: isRegistered || isFull
                            ? null
                            : () async {
                                try {
                                  await eventProvider.registerForEvent(event.id);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Successfully registered for event'),
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                    ),
                                  );
                                }
                              },
                        child: Text(
                          isRegistered
                              ? 'Already Registered'
                              : isFull
                                  ? 'Event Full'
                                  : 'Register for Event',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
} 