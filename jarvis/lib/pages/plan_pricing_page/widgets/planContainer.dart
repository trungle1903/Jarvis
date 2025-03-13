import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanContainer extends StatefulWidget {
  const PlanContainer({super.key, this.planName = "", this.price = 0.0, required this.onClick, this.isCurrentPlan = false, this.featureList});
  final double price;
  final VoidCallback onClick;
  final String planName;
  final bool isCurrentPlan;
  final List<String>? featureList;

  @override
  State<PlanContainer> createState() => _PlanContainerState();
}

class _PlanContainerState extends State<PlanContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: widget.isCurrentPlan ? Colors.grey.shade600.withOpacity(0.2) : Colors.transparent,
          border: Border.all(width: 0.8, color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(widget.planName,
                      style: GoogleFonts.jetBrainsMono(
                          fontWeight: FontWeight.w800,
                          fontSize:40)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriceDisplay(context: context, price: widget.price.toString()),
                  Text("Current Plan", style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w800,
                      fontSize: 13))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildPriceDisplay({required BuildContext context, String price = "0"}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(
            style: GoogleFonts.jetBrainsMono(),
            children: [
              WidgetSpan(
                child: Transform.translate(
                  offset: const Offset(0, -7),
                  child: const Text(
                    '\$',
                    textScaler: TextScaler.linear(1.5),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              TextSpan(
                  text: price,
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 40)),
              WidgetSpan(
                child: Transform.translate(
                  offset: Offset(2, -3),
                  child: Column(
                    children: [
                      const Text(
                        'USD/',
                        textScaler: TextScaler.linear(0.7),
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Text(
                        'month',
                        textScaler: TextScaler.linear(0.7),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ])
        ),
      ],
    );
  }
}
