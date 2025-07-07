import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Widget/global_appbar.dart';

class CarBookingSection extends StatelessWidget {
  const CarBookingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        title: "Car Booking",
        centerTitle: true,
        showBackButton: true,
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://cdni.iconscout.com/illustration/premium/thumb/coming-soon-2130512-1800921.png',
                height: 250.h,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Icon(Icons.car_rental, size: 100, color: Colors.grey),
              ),
              SizedBox(height: 24.h),
              Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Our car booking feature is on its way.\nStay tuned for updates!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
