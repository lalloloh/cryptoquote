import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  final String label;
  final TextStyle? textStyle;

  const ExpandedButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            label: Text(
              label,
              style: textStyle ??
                  Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}
