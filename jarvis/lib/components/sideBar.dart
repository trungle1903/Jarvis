import 'package:flutter/material.dart';
import 'package:jarvis/pages/bots_page.dart';
import 'package:jarvis/pages/email_page/emailPage.dart';
import 'package:jarvis/pages/group_page.dart';
import 'package:jarvis/pages/sign_in_page/signIn.dart';

class SideBar extends StatelessWidget {
  final int selectedIndex; // Get selected index from parent

  const SideBar({super.key, required this.selectedIndex});

  void navigateTo(BuildContext context, int index, String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

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
          buildNavItem(Icons.chat, "Chat", 0, context, "/chat"),
          buildNavItem(Icons.smart_toy, "BOT", 1, context, "/bots"),
          buildNavItem(Icons.group, "Group", 2, context, "/groups"),

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
                icon: const Icon(Icons.person, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.mail_outline, color: Colors.grey),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmailPage()),
                  );
                },
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInApp()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNavItem(
    IconData icon,
    String title,
    int index,
    BuildContext context,
    String routeName,
  ) {
    bool isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue : Colors.black,
        ),
      ),
      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      onTap: () => navigateTo(context, index, routeName),
    );
  }
}
