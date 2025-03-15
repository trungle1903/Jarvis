import 'package:flutter/material.dart';
class DropdownAI extends StatefulWidget {
  DropdownAI({super.key, required this.aiModels, required this.onChange});
  List<Map<String, String>> aiModels;
  ValueChanged<String?> onChange;

  @override
  _DropdownAIState createState() => _DropdownAIState();
}

class _DropdownAIState extends State<DropdownAI> {
  late List<Map<String, String>> _aiModels;
  late String? _selectedModel;
  late String? _selectedLogo;

  @override
  void initState() {
    super.initState();
    _aiModels = widget.aiModels;
    _selectedModel = widget.aiModels.last['model'];
    _selectedLogo = widget.aiModels.last['logo'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: PopupMenuButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          itemBuilder: (context) {
            return _aiModels.map((model) {
              return PopupMenuItem(
                value: model['name'],
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                        height: 30,
                        child: Image.asset(model['logo']??"")),
                    SizedBox(width: 10),
                    Text(model['name']??""),
                  ],
                ),
              );
            }).toList();
          },
          onSelected: (value) {
             setState(() {
                _selectedModel = value.toString();
                _selectedLogo = _aiModels.firstWhere((model) => model['name'] == _selectedModel)['logo'];
             });

             widget.onChange(_selectedModel);
            // Handle selection here (e.g., navigate or update UI)
          },
          child: Row(
            children: [
              Image.asset(_selectedLogo??"", width: 30, height: 30,),
              Icon(Icons.arrow_drop_up),
              
            ],
          ),
        ),
    );

  }
}