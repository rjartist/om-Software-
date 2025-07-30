import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_textfiled.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class MobileInputPage extends StatelessWidget {
  const MobileInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: GlobalAppBar(title: "Login to Continue", centerTitle: true),
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 40),
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
              key: const ValueKey("mobile_input"),
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
                await provider.sendOtp(context, provider.mobileController.text);
                if (provider.isOtpSent) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OtpVerifyPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OtpVerifyPage extends StatelessWidget {
  const OtpVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    final mobileNumber = provider.mobileController.text;

    return Scaffold(
      appBar: GlobalAppBar(title: "Login to Continue", centerTitle: true),
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "OTP Verification",
              style: AppTextStyle.blackText(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter the OTP sent to\n+91 $mobileNumber",
              style: AppTextStyle.blackText(
                fontSize: 14,
                color: AppColors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PinCodeTextField(
              key: const ValueKey("otp_input"),
              appContext: context,
              length: 6,
              controller: provider.otpController,
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
              onChanged: (_) {},
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
                              provider.sendOtp(context, mobileNumber);
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
                await provider.verifyOtp(context, mobileNumber);
              },
            ),
          ],
        ),
      ),
    );
  }
}




// class MobileOtpScreen extends StatefulWidget {
//   const MobileOtpScreen({super.key});

//   @override
//   State<MobileOtpScreen> createState() => _MobileOtpScreenState();
// }

// class _MobileOtpScreenState extends State<MobileOtpScreen> {
//   final PageController _pageController = PageController();

//   void goToOtpPage() {
//     _pageController.animateToPage(
//       1,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   void goToMobilePage() {
//     _pageController.animateToPage(
//       0,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LoginProvider>(context);

