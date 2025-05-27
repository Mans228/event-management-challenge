import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/events_provider.dart';
import '../models/event.dart';
import 'event_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() =>
        Provider.of<EventsProvider>(context, listen: false).fetchEvents());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your profile'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Events'),
            Tab(text: 'Registered Events'),
          ],
        ),
      ),
      body: Consumer<EventsProvider>(
        builder: (context, eventProvider, _) {
          if (eventProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final organizedEvents = eventProvider.events
              .where((event) => event.organizerId == user.id)
              .toList();

          final registeredEvents = eventProvider.events
              .where((event) =>
                  event.participantIds.contains(user.id) &&
                  event.organizerId != user.id)
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        user.username[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEventList(organizedEvents, 'organized'),
                    _buildEventList(registeredEvents, 'registered for'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventList(List<Event> events, String type) {
    if (events.isEmpty) {
      return Center(
        child: Text('You haven\'t $type any events yet'),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(event.title),
            subtitle: Text(
              '${event.location} - ${_formatDate(event.date)}',
            ),
            trailing: Text(
              '${event.participantIds.length}/${event.maxParticipants}',
            ),
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
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
} 