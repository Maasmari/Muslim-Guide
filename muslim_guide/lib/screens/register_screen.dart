import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter your info to register',
          ),
          
          const SizedBox(height: 20),
          OutlinedButton(onPressed: () {}, child: const Text('Register'))
        ],
      ),
    );
  }
}