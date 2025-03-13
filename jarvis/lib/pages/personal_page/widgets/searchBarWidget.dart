import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final Color backgroundColor;
  final bool hasBorder;

  const SearchBarWidget({Key? key, required this.onSearch, this.backgroundColor = Colors.transparent, this.hasBorder = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        hintText: "Search",
        hintStyle: GoogleFonts.jetBrainsMono(
          color: Colors.grey
        ),
        hoverColor: backgroundColor,
        fillColor: backgroundColor,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo,
                width: hasBorder ? 1.0: 0
            ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24,
            width: hasBorder ? 1.0: 0
          )
        ),
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: onSearch, // Pass the search query back to the parent
    );
  }
}