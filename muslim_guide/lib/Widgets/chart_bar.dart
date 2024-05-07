import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
    required this.color,
  });

  final double fill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints
              .maxWidth, // Ensure the container tries to use up all available width
          height: constraints.maxHeight * fill, // Apply fill factor to height
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color: color,
            ),
          ),
        );
      },
    );
  }
}
