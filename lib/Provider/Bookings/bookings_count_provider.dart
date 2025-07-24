import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkmarts/Models/MyBookings/MyBookingsModel.dart';
import 'package:gkmarts/Models/MyBookings/bookings_count_model.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Services/MyBookings/bookings_count_service.dart';
import 'package:gkmarts/Services/MyBookings/my_bookings_service.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:provider/provider.dart';

class BookingsCountProvider extends ChangeNotifier {
  bool isLoading = false;

  BookingCount? bookingCount;

  Future<void> fetchBookingsCounts(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await BookingsCountService().getBookingsCount(
        context,
      ); // implement this
      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        bookingCount = BookingCount.fromJson(data);
        notifyListeners();

        // GlobalSnackbar.success(context, "Bookings count loaded");
      } else {
        // GlobalSnackbar.error(
        //   context,
        //   response.message ?? "Failed to load bookings count",
        // );
      }
    } catch (e) {
      // GlobalSnackbar.error(
      //   context,
      //   "Error loading bookings count: ${e.toString()}",
      // );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
