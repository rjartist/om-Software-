import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_textfiled.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class MobileInputPage extends StatelessWidget {
  final bool isHome;
  const MobileInputPage({super.key, this.isHome = false});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          Provider.of<LoginProvider>(context, listen: false).clearMobileOtp();
        }
      },
      child: Scaffold(
        // appBar: GlobalAppBar(title: "Login to Continue", centerTitle: true),
        backgroundColor: AppColors.bgColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              vSizeBox(60),
              Container(
                width: 120.w,
                // height: 100,
                // padding: const EdgeInsets.all(20),
                // decoration: const BoxDecoration(color: Colors.white),
                child: Image.asset(
                  'assets/images/splash-removebg-preview.png',
                  fit: BoxFit.contain,
                ),
              ),
              vSizeBox(20),
              Text("Hi there!", style: AppTextStyle.blackText(fontSize: 28)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Please enter a 10-digit valid mobile number to receive OTP",
                  style: AppTextStyle.blackText(
                    fontSize: 14,
                    color: AppColors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              GlobalTextField(
                controller: provider.mobileController,
                label: "Mobile Number",
                hintText: "Enter mobile number",
                isNumberInput: true,
                obscureText: false,
                isEditable: true,
                errorText:
                    provider.mobileErrorText.isEmpty
                        ? null
                        : provider.mobileErrorText,
                onChanged: provider.onMobileChanged,
              ),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyle.greytext(),
                  children: [
                    const TextSpan(text: "By proceeding, you agree to our\n"),
                    TextSpan(
                      text: "Terms & Conditions",
                      style: AppTextStyle.primaryText(fontSize: 15),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy.",
                      style: AppTextStyle.primaryText(fontSize: 15),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlobalButton(
                text: "Get OTP",
                height: 45,
                borderRadius: 12,
                isLoading: provider.isOtpSending,
                onPressed: () async {
                  await provider.sendOtp(
                    context,
                    provider.mobileController.text,
                  );
                  if (provider.isOtpSent) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => OtpVerifyPage(
                              mobileNumber: provider.mobileController.text,
                            ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpVerifyPage extends StatefulWidget {
  final String mobileNumber;
  final bool isHome;
  const OtpVerifyPage({
    super.key,
    required this.mobileNumber,
    this.isHome = false,
  });

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            vSizeBox(60),
            SizedBox(
              width: 120.w,

              child: Image.asset(
                'assets/images/splash-removebg-preview.png',
                fit: BoxFit.contain,
              ),
            ),
            vSizeBox(20),
            Text(
              "OTP Verification",
              style: AppTextStyle.blackText(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter the OTP sent to\n+91 ${widget.mobileNumber}",
              style: AppTextStyle.blackText(
                fontSize: 14,
                color: AppColors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: otpController,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              autoFocus: true,
              animationDuration: const Duration(milliseconds: 300),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              enableActiveFill: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(4),
                fieldHeight: 42,
                fieldWidth: 42,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedColor: AppColors.primaryColor,
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.grey.shade300,
              ),
              onChanged: (value) {
                if (value.length == 6 && !provider.isOtpVerifying) {
                  provider.verifyOtp(
                    context,
                    widget.mobileNumber,
                    value, // ← use value, not otpController.text
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                style: AppTextStyle.smallGrey(fontSize: 13),
                children: [
                  const TextSpan(text: "Didn't receive OTP? "),
                  TextSpan(
                    text:
                        provider.resendSeconds > 0
                            ? "Resend in (00:${provider.resendSeconds.toString().padLeft(2, '0')})"
                            : "Resend OTP",
                    style: AppTextStyle.primaryText(fontSize: 13).copyWith(
                      decoration:
                          provider.resendSeconds == 0
                              ? TextDecoration.underline
                              : TextDecoration.none,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            if (provider.resendSeconds == 0) {
                              provider.sendOtp(context, widget.mobileNumber);
                            }
                          },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GlobalButton(
              text: "Verify & Continue",
              height: 45,
              borderRadius: 10,
              isLoading: provider.isOtpVerifying,
              onPressed: () async {
                await provider.verifyOtp(
                  context,
                  widget.mobileNumber,
                  otpController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
