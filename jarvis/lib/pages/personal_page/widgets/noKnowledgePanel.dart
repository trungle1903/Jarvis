import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoKnowledgePanel extends StatelessWidget {
  const NoKnowledgePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('lib/core/assets/imgs/file.png'),
          width: 300,
        ),
        Text(
          "No data",
          style: GoogleFonts.jetBrainsMono(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.w800),
        ),
        Text("Create a knowledge base to store your data", style: GoogleFonts.jetBrainsMono(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            color: Colors.black54,
            fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
