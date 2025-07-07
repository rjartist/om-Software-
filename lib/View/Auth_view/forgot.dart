
import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Login/login_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_textfiled.dart';

import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      // appBar: GlobalAppBar(title: "",showBackButton: true,),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),

              const SizedBox(height: 30),

              // Centered Image
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/createAccountImg.png',

                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Title
              Text(
                "Forgot Password?",
                style: AppTextStyle.boldBlackText(
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Enter your email and we’ll send you a reset link.",
                style: AppTextStyle.greytext(),
              ),

              const SizedBox(height: 40),

              // Email Field
              GlobalTextField(
                controller: provider.emailController,
                label: "Email",
                hintText: "Enter your registered email",
                isEditable: true,
                isNumberInput: false,
              ),

              const SizedBox(height: 30),

              // Reset Button
              GlobalButton(
                text: "Send Reset Link",
                isLoading: provider.isForgotPassword,
                onPressed: () {
                  provider.forgotPassword(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}