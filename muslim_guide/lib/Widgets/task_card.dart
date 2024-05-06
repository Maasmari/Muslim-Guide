import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final List<Task> tasks;
  final Color color;

  TaskCard({required this.title, required this.tasks, required this.color});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    // Define a fixed height for the card
    const double cardHeight = 145.0; // Change this value as needed

    return Card(
      elevation: 4.0,
      color: widget.color,
      margin: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: cardHeight, // Ensures the card has a constant height
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 30.0),
                ],
              ),
              const SizedBox(height: 8.0),
              Expanded(
                // Makes the list of tasks scrollable within the fixed height
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.tasks
                        .map((task) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    task.taskName,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
