import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muslim_guide/models/task.dart';
import 'package:muslim_guide/providers/completion_provider.dart';

// ignore: must_be_immutable
class CheckboxTask extends StatefulWidget {
  final Task task;
  DateTime now;
  CheckboxTask({Key? key, required this.task, required this.now})
      : super(key: key);

  @override
  State<CheckboxTask> createState() => _CheckboxTaskState();
}

class _CheckboxTaskState extends State<CheckboxTask> {
  late Task _task;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _fetchTaskCompletion(widget.now);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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

  void _fetchTaskCompletion(DateTime now) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 0), () async {
      var formatter = DateFormat('yyyy-MM-dd');
      DateTime date = DateTime.parse(formatter.format(now));

      bool isCompleted = await checkTaskCompletion(
          FirebaseAuth.instance.currentUser!.uid, _task.id, date);
      if (mounted) {
        setState(() {
          _task.isCompleted = isCompleted;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: _task.isCompleted,
      onChanged: (bool? value) {
        setState(() {
          _task.isCompleted = value ?? false;
          if (_task.isCompleted) {
            _createTaskCompletion(widget.now);
          } else {
            _deleteTaskCompletion(widget.now);
          }
        });
      },
    );
  }

  void _createTaskCompletion(DateTime now) async {
    var formatter = DateFormat('yyyy-MM-dd');
    DateTime date = DateTime.parse(formatter.format(now));
    await createTaskCompletion(
        FirebaseAuth.instance.currentUser!.uid, _task.id, date);
  }

  void _deleteTaskCompletion(DateTime now) async {
    var formatter = DateFormat('yyyy-MM-dd');
    DateTime date = DateTime.parse(formatter.format(now));
    await deleteTaskCompletion(
        FirebaseAuth.instance.currentUser!.uid, _task.id, date);
  }
}
