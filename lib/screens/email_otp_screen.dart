import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailOtpScreen extends StatefulWidget {
  const EmailOtpScreen({super.key});

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  final _emailController = TextEditingController();
  bool _loading = false;
  String? _message;

  Future<void> _sendMagicLink() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    final email = _emailController.text.trim();

    try {
      final res = await Supabase.instance.client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.flutter://login-callback/',
      );

      setState(() {
        _message = "Magic link sent to $email. Check your inbox.";
      });
    } catch (e) {
      setState(() {
        _message = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Login with Email')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _sendMagicLink,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Send Login Link'),
            ),
            const SizedBox(height: 20),
            if (_message != null)
              Text(
                _message!,
                style: const TextStyle(color: Colors.greenAccent),
              ),
          ],
        ),
      ),
    );
  }
}
