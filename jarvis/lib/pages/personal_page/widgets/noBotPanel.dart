import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoBotPanel extends StatelessWidget {
  const NoBotPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(image: AssetImage('lib/assets/imgs/empty-box.png'), width: 300),
        Text(
          "No bots found",
          style: GoogleFonts.jetBrainsMono(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          "Build a bot first",
          style: GoogleFonts.jetBrainsMono(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
