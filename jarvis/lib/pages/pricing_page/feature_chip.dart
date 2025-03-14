import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart'; // Assuming jvBlue and jvSubText are defined here

class FeatureChip extends StatelessWidget {
  final String text; // Main text
  final String subText; // Optional subtext

  const FeatureChip({
    required this.text,
    this.subText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white, 
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), 
        side: BorderSide(color: Colors.white), 
      ),
      label: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: jvBlue,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold, 
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, 
                ),
                if (subText.isNotEmpty)
                  Text(
                      subText,
                      style: TextStyle(
                        color: jvSubText, 
                        fontSize: 12, 
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}