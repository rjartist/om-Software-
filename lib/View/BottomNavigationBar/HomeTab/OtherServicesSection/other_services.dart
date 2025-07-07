import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Widget/global_appbar.dart';

class OtherServices extends StatelessWidget {
  const OtherServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: GlobalAppBar(
        title: "Other Services",
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
                'https://cdni.iconscout.com/illustration/premium/thumb/maintenance-mode-3850931-3209124.png',
                height: 250.h,
                errorBuilder:
                    (context, error, stackTrace) => Icon(
                      Icons.miscellaneous_services,
                      size: 100,
                      color: Colors.grey,
                    ),
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
                'We’re working on bringing more services to you.\nPlease check back later!',
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
