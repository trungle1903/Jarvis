import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class EmailOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onTap;

  const EmailOptionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: jvBlue,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: jvBlue, width: 0),
        ),
        margin: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 25, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
