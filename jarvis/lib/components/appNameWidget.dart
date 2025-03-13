import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        style: GoogleFonts.jetBrainsMono(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20),
        children: [
          TextSpan(
              text: "STEP",
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
              )),
          TextSpan(
            text: " ",
            style: GoogleFonts.jetBrainsMono(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 15),
          ),
          TextSpan(text: "AI",
              style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 20)
          ),
        ]));
  }
}
