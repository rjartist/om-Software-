import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gkmarts/Models/MyBookings/MyBookingsModel.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:gkmarts/Services/MyBookings/my_bookings_service.dart';
import 'package:gkmarts/Widget/global_snackbar.dart';
import 'package:provider/provider.dart';

class MyBookingsProvider extends ChangeNotifier {
  bool isLoading = false;
  MyBookingsModel? myBookingsModel;

  List<PastBookings> pastBookings = [];
  List<FutureBookings> futureBookings = [];
  List<CancelledBookings> cancelledBookings = [];

  Future<void> fetchBookings(BuildContext context) async {
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    if (!isOnline) {
      GlobalSnackbar.error(context, "No internet connection");
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      final response = await MyBookingsService().getMyBookings(
        context,
      ); // implement this
      if (response.isSuccess) {
        final data = jsonDecode(response.responseData);
        myBookingsModel = MyBookingsModel.fromJson(data);
        pastBookings = myBookingsModel?.pastBookings ?? [];
        futureBookings = myBookingsModel?.futureBookings ?? [];
        cancelledBookings = myBookingsModel?.cancelledBookings ?? [];
        notifyListeners();
        // print("pastBookings: ${pastBookings.toString()}");
        // print("futureBookings: ${futureBookings.toString()}");
        // print("cancelledBookings: ${cancelledBookings.toString()}");

        // You can cast futureBookings to List<PastBookings> if structure matches
        // if (bookings.futureBookings != null) {
        //   futureBookings = bookings.futureBookings!
        //       .map((e) => PastBookings.fromJson(e)) // or adjust type accordingly
        //       .toList();
        // }

        // GlobalSnackbar.success(context, "Bookings loaded");
      } else {
        // GlobalSnackbar.error(
        //   context,
        //   response.message ?? "Failed to load bookings",
        // );
      }
    } catch (e) {
      // GlobalSnackbar.error(context, "Error loading bookings: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
