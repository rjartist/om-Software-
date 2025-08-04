import 'package:flutter/material.dart';

import 'package:gkmarts/Provider/Login/login_provider.dart';

import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/View/Auth_view/create_account.dart';
import 'package:gkmarts/View/Auth_view/forgot.dart';
import 'package:gkmarts/View/home_page.dart';

import 'package:gkmarts/Widget/global_button.dart';
import 'package:gkmarts/Widget/global_textfiled.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
          
                // App Logo Centered
                Center(
                  child: Container(
                    height: 70,
                    // width: 171,
                    padding: const EdgeInsets.all(16),
          
                    child: Image.asset(
                      'assets/images/logo.png',
                      // 'assets/images/loginImg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          
                vSizeBox(10),
          
                // Welcome Text
                Text(
                  "Join the CX Play Community",
                  style: AppTextStyle.blackText(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
          
                const SizedBox(height: 50),
          
                Text(
                  "Login",
                  style: AppTextStyle.primaryText(fontWeight: FontWeight.bold),
                ),
                vSizeBox(30),
          
                // Email Field
                GlobalTextField(
                  controller: provider.emailController,
                  label: "Email",
                  hintText: "Enter your email",
                  isEditable: true,
                  isNumberInput: false,
                ),
          
                const SizedBox(height: 20),
          
                // Password Field
                GlobalTextField(
                  controller: provider.passwordController,
                  label: "Password",
                  hintText: "Enter your password",
                  obscureText: true,
                  isEditable: true,
                  isNumberInput: false,
                ),
          
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                          child: ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
          
                const SizedBox(height: 10),
          
                // Login Button
                GlobalButton(
                  text: "Login",
                  onPressed: () => provider.login(context),
                  isLoading: provider.isLoading,
                ),
          
                const SizedBox(height: 25),
          
                // OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    const SizedBox(width: 10),
                    const Text("OR"),
                    const SizedBox(width: 10),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
          
                const SizedBox(height: 25),
          
                // Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                         FocusScope.of(context).unfocus();
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                            child: const CreateAccount(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign up",
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
      ),
    );
  }
}
