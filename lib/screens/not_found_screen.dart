import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/404.png', semanticLabel: 'page not found'),
            const SizedBox(height: 20),
            const Text(
              'Oops! Page not found',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
