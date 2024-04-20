import 'package:flutter/material.dart';

class WriteSuggestionScreen extends StatelessWidget {
  const WriteSuggestionScreen({super.key});

  @override
  Widget build(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your suggestion!',
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Enter the name of the task',
                labelText: 'Task name',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null)
                    ? 'Enter a task name.'
                    : null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                hintText: 'Enter the description of the task',
                labelText: 'Task description',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null)
                    ? 'Enter a description of the task.'
                    : null;
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Submit Suggestion'),
            ),
          ],
        ),
      ),
    );
  }
}
