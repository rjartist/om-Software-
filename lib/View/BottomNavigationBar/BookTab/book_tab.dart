import 'package:flutter/material.dart';



class BookTab extends StatelessWidget {
  const BookTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/user_placeholder.png'), // placeholder
        ),
        const SizedBox(height: 12),
        const Center(child: Text("John Doe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        const Center(child: Text("johndoe@example.com", style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 24),

        const Divider(),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text("Dark Mode"),
          trailing: Switch(value: false, onChanged: (val) {}),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text("Language"),
          subtitle: const Text("English"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text("About App"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout", style: TextStyle(color: Colors.red)),
          onTap: () {
            // Perform logout later
          },
        ),
      ],
    );
  }
}
