import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkmarts/Models/MyBookings/MyBookingsModel.dart';
import 'package:gkmarts/Models/MyBookings/bookings_count_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Services/MyBookings/bookings_count_service.dart';
import 'package:gkmarts/Services/MyBookings/cancel_booking_service.dart';
import 'package:gkmarts/Services/MyBookings/my_bookings_service.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:provider/provider.dart';

class CancelBookingProvider extends ChangeNotifier {
  bool isLoading = false;

  String? _reason;
  int? _bookingId;

  String? get reason => _reason;
  int? get bookingId => _bookingId;

  void setBookingIdAndReason(int id, String value) {
    _bookingId = id;
    _reason = value;
    notifyListeners(); // if UI needs to react
  }

  Future<void> cancelBooking(BuildContext context, int id, String value) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final reqBody = {"bookingId": _bookingId, "cancellationReason": _reason};
      final response = await CancelBookingService().cancelBooking(reqBody);
      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        notifyListeners();

        GlobalSnackbar.success(context, "Success");
      } else {
        GlobalSnackbar.error(
          context,
          response.message ?? "Failed",
        );
      }
    } catch (e) {
      GlobalSnackbar.error(
        context,
        "Error loading: ${e.toString()}",
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
