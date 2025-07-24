import 'package:flutter/material.dart';
import 'package:gkmarts/Models/BookTabModel/venue_detail_model.dart';
import 'package:gkmarts/Provider/HomePage/Bottom_navigationBar/bottom_navigationbar.dart';
import 'package:gkmarts/Provider/HomePage/book_tab_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CancellationSuccessDialog extends StatelessWidget {
  final int bookingId;
  final String venueName;
  final String reason;

  const CancellationSuccessDialog({
    super.key,
    required this.bookingId,
    required this.venueName,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 60, color: Colors.green),
          const SizedBox(height: 12),
          const Text(
            "Cancellation Request Sent",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text("Booking ID: $bookingId"),
          Text("Venue: $venueName"),
          Text("Reason: $reason"),
          const SizedBox(height: 12),
          const Text(
            "Your request has been sent.\nWe’ll notify you shortly.\nFor help, call CX support.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GlobalPrimaryButton(
                  text: "Back to Home",
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    context.read<BookTabProvider>().clearBookingData();
                    context.read<BottomNavProvider>().changeIndex(0);
                  },
                  height: 42,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlobalSmallButton(
                  borderColor: AppColors.borderColor,
                  textColor: AppColors.black,
                  backgroundColor: Colors.grey.shade100,
                  text: "Call Now",
                  onTap: () async {
                    final Uri phoneUri = Uri(
                      scheme: 'tel',
                      path: '18001234567',
                    );
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      GlobalSnackbar.error(context, "Could not launch dialer.");
                    }
                  },
                  height: 42,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CancelBookingSheet extends StatefulWidget {
  final VenueDetailModel model;
  final String bookingDateTime;

  const CancelBookingSheet({
    super.key,
    required this.model,
    required this.bookingDateTime,
  });

  @override
  State<CancelBookingSheet> createState() => _CancelBookingSheetState();
}

class _CancelBookingSheetState extends State<CancelBookingSheet> {
  String? selectedReason;

  final List<String> reasons = [
    "Change of plans",
    "Found a better option",
    "Incorrect booking details",
    "Other",
  ];

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.blackText(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text("Cancellation Request", style: AppTextStyle.titleText()),
              const SizedBox(height: 16),

              // Venue Info
              _infoRow(Icons.location_on_outlined, widget.model.modifiedFacility.facilityName),
              const SizedBox(height: 8),
              _infoRow(Icons.calendar_today_outlined, widget.bookingDateTime),
              const SizedBox(height: 20),

              // Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reason for Cancellation",
                  style: AppTextStyle.blackText(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),

              // Dropdown
              DropdownButtonFormField<String>(
                value: selectedReason,
                hint: const Text("Select reason"),
                items:
                    reasons.map((reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.fiber_manual_record,
                              size: 6,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              reason,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => selectedReason = value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.borderColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                dropdownColor: Colors.white,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: GlobalSmallButton(
                      borderColor: AppColors.borderColor,
                      textColor: AppColors.black,
                      backgroundColor: Colors.grey.shade100,
                      text: "Don't Cancel",
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlobalPrimaryButton(
                      text: "Submit Request",
                      onTap: () {
                        if (selectedReason == null) {
                          GlobalSnackbar.error(
                            context,
                            "Please select a reason.",
                          );
                        } else {
                          final bookingId =
                              context.read<BookTabProvider>().bookingId;
                          final venueName = widget.model.modifiedFacility.facilityName;
                          final reason = selectedReason;
                          Navigator.pop(context);

                          Future.delayed(const Duration(milliseconds: 300), () {
                            showDialog(
                              context: navigatorKey.currentContext!,
                              barrierDismissible: false,
                              builder:
                                  (_) => CancellationSuccessDialog(
                                    bookingId: bookingId ?? 0,
                                    venueName: venueName,
                                    reason: reason!,
                                  ),
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bottom note
              Text(
                "Cancellations are subject to facility policies.\nCharges may apply.",
                textAlign: TextAlign.center,
                style: AppTextStyle.greytext(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CallNow extends StatelessWidget {
  final String title;
  final String description;
  final String phoneNumber;
  final VoidCallback onConfirm;

  const CallNow({
    super.key,
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.onConfirm,
  });

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
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              "📞 $phoneNumber",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GlobalSmallButton(
                    borderColor: AppColors.borderColor,
                    textColor: AppColors.black,
                    backgroundColor: AppColors.white,
                    text: "Close",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlobalPrimaryButton(
                    text: "Call Now",
                    onTap: () {
                      _makePhoneCall(phoneNumber);
                      Navigator.pop(context);
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      GlobalSnackbar.error(
        navigatorKey.currentContext!,
        "Could not launch dialer",
      );
    }
  }
}
