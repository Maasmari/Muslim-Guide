import 'package:flutter/material.dart';
import 'package:muslim_guide/models/suggestion.dart';

class WriteSuggestionScreen extends StatelessWidget {
  const WriteSuggestionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _enteredName = '';
    var _enteredDescription = '';

    final _formKey = GlobalKey<FormState>();

    void showFlashError(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    void _submitSuggestion() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ListOfSuggestions.add(Suggestion(
            taskName: _enteredName, taskDescription: _enteredDescription));
        showFlashError(context, 'Your Suggestion has been submitted');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Write a Suggestion',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              TextFormField(
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: 'Enter the name of the task',
                  labelText: 'Task name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (String? value) {
                  _enteredName = value!;
                },
                validator: (String? value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 30) {
                    return 'Enter a task name. Must be more than 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLength: 128,
                decoration: InputDecoration(
                  hintText: 'Enter the description of the task',
                  labelText: 'Task description',
                  border: OutlineInputBorder(),
                ),
                onSaved: (String? value) {
                  _enteredDescription = value!;
                },
                validator: (String? value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 8 ||
                      value.trim().length > 128) {
                    return 'Enter a task description. Must be more than 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: Text('Reset'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitSuggestion,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
