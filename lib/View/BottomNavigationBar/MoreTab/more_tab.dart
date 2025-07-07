


import 'package:flutter/material.dart';


class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Search Glossary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter keyword...",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Recent Results", style: TextStyle(fontSize: 16)),
          const Expanded(
            child: Center(child: Text("No search results yet.")),
          ),
        ],
      ),
    );
  }
}
