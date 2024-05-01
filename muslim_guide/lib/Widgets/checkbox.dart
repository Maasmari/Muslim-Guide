import 'package:flutter/material.dart';
import 'package:muslim_guide/models/task.dart';

class CheckboxTask extends StatefulWidget {
  CheckboxTask({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  State<CheckboxTask> createState() {
    return _CheckboxTaskState();
  }
}

class _CheckboxTaskState extends State<CheckboxTask> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

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
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: _task.isCompleted,
      onChanged: (bool? value) {
        setState(() {
          _task.isCompleted = value ?? false;
        });
      },
    );
  }
}
