import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_textfiled.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Clear controllers when this page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LoginProvider>(context, listen: false);
      provider.clearControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button (optional, to match Login flow you can skip this)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
        

              // App Logo Centered
              Center(
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    'assets/images/logo.png', // use same logo as login
                    fit: BoxFit.cover,
                  ),
                ),
              ),


              Text(
                "Create Account 👋",
                style: AppTextStyle.blackText(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
              // Text(
              //   "Please fill in the details below",
              //   style: AppTextStyle.greytext(),
              // ),
              vSizeBox(5),

        

              // Full Name
              GlobalTextField(
                controller: provider.fullNameController,
                label: "Full Name",
                hintText: "Enter your full name",
                isEditable: true,
                isNumberInput: false,
              ),
           

              // Email
              GlobalTextField(
                controller: provider.phonNoController,
                label: "Phone Number",
                hintText: "Enter your Phone Number",
                isEditable: true,
                isNumberInput: true,
                onChanged: (value) => provider.validatePhoneNo(value),
                errorText:
                    provider.phonNoError.isEmpty ? null : provider.phonNoError,
              ),
           
               GlobalTextField(
                controller: provider.emailController,
                label: "Email",
                hintText: "Enter your email",
                isEditable: true,
                isNumberInput: false,
                onChanged: (value) => provider.validateEmail(value),
                errorText:
                    provider.emailError.isEmpty ? null : provider.emailError,
              ),
             

              // Password
              GlobalTextField(
                controller: provider.passwordController,
                label: "Password",
                hintText: "Enter a password",
                obscureText: true,
                isEditable: true,
                isNumberInput: false,
                onChanged: (value) => provider.checkPasswordStrength(value),
              ),

              if (provider.passwordStrength.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password Strength: ${provider.passwordStrength}',
                      style: TextStyle(
                        color:
                            provider.passwordStrength == 'Strong'
                                ? Colors.green
                                : provider.passwordStrength == 'Medium'
                                ? Colors.orange
                                : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

       

              // Confirm Password
              GlobalTextField(
                controller: provider.confirmPasswordController,
                label: "Confirm Password",
                hintText: "Confirm your password",
                obscureText: true,
                isEditable: true,
                isNumberInput: false,
              ),

              const SizedBox(height: 5),

              // Sign Up Button
              GlobalButton(
                text: "SIGN UP",
                onPressed: () => provider.createAccount(context),
                isLoading: provider.isLoading,
              ),

             

              // OR Divider
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  SizedBox(width: 10),
                  Text("OR"),
                  SizedBox(width: 10),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),

          

              // Already have account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LoginProvider>(context);

//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Top gradient background with text
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.only(
//                 left: 20,
//                 right: 20,
//                 top: 45,
//                 bottom: 30,
//               ),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [AppColors.gradientStart, AppColors.gradientEnd],
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Hello",
//                     style: AppTextStyle.whiteText(
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "Create Account!",
//                     style: AppTextStyle.whiteText(
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text("Please enter details", style: AppTextStyle.whiteText()),
//                 ],
//               ),
//             ),

//             // Bottom container overlapping the top container
//             Transform.translate(
//               offset: const Offset(0, -20), // Move up to overlap
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: AppColors.bgColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 20,
//                 ),
//                 child: Column(
//                   spacing: 10,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Center(
//                       child: Image.asset(
//                         "assets/images/createAccountImg.png",
//                         height: 170.h,
//                         width: 170.w,
//                       ),
//                     ),

//                     GlobalTextField(
//                       controller: provider.fullNameController,
//                       label: "Full Name",
//                       hintText: "Enter your full name",
//                       isEditable: true,
//                       isNumberInput: false,
//                     ),

//                      GlobalTextField(
//                       controller: provider.emailController,
//                       label: "Email",
//                       hintText: "Enter your email",
//                       isEditable: true,
//                       isNumberInput: false,
//                       onChanged: (value) => provider.validateEmail(value),
//                       errorText:
//                           provider.emailError.isEmpty
//                               ? null
//                               : provider.emailError,
//                     ),

//                     TextField(
//                       controller: provider.passwordController,
//                       obscureText: provider.isObscured,
//                       onChanged:
//                           (value) => provider.checkPasswordStrength(value),
//                       cursorColor: AppColors.black,
//                       style: AppTextStyle.blackText(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 15,
//                       ),
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 15.w,
//                           vertical: 16.h,
//                         ),
//                         labelText: "Enter a password",
//                         hintText: "Enter a password",
//                         labelStyle: AppTextStyle.smallGrey(fontSize: 14.0),
//                         hintStyle: AppTextStyle.smallGrey(),
//                         floatingLabelBehavior: FloatingLabelBehavior.never,
//                         filled: true,
//                         fillColor: AppColors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: AppColors.borderColor),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(
//                             color: AppColors.borderColor,
//                             width: 1,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(
//                             color: AppColors.primaryColor.withOpacity(0.5),
//                             width: 1.5,
//                           ),
//                         ),
//                       ),
//                     ),

//                     if (provider.passwordStrength.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 6.0, left: 8),
//                         child: Text(
//                           'Password Strength: ${provider.passwordStrength}',
//                           style: TextStyle(
//                             color:
//                                 provider.passwordStrength == 'Strong'
//                                     ? Colors.green
//                                     : provider.passwordStrength == 'Medium'
//                                     ? Colors.orange
//                                     : Colors.red,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),

//                     GlobalTextField(
//                       controller: provider.confirmPasswordController,
//                       label: "Confirm Password",
//                       hintText: "Confirm your password",
//                       obscureText: true,
//                       isEditable: true,
//                       isNumberInput: false,
//                     ),

//                     const SizedBox(height: 10),

//                     GlobalButton(
//                       text: "SIGN UP",
//                       onPressed: () => provider.createAccount(context),
//                       isLoading: provider.isLoading,
//                     ),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Already have an account?",
//                           style: AppTextStyle.blackText(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text(
//                             "Sign in",
//                             style: TextStyle(
//                               color: AppColors.primaryColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
