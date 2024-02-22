import 'package:flutter/material.dart';

class CheckboxTask extends StatefulWidget {
  const CheckboxTask({super.key});

  @override
  State<CheckboxTask> createState() {
    return _CheckboxTaskState();
  }
}

class _CheckboxTaskState extends State<CheckboxTask> {
  bool isChecked = false;
  
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
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}