//     return Scaffold(
//       appBar: GlobalAppBar(title: "Login to Continue", centerTitle: true),
//       backgroundColor: AppColors.bgColor,
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: [
//           _buildMobilePage(context, provider),
//           _buildOtpPage(context, provider),
//         ],
//       ),
//     );
//   }

//   Widget _buildMobilePage(BuildContext context, LoginProvider provider) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           Text("Hi there!", style: AppTextStyle.blackText(fontSize: 28)),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: Text(
//               "Please enter a 10-digit valid mobile number to receive OTP",
//               style: AppTextStyle.blackText(
//                 fontSize: 14,
//                 color: AppColors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 30),
//           GlobalTextField(
//             controller: provider.mobileController,
//             label: "Mobile Number",
//             hintText: "Enter mobile number",
//             isNumberInput: true,
//             obscureText: false,
//             isEditable: true,
//             errorText:
//                 provider.mobileErrorText.isEmpty
//                     ? null
//                     : provider.mobileErrorText,
//             onChanged: provider.onMobileChanged,
//           ),
//           const SizedBox(height: 30),
//           RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               style: AppTextStyle.greytext(),
//               children: [
//                 const TextSpan(text: "By proceeding, you agree to our"),
//                 const TextSpan(text: "\n"),
//                 TextSpan(
//                   text: "Terms & Conditions",
//                   style: AppTextStyle.primaryText(fontSize: 15),
//                   recognizer:
//                       TapGestureRecognizer()
//                         ..onTap = () {
//                           // TODO: Navigate to Terms & Conditions
//                         },
//                 ),
//                 const TextSpan(text: " and "),
//                 TextSpan(
//                   text: "Privacy Policy.",
//                   style: AppTextStyle.primaryText(fontSize: 15),
//                   recognizer:
//                       TapGestureRecognizer()
//                         ..onTap = () {
//                           // TODO: Navigate to Privacy Policy
//                         },
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           GlobalButton(
//             text: "Get OTP",
//             height: 45,
//             borderRadius: 12,
//             isLoading: provider.isOtpSending,
//             onPressed: () async {
//               await provider.sendOtp(context, provider.mobileController.text);
//               if (provider.isOtpSent) {
//                 goToOtpPage();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOtpPage(BuildContext context, LoginProvider provider) {
//     String mobileNumber = provider.mobileController.text;

//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text("OTP Verification", style: AppTextStyle.blackText(fontSize: 28)),
//           const SizedBox(height: 8),
//           Text(
//             "Enter the OTP sent to\n+91 $mobileNumber",
//             style: AppTextStyle.blackText(
//               fontSize: 14,
//               color: AppColors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),

//           /// OTP Input Field
//           PinCodeTextField(
//             appContext: context,
//             length: 6,
//             controller: provider.otpController,
//             keyboardType: TextInputType.number,
//             animationType: AnimationType.fade,
//             autoFocus: true,
//             animationDuration: const Duration(milliseconds: 300),
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             enableActiveFill: true,
//             pinTheme: PinTheme(
//               shape: PinCodeFieldShape.box,
//               borderRadius: BorderRadius.circular(4),
//               fieldHeight: 42,
//               fieldWidth: 42,
//               activeFillColor: Colors.white,
//               selectedFillColor: Colors.white,
//               inactiveFillColor: Colors.white,
//               selectedColor: AppColors.primaryColor,
//               activeColor: AppColors.primaryColor,
//               inactiveColor: Colors.grey.shade300,
//             ),
//             onChanged: (_) {},
//           ),

//           const SizedBox(height: 12),
//           Text.rich(
//             TextSpan(
//               style: AppTextStyle.smallGrey(fontSize: 13),
//               children: [
//                 const TextSpan(text: "Didn't receive OTP? "),
//                 TextSpan(
//                   text:
//                       provider.resendSeconds > 0
//                           ? "Resend in (00:${provider.resendSeconds.toString().padLeft(2, '0')})"
//                           : "Resend OTP",
//                   style: AppTextStyle.primaryText(fontSize: 13).copyWith(
//                     decoration:
//                         provider.resendSeconds == 0
//                             ? TextDecoration.underline
//                             : TextDecoration.none,
//                   ),
//                   recognizer:
//                       TapGestureRecognizer()
//                         ..onTap = () {
//                           if (provider.resendSeconds == 0) {
//                             provider.sendOtp(context, mobileNumber);
//                           }
//                         },
//                 ),
//               ],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           GlobalButton(
//             text: "Verify & Continue",
//             height: 45,
//             borderRadius: 10,
//             isLoading: provider.isOtpVerifying,
//             onPressed: () async {
//               await provider.verifyOtp(context, mobileNumber);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
////------------------------------
// class MobileInputWidget extends StatelessWidget {
//   const MobileInputWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LoginProvider>(context);

//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: GlobalAppBar(title: "Login To Continue", showBackButton: true),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               vSizeBox(40),
//               Text("Hi there!", style: AppTextStyle.blackText(fontSize: 28)),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Text(
//                   "Please enter a 10-digit valid mobile number to receive OTP",
//                   style: AppTextStyle.blackText(
//                     fontSize: 14,
//                     color: AppColors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               GlobalTextField(
//                 controller: provider.mobileController,
//                 label: "Mobile Number",
//                 hintText: "Enter mobile number",
//                 isNumberInput: true,
//                 obscureText: false,
//                 isEditable: true,
//                 errorText:
//                     provider.mobileErrorText.isEmpty
//                         ? null
//                         : provider.mobileErrorText,
//                 onChanged: provider.onMobileChanged,
//               ),
//               const SizedBox(height: 30),
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   style: AppTextStyle.greytext(),
//                   children: [
//                     const TextSpan(text: "By proceeding, you agree to our"),
//                     const TextSpan(text: "\n"), // 👈 line break
//                     TextSpan(
//                       text: "Terms & Conditions",
//                       style: AppTextStyle.primaryText(fontSize: 15),
//                       recognizer:
//                           TapGestureRecognizer()
//                             ..onTap = () {
//                               // TODO: Handle T&C navigation
//                             },
//                     ),
//                     const TextSpan(text: " and "),
//                     TextSpan(
//                       text: "Privacy Policy.",
//                       style: AppTextStyle.primaryText(fontSize: 15),
//                       recognizer:
//                           TapGestureRecognizer()
//                             ..onTap = () {
//                               // TODO: Handle Privacy Policy navigation
//                             },
//                     ),
//                   ],
//                 ),
//               ),

//               vSizeBox(24),
//               GlobalButton(
//                 text: "Get OTP",
//                 height: 45,
//                 borderRadius: 12,
//                 isLoading: provider.isOtpSending,
//                 onPressed: () async {
//                   await provider.sendOtp(
//                     context,
//                     provider.mobileController.text,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OtpInputWidget extends StatelessWidget {
//   final String mobileNumber;

//   const OtpInputWidget({super.key, required this.mobileNumber});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LoginProvider>(context);

//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: GlobalAppBar(title: "OTP Verification", showBackButton: true),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "OTP Verification",
//                 style: AppTextStyle.blackText(fontSize: 28),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Enter the OTP sent to\n+91 $mobileNumber",
//                 style: AppTextStyle.blackText(
//                   fontSize: 14,
//                   color: AppColors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),

//               /// OTP Input
//               PinCodeTextField(
//                 appContext: context,
//                 length: 4,
//                 controller: provider.otpController,
//                 keyboardType: TextInputType.number,
//                 animationType: AnimationType.fade,
//                 autoFocus: true,
//                 animationDuration: const Duration(milliseconds: 300),
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 enableActiveFill: true, // Important to show fill color
//                 pinTheme: PinTheme(
//                   shape: PinCodeFieldShape.box,
//                   borderRadius: BorderRadius.circular(4),
//                   fieldHeight: 42,
//                   fieldWidth: 42,
//                   activeFillColor: Colors.white,
//                   selectedFillColor: Colors.white,
//                   inactiveFillColor: Colors.white,
//                   selectedColor: AppColors.primaryColor,
//                   activeColor: AppColors.primaryColor,
//                   inactiveColor: Colors.grey.shade300,
//                 ),
//                 onChanged: (_) {},
//               ),

//               const SizedBox(height: 12),
//               Text.rich(
//                 TextSpan(
//                   style: AppTextStyle.smallGrey(fontSize: 13),
//                   children: [
//                     const TextSpan(text: "Didn't receive OTP? "),
//                     TextSpan(
//                       text:
//                           provider.resendSeconds > 0
//                               ? "Resend in (00:${provider.resendSeconds.toString().padLeft(2, '0')})"
//                               : "Resend OTP",
//                       style: AppTextStyle.primaryText(fontSize: 13).copyWith(
//                         decoration:
//                             provider.resendSeconds == 0
//                                 ? TextDecoration.underline
//                                 : TextDecoration.none,
//                       ),
//                       recognizer:
//                           TapGestureRecognizer()
//                             ..onTap = () {
//                               if (provider.resendSeconds == 0) {
//                                 provider.sendOtp(context, mobileNumber);
//                               }
//                             },
//                     ),
//                   ],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               GlobalButton(
//                 text: "Verify & Continue",
//                 height: 45,
//                 borderRadius: 10,
//                 isLoading: provider.isOtpSending,
//                 onPressed: () async {
//                   await provider.verifyOtp(context, mobileNumber);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MobileOtpLoginDialog extends StatelessWidget {
//   const MobileOtpLoginDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoginProvider>(
//       builder: (context, provider, _) {
//         return AnimatedSwitcher(
//           duration: const Duration(milliseconds: 300),
//           transitionBuilder: (child, animation) {
//             return SlideTransition(
//               position: Tween<Offset>(
//                 begin: const Offset(1.0, 0.0),
//                 end: Offset.zero,
//               ).animate(animation),
//               child: child,
//             );
//           },
//           child:
//               provider.isOtpSent
//                   ? _buildOtpUI(context, provider)
//                   : _buildMobileInputUI(context, provider),
//         );
//       },
//     );
//   }

//   Widget _buildMobileInputUI(BuildContext context, LoginProvider provider) {
//     return Padding(
//       key: const ValueKey(1),
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "Hi there!",
//             style: AppTextStyle.titleText(),
//             textAlign: TextAlign.center,
//           ),
//           vSizeBox(8),
//           Text(
//             "Please enter a 10-digit valid mobile number to receive OTP",
//             style: AppTextStyle.mediumGrey(),
//             textAlign: TextAlign.center,
//           ),
//           vSizeBox(24),
//           GlobalTextField(
//             controller: provider.mobileController,
//             label: "Mobile Number",
//             hintText: "Enter mobile number",
//             isNumberInput: true,
//             obscureText: false,
//             isEditable: true,
//             onChanged: (val) => provider.onMobileChanged(val),
//           ),
//           vSizeBox(16),
//           RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               style: AppTextStyle.smallGrey(fontSize: 13), // base style
//               children: [
//                 const TextSpan(text: "By proceeding, you agree to our "),
//                 TextSpan(
//                   text: "Terms & Conditions",
//                   style: AppTextStyle.primaryText(fontSize: 13),
//                   recognizer:
//                       TapGestureRecognizer()
//                         ..onTap = () {
//                           // TODO: Handle terms click
//                         },
//                 ),
//                 const TextSpan(text: " and "),
//                 TextSpan(
//                   text: "Privacy Policy.",
//                   style: AppTextStyle.primaryText(fontSize: 13),
//                   recognizer:
//                       TapGestureRecognizer()
//                         ..onTap = () {
//                           // TODO: Handle privacy policy click
//                         },
//                 ),
//               ],
//             ),
//           ),
//           vSizeBox(24),
//           GlobalButton(
//             text: "Get OTP",
//             height: 45,
//             borderRadius: 12,
//             isLoading: provider.isOtpSending,
//             onPressed: () async {
//               final sent = await provider.sendOtp(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//  Widget _buildOtpUI(BuildContext context, LoginProvider provider) {
//   return Padding(
//     key: const ValueKey(2),
//     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           "OTP Verification",
//           style: AppTextStyle.titleText(),
//           textAlign: TextAlign.center,
//         ),
//         vSizeBox(8),
//         Text(
//           "Please enter the OTP sent to \n+91 ${provider.mobileController.text}",
//           style: AppTextStyle.mediumGrey(),
//           textAlign: TextAlign.center,
//         ),
//         vSizeBox(24),

//         // OTP Input using pin_code_fields
//         PinCodeTextField(
//           appContext: context,
//           length: 4,
//           controller: provider.otpController,
//           keyboardType: TextInputType.number,
//           animationType: AnimationType.fade,
//           autoFocus: true,
//           pinTheme: PinTheme(
//             shape: PinCodeFieldShape.box,
//             borderRadius: BorderRadius.circular(8),
//             fieldHeight: 50,
//             fieldWidth: 50,
//             activeFillColor: Colors.white,
//             selectedColor: AppColors.primaryColor,
//             activeColor: AppColors.primaryColor,
//             inactiveColor: Colors.grey,
//           ),
//           animationDuration: const Duration(milliseconds: 300),
//           onChanged: (value) {},
//         ),

//         vSizeBox(16),

//         // Resend OTP text and timer
//         Text.rich(
//           TextSpan(
//             style: AppTextStyle.smallGrey(),
//             children: [
//               const TextSpan(text: "Didn't receive OTP? "),
//               TextSpan(
//                 text: provider.resendSeconds > 0
//                     ? "Resend in (00:${provider.resendSeconds.toString().padLeft(2, '0')})"
//                     : "Resend OTP",
//                 style: AppTextStyle.primaryText(fontSize: 13),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     if (provider.resendSeconds == 0) {
//                       // provider.resendOtp(context);
//                     }
//                   },
//               ),
//             ],
//           ),
//         ),

//         vSizeBox(24),

//         // Submit Button
//         GlobalButton(
//           text: "Verify & Continue",
//           height: 45,
//           borderRadius: 12,
//           // isLoading: provider.isOtpVerifying,
//           onPressed: () async {
//             bool success = await provider.verifyOtp(context);
//             if (success) {
//               Navigator.of(context).pop();
//               provider.onLoginSuccess?.call();
//             }
//           },
//         ),

//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel"),
//         ),
//       ],
//     ),
//   );
// }
// }

// void showLoginDialog(BuildContext context, VoidCallback onSuccess) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (ctx) {
//       return ChangeNotifierProvider(
//         create: (_) => LoginProvider()..onLoginSuccess = onSuccess,
//         child: SafeArea(
//           // 👈 wrap with SafeArea
//           child: Center(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.9,
//               child: Material(
//                 color: AppColors.bgColor,
//                 borderRadius: const BorderRadius.all(Radius.circular(20)),
//                 child: const MobileOtpLoginDialog(),
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
