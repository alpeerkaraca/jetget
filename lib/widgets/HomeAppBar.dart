import 'package:flutter/material.dart';
import 'package:jetget/palette.dart';
import 'package:jetget/pages/notifications.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = ColorPalette();
    return Container(
      color: colorPalette.black.withOpacity(0.9),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 0),
            child: Text(
              "JetGet",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          const Spacer(),
          Badge(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(7),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(),
                  ),
                );
              },
              child: const Icon(
                Icons.notifications,
                size: 32,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
