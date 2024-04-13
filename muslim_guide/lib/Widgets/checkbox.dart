import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';

class CheckboxTask extends StatefulWidget {
  CheckboxTask({super.key, required this.task});

  final Task task;

  @override
  State<CheckboxTask> createState() {
    return _CheckboxTaskState(task: task);
  }
}

class _CheckboxTaskState extends State<CheckboxTask> {
  _CheckboxTaskState({required this.task});

  final Task task;
  
  Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.green;
    }


  @override
  Widget build(context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor:MaterialStateProperty.resolveWith(getColor),
      value: task.isCompleted,
      onChanged: (bool? value) {
        setState(() {
          task.isCompleted = value!;
        });
      },
    );
  }
}