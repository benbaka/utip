import 'package:flutter/material.dart';

class PersonCounter extends StatelessWidget {
  const PersonCounter({
    super.key,
    required this.theme,
    required int counter,
    required this.onDecrement,
    required this.onIncrement,
  }) : _counter = counter;

  final ThemeData theme;
  final int _counter;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            style: theme.textTheme.titleMedium,
            'Split'),
        Row(
          children: [
            IconButton(color: theme.colorScheme.primary, onPressed: onDecrement, icon: Icon(Icons.remove)),
            Text("$_counter", style: theme.textTheme.titleMedium),
            IconButton(color: theme.colorScheme.primary, onPressed: onIncrement, icon: Icon(Icons.add)),
          ],
        )
      ],
    );
  }
}
