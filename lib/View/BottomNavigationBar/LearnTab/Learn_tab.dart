import 'package:flutter/material.dart';


class LearnTab extends StatelessWidget {
  const LearnTab({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyBookmarks = <String>["Algorithm", "Binary Tree", "Flutter", "Provider"];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Saved Bookmarks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: dummyBookmarks.isEmpty
                ? const Center(child: Text("No bookmarks yet."))
                : ListView.separated(
                    itemCount: dummyBookmarks.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.bookmark),
                        title: Text(dummyBookmarks[index]),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Navigate to word detail page later
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
