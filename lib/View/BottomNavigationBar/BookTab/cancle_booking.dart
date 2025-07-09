import 'package:flutter/material.dart';
import 'package:gkmarts/Widget/global_button.dart';

class CancelBookingSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const CancelBookingSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Cancel Booking?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Are you sure you want to cancel your booking?\nTo proceed, please contact support.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            const Text(
              "📞 +91 000000000",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    child: const Text("Close"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlobalSmallButton(text: "Confirm Cancel", onTap:(){
                      Navigator.pop(context); // Close bottom sheet
                      onConfirm(); // Call confirm logic
                  })
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
