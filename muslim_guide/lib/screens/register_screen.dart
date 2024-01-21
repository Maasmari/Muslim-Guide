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
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Enter your email',
              labelText: 'Email',
            ),
            onSaved: (String? value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String? value) {
              return (value != null && !value.contains('@'))
                  ? 'Enter a valid email.'
                  : null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.password),
              hintText: 'Enter your password',
              labelText: 'Password',
            ),
            obscureText: true,
            onSaved: (String? value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String? value) {
              return (value != null && value.length < 8)
                  ? 'Your password is too short! Minimum password length is 8 characters.'
                  : null;
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: const Text('Click here to login instead.'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
