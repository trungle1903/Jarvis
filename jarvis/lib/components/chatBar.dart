import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatBar extends StatefulWidget {
  void Function(String) onSendMessage;
  ChatBar({super.key, required this.onSendMessage});

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  bool _showIcons = false;
  bool _showIconSend = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  //Event to display/hide the accessibility icons
  void onTextChanged() {
    if (_controller.text.isNotEmpty) {
      if (_showIcons) {
        setState(() {
          _showIcons = false;
        });
      }
      setState(() {
        _showIconSend = true;
      });
    } else {
      setState(() {
        _showIconSend = false;
      });
    }
  }

  void _toggleIcons() {
    setState(() {
      _showIcons = !_showIcons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white54,
        border: Border.all(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          //show icon "add" to display the other accessibility icons
          if (!_showIcons)
            IconButton(
              padding: const EdgeInsets.all(2),
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: _toggleIcons,
            ),
          //show the other accessibility icons
          if (_showIcons) ...[
            //Icon camera
            IconButton(
              icon: const Icon(
                Icons.camera_alt_rounded,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            //Icon photo
            IconButton(
              icon: const Icon(Icons.photo, size: 20, color: Colors.black),
              onPressed: () {},
            ),
            //Icon file
            IconButton(
              icon: const Icon(
                Icons.attach_file,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {},
            ),

            IconButton(
              icon: const Icon(Icons.arrow_left, size: 20, color: Colors.black),
              onPressed: () {
                setState(() {
                  _toggleIcons();
                });
              },
            ),
          ],

          const SizedBox(width: 4),
          //TextField to chat
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Enter your question',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 4),
          //Icon send
          if (_showIconSend)
            IconButton(
              padding: const EdgeInsets.all(2),
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: () {
                widget.onSendMessage(_controller.text);
                _controller.clear();
                setState(() {
                  _showIconSend = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
