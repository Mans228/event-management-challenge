import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/events_provider.dart';
import 'services/api_service.dart';
import 'screens/login_screen.dart';
import 'screens/event_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => EventsProvider(
            context.read<ApiService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Event Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isAuthenticated
                ? const EventListScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
