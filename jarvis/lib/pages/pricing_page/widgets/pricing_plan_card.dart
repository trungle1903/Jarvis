import 'package:flutter/material.dart';
import 'package:jarvis/components/gradient_button.dart';
import 'package:jarvis/constants/colors.dart';
import 'feature_chip.dart'; 

class PricingPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<Map<String, String>> features; 
  final String buttonText;
  final Color buttonTextColor;
  final Color buttonBgColor;
  final VoidCallback onPressed;

  const PricingPlanCard({
    required this.title,
    required this.price,
    required this.features,
    required this.buttonText,
    required this.buttonTextColor,
    required this.buttonBgColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: jvBlue,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: jvGrey)
      ),
      child: Container(
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              price,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: jvDeepBlue,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: GradientElevatedButton(
                onPressed: onPressed,
                text: buttonText,
                textStyle: TextStyle(color: buttonTextColor, fontWeight: FontWeight.bold),
                gradientColors: [buttonBgColor,buttonBgColor],
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Basic featured', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            ...features.map((feature) => Align(
                alignment: Alignment.centerLeft,
                child: FeatureChip(
                  text: feature['text']!,
                  subText: feature['subText'] ?? '',
                ),
            )).toList(),
            SizedBox(height: 16),
                        Divider(),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Advanced featured', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            ...features.map((feature) => Align(
                alignment: Alignment.centerLeft,
                child: FeatureChip(
                  text: feature['text']!,
                  subText: feature['subText'] ?? '',
              ),
            )).toList(),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Other featured', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            ...features.map((feature) => Align(
                alignment: Alignment.centerLeft,
                child: FeatureChip(
                  text: feature['text']!,
                  subText: feature['subText'] ?? '',
                ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}