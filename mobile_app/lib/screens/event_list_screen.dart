import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/events_provider.dart';
import '../models/event.dart';
import 'create_event_screen.dart';
import 'event_detail_screen.dart';
import 'profile_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<EventsProvider>(context, listen: false).fetchEvents());
  }

  Future<void> _refreshEvents() async {
    await Provider.of<EventsProvider>(context, listen: false).fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<EventsProvider>(
        builder: (context, eventProvider, _) {
          if (eventProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (eventProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(eventProvider.error!),
                  ElevatedButton(
                    onPressed: _refreshEvents,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (eventProvider.events.isEmpty) {
            return Center(
              child: Text(
                'No events found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshEvents,
            child: ListView.builder(
              itemCount: eventProvider.events.length,
              itemBuilder: (context, index) {
                final event = eventProvider.events[index];
                return EventListItem(event: event);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final Event event;

  const EventListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(event.title),
        subtitle: Text(
          '${event.location} - ${_formatDate(event.date)}',
        ),
        trailing: Text('${event.participantIds.length}/${event.maxParticipants}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetailScreen(eventId: event.id),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
} 