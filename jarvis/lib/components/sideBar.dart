import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with logo and title
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 24,
                  child: Image.asset('assets/logos/jarvis.png'),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Jarvis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Navigation Items
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.blue),
            title: const Text(
              'Chat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            tileColor: Colors.blue.withOpacity(0.1),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy, color: Colors.grey),
            title: const Text('BOT'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.group, color: Colors.grey),
            title: const Text('Group'),
            onTap: () {},
          ),
          const Spacer(),

          // Desktop/Mobile App Section
          ListTile(
            leading: const Icon(Icons.devices, color: Colors.black54),
            title: const Text(
              'Desktop/Mobile App',
              style: TextStyle(fontSize: 12),
            ),
            onTap: () {},
          ),

          // Bottom Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.mail_outline, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.help_outline, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.star_border, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
