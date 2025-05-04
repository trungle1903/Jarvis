import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/pages/auth/signIn.dart';
import 'package:jarvis/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: jvLightBlue,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: jvLightBlue),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: jvLightBlue,
                  radius: 24,
                  child: Image.asset('assets/logos/jarvis.png'),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Jarvis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: jvBlue,
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
          buildNavItem(Icons.storage_rounded, "Data", 2, context, "/knowledge-base"),
          buildNavItem(Icons.email, "Email Generator", 3, context, "/email"),
          buildNavItem(Icons.price_check, "Pricing", 4, context, "/pricing"),
          const Spacer(),
          Tooltip(
            message: 'Desktop/Mobile App',
            child: ListTile(
              leading: const Icon(Icons.devices, color: Colors.black54),
              title: const Text(
                'Desktop/Mobile App',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {},
            ),
          ),
          // Bottom Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Tooltip(
                message: 'User Center',
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: 'Feedback',
                child: IconButton(
                  icon: const Icon(Icons.attach_email, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: 'Help Center',
                child: IconButton(
                  icon: const Icon(Icons.help_outline, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: 'Give us a 5-star',
                child: IconButton(
                  icon: const Icon(Icons.star_border, color: Colors.grey),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: 'Log out',
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () async {
                    final confirmed = await showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text('Confirm Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );

                    if (confirmed == true) {
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      await authProvider.logout();

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/signIn',
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                ),
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
      leading: Icon(icon, color: isSelected ? jvBlue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? jvBlue : Colors.black,
        ),
      ),
      tileColor: isSelected ? Colors.white : Colors.transparent,
      onTap: () => navigateTo(context, index, routeName),
    );
  }
}
