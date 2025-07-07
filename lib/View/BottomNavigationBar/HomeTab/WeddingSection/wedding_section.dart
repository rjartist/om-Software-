import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Widget/global_appbar.dart';

class WeddingSection extends StatelessWidget {
  const WeddingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
         appBar: GlobalAppBar(
        title: "Wedding Booking",
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
                'https://cdni.iconscout.com/illustration/premium/thumb/wedding-planning-5794132-4844893.png',
                height: 250.h,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.favorite, size: 100, color: Colors.pinkAccent),
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
                'Wedding booking features are on their way.\nGet ready to celebrate with ease!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
