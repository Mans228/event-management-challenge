import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _username = '';
  String _password = '';

  void _submit(AuthProvider authProvider) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      authProvider.setLoading(true);

      // Simulate network delay
      Future.delayed(const Duration(seconds: 2), () {
        authProvider.setLoading(false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.isLogin
                ? 'Logged in as $_username'
                : 'Registered as $_username'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(authProvider.isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!authProvider.isLogin)
                TextFormField(
                  key: const ValueKey('email'),
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value != null && value.contains('@') ? null : 'Invalid email',
                  onSaved: (value) => _email = value ?? '',
                ),
              TextFormField(
                key: const ValueKey('username'),
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                value != null && value.length >= 3 ? null : 'Username too short',
                onSaved: (value) => _username = value ?? '',
              ),
              TextFormField(
                key: const ValueKey('password'),
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                value != null && value.length >= 6 ? null : 'Password too short',
                onSaved: (value) => _password = value ?? '',
              ),
              const SizedBox(height: 20),
              if (authProvider.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () => _submit(authProvider),
                  child: Text(authProvider.isLogin ? 'Login' : 'Register'),
                ),
              TextButton(
                onPressed: authProvider.toggleFormMode,
                child: Text(authProvider.isLogin
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
