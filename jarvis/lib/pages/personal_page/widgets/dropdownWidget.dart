import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownWidget extends StatefulWidget {
  // The list of dropdown types is passed as a parameter to the constructor
  final List<String> types;
  String display = "";
  ValueChanged<String?> onSelect;

  DropdownWidget({Key? key, required this.types, required this.onSelect, this.display = ""}) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  // This will store the selected dropdown value
  String? _selectedType;
  String _display = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedType = widget.types.isEmpty ? "No value" : widget.types.first;
      _display = widget.display;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.8),
        borderRadius: const BorderRadius.all(Radius.circular(4))
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            Text(widget.display, style: GoogleFonts.jetBrainsMono(
                color: Colors.black45,
                fontWeight: FontWeight.w700
            )),
            SizedBox(
              width: min(MediaQuery.of(context).size.width * .3, 130),
              child: DropdownButtonFormField<String>(
                value: _selectedType,
                style: GoogleFonts.jetBrainsMono(
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                ),
                // Use the types passed through the constructor (widget.types)
                items: widget.types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type, style: GoogleFonts.jetBrainsMono(
                        color: Colors.black,
                        fontWeight: FontWeight.w700
                    ),),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;

                    print(_selectedType);
                  });
                  widget.onSelect(_selectedType);
                },
                hint: Text(_display),
              ),
            ),
          ],
        ),
      ),
    );
  }
}