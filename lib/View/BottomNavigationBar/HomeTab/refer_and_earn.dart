import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gkmarts/Provider/Profile/referral_link_provider.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_Text_style.dart';
import 'package:gkmarts/Utils/ThemeAndColors/app_colors.dart';
import 'package:gkmarts/Widget/global_appbar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({super.key});

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  String? referralCode;
  String? referralLink;
  bool isLoading = true;

  // Example static data
  final List<Map<String, dynamic>> referrals = [
    {
      "title": "You have not earned points yet",
      "status": "Pending Booking",
      "points": "0",
    },
    {
      "title": "You have earned points",
      "status": "Bonus Earned",
      "points": "500",
    },
    {
      "title": "You have earned points",
      "status": "Bonus Earned",
      "points": "500",
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final referralProvider = context.read<ReferralLinkProvider>();

      referralProvider.genrateReferralLink(context);
    });
    _fetchReferralCode();
  }

  // Simulated API call to get user's referral code
  Future<void> _fetchReferralCode() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API delay
    // Example — Replace with actual API response
    String fetchedCode = "CX1234";

    setState(() {
      referralCode = fetchedCode;
      referralLink = "https://cxplayground.in/referral?code=$fetchedCode";
      isLoading = false;
    });
  }

  void _copyToClipboard() {
    if (referralLink != null) {
      Clipboard.setData(ClipboardData(text: referralLink!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Referral link copied to clipboard!"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _shareReferral(String? referralLink, String refCode) {
    if (referralLink != null) {
      Share.share(
        "Join me on CX Play! Use my referral link: ${'https://cxplay-bb5b4.web.app/refer/?code=$refCode'}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: GlobalAppBar(title: "Refer & Earn", showBackButton: true),
      body: Consumer<ReferralLinkProvider>(
        builder: (context, provider, _) {
          final referral = provider.ReferralLink;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Image.asset("assets/images/team.png", height: 150),
                  SizedBox(height: 20),
                  Text(
                    "Get Rewards for Every Referral!",
                    style: AppTextStyle.blackText(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Share your referral code with friends and earn coins when they install and complete their first booking on CX Play. The more you refer, the more you earn!",
                    style: AppTextStyle.blackText(
                      fontSize: 12,
                      color: AppColors.greytext,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      _copyToClipboard();
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      dashPattern: [6, 3], // [dash length, gap length]
                      color: Colors.grey,
                      strokeWidth: 2,
                      child: Container(
                        height: 60,
                        width: 160,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              referral?.referralCode ?? "",
                              style: AppTextStyle.blackText(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.copy, color: AppColors.black),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      _shareReferral(
                        referral?.referralLink,
                        referral?.referralCode ?? "",
                      );
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gradientRedStart,
                            AppColors.gradientRedEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, color: AppColors.white, size: 20),
                            SizedBox(width: 5),
                            Text(
                              "Share",
                              style: AppTextStyle.blackText(
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "Referral history",
                  //         style: AppTextStyle.blackText(
                  //           fontSize: 14,
                  //           color: AppColors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // // Referral history list
                  // referrals.isNotEmpty
                      // ? Column(
                      //   children:
                      //       referrals.map((user) {
                      //         return Padding(
                      //           padding: const EdgeInsets.only(top: 15),
                      //           child: Card(
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             color: AppColors.bgColor,
                      //             child: ListTile(
                      //               leading: CircleAvatar(
                      //                 backgroundColor: Colors.red.shade100,
                      //                 child: Text(
                      //                   user['points'],
                      //                   style: AppTextStyle.blackText(
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 ),
                      //               ),
                      //               title: Text(
                      //                 user['title'],
                      //                 style: AppTextStyle.blackText(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 14,
                      //                 ),
                      //               ),
                      //               subtitle: Text(
                      //                 "Status: ${user['status']}",
                      //                 style: AppTextStyle.blackText(
                      //                   fontSize: 12,
                      //                   fontWeight: FontWeight.w400,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       }).toList(),
                      // )
                  //     : Padding(
                  //       padding: const EdgeInsets.only(top: 50),
                  //       child: Center(
                  //         child: Text(
                  //           "No referral history found!",
                  //           style: AppTextStyle.blackText(
                  //             fontSize: 14,
                  //             color: AppColors.greytext,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
